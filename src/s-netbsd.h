/* Definitions file for GNU emacs running on NETBSD.  */

/* 94.2.23  written for Mule Ver.1.1 by Masuda <masuda@nanzan-u.ac.jp>

#include "s-386bsd.h"

#undef KERNEL_FILE
#define KERNEL_FILE "/netbsd"

#define A_TEXT_OFFSET(x) (sizeof(struct exec))
#define A_TEXT_SEEK(hdr) (N_TXTOFF(hdr) + A_TEXT_OFFSET(hdr))

#define LIBS_SYSTEM -lutil -lgcc
#define LIB_STANDARD -lc -lgcc
