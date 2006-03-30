#include <Python.h>


/***********************************************************

A PyGreenlet is a range of C stack addresses that must be
saved and restored in such a way that the full range of the
stack contains valid data when we switch to it.

Stack layout for a greenlet:

               |     ^^^       |
               |  older data   |
               |               |
  stack_stop . |_______________|
        .      |               |
        .      | greenlet data |
        .      |   in stack    |
        .    * |_______________| . .  _____________  stack_copy + stack_saved
        .      |               |     |             |
        .      |     data      |     |greenlet data|
        .      |   unrelated   |     |    saved    |
        .      |      to       |     |   in heap   |
 stack_start . |     this      | . . |_____________| stack_copy
               |   greenlet    |
               |               |
               |  newer data   |
               |     vvv       |


Note that a greenlet's stack data is typically partly at its correct
place in the stack, and partly saved away in the heap, but always in
the above configuration.

Greenlets are chained: each points to the previous greenlet, which is
the one that owns the data currently in the C stack above my
stack_stop.  The currently running greenlet is the first element of
this chain.  The main (initial) greenlet is the last one.  Greenlets
whose stack is entirely in the heap can be skipped from the chain.

The chain is not related to execution order, but only to the order
in which bits of C stack happen to belong to greenlets at a particular
point in time.

The main greenlet doesn't have a stack_stop: it is responsible for the
complete rest of the C stack, and we don't know where it begins.  We
use (char*) -1, the largest possible address.

The running greenlet's stack_start is undefined.
A greenlet that finished its execution has stack_stop == NULL.

 ***********************************************************/


typedef struct _greenlet {
	PyObject_HEAD
	char* stack_start;
	char* stack_stop;
	char* stack_copy;
	long stack_saved;
	struct _greenlet* stack_prev;
	struct _greenlet* parent;
} PyGreenlet;

staticforward PyTypeObject PyGreen_Type;

#define PyGreen_Check(op) PyObject_TypeCheck(op, &PyGreen_Type)
#define PyGreen_Finished(op) (((PyGreenlet*)(op))->stack_stop == NULL)

static PyObject* PyGreen_New(PyObject* func, PyObject* fargs, PyObject* fkwds);
static PyObject* PyGreen_Switch(PyObject* g, PyObject* value);


/*** global state: XXX move to the ThreadState ***/

static PyGreenlet ts_main = {
	PyObject_HEAD_INIT(&PyGreen_Type)
	NULL,		/* stack_start */
	(char*) -1,	/* stack_stop */
	NULL,		/* stack_copy */
	0,		/* stack_saved */
	NULL,		/* stack_prev */
	NULL};		/* parent */

static PyGreenlet* ts_current = &ts_main;
static PyGreenlet* ts_target;
static PyObject* ts_passaround;


/***********************************************************/

static int g_save(PyGreenlet* g, char* stop)
{
	/* Save more of g's stack into the heap -- at least up to 'stop'

	   g->stack_stop |________|
	                 |        |
			 |    __ stop       . . . . .
	                 |        |    ==>  .       .
			 |________|          _______
			 |        |         |       |
			 |        |         |       |
	  g->stack_start |        |         |_______| g->stack_copy

	 */
	long sz1 = g->stack_saved;
	long sz2 = stop - g->stack_start;
	if (sz2 > sz1) {
		char* c = PyMem_Realloc(g->stack_copy, sz2);
		if (!c) {
			PyErr_NoMemory();
			return -1;
		}
		memcpy(c+sz1, g->stack_start+sz1, sz2-sz1);
		g->stack_copy = c;
		g->stack_saved = sz2;
	}
	return 0;
}

static void slp_restore_state(void)
{
	PyGreenlet* g = ts_target;
	
	/* Restore the heap copy back into the C stack */
	if (g->stack_saved != 0) {
		memcpy(g->stack_start, g->stack_copy, g->stack_saved);
		PyMem_Free(g->stack_copy);
		g->stack_copy = NULL;
		g->stack_saved = 0;
	}
	g->stack_prev = ts_current;
	ts_current = g;
}

