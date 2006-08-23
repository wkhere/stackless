"""Python Microthread Library, version 0.1
Microthreads are useful when you want to program many behaviors
happening simultaneously. Simulations and games often want to model
the simultaneous and independent behavior of many people, many
businesses, many monsters, many physical objects, many spaceships, and
so forth. With microthreads, you can code these behaviors as Python
functions. Microthreads use Stackless Python. For more details, see
http://world.std.com/~wware/uthread.html"""

__version__ = "0.1"

__license__ = \
"""Python Microthread Library version 0.1
Copyright (C)2000  Will Ware, Christian Tismer

Permission to use, copy, modify, and distribute this software and its
documentation for any purpose and without fee is hereby granted,
provided that the above copyright notice appear in all copies and that
both that copyright notice and this permission notice appear in
supporting documentation, and that the names of the authors not be
used in advertising or publicity pertaining to distribution of the
software without specific, written prior permission.

WILL WARE AND CHRISTIAN TISMER DISCLAIM ALL WARRANTIES WITH REGARD TO
THIS SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS. IN NO EVENT SHALL WILL WARE OR CHRISTIAN TISMER BE LIABLE FOR
ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT
OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE."""

import stackless
import sys
import time
import types
import weakref
import traceback
import copy
import logging

# This is a simple replacement for what CCP uses which is linked into our
# framework.
def WriteTraceback(text, tb):
    logging.error(text)
    for s in traceback.format_tb(tb):
        logging.error(s.strip())
    logging.error(str(excInstance))

def LogTraceback(text):
    if text is None:
        text = "Traceback:"
    tb = traceback.extract_stack()
    WriteTraceback(text, tb)

def StackTrace(text=None):
    excClass, excInstance, tb = sys.exc_info()
    if excClass:
        if text is None:
            text = "Stacktrace:"
        WriteTraceback(text, tb)
    else:
        LogTraceback(text)

tasks = [] # bogus breyta

# handled internally
schedule = stackless.schedule

# We need to subclass it so that we can store attributes on it.
class Tasklet(stackless.tasklet):
    pass
        
def new(func, *args, **kw):
    return Tasklet(func)(*args, **kw)

def newWithoutTheStars(func, args, kw):
    return Tasklet(func)(*args, **kw)

idIndex = 0

def uniqueId():
    """Microthread-safe way to get unique numbers, handy for
    giving things unique ID numbers"""
    global idIndex
    ## CCP is cutting out atomic as we never preemtivly schedule and stackless was crashing there
    #tmp = stackless.atomic()
    z = idIndex
    idIndex += 1
    return z

def irandom(n):
    """Microthread-safe version of random.randrange(0,n)"""
    import random
    ## CCP is cutting out atomic as we never preemtivly schedule and stackless was crashing there
    #tmp = stackless.atomic()
    n = random.randrange(0, n)
    return n

synonyms = {}

def MakeSynonymOf(threadid, synonym_threadid):
    global synonyms
    key = (threadid, synonym_threadid)
    if key not in synonyms:
        synonyms[key] = 1
    else:
        synonyms[key] += 1

def MakeCurrentSynonymOf(synonym_threadid):
    return MakeSynonymOf(id(stackless.getcurrent()), synonym_threadid)

def RemoveSynonymOf(threadid, synonym_threadid):
    global synonyms
    key = (threadid, synonym_threadid)
    if key not in synonyms:
        StackTrace("RemoveSynonymOf unexpected call threadid:%s synonym_threadid:%s" % key)
        return
    synonyms[key] -= 1
    if 0 == synonyms[key]:
        del synonyms[key]

def RemoveCurrentSynonymOf(synonym_threadid):
    return RemoveSynonymOf(id(stackless.getcurrent()), synonym_threadid)

def IsSynonymOf(threadid, synonym_threadid):
    global synonyms
    key = (threadid, synonym_threadid)
    return key in synonyms

def IsCurrentSynonymOf(synonym_threadid):
    return IsSynonymOf(id(stackless.getcurrent()), synonym_threadid)


