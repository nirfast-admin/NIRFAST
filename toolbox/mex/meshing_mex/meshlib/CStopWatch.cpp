#include <cstdio> // NULL

#include "CStopWatch.h"

#if defined(_MSC_VER) || defined(WIN32) || defined(WIN64) || defined (WINDOWS) || defined(windows)

double CStopWatch::getElapsedTime() {	
    return (timer.stop - timer.start) / 1000. ;
}

#else

double CStopWatch::getElapsedTime() {	
	timeval res;
	timersub(&(timer.stop),&(timer.start),&res);
	return (res.tv_sec + res.tv_usec /1000000.0); // 10^6 uSec per second
}

#endif
