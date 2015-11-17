#ifndef __HR_TIME_H
#define __HR_TIME_H

#include <time.h>

#if defined(_MSC_VER) || defined(WIN32) || defined(WIN64) || defined (WINDOWS) || defined(windows)

typedef struct {
    double start;
    double stop;
} stopWatch;

class CStopWatch {

private:
	stopWatch timer;
public:
	CStopWatch() {};
	inline void startTimer() { timer.start = (double)clock(); }
	inline void stopTimer()  { timer.stop  = (double)clock(); }
	double getElapsedTime();
};

#else
#include <sys/time.h>

typedef struct {
	timeval start;
	timeval stop;
} stopWatch;

class CStopWatch {

private:
	stopWatch timer;
public:
	CStopWatch() {};
	inline void startTimer( ) { gettimeofday(&(timer.start),NULL); }
	inline void stopTimer( )  { gettimeofday(&(timer.stop),NULL);  }
	double getElapsedTime();
};

#endif

#endif
