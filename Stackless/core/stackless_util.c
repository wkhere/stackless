#include "Python.h"

#ifdef STACKLESS
#include "stackless_impl.h"

/* backward compatibility */
#ifndef Py_TYPE
#define Py_TYPE(ob)	(ob->ob_type)
#endif

/* Shorthands to return certain errors */

PyObject *
slp_type_error(const char *msg)
{
	PyErr_SetString(PyExc_TypeError, msg);
	return NULL;
}

PyObject *
slp_runtime_error(const char *msg)
{
	PyErr_SetString(PyExc_RuntimeError, msg);
	return NULL;
}

PyObject *
slp_value_error(const char *msg)
{
	PyErr_SetString(PyExc_ValueError, msg);
	return NULL;
}

PyObject *
slp_null_error(void)
{
	if (!PyErr_Occurred())
		PyErr_SetString(PyExc_SystemError,
		    "null argument to internal routine");
	return NULL;
}


/* CAUTION: This function returns a borrowed reference */
PyFrameObject *
slp_get_frame(PyTaskletObject *task)
{
	PyThreadState *ts = PyThreadState_GET();

	return ts->st.current == task ? ts->frame : task->f.frame;
}

void slp_check_pending_irq()
{
	PyThreadState *ts = PyThreadState_GET();
	PyTaskletObject *current = ts->st.current;

	/* act only if hard irq is in effect */
	if (current->flags.pending_irq && !(ts->st.runflags & PY_WATCHDOG_SOFT)) {
		if (current->flags.atomic)
			return;
		if (!TASKLET_NESTING_OK(current))
			return;
		/* trigger interrupt */
		if (_Py_Ticker > 0)
			_Py_Ticker = 0;
		ts->st.ticker = 0;
		current->flags.pending_irq = 0;
	}
}

int 
slp_return_wrapper(PyObject *retval)
{
	STACKLESS_ASSERT();
	if (retval == NULL)
		return -1;
	if (STACKLESS_UNWINDING(retval)) {
		STACKLESS_UNPACK(retval);
		Py_XDECREF(retval);
		return 1;
	}
	Py_DECREF(retval);
	return 0;
}

int 
slp_int_wrapper(PyObject *retval)
{
	int ret = -909090;

	STACKLESS_ASSERT();
	if (retval != NULL) {
		ret = PyInt_AsLong(retval);
		Py_DECREF(retval);
	}
	return ret;
}

int 
slp_current_wrapper( int(*func)(PyTaskletObject*), PyTaskletObject *task )
{
	PyThreadState *ts = PyThreadState_GET();

	int ret;
	ts->st.main = (PyTaskletObject*)Py_None;
	ret = func(task);
	ts->st.main = NULL;
	return ret;
}

int
slp_resurrect_and_kill(PyObject *self, void(*killer)(PyObject *))
{
	/* modelled after typeobject.c's slot_tp_del */

	PyObject *error_type, *error_value, *error_traceback;

	/* Temporarily resurrect the object. */
	assert(self->ob_refcnt == 0);
	self->ob_refcnt = 1;

	/* Save the current exception, if any. */
	PyErr_Fetch(&error_type, &error_value, &error_traceback);

	killer(self);

	/* Restore the saved exception. */
	PyErr_Restore(error_type, error_value, error_traceback);

	/* Undo the temporary resurrection; can't use DECREF here, it would
	 * cause a recursive call.
	 */
	assert(self->ob_refcnt > 0);
	if (--self->ob_refcnt == 0)
		return 0;	/* this is the normal path out */

	/* __del__ resurrected it!  Make it look like the original Py_DECREF
	 * never happened.
	 */
	{
		Py_ssize_t refcnt = self->ob_refcnt;
		_Py_NewReference(self);
		self->ob_refcnt = refcnt;
	}
	assert(!PyType_IS_GC(Py_TYPE(self)) ||
	       _Py_AS_GC(self)->gc.gc_refs != _PyGC_REFS_UNTRACKED);
	/* If Py_REF_DEBUG, _Py_NewReference bumped _Py_RefTotal, so
	 * we need to undo that. */
	_Py_DEC_REFTOTAL;
	/* If Py_TRACE_REFS, _Py_NewReference re-added self to the object
	 * chain, so no more to do there.
	 * If COUNT_ALLOCS, the original decref bumped tp_frees, and
	 * _Py_NewReference bumped tp_allocs:  both of those need to be
	 * undone.
	 */
#ifdef COUNT_ALLOCS
	--Py_TYPE(self)->tp_frees;
	--Py_TYPE(self)->tp_allocs;
#endif
	/* This code copied from iobase_dealloc() (in 3.0) */
	/* When called from a heap type's dealloc, the type will be
	   decref'ed on return (see e.g. subtype_dealloc in typeobject.c).
	   This will undo that, thus preventing a crash.  But such a type
	   _will_ have had its dict and slots cleared. */
	if (PyType_HasFeature(Py_TYPE(self), Py_TPFLAGS_HEAPTYPE))
		Py_INCREF(Py_TYPE(self));

	return -1;
}

#endif
