#include <windows.h>
#include <sys/time.h>

gettimeofday (tp, tzp)
     struct timeval *tp;
     struct timezone *tzp;
{
  SYSTEMTIME st;
  
  GetSystemTime (&st);

  tp->tv_sec = time ((long *) 0);
  tp->tv_usec = st.wMilliseconds;
}