semaphores               = weakref.WeakKeyDictionary({})

def GetSemaphores():
    return semaphores

class Semaphore:
    """Semaphores protect globally accessible resources from
    the effects of context switching."""

    def __init__(self, semaphoreName=None, maxcount=1, strict=True):
        global semaphores

        semaphores[self] = 1

        self.semaphoreName  = semaphoreName
        self.maxcount       = maxcount
        self.count          = maxcount
        self.waiting        = stackless.channel()
        self.thread         = None
        self.lockedWhen     = None
        self.strict         = strict

    def IsCool(self):
        '''
            returns true if and only if nobody has, or is waiting for, this lock
        '''
        return self.count==self.maxcount

    def __str__(self):
        return "Semaphore("+ str(self.semaphoreName) +")"

    def __del__(self):
        if not self.IsCool():
            logger.error("Semaphore "+ str(self) +" is being destroyed in a locked or waiting state")

    def acquire(self):
        if self.strict:
            assert self.thread is not stackless.getcurrent()
            if self.thread is stackless.getcurrent():
                raise RuntimeError, "tasklet deadlock, acquiring tasklet holds strict semaphore"
        self.count -= 1
        if self.count < 0:
            self.waiting.receive()

        self.lockedWhen = time.time()
        self.thread = stackless.getcurrent()

    claim = acquire

    def release(self):
        if self.strict:
            assert self.thread is stackless.getcurrent()
            if self.thread is not stackless.getcurrent():
                raise RuntimeError, "wrong tasklet releasing strict semaphore"

        self.count += 1
        self.thread     =   None
        self.lockedWhen =   None
        if self.count <= 0:
            PoolWorker("uthread::Semaphore::delayed_release",self.__delayed_release)

    #This allows the release thread to continue without being interrupted
    def __delayed_release(self):
        self.waiting.send(None)

class CriticalSection(Semaphore):
    def __init__(self, semaphoreName = None, strict=True):
        Semaphore.__init__(self, semaphoreName)
        self.__reentrantRefs = 0

    def acquire(self):
        # MEB: if (self.count<=0) and (self.thread is stackless.getcurrent() or stackless.getcurrent() is synonymof self.thread):
        if (self.count<=0) and (self.thread is stackless.getcurrent() or IsCurrentSynonymOf(self.thread)):
            self.__reentrantRefs += 1
        else:
            Semaphore.acquire(self)

    def release(self):
        if self.__reentrantRefs:
            # MEB: assert self.thread is stackless.getcurrent()
            assert self.thread is stackless.getcurrent() or IsCurrentSynonymOf(self.thread)
            # MEB: if self.thread is not stackless.getcurrent():
            if not (self.thread is stackless.getcurrent() or IsCurrentSynonymOf(self.thread)):
                raise RuntimeError, "wrong tasklet releasing reentrant CriticalSection"
            self.__reentrantRefs -= 1
        else:
            Semaphore.release(self)

def FNext(f):
    first  = stackless.getcurrent()
    try:
        cursor = first.next
        while cursor != first:
            if cursor.frame.f_back == f:
                return FNext(cursor.frame)
            cursor = cursor.next
        return f
    finally:
        first  = None
        cursor = None

