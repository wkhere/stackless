import pickle, sys
import unittest
import stackless
import random

# Helpers

def is_soft():
    softswitch = stackless.enable_softswitch(0)
    stackless.enable_softswitch(softswitch)
    return softswitch

class SimpleScheduler(object):
    """ Not really scheduler as such but used here to implement
    autoscheduling hack and store a schedule count. """

    def __init__(self, bytecodes = 25, softSchedule = False):
        self.bytecodes = bytecodes
        self.schedule_count = 0
        self.softSchedule = softSchedule


    def get_schedule_count(self):
        return self.schedule_count


    def schedule_cb(self, task):
        self.schedule_count += 1
        if task:
            task.insert()


    def autoschedule(self):
        while stackless.runcount > 1:
            try:
                returned = stackless.run(self.bytecodes, soft = self.softSchedule)
                
            except Exception, e:
                                
                # Can't clear off exception easily... 
                while stackless.runcount > 1:
                    stackless.current.next.kill()

                raise e
                        
            else:
                self.schedule_cb(returned)

def runtask6(name):
    me = stackless.getcurrent()
    cur_depth = me.recursion_depth
    
    for ii in xrange(1000):
        assert cur_depth == me.recursion_depth

    

def runtask_print(name):
    x = 0
    for ii in xrange(1000):
        x += 1

    return name


def runtask(name):
    x = 0
    for ii in xrange(1000):
        if ii % 50 == 0:
            sys._getframe() # a dummy
            
        x += 1

    return name


def runtask2(name):
    x = 0
    for ii in xrange(1000):
        if ii % 50 == 0:
            stackless.schedule() # same time, but should give up timeslice
            
        x += 1

    return name

def runtask3(name):
    exec """
for ii in xrange(1000):
    pass
"""


def runtask4(name, channel):
    for ii in xrange(1000):
        if ii % 50 == 0:
            channel.send(name)


def recurse_level_then_do_schedule(count):
    if count == 0:
        stackless.schedule()
    else:
        recurse_level_then_do_schedule(count - 1)

        
def runtask5(name):
    for ii in [1, 10, 100, 500]:
        recurse_level_then_do_schedule(ii)


def runtask_atomic_helper(count):
    hold = stackless.current.set_atomic(1)
    for ii in xrange(count): pass
    stackless.current.set_atomic(hold)

def runtask_atomic(name):
    for ii in xrange(10):
        for ii in [1, 10, 100, 500]:
            runtask_atomic_helper(ii)


def runtask_bad(name):
    raise UserWarning


class ServerTasklet(stackless.tasklet):
    
    def __init__(self, func, name=None):
        if not name:
            name = "at %08x" % (id(self))
        self.name = name


    def __new__(self, func, name=None):
        return stackless.tasklet.__new__(self, func)


    def __repr__(self):
        return "Tasklet %s" % self.name


def servertask(name, chan):
    self = stackless.getcurrent()
    self.count = 0
    while True:
        r = chan.receive()
        self.count += 1

    
