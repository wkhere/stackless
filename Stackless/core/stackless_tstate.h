/*** addition to tstate ***/

typedef struct _sts {
    /* the blueprint for new stacks */
    struct _cstack *initial_stub;
    /* "serial" is incremented each time we create a new stub.
     * (enter "stackless" from the outside)
     * and "serial_last_jump" indicates to which stub the current
     * stack belongs.  This is used to find out if a stack switch
     * is required when the main tasklet exits
     */
#ifdef have_long_long
    long_long serial;
    long_long serial_last_jump;
#else
    long serial;
    long serial_last_jump;
#endif
    /* the base address for hijacking stacks. XXX deprecating */
    intptr_t *cstack_base;
    /* stack overflow check and init flag */
    intptr_t *cstack_root;
    /* main tasklet */
    struct _tasklet *main;
    /* runnable tasklets */
    struct _tasklet *current;
    int runcount;

    /* scheduling */
    long ticker;
    long interval;
    PyObject * (*interrupt) (void);    /* the fast scheduler */
    /* trap recursive scheduling via callbacks */
    int schedlock;
    int runflags;                               /* flags for stackless.run() behaviour */
#ifdef WITH_THREAD
    struct {
        PyObject *block_lock;                   /* to block the thread */
        int is_blocked;
    } thread;
#endif
    /* number of nested interpreters (1.0/2.0 merge) */
    int nesting_level;
    PyObject *del_post_switch;                  /* To decref after a switch */
} PyStacklessState;

/* internal macro to temporarily disable soft interrupts */
#define PY_WATCHDOG_NO_SOFT_IRQ (1<<31)

/* these macros go into pystate.c */
#define __STACKLESS_PYSTATE_NEW \
    tstate->st.initial_stub = NULL; \
    tstate->st.serial = 0; \
    tstate->st.serial_last_jump = 0; \
    tstate->st.cstack_base = NULL; \
    tstate->st.cstack_root = NULL; \
    tstate->st.ticker = 0; \
    tstate->st.interval = 0; \
    tstate->st.interrupt = NULL; \
    tstate->st.schedlock = 0; \
    tstate->st.main = NULL; \
    tstate->st.current = NULL; \
    tstate->st.runcount = 0; \
    tstate->st.nesting_level = 0; \
    tstate->st.runflags = 0; \
    tstate->st.del_post_switch = NULL;

/* note that the scheduler knows how to zap. It checks if it is in charge
   for this tstate and then clears everything. This will not work if
   we use Py_CLEAR, since it clears the pointer before deallocating.
 */

struct _ts; /* Forward */

void slp_kill_tasks_with_stacks(struct _ts *tstate);

#define __STACKLESS_PYSTATE_CLEAR \
    slp_kill_tasks_with_stacks(tstate); \
    Py_CLEAR(tstate->st.initial_stub);

#ifdef WITH_THREAD

#define STACKLESS_PYSTATE_NEW \
    __STACKLESS_PYSTATE_NEW \
    tstate->st.thread.block_lock = NULL; \
    tstate->st.thread.is_blocked = 0;


#define STACKLESS_PYSTATE_CLEAR \
    __STACKLESS_PYSTATE_CLEAR \
    Py_CLEAR(tstate->st.thread.block_lock); \
    tstate->st.thread.is_blocked = 0;

#else

#define STACKLESS_PYSTATE_NEW __STACKLESS_PYSTATE_NEW
#define STACKLESS_PYSTATE_CLEAR __STACKLESS_PYSTATE_CLEAR

#endif
