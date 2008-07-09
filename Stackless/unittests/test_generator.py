import unittest
import gc

def f(): yield 1

class TestGarbageCollection(unittest.TestCase):
    def testSimpleLeakage(self):
        leakage = []

        gc.collect(2)
        before  = set(id(o) for o in gc.get_objects())

        for i in f():
            pass

        gc.collect(2)
        after = gc.get_objects()

        for x in after:
            if x is not before and id(x) not in before:
                leakage.append(x)

        if len(leakage):
            self.failUnless(len(leakage) == 0, "Leaked %s" % repr(leakage))

if __name__ == '__main__':
    unittest.main()
