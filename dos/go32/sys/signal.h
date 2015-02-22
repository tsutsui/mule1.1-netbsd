/* This is file sys/signal.h 

Copyright (C) 1992 M.Kobayashi (EastWind)

  This file is distributed under the conditions described in the
GNU CC General Public License.   A copy of this license is
supposed to have been given to you along with GNU CC so you
can know your rights and responsibilities.  It should be in a
file named COPYING.  Among other things, the copyright notice
and this notice must be preserved on all copies.  
*/

int raise(int);

#ifndef _SIGNAL_H_
#define _SIGNAL_H_

#define SIG_DFL ((SignalHandler )  0)
#define SIG_ERR ((SignalHandler ) -1)
#define SIG_IGN ((SignalHandler )  1)

#define SIGNO	0

#define SIGHUP  1       
#define SIGINT  2       
#define SIGQUIT 3       
#define SIGILL  4       
#define SIGTRAP 5       
#define SIGIOT  6       
#define SIGABRT 6       
#define SIGEMT  7       
#define SIGFPE  8       
#define SIGKILL 9       
#define SIGBUS  10      
#define SIGSEGV 11      
#define SIGSYS  12      
#define SIGPIPE 13      
#define SIGALRM 14      
#define SIGTERM 15      
#define SIGURG  16      
#define SIGSTOP 17      
#define SIGTSTP 18      
#define SIGCONT 19      
#define SIGCHLD 20      
#define SIGCLD  20      
#define SIGTTIN 21      
#define SIGTTOU 22      
#define SIGIO   23      
#define SIGPOLL SIGIO   
#define SIGXCPU 24      
#define SIGXFSZ 25      
#define SIGVTALRM 26    
#define SIGPROF 27      
#define SIGWINCH 28     
#define SIGLOST 29      
#define SIGUSR1 30      
#define SIGUSR2 31      
#define SIGMAXIMUM 32

#endif
