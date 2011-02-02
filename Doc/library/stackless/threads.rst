.. _slp-threads:

*********************************
Threads --- Threads and Stackless
*********************************

Stackless is a lightweight threading solution.  It works by
scheduling its tasklets within the CPU time allocated to the real thread
that Python, and therefore the scheduler running within it, is on.

It does not:

 * Magically move tasklets between threads to do some wonderful
   load balancing.
 * Magically remove the global interpreter lock.
 * Solve all your scalability needs out of the box.

But it does allow its functionality to be used flexibly, when you
want to make use of more than one thread.

----------------------
A scheduler per thread
----------------------

The operating system thread that the Python runtime is started in and runs on,
is called the main thread.  The typical use of Stackless, is to run the
scheduler in this thread.  But there is nothing that prevents a different
scheduler, and therefore a different set of tasklets, from running in every
Python thread you care to start.

.. note::

   Remember that tasklets are in essence part of the thread they were created
   in, and there is no way to move tasklets between threads.

Example - scheduler per thread::

    import threading
    import stackless
    
    def secondary_thread_func():
        print "THREAD(2): Has", stackless.runcount, "tasklets in its scheduler"
    
    def main_thread_func():
        print "THREAD(1): Waiting for death of THREAD(2)"
        while thread.is_alive():
            stackless.schedule()
        print "THREAD(1): Death of THREAD(2) detected"
    
    mainThreadTasklet = stackless.tasklet(main_thread_func)()
    
    thread = threading.Thread(target=secondary_thread_func)
    thread.start()
    
    stackless.run()

Output::

    THREAD(2): HasTHREAD(1): Waiting for death of THREAD(2)
     1 tasklets in its scheduler
    THREAD(1): Death of THREAD(2) detected

This example demonstrates that there actually are two independent schedulers
present, one in each participating Python thread.  We know that the main
thread has one manually created tasklet running, in addition to its main
tasklet which is running the scheduler.  If the secondary thread is truly
independent, then when it runs it should have a tasklet count of ``1``
representing its own main tasklet.  And this is indeed what we see.

See also:

  * The :attr:`stackless.threads` attribute.
  * The :attr:`tasklet.thread_id` attribute.

.. _slp-threads-channel:

------------------------
Channels are thread-safe
------------------------

Whether or not you are running a scheduler on multiple threads, you can still
communicate with a thread that is running a scheduler using a
:class:`channel` object.

Example - interthread channel usage::

    import threading
    import stackless

    commandChannel = stackless.channel()

    def master_func():
        commandChannel.send("ECHO 1")
        commandChannel.send("ECHO 2")
        commandChannel.send("ECHO 3")
        commandChannel.send("QUIT")

    def slave_func():
        print "SLAVE STARTING"
        while 1:
            command = commandChannel.receive()
            print "SLAVE:", command
            if command == "QUIT":
                break
        print "SLAVE ENDING"

    def scheduler_run(tasklet_func):
        t = stackless.tasklet(tasklet_func)()
        while t.alive:
            stackless.run()

    thread = threading.Thread(target=scheduler_run, args=(master_func,))
    thread.start()

    scheduler_run(slave_func)

Output::

    SLAVE STARTING
    SLAVE: ECHO 1
    SLAVE: ECHO 2
    SLAVE: ECHO 3
    SLAVE: QUIT
    SLAVE ENDING

This example runs *slave_func* as a tasklet on the main thread, and
*master_func* as a tasklet on a secondary thread that is manually created.
The idea is that the master thread tells the slave thread what to do, with
a ``QUIT`` message meaning that it should exit.

.. note::

    The reason the scheduler is repeatedly run in a loop, is because when a
    scheduler has no remaining tasklets scheduled within it, it will exit.
    As there is only one tasklet in each thread, as each channel operation in
    the thread blocks the calling tasklet, the scheduler will exit.  Linking
    how long the scheduler is driven to the lifetime of all tasklets that it
    handles, ensures correct behaviour.

