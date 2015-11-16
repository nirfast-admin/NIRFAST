#ifndef extract_ind_regions_mex
#define extract_ind_regions_mex

#include "mex.h"
#include <queue>

#define ulong unsigned long int
ulong ne;

double *ele;
const mxArray *list;

void SetCell(mxArray* cell_pointer, std::vector<ulong> elements, ulong i);

enum {White=0, Gray, Black=-1};

#endif
