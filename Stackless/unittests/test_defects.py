import unittest
import stackless

"""
Various regression tests for stackless defects.
Typically, one can start by adding a test here, then fix it.
Don't check in tests for un-fixed defects unless they are disabled (by adding a leading _)
"""
        
class TestTaskletTempvalDel(unittest.TestCase):
    #Defect:  If a tasklet's tempval contains any non-trivial __del__ function, it will cause
    #an assertion in debug mode due to violation of the stackless protocol.
    #The return value of the tasklet's function is stored in the tasklet's tempval and cleared
    #when the tasklet exits.
    
    class ObjWithDel:
        def __del__(self):
            self.called_func()
        def called_func(self):
            pass #destructor must call a function
    
    def _test(self):
        def TaskletFunc(self):
            return self.ObjWithDel()
            
        stackless.tasklet(TaskletFunc)(self)
        stackless.run()
        
if __name__ == '__main__':
    import sys
    if not sys.argv[1:]:
        sys.argv.append('-v')
    unittest.main()
