#include "s-usg5-4.h"
#undef LIBS_SYSTEM

#undef SYSTEM_TYPE
#define SYSTEM_TYPE "silicon-graphics-unix"
#define IRIX5

#define HAVE_SYSVIPC
#define HAVE_PTYS
#define HAVE_SOCKETS
#define HAVE_RANDOM

/* Define HAVE_ALLOCA to say that the system provides a properly
   working alloca function and it should be used. */
#define HAVE_ALLOCA
#undef C_ALLOCA
#define alloca __builtin_alloca

/* use K&R C */
#define C_SWITCH_MACHINE -cckr

#undef SETUP_SLAVE_PTY

/* No need to use sprintf to get the tty name--we get that from _getpty.  */
#ifdef PTY_TTY_NAME_SPRINTF
#undef PTY_TTY_NAME_SPRINTF
#endif
#define PTY_TTY_NAME_SPRINTF
/* No need to get the pty name at all.  */
#ifdef PTY_NAME_SPRINTF
#undef PTY_NAME_SPRINTF
#endif
#define PTY_NAME_SPRINTF
#ifdef emacs
char *_get_pty();
#endif

/* We need only try once to open a pty.  */
#define PTY_ITERATION
