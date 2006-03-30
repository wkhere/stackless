import greenlet, sys
import time; print "break!"; time.sleep(1)

def f(n):
    for i in range(10):
        print i
        try:
            greenlet.main.switch()
        except:
            print 'seeing:', sys.exc_info()
            raise


def send_exception(g, exc):
    def crasher(exc):
        raise exc
    g1 = greenlet.greenlet(crasher, (exc,), parent=g)
    g1.switch()


gf = [greenlet.greenlet(f, (10+5*j,)) for j in range(2)]
print `gf`

try:
    while 1:
        for g in gf:
            g.switch()
            send_exception(g, "crash")
finally:
    g = gf = None
