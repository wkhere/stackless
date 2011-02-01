.. _stackless-pickling:

**********************************************
Pickling --- Serialisation of running tasklets
**********************************************

One of the most impressive features of Stackless, is the ability to pickle
tasklets.  This allows you to take a tasklet mid-execution, serialise it to
a chunk of data and then unserialise that data at a later point, creating a
new tasklet from it that resumes where the last left off.

What makes this
particularly impressive is the fact that the Python :mod:`pickle` structure
is platform independent.  Code can for instance initially be run on a x86
Windows machine, then interrupted, pickled and sent over the network to be
resumed on an ARM Linux machine.

Example - pickling a tasklet::

    >>> def func():
    ...    busy_count = 0
    ...    while 1:
    ...        busy_count += 1
    ...        if busy_count % 10 == 0:
    ...            print busy_count
    ...
    >>> stackless.tasklet(func)()
    <stackless.tasklet object at 0x01BD16B0>
    >>> t1 = stackless.run(100)
    10
    20
    >>> s = pickle.dumps(t1)
    >>> t1.kill()
    >>> t2 = pickle.loads(s)
    >>> t2.insert()
    >>> stackless.run(100)
    30
    40
    50

In the above example, a tasklet is created that increments the counter
*busy_count* and outputs the value when it is a multiple of ``10``.

Run the tasklet for a while::

    >>> t1 = stackless.run(100)
    10
    20

The tasklet has been interrupted at some point in its execution.  If
it were to be resumed, we would expect its output to be the values following
those previously displayed.

Serialise the tasklet::

    >>> s = pickle.dumps(t1)

As any other object is pickled, so are tasklets.  In this case, the serialised
representation of the tasklet is a string, stored in *s*.

Destroy the tasklet::

    >>> t1.kill()

We want to show that the old code cannot be resumed, and in order to do so, we
destroy the tasklet it was running within.

Unserialise the stored representation::

    >>> t2 = pickle.loads(s)

As any other object is unpickled, so are tasklets.  We take the string and
by unpickling it, get a new tasklet object back.

Schedule the new tasklet::

    >>> t2.insert()

Now the newly recreated tasklet is inserted into the scheduler, so that when
the scheduler is next run, the tasklet is resumed.

Run the scheduler::

    >>> stackless.run(100)
    30
    40
    50
    <stackless.tasklet object at 0x01BD1D30>

When the scheduler is run, the values displayed are indeed the ones that
follow those displayed by the original tasklet.  The value returned by
:func:`stackless.run` is not stored in a variable this time, so the
interpreter displays the recreated tasklet.  You can see that it has a
different address than *t1*, which was displayed earlier.

.. note::

    It should be possible to pickle any tasklets that you might want to.
    However, not all tasklets can be unpickled.  One of the cases in which
    this is true, is where not all the functions called by the code within
    the tasklet are Python functions.  The Stackless pickling mechanism
    has no ability to deal with C functions that may have been called.
