import unittest
import sys

from stackless import *

#test that thread state is restored properly

class TestExceptionState(unittest.TestCase):
    def Tasklet(self):
        try:
            1/0
        except Exception,  e:
            self.ran = True
            ei = sys.exc_info()
            self.assertEquals(ei[0], ZeroDivisionError)
            schedule()
            ei = sys.exc_info()
            self.assertEquals(ei[0], ZeroDivisionError)
            self.assertTrue("by zero" in str(ei[1]))

    def testExceptionState(self):
        t = tasklet(self.Tasklet)
        sys.exc_clear()
        t()
        self.ran = False
        t.run()
        self.assertTrue(self.ran)
        ei = sys.exc_info()
        self.assertEquals(ei, (None,)*3)
        t.run()
        ei = sys.exc_info()
        self.assertEquals(ei, (None,)*3)

class TestTracingState(unittest.TestCase):
    def __init__(self, *args):
        unittest.TestCase.__init__(self, *args)
        self.trace = []

    def Callback(self, *args):
        self.trace.append(args)

    def foo(self):
        pass

    def Tasklet(self):
        sys.setprofile(self.Callback)

        self.foo()
        n = len(self.trace)
        self.foo()
        n2 = len(self.trace)
        self.assertTrue(n2 > n)

        schedule()

        self.foo()
        n = len(self.trace)
        self.foo()
        n2 = len(self.trace)
        self.assertTrue(n2 > n)

    def testTracingState(self):
        t = tasklet(self.Tasklet)
        t()
        t.run()

        self.foo()
        n = len(self.trace)
        self.foo()
        n2 = len(self.trace)
        self.assertEqual(n, n2)

        t.run()

        self.foo()
        n = len(self.trace)
        self.foo()
        n2 = len(self.trace)
        self.assertEqual(n, n2)

if __name__ == '__main__':
    import sys
    if not sys.argv[1:]:
        sys.argv.append('-v')
    unittest.main()
