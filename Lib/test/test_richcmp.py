# Tests for rich comparisons

from test_support import TestFailed

class Number:

    def __init__(self, x):
        self.x = x

    def __lt__(self, other):
        return self.x < other

    def __le__(self, other):
        return self.x <= other

    def __eq__(self, other):
        return self.x == other

    def __ne__(self, other):
        return self.x != other

    def __gt__(self, other):
        return self.x > other

    def __ge__(self, other):
        return self.x >= other

    def __cmp__(self, other):
        raise TestFailed, "Number.__cmp__() should not be called"

    def __repr__(self):
        return "Number(%s)" % repr(self.x)

class Vector:

    def __init__(self, data):
        self.data = data

    def __len__(self):
        return len(self.data)

    def __getitem__(self, i):
        return self.data[i]

    def __setitem__(self, i, v):
        self.data[i] = v

    def __hash__(self):
        raise TypeError, "Vectors cannot be hashed"

    def __nonzero__(self):
        raise TypeError, "Vectors cannot be used in Boolean contexts"

    def __cmp__(self, other):
        raise TestFailed, "Vector.__cmp__() should not be called"

    def __repr__(self):
        return "Vector(%s)" % repr(self.data)

    def __lt__(self, other):
        return Vector([a < b for a, b in zip(self.data, self.__cast(other))])

    def __le__(self, other):
        return Vector([a <= b for a, b in zip(self.data, self.__cast(other))])

    def __eq__(self, other):
        return Vector([a == b for a, b in zip(self.data, self.__cast(other))])

    def __ne__(self, other):
        return Vector([a != b for a, b in zip(self.data, self.__cast(other))])

    def __gt__(self, other):
        return Vector([a > b for a, b in zip(self.data, self.__cast(other))])

    def __ge__(self, other):
        return Vector([a >= b for a, b in zip(self.data, self.__cast(other))])

    def __cast(self, other):
        if isinstance(other, Vector):
            other = other.data
        if len(self.data) != len(other):
            raise ValueError, "Cannot compare vectors of different length"
        return other

operators = "<", "<=", "==", "!=", ">", ">="
opmap = {}
for op in operators:
    opmap[op] = eval("lambda a, b: a %s b" % op)

def testvector():
    a = Vector(range(2))
    b = Vector(range(3))
    for op in operators:
        try:
            opmap[op](a, b)
        except ValueError:
            pass
        else:
            raise TestFailed, "a %s b for different length should fail" % op
    a = Vector(range(5))
    b = Vector(5 * [2])
    for op in operators:
        print "%23s %-2s %-23s -> %s" % (a, op, b, opmap[op](a, b))
        print "%23s %-2s %-23s -> %s" % (a, op, b.data, opmap[op](a, b.data))
        print "%23s %-2s %-23s -> %s" % (a.data, op, b, opmap[op](a.data, b))
        try:
            if opmap[op](a, b):
                raise TestFailed, "a %s b shouldn't be true" % op
            else:
                raise TestFailed, "a %s b shouldn't be false" % op
        except TypeError:
            pass

def testop(a, b, op):
    try:
        ax = a.x
    except AttributeError:
        ax = a
    try:
        bx = b.x
    except AttributeError:
        bx = b
    opfunc = opmap[op]
    realoutcome = opfunc(ax, bx)
    testoutcome = opfunc(a, b)
    if realoutcome != testoutcome:
        print "Error for", a, op, b, ": expected", realoutcome,
        print "but got", testoutcome
##    else:
##        print a, op, b, "-->", testoutcome # and "true" or "false"

def testit(a, b):
    testop(a, b, "<")
    testop(a, b, "<=")
    testop(a, b, "==")
    testop(a, b, "!=")
    testop(a, b, ">")
    testop(a, b, ">=")

def basic():
    for a in range(3):
        for b in range(3):
            testit(Number(a), Number(b))
            testit(a, Number(b))
            testit(Number(a), b)

def tabulate(c1=Number, c2=Number):
    for op in operators:
        opfunc = opmap[op]
        print
        print "operator:", op
        print
        print "%9s" % "",
        for b in range(3):
            b = c2(b)
            print "| %9s" % b,
        print "|"
        print '----------+-' * 4
        for a in range(3):
            a = c1(a)
            print "%9s" % a,
            for b in range(3):
                b = c2(b)
                print "| %9s" % opfunc(a, b),
            print "|"
        print '----------+-' * 4
    print
    print '*' * 50
                
def main():
    basic()
    tabulate()
    tabulate(c1=int)
    tabulate(c2=int)
    testvector()

main()