static int slp_save_state(char* stackref)
{
	/* must free all the C stack up to target_stop */
	char* target_stop = ts_target->stack_stop;
	assert(ts_current->stack_saved == 0);
	ts_current->stack_start = stackref;
	
	while (ts_current->stack_stop < target_stop) {
		/* ts_current is entierely within the area to free */
		if (ts_current->stack_stop != NULL) {
			if (g_save(ts_current, ts_current->stack_stop))
				return -1;  /* XXX */
		}
		ts_current = ts_current->stack_prev;
	}
	if (ts_current != ts_target) {
		if (g_save(ts_current, target_stop))
			return -1;  /* XXX */
	}
	return 0;
}


/*
 * the following macros are spliced into the OS/compiler
 * specific code, in order to simplify maintenance.
 */

#define SLP_SAVE_STATE(stackref, stsizediff)		\
  stackref += STACK_MAGIC;				\
  if (slp_save_state((char*)stackref)) return -1;	\
  if (ts_target->stack_start == NULL) return -1;	\
  stsizediff = ts_target->stack_start - (char*)stackref

#define SLP_RESTORE_STATE()			\
  slp_restore_state()


#define SLP_EVAL
#include "slp_platformselect.h"


static PyObject* g_switch(PyGreenlet* self, PyObject* value)
{
	PyThreadState* tstate = PyThreadState_GET();
	struct _frame* frame = tstate->frame;
	int recursion_depth = tstate->recursion_depth;
	int err;
	while (PyGreen_Finished(self)) {
		self = self->parent;
	}
	ts_target = self;
	ts_passaround = value;
	err = slp_switch();
	if (err) {
		Py_XDECREF(value);
		return NULL;
	}
	tstate = PyThreadState_GET();
	tstate->recursion_depth = recursion_depth;
	tstate->frame = frame;
	return ts_passaround;
}

/* forward -- trying hard to prevent the compiler from inlining */
static void g_initialstub(PyGreenlet* self, PyObject* func,
			  PyObject* fargs, PyObject* fkwds);

static int g_start(PyGreenlet* self, PyGreenlet* parent, PyObject* func,
		    PyObject* fargs, PyObject* fkwds)
{
	void* dummymarker;
	if (PyErr_Occurred()) {
		PyErr_WriteUnraisable((PyObject*) self);
	}
	self->stack_stop = (char*) &dummymarker;
	self->stack_prev = ts_current;
	if (self->parent == NULL) {
		Py_INCREF(parent);
		self->parent = parent;
	}
	else if (self->parent != parent) {
		PyErr_SetString(PyExc_ValueError, "cannot change parent");
		return -1;
	}
	g_initialstub(self, func, fargs, fkwds);
	if (self->stack_prev != ts_current)
		Py_FatalError("corrupted state");
	return 0;
}

static void g_initialstub(PyGreenlet* self, PyObject* func,
			  PyObject* fargs, PyObject* fkwds)
{
	PyObject* result;
	assert(ts_current->stack_saved == 0);
	ts_current->stack_start = NULL;
	ts_current = self;
	Py_INCREF(func);
	Py_XINCREF(fargs);
	Py_XINCREF(fkwds);
	/* save only -- returns twice! */
	if (g_switch(self->stack_prev, NULL) == NULL && !PyErr_Occurred()) {
		/* first return, from the save operation.
		   ts_current is restored to the parent */
		return;
	}
	/* second return, when someone actually switches to 'self' */
	if (PyErr_Occurred())
		result = NULL;
	else
		result = PyEval_CallObjectWithKeywords(func, fargs, fkwds);
	if (PyErr_Occurred() && PyErr_ExceptionMatches(PyExc_SystemExit)) {
		PyObject *exc, *val, *tb;
		PyErr_Fetch(&exc, &val, &tb);
		if (val == NULL) {
			Py_INCREF(Py_None);
			val = Py_None;
		}
		result = val;
		Py_DECREF(exc);
		Py_XDECREF(tb);
	}
	Py_XDECREF(fkwds);
	Py_XDECREF(fargs);
	Py_DECREF(func);
        ts_current->stack_stop = NULL;  /* dead */
	g_switch(ts_current, result);
	/* must not return from here! */
	Py_FatalError("XXX memory exhausted at a very bad moment");
}


