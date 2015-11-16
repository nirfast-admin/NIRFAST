// Usage: 
// [nodes] = tag_checkerbaord3d_mex(P, delta, llc, ds, grading_flag, grading_rate)
// P is the checkerboard (stencil) matrix
// delta is size of each pixel in P
// llc is the lower left corner of the matrix in real world coordinates
// ds is the average desired edge size of the tetrahedrons
// grading_flag is the flag for creating a grading or non-grading mesh size.
// grading_rate is the rate in which we want to increase tet edge size (should be between 0 and 1)
// To compile:
// On Windows platforms:
// mex -v -DWIN32 -I./meshlib tag_checkerboard3d_mex.cpp meshlib/CStopWatch.cpp
// mex -v -DWIN64 -I./meshlib tag_checkerboard3d_mex.cpp meshlib/CStopWatch.cpp

// On Apple Mac OSX:
// mex -v -DOSX -I./meshlib tag_checkerboard3d_mex.cpp meshlib/CStopWatch.cpp

// On Linux:
// mex -v -Dlinux -I./meshlib tag_checkerboard3d_mex.cpp meshlib/CStopWatch.cpp

#include "tag_checkerboard3d_mex.h"

#define P(i,j,k) P[(i)+nrow*(j)+ncol*nrow*(k)]
// #define row_state(i,j) row_state[(i)+npln*(j)]
#define row_state(i,j) row_state[npln*(i)+(j)]
#define row_state_back(i,j) row_state_back[npln*(i)+(j)]
#define row_direction(i,j) row_direction[npln*(i)+(j)]
#define row_visit(i,j) row_visit[npln*(i)+(j)]
#define row_visit_back(i,j) row_visit_back[npln*(i)+(j)]

