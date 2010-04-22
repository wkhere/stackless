"""
runAll.py

Runs all testcases in files named test_*.py.
Should be run in the folder Stackless/unittests.
"""


import os, sys, glob, unittest, stackless

def getsoft():
    hold = stackless.enable_softswitch(False)
    stackless.enable_softswitch(hold)
    return hold

def makeSuite(target, path = None):
    "Build a test suite of all available test files."

    suite = unittest.TestSuite()
    if '.' not in sys.path:
        sys.path.insert(0, '.')

    pattern = "test_*.py"
    if path:
        pattern = os.path.join(path, pattern)
    for idx, filename in enumerate(glob.glob(pattern)):
        modname = os.path.splitext(os.path.basename(filename))[0]
        module = __import__(modname)
        tests = unittest.TestLoader().loadTestsFromModule(module)
        use_it = target == 0 or idx+1 == target
        if use_it:
            suite.addTest(tests)
            if target > 0:
                print "single test of '%s', switch=%s" % \
                      (filename, ("hard", "soft")[getsoft()])

    return suite


def main():
    path = os.path.split(__file__)[0]
    print path
    hold = stackless.enable_softswitch(True)
    try:
        target = int(sys.argv[1])
        del sys.argv[1]
    except (IndexError, ValueError):
        try:
            target = TARGET
        except NameError:
            target = 0

    for use_psyco in (False, True):
        if use_psyco:
            # we import psyco so late, because we want to avoid side-effects
            # from functions like sys.getframe, which are overridden at import
            # time.
            try:
                import psyco
                if not psyco._psyco.stackless_compatible:
                    raise AttributeError
                psyco.full()
            except (ImportError, AttributeError):
                break

        try:
            flags = True, False
            if target:
                flags = (flags[target > 0],)
                if abs(target) == 42:
                    target = 0
            for switch in flags:
                stackless.enable_softswitch(switch)
                testSuite = makeSuite(abs(target), path)
                unittest.TextTestRunner(verbosity=2).run(testSuite)
        finally:
            stackless.enable_softswitch(hold)
        
if __name__ == '__main__':
    main()
