import unittest
import stackless
import threading

class TestChannels(unittest.TestCase):
    def setUp(self):
        self.assertEqual(stackless.getruncount(), 1, "Leakage from other tests, with %d tasklets still in the scheduler" % (stackless.getruncount() - 1))

    def tearDown(self):
        self.assertEqual(stackless.getruncount(), 1, "Leakage from this test, with %d tasklets still in the scheduler" % (stackless.getruncount() - 1))        

    def testBlockingSend(self):
        ''' Test that when a tasklet sends to a channel without waiting receivers, the tasklet is blocked. '''

        # Function to block when run in a tasklet.
        def f(testChannel):
            testChannel.send(1)

        # Get the tasklet blocked on the channel.
        channel = stackless.channel()
        tasklet = stackless.tasklet(f)(channel)
        tasklet.run()
        
        # The tasklet should be blocked.
        self.assertTrue(tasklet.blocked, "The tasklet should have been run and have blocked on the channel waiting for a corresponding receiver")

        # The channel should have a balance indicating one blocked sender.
        self.assertTrue(channel.balance == 1, "The channel balance should indicate one blocked sender waiting for a corresponding receiver")

    def testBlockingReceive(self):
        ''' Test that when a tasklet receives from a channel without waiting senders, the tasklet is blocked. '''

        # Function to block when run in a tasklet.
        def f(testChannel):
            testChannel.receive()

        # Get the tasklet blocked on the channel.
        channel = stackless.channel()
        tasklet = stackless.tasklet(f)(channel)
        tasklet.run()
        
        # The tasklet should be blocked.
        self.assertTrue(tasklet.blocked, "The tasklet should have been run and have blocked on the channel waiting for a corresponding sender")

        # The channel should have a balance indicating one blocked sender.
        self.assertEqual(channel.balance, -1, "The channel balance should indicate one blocked receiver waiting for a corresponding sender")

    def testNonBlockingSend(self):
        ''' Test that when there is a waiting receiver, we can send without blocking with normal channel behaviour. '''

        originalValue = 1
        receivedValues = []
    
        # Function to block when run in a tasklet.
        def f(testChannel):
            receivedValues.append(testChannel.receive())

        # Get the tasklet blocked on the channel.
        channel = stackless.channel()
        tasklet = stackless.tasklet(f)(channel)
        tasklet.run()

        # Make sure that the current tasklet cannot block when it tries to receive.  We do not want
        # to exit this test having clobbered the block trapping value, so we make sure we restore
        # it.
        oldBlockTrap = stackless.getcurrent().block_trap
        try:
            stackless.getcurrent().block_trap = True
            channel.send(originalValue)
        finally:
            stackless.getcurrent().block_trap = oldBlockTrap
        
        self.assertTrue(len(receivedValues) == 1 and receivedValues[0] == originalValue, "We sent a value, but it was not the one we received.  Completely unexpected.")

    def testNonBlockingReceive(self):
        ''' Test that when there is a waiting sender, we can receive without blocking with normal channel behaviour. '''
        originalValue = 1
    
        # Function to block when run in a tasklet.
        def f(testChannel, valueToSend):
            testChannel.send(valueToSend)

        # Get the tasklet blocked on the channel.
        channel = stackless.channel()
        tasklet = stackless.tasklet(f)(channel, originalValue)
        tasklet.run()

        # Make sure that the current tasklet cannot block when it tries to receive.  We do not want
        # to exit this test having clobbered the block trapping value, so we make sure we restore
        # it.
        oldBlockTrap = stackless.getcurrent().block_trap
        try:
            stackless.getcurrent().block_trap = True
            value = channel.receive()
        finally:
            stackless.getcurrent().block_trap = oldBlockTrap

        tasklet.kill()
        
        self.assertEqual(value, originalValue, "We received a value, but it was not the one we sent.  Completely unexpected.")

    def testMainTaskletBlockingWithoutASender(self):
        ''' Test that the last runnable tasklet cannot be blocked on a channel. '''    
        self.assertEqual(stackless.getruncount(), 1, "Leakage from other tests, with tasklets still in the scheduler.")
        
        c = stackless.channel()
        self.assertRaises(RuntimeError, c.receive)

    def testInterthreadCommunication(self):
        ''' Test that tasklets in different threads sending over channels to each other work. '''    
        self.assertEqual(stackless.getruncount(), 1, "Leakage from other tests, with tasklets still in the scheduler.")

        commandChannel = stackless.channel()

        def master_func():
            commandChannel.send("ECHO 1")
            commandChannel.send("ECHO 2")
            commandChannel.send("ECHO 3")
            commandChannel.send("QUIT")

        def slave_func():
            while 1:
                command = commandChannel.receive()
                if command == "QUIT":
                    break

        def scheduler_run(tasklet_func):
            t = stackless.tasklet(tasklet_func)()
            while t.alive:
                stackless.run()

        thread = threading.Thread(target=scheduler_run, args=(master_func,))
        thread.start()

        scheduler_run(slave_func)


if __name__ == '__main__':
    import sys
    if not sys.argv[1:]:
        sys.argv.append('-v')
    unittest.main()
