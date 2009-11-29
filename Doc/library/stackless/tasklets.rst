.. _tasklets:

********
Tasklets
********

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

   descriptive text

.. method:: tasklet.remove()

   descriptive text

.. method:: tasklet.run()

   descriptive text

.. method:: tasklet.raise_exception(exc, value)

   descriptive text

.. method:: tasklet.set_atomic(flag)

   descriptive text

.. method:: tasklet.set_ignore_nesting(flag)

   descriptive text

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

The following attributes allow identification of tasklet importance:

.. attribute:: tasklet.is_current

   This attribute is ``True`` if the tasklet is the current tasklet.

.. attribute:: tasklet.is_main

   This attribute is ``True`` if the tasklet is the main tasklet.

In almost every case, tasklets will be linked into a chain of tasklets.  This
might be the scheduler itself, otherwise it will be a channel the tasklet is
blocked on.

The following attributes allow a tasklets place in a chain to be identified:

.. attribute:: tasklet.prev

   The previous tasklet in the chain that this tasklet is linked into.

.. attribute:: tasklet.next

   The next tasklet in the chain that this tasklet is linked into.