class SquidgySemaphore:
    '''
        This is a semaphore which allows exclusive locking
    '''

    def __init__(self, lockName):
        self.__outer__  = Semaphore(lockName)
        self.lockers    = {}
        self.__wierdo__ = 0

    def IsCool(self):
        '''
            returns true if and only if nobody has, or is waiting for, this lock
        '''
        while 1:
            lockers = []
            try:
                for each in self.lockers:
                    return 0
                break
            except:
                StackTrace()
                sys.exc_clear()
        return self.__outer__.IsCool() and not self.__wierdo__

    def acquire_pre_friendly(self):
        '''
            Same as acquire, but with respect for pre_acquire_exclusive
        '''
        while 1:
            if self.__wierdo__:
                Sleep(0.5)
            else:
                self.acquire()
                if self.__wierdo__:
                    self.release()
                else:
                    break

    def pre_acquire_exclusive(self):
        '''
            Prepares the lock for an acquire_exclusive call, so that
            acquire_pre_friendly will block on the dude.
        '''
        self.__wierdo__ += 1

    def acquire_exclusive(self):
        i = 0
        while 1:
            self.__outer__.acquire()
            theLocker = None
            try:
                # self.lockers is a dict, and we just want one entry from it.
                # for each in/break is a convenient way to get one entry.
                for each in self.lockers:
                    theLocker = each
                    break
            except:
                StackTrace()
                sys.exc_clear()

            if theLocker is not None:
                self.__outer__.release() # yielding to the sucker is fine, since we're waiting for somebody anyhow.
                if i and ((i%(3*4*60))==0):
                    logger.error("Acquire-exclusive is waiting for the inner lock (%d seconds total, lockcount=%d)" % (i/4, len(self.lockers)))
                    LogTraceback("This acquire_exclusive is taking a considerable amount of time")
                    logger.error("This dude has my lock:")
                    logger.error("tasklet: "+str(theLocker))
                    for s in traceback.format_list(traceback.extract_stack(FNext(theLocker.frame),40)):
                        for n in range(0,10120,253): # forty lines max.
                            if n==0:
                                if len(s)<=255:
                                    x = s
                                else:
                                    x = s[:(n+253)]
                            else:
                                x = " - " + s[n:(n+253)]
                            logger.error(x, 4)
                            if (n+253)>=len(s):
                                break
                Sleep(0.500)
            else:
                break
            i += 1

    def release_exclusive(self):
        self.__outer__.release()
        self.__wierdo__ -= 1

    def acquire(self):
        # you don't need the outer lock to re-acquire
        self.__outer__.acquire()
        self.__acquire_inner()
        self.__outer__.release()

    def release(self, t=None):
        if t is None:
            t = stackless.getcurrent()
        self.__release_inner(t)

    def __acquire_inner(self):
        while 1:
            try:
                if self.lockers.has_key(stackless.getcurrent()):
                    self.lockers[stackless.getcurrent()] += 1
                else:
                    self.lockers[stackless.getcurrent()] = 1
                break
            except:
                StackTrace()
                sys.exc_clear()

    def __release_inner(self, t):
        while 1:
            try:
                if self.lockers.has_key(t):
                    self.lockers[t] -= 1
                    if self.lockers[t]==0:
                        del self.lockers[t]
                else:
                    StackTrace("You can't release a lock you didn't acquire")
                break
            except:
                StackTrace()
                sys.exc_clear()

channels            = weakref.WeakKeyDictionary()

def GetChannels():
    return channels

class Channel:
    """
        A Channel is a stackless.channel() with administrative spunk
    """

    def __init__(self,channelName=None):
        global channels
        self.channelName = channelName
        self.channel = stackless.channel()
        self.send = self.channel.send
        self.send_exception = self.channel.send_exception
        channels[self] = 1

    def receive(self):
        return self.channel.receive()

    def __getattr__(self,k):
        return getattr(self.channel,k)




