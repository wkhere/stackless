.. _tasklets:

********************************
Tasklets --- Lightweight threads
********************************

Tasklets wrap functions, allowing them to be launched as microthreads to be
run within the scheduler.

Launching a tasklet::

    stackless.tasklet(callable)(*args, **kwargs)

That is the most common way of launching a tasklet.  This does not just create
a tasklet, but it also automatically inserts the created tasklet into the
scheduler.

Example - launching a more concrete tasklet::

    >>> def func(*args, **kwargs):
    ...     print "scheduled with", args, "and", kwargs
    ...
    >>> stackless.tasklet(func)(1, 2, 3, string="test")
    <stackless.tasklet object at 0x01C58030>
    >>> stackless.run()
    scheduled with (1, 2, 3) and {'string': 'test'}

--------------------------------
Tasklets, main, current and more
--------------------------------

There are two especially notable tasklets, the main tasklet and the current
tasklet.

The main tasklet is fixed, and it is the initial thread of execution of
your application.  Chances are that it is running the scheduler.

The current tasklet however, is the tasklet that is currently running.  It
might be the main tasklet, if no other tasklets are being run.  Otherwise,
it is the entry in the scheduler's chain of runnable tasklets, that is
currently executing.

Example - is the main tasklet the current tasklet::

    stackless.main == stackless.current
    
Example - is the current tasklet the main tasklet::

    stackless.current.is_main == 1

Example - how many tasklets are scheduled::

    stackless.runcount

.. note::

  The main tasklet factors into the :attr:`stackless.runcount` value.  If you
  are checking how many tasklets are in the scheduler from your main loop,
  you need to keep in mind that there will be another tasklet in there over
  and above the ones you explicitly created.

---------------------
The ``tasklet`` class
---------------------

.. class:: tasklet(callable=None)

   This class exposes the form of lightweight thread (the tasklet) provided by
   Stackless Python.  Wrapping a callable object and arguments to pass into
   it when it is invoked, the callable is run within the tasklet.
   
   Tasklets are usually created in the following manner::
   
   >>> stackless.tasklet(func)(1, 2, 3, name="test")
   
   Note that there is no need to hold a reference to the created tasklet.
   This is because the act of passing the arguments to it, implicitly
   inserts it into the :ref:`scheduler <stackless-scheduler>`.

.. method:: tasklet.bind(callable)

   Bind the tasklet to the given callable object, *callable*::

   >>> t = stackless.tasklet()
   >>> t.bind(func)

   In most every case, programmers will instead pass *func* into the tasklet
   constructor::

   >>> t = stackless.tasklet(func)

   Note that the tasklet cannot be run until it has been provided with
   arguments to call *callable* with, through a subsequent call to
   :meth:``tasklet.setup``.

.. method:: tasklet.setup(*args, **kwargs)

   Provide the tasklet with arguments to pass into its bound callable::

   >>> t = stackless.tasklet()
   >>> t.bind(func)
   >>> t.setup(1, 2, name="test")
   
   In most every case, programmers will instead pass the arguments and
   callable into the tasklet constructor instead::

   >>> t = stackless.tasklet(func)(1, 2, name="test")
   
   Note that when tasklets have been bound to a callable object and
   provided with arguments to pass to it, they are implicitly
   scheduled and will be run in turn when the scheduler is next run.

.. method:: tasklet.insert()

   Insert the tasklet into the scheduler.

.. method:: tasklet.remove()

   Remove the tasklet from the scheduler.

