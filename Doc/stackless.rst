****************
Stackless Python
****************

:Author: Richard Tew (richard.m.tew at gmail.com)
:Release: |release|
:Date: |today|

`Stackless Python <http://www.stackless.com>`_
is an enhanced version of the Python programming language.
It allows programmers to reap the benefits of thread-based programming without
the performance and complexity problems associated with conventional threads.
The microthreads that Stackless adds to Python are a cheap and lightweight
convenience, which if used properly, can not only serve as a way to structure
an application or framework, but by doing so improve program structure and
facilitate more readable code.

If you are reading this text as part of a version of Python you have installed,
then you have installed Stackless rather than standard Python.

Overview
========

Unless actual use is made of the enhanced functionality that Stackless adds
to Python, Stackless will behave exactly the same as Python would and is used
in exactly the same way.  This functionality is exposed as a framework
through the :mod:`stackless` module.

.. toctree::
   
   library/stackless/stackless.rst

What You Need To Know
=====================

Stackless Python provides a minimal framework and it is not accompanied by any
support functionality, to address the common needs that may arise when building
a more targeted framework around it.

When operations are invoked that block the Python interpreter, the user needs
to be aware that this inherently blocks all running tasklets.  Until the tasklet
that engaged that operation is complete, the Python interpreter and therefore
scheduler is blocked on that operation and in that tasklet.  Operations that
block the interpreter are often related to synchronous IO (file reading
and writing, socket operations, interprocess communication and more), although
:func:`time.sleep` should also be kept in mind.  The user is advised to use
asynchronous versions of IO functionality.

External Resources
==================

There are a range of resources available outside of this document:

 * The Stackless `mailing list <http://www.stackless.com/mailman/listinfo/stackless>`_.
 * The Stackless `examples project <http://code.google.com/p/stacklessexamples>`_.
 * Grant Olson's tutorial: `Introduction to Concurrent Programming with Stackless Python <http://members.verizon.net/olsongt/stackless/why_stackless.html>`_.

History
=======

Continuations are a feature that require the programming language they are
part of, to be implemented in a way conducive to their presence.  In order to
add them to the Python programming language, Christian Tismer modified it
extensively.  The primary way in which it was modified, was to make it Stackless.
And so, his fork of Python was named Stackless Python.

Now, storing data on the stack locks execution on an operating system thread to
the current executing functionality, until that functionality completes and the
stack usage is released piece by piece.  In order to add continuations to Python,
that data needed to be stored on the heap instead, therefore decoupling the
executing functionality from the stack.  With the extensive changes this required
in place, Christian `released Stackless Python
<http://mail.python.org/pipermail/python-dev/2000-January/001835.html>`_.

Maintaining the fork of a programming language is a lot of work, and when the
programming language changes in ways that are incompatible with the changes in
the fork, then that work is sigificantly increased.  Over time it became
obvious that the amount of changes to Python were too much weight to carry,
and Christian contemplated a rewrite of Stackless.  It became obvious that a
`simpler approach
<http://mail.python.org/pipermail/python-dev/2002-January/019671.html>`_ could
be taken, where Stackless was no longer stackless and no longer had continuations.

Following the rewrite, a framework was designed and added `inspired by
<http://www.stackless.com/pipermail/stackless/2002-May/000114.html>`_ coming from
`CSP <http://usingcsp.com/>`_ and the `Limbo
<http://en.wikipedia.org/wiki/Limbo_%28programming_language%29>`_ programming
language.  From this point on, Stackless was in a state where it contained the
minimum functionality to give the benefits it aimed to provide, with the
minimum amount of work required to keep it maintained.

A few years later in 2004, while sprinting on Stackless in Berlin, Christian and
Armin Rigo `came up with a way
<http://www.stackless.com/pipermail/stackless-dev/2004-March/000022.html>`_ to
take the core functionality of Stackless and build an extension module that provided
it.  This was the creation of greenlets, which are very likely a more popular
tool than Stackless itself today.  The greenlet source code in practice can be
used as the base for green threading functionality not just in Python, but in
other programming languages and projects.

With Stackless Python a solid product, Christian's focus moved onto other
projects, `PyPy <http://pypy.org>`_ among them.  One of his interests in PyPy was
a proper implementation of the Stackless functionality, where it could be
integrated as a natural part of any Python built.

For a while, Stackless Python languished, with no new versions to match the
releases of Python itself.  Then in 2006, CCP sent Kristjan Valur Jonsson and
Richard Tew to PyCon where `they sprinted
<http://zope.stackless.com/Members/rmtew/News%20Archive/pycon2006/news_item_view>`_
with the aid of Christian Tismer.  The result was an up to date release of Stackless
Python.  From this point in time, maintaining and releasing Stackless Python
has been undertaken by Richard and Kristjan.