# -----------------------------------------------------------------------------------
#  FIFO Class
# -----------------------------------------------------------------------------------
class FIFO(object):

    __slots__ = ('data',)

    # -----------------------------------------------------------------------------------
    #  FIFO - Constructor
    # -----------------------------------------------------------------------------------
    def __init__(self):
        self.data = [[], []]

    # -----------------------------------------------------------------------------------
    #  FIFO - push
    # -----------------------------------------------------------------------------------
    def push(self, v):
        self.data[1].append(v)

    # -----------------------------------------------------------------------------------
    #  FIFO - pop
    # -----------------------------------------------------------------------------------
    def pop(self):
        d = self.data
        if not d[0]:
            d.reverse()
            d[0].reverse()
        return d[0].pop()

    # -----------------------------------------------------------------------------------
    #  FIFO - __nonzero__
    # -----------------------------------------------------------------------------------
    # NB: Please don't define this function, as it will break some legacy code in client
    #     Use the len() function instead
    #def __nonzero__(self):
    #    d = self.data
    #    return not (not (d[0] or d[1]))

    # -----------------------------------------------------------------------------------
    #  FIFO - __contains__
    # -----------------------------------------------------------------------------------
    def __contains__(self, o):
        d = self.data
        return (o in d[0]) or (o in d[1])


    # -----------------------------------------------------------------------------------
    #  FIFO - Length
    # -----------------------------------------------------------------------------------
    def Length(self):
        d = self.data
        return len(d[0]) + len(d[1])

    # -----------------------------------------------------------------------------------
    #  FIFO - clear
    # -----------------------------------------------------------------------------------
    def clear(self):
        self.data = [[], []]

    # -----------------------------------------------------------------------------------
    #  FIFO - clear
    # -----------------------------------------------------------------------------------
    def remove(self, o):
        d = self.data
        try:
            d[0].remove(o)
        except ValueError:
            sys.exc_clear()

        try:
            d[1].remove(o)
        except ValueError:
            sys.exc_clear()


# -----------------------------------------------------------------------------------
#  Queue - QueueCheck
# -----------------------------------------------------------------------------------
def QueueCheck(o):

    while True:
        try:
            o.pump()
        except ReferenceError:
            sys.exc_clear()
            break
        except StandardError:
            StackTrace()
            sys.exc_clear()

        Sleep(0.1)


# -----------------------------------------------------------------------------------
#  Queue Class
# -----------------------------------------------------------------------------------
class Queue(FIFO):
    """A queue is a microthread-safe FIFO."""

    # -----------------------------------------------------------------------------------
    #  Queue - Constructor
    # -----------------------------------------------------------------------------------
    def __init__(self):
        FIFO.__init__(self)
        self.channel  = stackless.channel()
        self.blockingThreadRunning = False

    # -----------------------------------------------------------------------------------
    #  Queue - put
    # -----------------------------------------------------------------------------------
    def put(self, x):
        self.push(x)
        self.pump()

    # -----------------------------------------------------------------------------------
    #  Queue - pump
    # -----------------------------------------------------------------------------------
    def pump(self):

        while self.channel.queue and self.Length() and self.channel.balance < 0:
            o = self.pop()
            self.channel.send(o)

    # -----------------------------------------------------------------------------------
    #  Queue - non_blocking_put
    # -----------------------------------------------------------------------------------
    def non_blocking_put(self, x):

        # Create a non blocking worker thread if this is the first time this gets called
        if not self.blockingThreadRunning:
            self.blockingThreadRunning = True
            new(QueueCheck, weakref.proxy(self)).context = "uthread::QueueCheck"

        self.push(x)

    # -----------------------------------------------------------------------------------
    #  Queue - get
    # -----------------------------------------------------------------------------------
    def get(self):
        if self.Length():
            return self.pop()

        return self.channel.receive()


# --------------------------------------------------------------------
class Event:

    # --------------------------------------------------------------------
    def __init__(self, manual=1, signaled=0):
        self.channel = stackless.channel()
        self.manual = manual
        self.signaled = signaled

    # --------------------------------------------------------------------
    def Wait(self, timeout=-1):
        if timeout != -1:
            raise RuntimeError("No timeouts supported in Event")

        if not self.signaled:
            self.channel.receive()

    # --------------------------------------------------------------------
    def SetEvent(self):
        if self.manual:
            self.signaled = 1

        while self.channel.queue:
            self.channel.send(None)

    # --------------------------------------------------------------------
    def ResetEvent(self):
        self.signaled = 0



