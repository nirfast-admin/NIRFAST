#include "get_ray_shell_intersections.h"

#ifndef p
#define p(i,j) p[(i)+np*(j)]
#define t(i,j) t[(i)+ne*(j)]
#endif

#ifndef facets_bbx
#define facets_bbx(i,j) facets_bbx[(i) + ne*(j)]
#endif
/***************************************************************
* To compile this file use:
*	For Windows:
* 		mex -v -DWIN32 -I./meshlib get_ray_shell_intersections.cpp isinvolume_randRay.cpp meshlib/geomath.cpp meshlib/vector.cpp
*	For Linux/Mac:
* 		mex -v -I./meshlib get_ray_shell_intersections.cpp isinvolume_randRay.cpp meshlib/geomath.cpp meshlib/vector.cpp
*
***************************************************************/

/****************************************************************
* Usage from Matlab
*	[all_ok st intpnts intersected_facets] =
*		get_ray_shell_intersections(rp1,p,t,tiny,facets_bbx,xmin,xmax,ntries)
*
*	all_ok will be true of algorithm could determine the location of all the points in rp1 successfully
*	st[i]
*		0 = outside
*		1 = inside
*	  255 = unable to determine the location of rp1[i]
*	intpnts[i] : If st[i]!=255
*		This will be an ncp x 3 array containing the points where 'ray' crossed the facets in 't'
*	intersected_facets[i] : if st[i]!=255
*		This will be an 1 x ncp array containing the facet id's that ray has crossed.
*		
****************************************************************/

// #define debugflag

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	CheckArgsIn(nlhs, plhs, nrhs, prhs);
	bool debug = false;
	bool all_ok = true;
	if (nrhs>8) // debug flag
        debug = true;
	
	double *tmpqp = new double[3];
	
    p = mxGetPr(innode);
    t = mxGetPr(inele);
    double *rp1 = mxGetPr(inrp1);
	double tiny=mxGetScalar(intiny);

    np=mxGetM(innode);
	ne=mxGetM(inele);
	ULONG nqp = mxGetM(inrp1);
	
    double xMin = mxGetScalar(inxmin);
    double xMax = mxGetScalar(inxmax);
	double foo = mxGetScalar(inntries);
    int ntries = (int) foo;
    
	//double *facets_bbx = new double(ne*6);
	double *facets_bbx;
	if (!mxIsEmpty(infacets))
		facets_bbx = (double *) mxGetData(infacets);
	else
		mexErrMsgTxt("get_ray_shell_intersections: facets_bbx is empty!\n");
    
	
	// Check the status of all points in rp1 and setup the returning matrices
	mxArray *cell_intpnts = mxCreateCellMatrix(nqp,1);
	mxArray *cell_facets = mxCreateCellMatrix(nqp,1);
    outst = mxCreateNumericMatrix(nqp, 1, mxUINT8_CLASS, mxREAL);
    unsigned char *st = (unsigned char *) mxGetData(outst);

    if (debug)
        mexPrintf("Entering the loop to call isinvolume_ranRay\n");
	std::vector<ULONG> int_facets;
	std::vector<points> int_points;
	// st vector
    for (ULONG i=0; i<nqp; ++i) {
        for (int j=0; j<3; tmpqp[j] = rp1[i+nqp*j], ++j);
        st[i] = isinvolume_randRay(tmpqp,innode,inele,tiny,facets_bbx,ntries,xMin,xMax,int_facets,int_points);
		if (st[i]==255)
			all_ok = false;
		else {
				SetCell_intpnts(cell_intpnts, int_points, i);
				SetCell_facets(cell_facets, int_facets, i);
		}
	}
	
	outintpnts   = cell_intpnts;
	outintfacets = cell_facets;
	// all_ok flag
	mxLogical foo2 = all_ok;
    outallok = mxCreateLogicalScalar(foo2);

    // Free the facets_bbx memory
	delete [] tmpqp;
	int_facets.clear();
	int_points.clear();
   
}

void SetCell_intpnts(mxArray* cell_pointer, std::vector<points> int_points, ULONG i) {

	mwSize dims[2] = {int_points.size(), 3};
	mxArray *tmpArray2=mxCreateNumericArray(2,dims,mxDOUBLE_CLASS,mxREAL);
    double *temp2 = (double *) mxGetData(tmpArray2);

	ULONG counter=0;
	for (std::vector<points>::iterator j=int_points.begin(); j!=int_points.end(); ++j) {
		for (int k=0; k<3; ++k) {
			temp2[counter + k*int_points.size()] = (*j).c[k];
		}
		++counter;
	}

	mxSetCell(cell_pointer, i, mxDuplicateArray(tmpArray2));

	mxDestroyArray(tmpArray2);
}