/***********************************************************/


static PyObject* PyGreen_New(PyObject* func, PyObject* fargs, PyObject* fkwds)
{
	PyGreenlet* o = PyObject_New(PyGreenlet, &PyGreen_Type);
	if (o == NULL)
		return NULL;
	if (g_start(o, ts_current, func, fargs, fkwds)) {
		Py_DECREF(o);
		return NULL;
	}
	return (PyObject*) o;
}

static int green_init(PyGreenlet *self, PyObject *args, PyObject *kw)
{
	PyGreenlet* nparent = ts_current;
	PyObject *func, *fargs=NULL, *fkwds=NULL;
	static char *kwlist[] = {"func", "args", "kwds", "parent", 0};

	if (!PyArg_ParseTupleAndKeywords(args, kw, "O|OOO:green", kwlist,
					 &func, &fargs, &fkwds, &nparent))
		return -1;
	if (!PyGreen_Check(nparent)) {
		PyErr_SetString(PyExc_TypeError, "parent must be a greenlet");
		return -1;
	}
	if (self->stack_stop != NULL) {
		PyErr_SetString(PyExc_RuntimeError, "greenlet already running");
		return -1;
	}
	return g_start(self, nparent, func, fargs, fkwds);
}

static void green_dealloc(PyGreenlet* self)
{
	if (!PyGreen_Finished(self)) {
		/* Hacks hacks hacks copied from instance_dealloc() */
		PyObject* result;
		PyObject *error_type, *error_value, *error_traceback;
		/* Temporarily resurrect the greenlet. */
		assert(self->ob_refcnt == 0);
		self->ob_refcnt = 1;
		/* Save the current exception, if any. */
		PyErr_Fetch(&error_type, &error_value, &error_traceback);
		/* Send the greenlet a SystemExit exception. */
		PyErr_SetNone(PyExc_SystemExit);
		result = PyGreen_Switch((PyObject*) self, NULL);
		if (result != NULL)
			Py_DECREF(result);
		else {
			PyErr_WriteUnraisable((PyObject*) self);
			/* XXX */
		}
		/* Restore the saved exception. */
		PyErr_Restore(error_type, error_value, error_traceback);
		/* Undo the temporary resurrection; can't use DECREF here,
		 * it would cause a recursive call.
		 */
		assert(self->ob_refcnt > 0);
		if (--self->ob_refcnt != 0) {
			/* Resurrected! */
			int refcnt = self->ob_refcnt;
			_Py_NewReference((PyObject*) self);
			self->ob_refcnt = refcnt;
#ifdef COUNT_ALLOCS
			--self->ob_type->tp_frees;
			--self->ob_type->tp_allocs;
#endif
			return;
		}
	}
	Py_XDECREF(self->parent);
	PyObject_Del((PyObject*) self);
}

static PyObject* PyGreen_Switch(PyObject* g, PyObject* value)
{
	if (!PyGreen_Check(g)) {
		PyErr_BadInternalCall();
		return NULL;
	}
	Py_XINCREF(value);
	return g_switch((PyGreenlet*) g, value);
}

static PyObject* green_switch(PyGreenlet* self, PyObject* args)
{
	PyObject* value = Py_None;
	if (!PyArg_ParseTuple(args, "|O:switch", &value))
		return NULL;
	Py_INCREF(value);
	return g_switch(self, value);
}

static int green_nonzero(PyGreenlet* self)
{
	return !PyGreen_Finished(self);
}

static PyObject* green_getparent(PyGreenlet* self, void* c)
{
	PyObject* result = self->parent ? (PyObject*) self->parent : Py_None;
	Py_INCREF(result);
	return result;
}

