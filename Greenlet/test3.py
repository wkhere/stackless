import greenlet
import time; print "break!"; time.sleep(1)


class genlet(greenlet.greenlet):

    def __iter__(self):
        return self

    def next(self):
        self.parent = greenlet.getcurrent()
        result = self.switch()
        if self:
            return result
        else:
            raise StopIteration

def Yield(value):
    g = greenlet.getcurrent()
    while not isinstance(g, genlet):
        if g is None:
            raise RuntimeError, 'yield outside a genlet'
        g = g.parent
    g.parent.switch(value)

def generator(fn):
    def runner(*args, **kwds):
        return genlet(fn, args, kwds)
    return runner

# ____________________________________________________________

def g(n):
    for i in range(n):
        Yield(i)
g = generator(g)

for j in g(10):
    print j