.. method:: tasklet.run()

   If the tasklet is alive and not blocked on a channel, then it will be run
   immediately.  However, this behaves differently depending on whether
   the tasklet is in the scheduler's chain of runnable tasklets.
   
   Example - running a tasklet that is scheduled::
   
       >>> def f():
       ...     while 1:
       ...             print id(stackless.current)
       ...             stackless.schedule()
       ...
       >>> t1 = stackless.tasklet(f)()
       >>> t2 = stackless.tasklet(f)()
       >>> t3 = stackless.tasklet(f)()
       >>> t1.run()
       29524656
       29525936
       29526512

   What you see here is that *t1* is not the only tasklet that ran.  When *t1*
   yields, the next tasklet in the chain is scheduled and so forth until the
   tasklet that actually ran *t1* is scheduled and resumes execution.
   
   If you were to run *t2* instead of *t1*, then we would have only seen the
   output of *t2* and *t3*, because the tasklet calling :attr:`run` is before
   *t1* in the chain.

   Removing the tasklet to be run from the scheduler before it is actually
   run, gives more predictable results as shown in the following example.  But
   keep in mind that the scheduler is still being run and the chain is still
   involved, the only reason it looks correct is tht the act of removing the
   tasklet effectively moves it before the tasklet that calls
   :attr:`remove`.

   Example - running a tasklet that is not scheduled::

       >>> t2.remove()
       <stackless.tasklet object at 0x01C287B0>
       >>> t2.run()
       29525936

   While the ability to run a tasklet directly is useful on occasion, that
   the scheduler is still involved and that this is merely directing its
   operation in limited ways, is something you need to be aware of.

.. method:: tasklet.raise_exception(exc_class, *args)

   Raise an exception on the given tasklet.  *exc_class* is required to be a
   sub-class of :exc:`Exception`.  It is instantiated with the given arguments
   *args* and raised within the given tasklet.
   
   In order to make best use of this function, you should be familiar with
   how tasklets and the scheduler :ref:`deal with exceptions
   <slp-exc-section>`, and the purpose of the :ref:`TaskletExit <slp-exc>`
   exception.

.. method:: tasklet.set_atomic(flag)

   This method is used to construct a block of code within which the tasklet
   will not be auto-scheduled when pre-emptive scheduling.  It is useful for 
   wrapping critical sections that should not be interrupted::

     old_value = t.set_atomic(1)
     # Implement unsafe logic here.
     t.set_atomic(old_value)

.. method:: tasklet.set_ignore_nesting(flag)

   It is probably best not to use this until you understand nesting levels::

     old_value = t.set_ignore_nesting(1)
     # Implement unsafe logic here.
     t.set_ignore_nesting(old_value)

The following (read-only) attributes allow tasklet state to be checked:

.. attribute:: tasklet.alive

   This attribute is ``True`` while a tasklet is still running.  Tasklets that
   are not running will most likely have either run to completion and exited,
   or will have unexpectedly exited through an exception of some kind.

.. attribute:: tasklet.paused

   This attribute is ``True`` when a tasklet is alive, but not scheduled or
   blocked on a channel.

.. attribute:: tasklet.blocked

   This attribute is ``True`` when a tasklet is blocked on a channel.

.. attribute:: tasklet.scheduled

   This attribute is ``True`` when the tasklet is either scheduled or blocked
   on a channel.

.. attribute:: tasklet.restorable

   This attribute is relevant to tasklets that were created through unpickling.
   
   If it is possible to continue running the unpickled tasklet from whatever
   point in execution it may be, then this attribute will be ``True``.  For
   the tasklet to be runnable, it must not have lost runtime information
   (C stack usage for instance).

The following attributes allow checking of user set situations:

.. attribute:: tasklet.atomic

   This attribute is ``True`` while this tasklet is within a
   :meth:`tasklet.set_atomic` block

.. attribute:: tasklet.block_trap

   Setting this attribute to ``True`` prevents the tasklet from being blocked
   on a channel.

.. attribute:: tasklet.ignore_nesting

   This attribute is ``True`` while this tasklet is within a
   :meth:`tasklet.set_ignore_nesting` block

The following attributes allow identification of tasklet place:

.. attribute:: tasklet.is_current

   This attribute is ``True`` if the tasklet is the current tasklet.

.. attribute:: tasklet.is_main

   This attribute is ``True`` if the tasklet is the main tasklet.

.. attribute:: tasklet.thread_id

   This attribute is the id of the thread the tasklet belongs to.
   
   The relationship between tasklets and threads is :doc:`covered elsewhere
   <threads>`.

In almost every case, tasklets will be linked into a chain of tasklets.  This
might be the scheduler itself, otherwise it will be a channel the tasklet is
blocked on.

The following attributes allow a tasklets place in a chain to be identified:

.. attribute:: tasklet.prev

   The previous tasklet in the chain that this tasklet is linked into.

.. attribute:: tasklet.next

   The next tasklet in the chain that this tasklet is linked into.