def LockCheck():
    global semaphores
    while 1:
        each = None
        Sleep(5 * 60)
        now = time.time()
        try:
            for each in semaphores.keys():
                BeNice()
                if (each.count<=0) and (each.waiting.balance < 0) and (each.lockedWhen and (now - each.lockedWhen)>=(5*MIN)):
                    logger.error("Semaphore %s appears to have threads in a locking conflict."%id(each))
                    logger.error("holding thread:")
                    try:
                        for s in traceback.format_list(traceback.extract_stack(each.thread.frame,40)):
                            logger.error(s)
                    except:
                        sys.exc_clear()
                    first = each.waiting.queue
                    t = first
                    while t:
                        logger.error("waiting thread %s:"%id(t),4)
                        try:
                            for s in traceback.format_list(traceback.extract_stack(t.frame,40)):
                                logger.error(s,4)
                        except:
                            sys.exc_clear()
                        t = t.next
                        if t is first:
                            break
                    logger.error("End of locking conflict log")
        except StandardError:
            StackTrace()
            sys.exc_clear()

new(LockCheck).context = "uthread::LockCheck"

__uthread__queue__          = None
def PoolHelper(queue):
    t = stackless.getcurrent()
    t.localStorage   = {}
    respawn = True
    try:
        try:
            while 1:
                BeNice()
                ctx, callingContext, func, args, keywords = queue.get()
                if (queue.channel.balance >= 0):
                    new(PoolHelper, queue).context = "uthread::PoolHelper"
                #SetLocalStorage(loc)
                # _tmpctx = t.PushTimer(ctx)
                try:
                    apply( func, args, keywords )
                finally:
                    ctx                 = None
                    callingContext      = None
                    func                = None
                    #t.localStorage      = {}
                    #loc                 = None
                    args                = None
                    keywords            = None
                    # t.PopTimer(_tmpctx)
        except SystemExit:
            respawn = False
            raise
        except:
            if callingContext is not None:
                extra = "spawned at %s %s(%s)"%callingContext
            else:
                extra = ""
            StackTrace("Unhandled exception in %s%s" % (ctx, extra))
            sys.exc_clear()
    finally:
        if respawn:
            del t
            new(PoolHelper, queue).context = "uthread::PoolHelper"

def PoolWorker(ctx,func,*args,**keywords):
    '''
        Same as uthread.pool, but without copying local storage, thus resetting session, etc.

        Should be used for spawning worker threads.
    '''
    return PoolWithoutTheStars(ctx,func,args,keywords,0,1)

def PoolWorkerWithoutTheStars(ctx,func,args,keywords):
    '''
        Same as uthread.worker, but without copying local storage, thus resetting session, etc.

        Should be used for spawning worker threads.
    '''
    return PoolWithoutTheStars(ctx,func,args,keywords,0,1)

def PoolWithoutTheStars(ctx,func,args,keywords,unsafe=0,worker=0):
    if type(ctx) not in types.StringTypes:
        StackTrace("uthread.pool must be called with a context string as the first parameter")
    global __uthread__queue__
    callingContext = None
    if ctx is None:
        if unsafe:
            ctx = "uthread::PoolHelper::UnsafeCrap"
        else:
            tb = traceback.extract_stack(limit=2)[0]
            ctx = getattr(stackless.getcurrent(), "context", "")
            callingContext = tb[2], tb[0], tb[1] #function , file, lineno
            del tb

    if __uthread__queue__ is None:
        __uthread__queue__ = Queue()
        for i in range(60):
            new(PoolHelper, __uthread__queue__).context = "uthread::PoolHelper"
    #if unsafe or worker:
    #    st = None
    #else:
    #    st = copy.copy(GetLocalStorage())
    __uthread__queue__.non_blocking_put( (str(ctx), callingContext, func, args, keywords,) )
    return None

def Pool(ctx,func,*args,**keywords):
    '''
        executes apply(args,keywords) on a new uthread.  The uthread in question is taken
        from a thread pool, rather than created one-per-shot call.  ctx is used as the
        thread context.  This should generally be used for short-lived threads to reduce
        overhead.
    '''
    return PoolWithoutTheStars(ctx,func,args,keywords)