//#define _mydebug

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

	srand( (unsigned)time( NULL ) );
	CStopWatch mytimer;
	
	mwSize  nsubs; 
	const mwSize *dims;

	std::vector<mypoint> nodes;
	
	char *P = (char *) mxGetData(prhs[0]);
	double *delta = (double *) mxGetData(prhs[1]);
	double *llc = (double *) mxGetData(prhs[2]);
	double ds = *(mxGetPr(prhs[3]));
	bool grading_flag = true;
	
	if (nrhs>=5 && !mxIsEmpty(prhs[4])) {
		grading_flag = (*mxGetPr(prhs[4])) == 0. ? false : true;
	}
	
	double grading_rate = 0.7;
	
	if (nrhs==6 && !mxIsEmpty(prhs[5])) {
		grading_rate = *mxGetPr(prhs[5]);
	}
	
	#ifdef _mydebug
	mexPrintf(" Input data was read successfully!\n");
	#endif
	
	double dx, dy, dz;
	double xmin, ymin, zmin;
	int nrow, ncol, npln;
	
	dx = delta[0]; dy = delta[1]; dz = delta[2];
	xmin = llc[0]; ymin = llc[1]; zmin = llc[2];
	
	nsubs=mxGetNumberOfDimensions(prhs[0]);
	if (nsubs!=3)
		mexErrMsgTxt("Input checkerboard should be a 3D matrix!\n");
	
	dims = mxGetDimensions(prhs[0]);
	nrow = dims[0]; ncol = dims[1]; npln = (int) dims[2];
	ULONG no_tagged_pixels=0;
	ULONG cc=0;
	
	#ifdef _mydebug
	mexPrintf(" Read dimensions successfully!\n");
	#endif

	mytimer.startTimer();
	
	#ifdef _mydebug
	mexPrintf(" Timer initialized successfully!\n");
	#endif
	
	#ifdef _mydebug
	mexPrintf(" nrow = %ld , npln = %ld\n",nrow,npln);
	#endif
	int *row_state = new int[nrow*npln];
	int *row_state_back = new int[nrow*npln];
	int *row_direction = new int[nrow*npln];
	int *row_visit = new int[nrow*npln];
	int *row_visit_back = new int[nrow*npln];
	
	for (int i=0; i<nrow; ++i) {
		for (int j=0; j<npln; ++j) {
	#ifdef _mydebug
			mexPrintf(" i = %ld , j = %ld\n", i, j);
	#endif
			row_state(i,j) = 0;
			row_state_back(i,j) = ncol-1;
			row_direction(i,j) = 1;
			row_visit(i,j) = 0;
			row_visit_back(i,j) = 0;
		}
	}
	#ifdef _mydebug
	mexPrintf(" Initialized row_state() successfully!\n");
	mexPrintf("  Tagging Possible Interior Nodes...");
	#endif

	
	
	while (true) {
		int ii, jj, kk;
		
        /*ii = myrand(nrow);
        kk = myrand(npln);*/
        GetRandom(ii, kk, row_state, nrow, ncol, npln);
		
		if (ReadyForTermination(P, nrow, ncol, npln))
			break;
		
		if (row_direction(ii,kk) == 1) { // Forward
			jj = row_state(ii,kk);
			if (jj >= ncol) {
				++cc;
				continue;
			}
			int idx = jj;
            int dI;
			while (idx<ncol) {
				if (P(ii,idx,kk) == 0) {
					P(ii,idx,kk) = node_code;
					
					mypoint foo;
					foo.coords[0] = (idx-2)*dx+xmin;
					foo.coords[1] = (nrow-ii-1)*dy+ymin;
					foo.coords[2] = (npln-kk-1)*dz+zmin;
					nodes.push_back(foo);
					++no_tagged_pixels;
					
					double dd = ds;
					if (grading_flag && row_visit(ii,kk)>=1) { // Increase the size of dd by grading_rate
						for (int fooc=0; fooc<row_visit(ii,kk)-1; ++fooc)
							dd *= (1+grading_rate);
					}
					dI = round(dd/dx);
					for (int i=_stupidMS_max(0,ii-dI); i<=_stupidMS_min(nrow-1,ii+dI); ++i) {
						for (int j=_stupidMS_max(0,idx-dI); j<=_stupidMS_min(ncol-1, idx+dI); ++j) {
							for (int k=_stupidMS_max(0,kk-dI); k<=_stupidMS_min(npln-1,kk+dI); ++k) {
								assert(i>=0 && j>=0 && k>=0 && i<nrow && j<ncol && k<npln);
								if (P(i,j,k)==0)
									P(i,j,k) = NA;
							}
						}
					}
					break;
				}
				++idx;
			}
			row_state(ii,kk) = idx + dI + 1;
			row_direction(ii,kk) = -1;
			row_visit(ii,kk) = row_visit(ii,kk) + 1;
		}
		else if (row_direction(ii,kk)==-1) {
			jj = row_state_back(ii,kk);
			if (jj < 0) {
				++cc;
				continue;
			}
			int idx = jj;
            int dI;
			while (idx >= 0) {
				if (P(ii,idx,kk) == 0) {
					P(ii,idx,kk) = node_code;
					mypoint foo;
					foo.coords[0] = (idx-2)*dx+xmin;
					foo.coords[1] = (nrow-ii-1)*dy+ymin;
					foo.coords[2] = (npln-kk-1)*dz+zmin;
					nodes.push_back(foo);
					++no_tagged_pixels;
					
					double dd = ds;
					if (grading_flag && row_visit_back(ii,kk)>=1) { // Increase the size of dd by grading_rate
						for (int fooc=0; fooc<row_visit_back(ii,kk)-1; ++fooc)
							dd *= (1+grading_rate);
					}
					dI = round(dd/dx);
					for (int i=_stupidMS_max(0,ii-dI); i<=_stupidMS_min(nrow-1,ii+dI); ++i) {
						for (int j=_stupidMS_max(0,idx-dI); j<=_stupidMS_min(ncol-1, idx+dI); ++j) {
							for (int k=_stupidMS_max(0,kk-dI); k<=_stupidMS_min(npln-1,kk+dI); ++k) {
								assert(i>=0 && j>=0 && k>=0 && i<nrow && j<ncol && k<npln);
								if (P(i,j,k)==0)
									P(i,j,k) = NA;
							}
						}
					}
					break;
				}
				--idx;
			}
			row_state_back(ii,kk) = idx - dI - 1;
			row_direction(ii,kk) = 1;
			row_visit_back(ii,kk) = row_visit_back(ii,kk) + 1;
		}
	}
	mytimer.stopTimer();
	
	#ifdef _mydebug
	mexPrintf(" Tagged the pixels successfully\n");
	//mexPrintf(" done!\n");
	#endif

	if (no_tagged_pixels==0) {
		mexPrintf("\n\tWarning!\n");
		mexPrintf("\t Based on input matrix, checkerboard3d can not deploy any new nodes!\n\n");
	}
	
	/*mexPrintf("  Number of calling rand() function redundantly: %d\n",cc);
	mexPrintf("  nrow*ncol*npln = %d\n", nrow*ncol*npln);
	mexPrintf("  Time elapsed in tagging : %.6g\n", mytimer.getElapsedTime());*/
	
	plhs[0] = mxCreateNumericMatrix(nodes.size(), 3, mxDOUBLE_CLASS, mxREAL);
	double *foo = (double *) mxGetData(plhs[0]);
	for (ULONG i=0; i<nodes.size(); ++i) {
		for (int j=0; j<3; ++j) {
			foo[i+nodes.size()*j] = nodes[i].coords[j];
		}
	}
	
	#ifdef _mydebug
	mexPrintf(" Assigned ouput successfully\n");
	#endif

	// Free allocated memory
	nodes.clear();
    delete [] row_state;
	delete [] row_state_back;
	delete [] row_direction;
	delete [] row_visit;
	delete [] row_visit_back;
}



bool ReadyForTermination(char *P, int& nrow, int& ncol, int& npln) {
	for (int i=0; i<nrow; ++i) {
		for (int j=0; j<ncol; ++j) {
			for (int k=0; k<npln; ++k) {
				if (P(i,j,k) == 0)
					return false;
			}
		}
	}
	return true;
}

void GetRandom(int &ii, int &kk, int *row_state, int &nrow, int &ncol, int &npln) {
	
	std::vector<ULONG> randpool;
	for (int i=0; i<nrow; ++i) {
		for (int j=0; j<npln; ++j) {
			if (row_state(i,j)>=ncol || row_state(i,j)<0) {
				continue;
			}
			randpool.push_back(i*npln+j);
		}
	}
	
	ULONG foo = randpool[myrand(randpool.size())];
	ii = (int) foo / npln;
	kk = foo % npln;
}

/*bool ReadyForTermination(int *row_state, int& nrow, int& ncol, int& npln) {
	for (int i=0; i<nrow; ++i) {
		for (int j=0; j<npln; ++j) {
			if (row_state(i,j) < ncol)
				return false;
		}
	}
	return true;
}*/
