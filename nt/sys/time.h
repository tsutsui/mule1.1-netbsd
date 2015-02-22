#include <winsock.h>

#ifndef _WINSOCKAPI_
struct timeval {
  long tv_sec;
  long tv_usec;
};
#endif

struct timezone { 
  long tz_minuteswest;
  long tz_dsttime;
};

struct tm {
  int tm_sec;
  int tm_min;
  int tm_hour;
  int tm_mday;
  int tm_mon;
  int tm_year;
  int tm_wday;
  int tm_yday;
  int tm_isdst;
};
