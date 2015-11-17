#ifndef tag_checkerboard3d_mex_h
#define tag_checkerboard3d_mex_h

//#define _mydebug

#if defined(__APPLE__) || defined(OSX) || defined(__MACH__) || defined(linux) || defined(__linux)
#include <sys/resource.h>
#include <unistd.h>
#endif
 
 
#include <math.h>
#include <time.h>
#include <vector>
#include <iostream>
#include <algorithm>
#include <cmath>
#include <assert.h>

#include "mex.h"
#include "CStopWatch.h"

#ifndef ULONG
#define ULONG unsigned long
#endif

#define outside 5
#define inside 6
#define NA 3
#define node_code 2
#define boundary_node_code 1
#define on_facet 7

#if defined(WIN32) || defined(WIN64)
/*#define _stupidMS_min _cpp_min
#define _stupidMS_max _cpp_max*/
#define _stupidMS_min std::min
#define _stupidMS_max std::max
#define round(x) ((int)((x) > 0.0 ? (x) + 0.5 : (x) - 0.5))
#else
#define _stupidMS_min std::min
#define _stupidMS_max std::max
#endif

#ifndef myrand
#define myrand(n) ( (ULONG)  ( (double)rand() / ((double)(RAND_MAX)+(double)(1.0)) * (double)n ) )
#endif

inline bool ReadyForTermination(char *P, int& nrow, int& ncol, int& npln);
void GetRandom(int &ii, int &kk, int *row_state, int &nrow, int &ncol, int &npln);

struct mypoint {
	double coords[3];
};

#endif