void SetCell_facets(mxArray* cell_pointer, std::vector<ULONG> facets, ULONG i) {

	mwSize dims[2] = {1, facets.size()};
	mxArray *tmpArray2=mxCreateNumericArray(2,dims,mxDOUBLE_CLASS,mxREAL);
    double *temp2 = (double *) mxGetData(tmpArray2);

	ULONG counter=0;
	for (std::vector<ULONG>::iterator j=facets.begin(); j!=facets.end(); 
		 temp2[counter]=(double)*j, ++counter, ++j);

	mxSetCell(cell_pointer, i, mxDuplicateArray(tmpArray2));

	mxDestroyArray(tmpArray2);
}


void GetFacetsBBX(double *facets_bbx, int nrhs, const mxArray *prhs[]) {
	
	//     check to see if we need to create facets_bbx
	if (nrhs>=5 && !mxIsEmpty(infacets)) {
        double *tmpfacets_bbx=(double *) mxGetData(infacets);
        ULONG nbbx=mxGetM(infacets);
        if (nbbx!=ne) {
            mexErrMsgTxt("get_ray_shell_intersections: Number of patches and bounding box list does not match!\n");
        }
        if (mxGetN(infacets)!=6)
            mexErrMsgTxt("Facets bbx needs to be 'ne' by 6 matrix!");
		// Make it a C-like array, i.e. row-based.
		for (ULONG i=0; i<nbbx; ++i) {
			for (int j=0; j<6; ++j) {
				facets_bbx(i,j) = (double) tmpfacets_bbx[i+nbbx*j];
			}
		}
    }
    else if (mxIsEmpty(infacets)) {
       	for (ULONG i=0; i<ne; ++i) {
	        ULONG n1 = (ULONG) t(i,0);
	        ULONG n2 = (ULONG) t(i,1);
	        ULONG n3 = (ULONG) t(i,2);
	        double tmp;
	        for (int j=0; j<3; ++j) {
	            tmp = std::min(p(n1-1,j),p(n2-1,j));
				facets_bbx(i,j) = (double) std::min(tmp,p(n3-1,j));
	            tmp = std::max(p(n1-1,j),p(n2-1,j));
				facets_bbx(i,j+3) = (double) std::max(tmp,p(n3-1,j));
	        }
	    }
    }
}

bool CheckArgsIn(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

    if (nrhs!=8) {
        mexPrintf("nargin = %d\n",nrhs);
        mexErrMsgTxt("get_ray_shell_intersections: You need to enter 8 input args!");
    }
    if (nlhs<2) {
        mexErrMsgTxt("get_ray_shell_intersections: Output arguments should be at least 2!");
    }
	if (mxGetN(innode)!=3 || mxGetN(inele)!=3) {
		mexErrMsgTxt("get_ray_shell_intersections can only be used for 3D triangular shells!\n");
	}
    bool f1=true;
    for (int i=0; i<nrhs; f1=f1 && !mxIsComplex(prhs[i]), ++i);
    if (!f1) {
        mexErrMsgTxt("get_ray_shell_intersections: Input arguments are complex!");
    }
    for (int i=0; i<nrhs; f1=f1 && (!mxIsEmpty(prhs[i]) || i==4), ++i);
    if (!f1) {
        mexErrMsgTxt("get_ray_shell_intersections: Input arguments are empty!");
    }
    f1=true;
    for (int i=0; i<nrhs; f1=f1 && !mxIsChar(prhs[i]), ++i);
    if (!f1) {
        mexErrMsgTxt("get_ray_shell_intersections: Input arguments are string!");
    }
	if (!mxIsDouble(inrp1) || !mxIsDouble(intiny))
        mexErrMsgTxt("get_ray_shell_intersections: rp1 and rp2 need to be of type 'double'!");
	if (!mxIsDouble(innode))
        mexErrMsgTxt("get_ray_shell_intersections: p needs to be either 'single' or 'double'");
	if (!mxIsDouble(inele))
        mexErrMsgTxt("get_ray_shell_intersections: t needs to be 'double'!");
    return true;
}