def UnSafePool(ctx,func,*args,**keywords):
    '''
        uthread.pool, but without any dangerous calls to stackless.getcurrent(), which could
        have dramatic and drastic effects in the wrong context.
    '''
    return PoolWithoutTheStars(ctx,func,args,keywords,1)

def ParallelHelper(ch,idx,what):
    ch, threadid = ch
    MakeCurrentSynonymOf(threadid)
    try:
        ei = None
        try:
            if len(what)==3:
                ret = (idx, apply(what[0], what[1], what[2] ))
                if ch.balance < 0 :
                    ch.send( (1, ret) )
            else:
                ret = (idx, apply(what[0], what[1] ))
                if ch.balance < 0:
                    ch.send( (1, ret) )
        except StandardError:
            ei = sys.exc_info()
            sys.exc_clear()

        if ei:
            if ch.balance < 0:
                ch.send((0,ei))
        del ei
    finally:
       RemoveCurrentSynonymOf(threadid)

def Parallel(funcs,exceptionHandler=None,maxcount=30):
    '''
        Executes in parallel all the function calls specified in the list/tuple 'funcs', but returns the
        return values in the order of the funcs list/tuple.  If an exception occurs, only the first exception
        will reach you.  The rest will dissapear in a puff of logic.

        Each 'func' entry should be a tuple/list of:
        1.  a function to call
        2.  a tuple of arguments to call it with
        3.  optionally, a dict of keyword args to call it with.
    '''
    if not funcs:
        return

    context = "ParallelHelper::"+getattr(stackless.getcurrent(),"context","???")
    ch = stackless.channel(), id(stackless.getcurrent())
    ret = [ None ] * len(funcs)
    n = len(funcs)
    if n > maxcount:
        n = maxcount
    for i in range(n):
        if type(funcs[i]) != types.TupleType:
            raise RuntimeError("Parallel requires a list/tuple of (function, args tuple, optional keyword dict,)")
        Pool(context, ParallelHelper, ch, i, funcs[i])
    for i in range(len(funcs)):
        ok, bunch = ch[0].receive()
        if ok:
            idx,val = bunch
            if len(funcs[i])==4:
                ret[idx] = (funcs[i][3], val,)
            else:
                ret[idx] = val
        else:
            try:
                raise bunch[0],bunch[1],bunch[2]
            except StandardError:
                if exceptionHandler:
                    exctype, exc, tb = sys.exc_info()
                    try:
                        try:
                            apply( exceptionHandler, (exc,) )
                        except StandardError:
                            raise exc, None, tb
                    finally:
                        exctype, exc, tb = None, None, None
                else:
                    StackTrace()
                    raise

        if n<len(funcs):
            if type(funcs[n]) != types.TupleType:
                raise RuntimeError("Parallel requires a list/tuple of (function, args tuple, optional keyword dict,)")
            Pool(context, ParallelHelper, ch, n, funcs[n])
            n+=1
    return ret

locks = {}
def Lock(object, *args):
    global locks
    t = (id(object), args)
    if t not in locks:
        locks[t] = Semaphore(t, strict=False)
    locks[t].acquire()

def TryLock(object, *args):
    global locks
    t = (id(object), args)

    if t not in locks:
        locks[t] = Semaphore(t, strict=False)
    if not locks[t].IsCool():
        return False
    locks[t].acquire()
    return True

def ReentrantLock(object, *args):
    global locks
    t = (id(object), args)
    if t not in locks:
        locks[t] = CriticalSection(t)
    locks[t].acquire()

def UnLock(object, *args):
    global locks
    t = (id(object), args)
    locks[t].release()
    if (t in locks) and (locks[t].IsCool()): # may be gone or changed by now
        del locks[t]

# Exported names.
parallel = Parallel
worker = PoolWorker
workerWithoutTheStars = PoolWorkerWithoutTheStars
unsafepool = UnSafePool
pool = Pool
poolWithoutTheStars = PoolWithoutTheStars


