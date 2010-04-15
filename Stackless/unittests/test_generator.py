import unittest
import gc

def f(): yield 1

class TestGarbageCollection(unittest.TestCase):
    def testSimpleLeakage(self):
        leakage = []

        gc.collect(2)
        before  = gc.get_objects()

        for i in f():
            pass

        gc.collect(2)
        after = gc.get_objects()

        bset = set(id(o) for o in before)
        for x in after:
            if x is not before and id(x) not in bset:
                leakage.append(x)

        try:
            __in_psyco__
            relevant = False
        except NameError:
            relevant = True
        if relevant and len(leakage):
            self.failUnless(len(leakage) == 0, "Leaked %s" % repr(leakage))

if __name__ == '__main__':
    import sys
    if not sys.argv[1:]:
        sys.argv.append('-v')
    unittest.main()
