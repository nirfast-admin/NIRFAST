/*
	Filename:	init.h
	Language:	C++
	Date:		1998/06/14
	Author:		Ziji Wu   
	Version:	Version: 1.0
	Modified:   Hamid Ghadyani
	Description:Declare common variables/headers
*/

#ifndef __init_h
#define __init_h
//#define __GLOBAL_DEBUG_FLAG true


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>


#if defined(__APPLE__) || defined(__MACH__)
#include <sys/malloc.h>
#else
#include <malloc.h>
#endif

#if defined(__APPLE__) || defined(__MACH__) || defined(linux) || defined(__linux)
#include <sys/resource.h>
#include <unistd.h>
#endif


#include <math.h>
#include <assert.h>
#include <time.h>

#include <cmath>
#include <iostream>
#include <string>
#include <sstream>
#include <algorithm>
#include <limits>
#include <map>
#include <vector>
#include <list>
#include <set>
#include <functional>
#include <math.h>
#include <stdio.h>

#include "CStopWatch.h"

//#include "math.h"

#ifndef REAL
#define REAL double                      /* float or double */
#endif



#ifndef PI
#define PI 3.14159265358979323846264338327950288419716939937510
#endif

#ifndef BAD

#define BAD	   -1
#define NONE    0
#define OK	    1
#define YES 1
#define NO 0

#endif

#ifndef ULONG
#define ULONG unsigned long
#endif

#ifndef CPU_TIME
//extern int getrusage();
/*#if defined(__APPLE__) || defined(__MACH__) || defined(linux) || defined(__linux)
#define CPU_TIME (getrusage(RUSAGE_SELF,&ruse), ruse.ru_utime.tv_sec + \
ruse.ru_stime.tv_sec + 1e-6 * \
(ruse.ru_utime.tv_usec + ruse.ru_stime.tv_usec))
#else*/
#define CPU_TIME (double)clock()
//#endif

#endif // CPU_TIME

#ifndef myrand
#define myrand(n) ( (ULONG)  ( (double)rand() / ((double)(RAND_MAX)+(double)(1.0)) * (double)(n) ) )
//#define myrand(n) (ceil( (double)rand() / ((double)RAND_MAX + 1.0) * (double) (n))); // this produces between 1 and n (including both)
#endif

#define FloatTol 1.0e-7
#define TinyZero 1E-8
#ifndef REAL
#define REAL double                      /* float or double */
#endif


#endif