class TestWatchdog(unittest.TestCase):
    softSchedule = False
    def setUp(self):
        self.verbose = __name__ == "__main__"

    def tearDown(self):
        del self.verbose

        
    def run_tasklets(self, fn, n=100):
        scheduler = SimpleScheduler(n, self.softSchedule)
        tasklets = []
        for name in ["t1", "t2", "t3"]:
            tasklets.append(stackless.tasklet(fn)(name))
        # allow scheduling with hard switching
        map(lambda t:t.set_ignore_nesting(1), tasklets)

        scheduler.autoschedule()
        for ii in tasklets:
            self.failIf(ii.alive) 

        return scheduler.get_schedule_count()


    def test_simple(self):
        self.run_tasklets(runtask)


    def xtest_recursion_count(self):
        self.run_tasklets(runtask6)


    def test_nested(self):
        self.run_tasklets(runtask5)


    def test_nested2(self):
        self.run_tasklets(runtask5, 0)


    def test_tasklet_with_schedule(self):
        # make sure that we get enough tick counting
        try:
            hold = sys.getcheckinterval()
        except AttributeError:
            hold = 10 # default before 2.3
        sys.setcheckinterval(10)

        n1 = self.run_tasklets(runtask)
        n2 = self.run_tasklets(runtask2)

        sys.setcheckinterval(hold)
        if self.verbose:
            print
            print 20*"*", "runtask:", n1, "runtask2:", n2
        if not self.softSchedule:
            self.failUnless(n1 > n2)
        else:
            self.failUnless(n1 < n2)


    def test_exec_tasklet(self):
        self.run_tasklets(runtask3)

    def test_send_recv(self):
        chan = stackless.channel()
        server = ServerTasklet(servertask)
        server_task = server("server", chan)
        
        scheduler = SimpleScheduler(100, self.softSchedule)
        
        tasklets = [stackless.tasklet(runtask4)(name, chan)
                     for name in ["client1", "client2", "client3"]] 
    
        scheduler.autoschedule()
        self.assertEquals(server.count, 60)

        # Kill server
        self.failUnlessRaises(StopIteration, lambda:chan.send_exception(StopIteration))


    def test_atomic(self):
        self.run_tasklets(runtask_atomic)

    def test_exception(self):
        self.failUnlessRaises(UserWarning, lambda:self.run_tasklets(runtask_bad))

    def get_pickled_tasklet(self):
        orig = stackless.tasklet(runtask_print)("pickleme")
        orig.set_ignore_nesting(1)
        not_finished = stackless.run(100)
        self.assertEqual(not_finished, orig)
        return pickle.dumps(not_finished)
    
    def test_pickle(self):
        # Run global
        t = pickle.loads(self.get_pickled_tasklet())
        t.insert()
        if is_soft():
            stackless.run()
        else:
            self.failUnlessRaises(RuntimeError, stackless.run)

        # Run on tasklet
        t = pickle.loads(self.get_pickled_tasklet())
        t.insert()
        if is_soft():
            t.run()
        else:
            self.failUnlessRaises(RuntimeError, t.run)
            return # enough crap

        # Run on watchdog
        t = pickle.loads(self.get_pickled_tasklet())
        t.insert()
        while stackless.runcount > 1:
            returned = stackless.run(100)
            
    def test_run_return(self):
        #if the main tasklet had previously gone into C stack recusion-based switch, stackless.run() would give
        #strange results
        #this would happen after, e.g. tasklet pickling and unpickling
        #note, the bug was hard to repro, most of the time, it didn't occur.
        t = pickle.loads(self.get_pickled_tasklet())
        def func():
            pass
        t = stackless.tasklet(func)
        t()
        r = stackless.run()
        self.assertEqual(r, None)
        
    def test_lone_receive(self):
        #This is a bug, but we can't fix it now
        return
        def f():
            stackless.channel().receive()
        stackless.tasklet(f)()
        stackless.run()
        
class TestWatchdogSoft(TestWatchdog):
    softSchedule = True
    

    def __init__(self, *args):
        self.chans = [stackless.channel() for i in xrange(3)]
        #for c in self.chans:
        #    c.preference = 0
        TestWatchdog.__init__(self, *args)
        
    def ChannelTasklet(self, i):
        a = i;
        b = (i+1)%3
        recv = False #to bootstrap the cycle
        while True:
            #print a
            if i != 0 or recv:
                d = self.chans[a].receive()
            recv = True
            j = 0
            for i in xrange(random.randint(100, 1000)):
                j = i+i

            self.chans[b].send(j)
        
        
    #test the soft interrupt on a chain of tasklets running
    def test_channelchain(self):
        c = [stackless.tasklet(self.ChannelTasklet) for i in xrange(3)]
        #print sys.getcheckinterval()
        for i, t in enumerate(reversed(c)):
            t(i)
        try:
            for i in range(10):
                stackless.run(50000, soft=True, totaltimeout=True, ignore_nesting=True)
                #print "**", stackless.runcount
                self.failUnless(stackless.runcount == 3 or stackless.runcount == 4)
        finally:
            for t in c:
                t.kill()
            
            
        
    
if __name__ == '__main__':
    import sys
    if not sys.argv[1:]:
        sys.argv.append('-v')
    unittest.main()