static int green_setparent(PyGreenlet* self, PyGreenlet* nparent, void* c)
{
	PyGreenlet* p;
	if (!PyGreen_Check(nparent)) {
		PyErr_SetString(PyExc_TypeError, "parent must be a greenlet");
		return -1;
	}
	for (p=nparent; p; p=p->parent) {
		if (p == self) {
			PyErr_SetString(PyExc_ValueError, "cyclic parent chain");
			return -1;
		}
	}
	p = self->parent;
	self->parent = nparent;
	Py_INCREF(nparent);
	Py_DECREF(p);
	return 0;
}


/***********************************************************/


static PyMethodDef green_methods[] = {
    {"switch", (PyCFunction)green_switch, METH_VARARGS, /*XXXswitch_doc*/ NULL},
    {NULL,     NULL}		/* sentinel */
};

static PyGetSetDef green_getsets[] = {
	{"parent", (getter)green_getparent,
		   (setter)green_setparent, /*XXX*/ NULL},
	{NULL}
};

static PyNumberMethods green_as_number = {
	NULL,		/* nb_add */
	NULL,		/* nb_subtract */
	NULL,		/* nb_multiply */
	NULL,		/* nb_divide */
	NULL,		/* nb_remainder */
	NULL,		/* nb_divmod */
	NULL,		/* nb_power */
	NULL,		/* nb_negative */
	NULL,		/* nb_positive */
	NULL,		/* nb_absolute */
	(inquiry)green_nonzero,	/* nb_nonzero */
};

statichere PyTypeObject PyGreen_Type = {
	PyObject_HEAD_INIT(&PyType_Type)
	0,
	"greenlet.greenlet",
	sizeof(PyGreenlet),
	0,
	(destructor)green_dealloc,		/* tp_dealloc */
	0,					/* tp_print */
	0,					/* tp_getattr */
	0,					/* tp_setattr */
	0,					/* tp_compare */
	0,					/* tp_repr */
	&green_as_number,			/* tp_as _number*/
	0,					/* tp_as _sequence*/
	0,					/* tp_as _mapping*/
	0, 					/* tp_hash */
	0,					/* tp_call */
	0,					/* tp_str */
	PyObject_GenericGetAttr,		/* tp_getattro */
	0,					/* tp_setattro */
	0,					/* tp_as_buffer*/
	Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE,  /* tp_flags */
	0,					/* tp_doc */
 	0,					/* tp_traverse */
	0,					/* tp_clear */
	0,					/* tp_richcompare */
	0,					/* tp_weaklistoffset */
	0,					/* tp_iter */
	0,					/* tp_iternext */
	green_methods,				/* tp_methods */
	0,					/* tp_members */
	green_getsets,				/* tp_getset */
	0,					/* tp_base */
	0,					/* tp_dict */
	0,					/* tp_descr_get */
	0,					/* tp_descr_set */
	0,					/* tp_dictoffset */
	(initproc)green_init,			/* tp_init */
	PyType_GenericAlloc,			/* tp_alloc */
	PyType_GenericNew,			/* tp_new */
	PyObject_Del,				/* tp_free */
};
/* XXX need GC support */


static PyObject* mod_getcurrent(PyObject* self)
{
	Py_INCREF(ts_current);
	return (PyObject*) ts_current;
}

static PyMethodDef GreenMethods[] = {
	{"getcurrent", (PyCFunction)mod_getcurrent, METH_NOARGS, /*XXX*/ NULL},
	{NULL,     NULL}        /* Sentinel */
};

void initgreenlet(void)
{
	PyObject* m = Py_InitModule("greenlet", GreenMethods);
        Py_INCREF(&PyGreen_Type);
	PyModule_AddObject(m, "greenlet", (PyObject*) &PyGreen_Type);
        Py_INCREF(&ts_main);
	PyModule_AddObject(m, "main", (PyObject*) &ts_main);
}
