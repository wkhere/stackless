import greenlet, sys
import time; print "break!"; time.sleep(1)

def f():
    for i in range(10):
        print i
        try:
            greenlet.main.switch()
        except:
            print 'seeing:', sys.exc_info()
            raise
        alkj

gf = [greenlet.greenlet(f) for j in range(2)]
print `gf`

try:
    while gf:
        for g in gf:
            g.switch()
        gf = filter(None, gf)
finally:
    g = gf = None
