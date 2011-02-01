.. _stackless-debugging:

***********************************************
Debugging and Tracing --- How Stackless differs
***********************************************

Debugging tools, like those used for tracing, are implemented through
calls to the :func:`sys.settrace` function.  Now, in normal Python, when
this has been called any code that runs within the operating system thread
is covered by it.  In Stackless however, this function only covers the
current tasklet.

The debugging related modules, whether :doc:`in the standard library
<../debug>` or not, do not take this difference into account.  They are not
likely to work, and if they do, are not likely to work in the way you expect.
In an ideal world, Stackless Python might include modified versions of these
modules, and patches adding them would be most welcome.

If you want working debugging for Stackless Python, at this time your best
option is to use the `WingWare Python IDE <http://wingware.com>`_.  WingWare
have gone out of their way to add and support Stackless Python development.

.. note::

    In the past, the possibility of ditching the per-tasklet behaviour for
    the standard per-thread behaviour has been broached on the mailing list.
    Given the lack of movement on usability for this part of Stackless, it is
    not unlikely that this suggested change will be revisited.

-------------------------
``settrace`` and tasklets
-------------------------

In order to get debugging support working on a per-tasklet basis, you need to
ensure you call :func:`sys.settrace` for all tasklets.  Vilhelm Saevarsson 
`has an email
<http://www.stackless.com/pipermail/stackless/2007-October/003074.html>`_
giving code and a description of the steps required including potentially
unforeseen circumstances, in the Stackless mailing list archives.

Vilhelm's code::

    import sys
    import stackless
    
    def contextDispatch( prev, next ):
        if not prev: #Creating next
            # I never see this print out
            print "Creating ", next
        elif not next: #Destroying prev
            # I never see this print out either
            print "Destroying ", prev
        else:
            # Prev is being suspended
            # Next is resuming
            # When worker tasklets are resuming and have
            # not been set to trace, we make sure that
            # they are tracing before they run again
            if not next.frame.f_trace:
                # We might already be tracing so ...
                sys.call_tracing(next.settrace, (traceDispatch, ))
    
    stackless.set_schedule_callback(contextDispatch)

    def __call__(self, *args, **kwargs):
         f = self.tempval
         def new_f(old_f, args, kwargs):
             sys.settrace(traceDispatch)
             old_f(*args, **kwargs)
             sys.settrace(None)
         self.tempval = new_f
         stackless.tasklet.setup(self, f, args, kwargs)
    
    def settrace( self, tb ):
        self.frame.f_trace = tb
        sys.settrace(tb)
    
    stackless.tasklet.__call__ = __call__
    stackless.tasklet.settrace = settrace

The key actions taken by this code:

 * Wrap the creation of tasklets, so that the debugging hook is installed
   when the tasklet is first run.
 * Intercept scheduling events, so that tasklets that were created before
   debugging was engaged, have the debugging hook installed before they are
   run again.
