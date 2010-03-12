import unittest
import stackless

"""
Various regression tests for stackless defects.
Typically, one can start by adding a test here, then fix it.
Don't check in tests for un-fixed defects unless they are disabled (by adding a leading _)
"""

class TestTaskletDel(unittest.TestCase):
    #Defect:  If a tasklet's tempval contains any non-trivial __del__ function, it will cause
    #an assertion in debug mode due to violation of the stackless protocol.
    #The return value of the tasklet's function is stored in the tasklet's tempval and cleared
    #when the tasklet exits.
    #Also, the tasklet itself would have problems with a __del__ method.
    
    class ObjWithDel:
        def __del__(self):
            self.called_func()
        def called_func(self):
            pass #destructor must call a function

    class TaskletWithDel(stackless.tasklet):
        def __del__(self):
            self.func()
        def func(self):
            pass

    class TaskletWithDelAndImport(stackless.tasklet):
        def __del__(self):
            import ctypes
            
    #Test that a tasklet tempval's __del__ operator works.
    def testTempval(self):
        def TaskletFunc(self):
            return self.ObjWithDel()
        
        stackless.tasklet(TaskletFunc)(self)
        stackless.run()
    
    #Test that a tasklet's __del__ operator works.
    def testTasklet(self):
        def TaskletFunc(self):
            pass

        self.TaskletWithDel(TaskletFunc)(self)
        stackless.run()

    #This test crashes.  Something strange happens, needs work
    #an import in the __del__ causes strange things.
    def _testTasklet2(self):
        def TaskletFunc(self):
            pass

        self.TaskletWithDelAndImport(TaskletFunc)(self)
        stackless.run()

class Schedule(unittest.TestCase):
    def testScheduleRemove(self):
        #schedule remove doesn't work if it is the only tasklet running under watchdog
        def func(self):
            stackless.schedule_remove()
            self.fail("We shouldn't be here")
        stackless.run() #flush all runnables
        stackless.tasklet(func)(self)
        stackless.run()

    def testScheduleRemove2(self):
        #schedule remove doesn't work if it is the only tasklet with main blocked
        def func(self, chan):
            #main tasklet is blocked, this should raise an error
            self.assertRaises(RuntimeError, stackless.schedule_remove)
            chan.send(None)
        stackless.run() #flush all runnables
        chan = stackless.channel()
        stackless.tasklet(func)(self, chan)
        chan.receive()

if __name__ == '__main__':
    import sys
    if not sys.argv[1:]:
        sys.argv.append('-v')
    unittest.main()
