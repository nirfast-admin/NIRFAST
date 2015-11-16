#include "expand_bdybuffer_mex.h"


#define prismbbx(i,j) prismbbx[(i)+(j)*nf]
#define prismp(i,j,k) prismp[(i)+(j)*nf+(k)*nf*3]
#define prismfbbx(i,j,k) prismfbbx[(i)+(j)*nf+(k)*nf*8]
#define P(i,j,k) P[(i)+(j)*nrow+(k)*nrow*ncol]
#define fout(i,j,k) fout[(i)+(j)*nrow+(k)*nrow*ncol]

/* To compile this file use:
* For Windows:
* mex -v -DWIN32 -I./meshlib expand_bdybuffer_mex.cpp isinvolume_randRay.cpp meshlib/geomath.cpp meshlib/vector.cpp
For Linux/Mac:
 * mex -v -I./meshlib expand_bdybuffer_mex.cpp isinvolume_randRay.cpp meshlib/geomath.cpp meshlib/vector.cpp
 */
 
// P = expand_bdybuffer_mex(P,prismp,ds,prismbbx,prismfbbx,delta,llc,edgelen,edgeidx,tiny);
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

	double *edgelen = mxGetPr(_edgelen);
	double *edgeidx = mxGetPr(_edgeidx);
	double ds = *mxGetPr(_ds);
	double *delta = mxGetPr(_delta);
	double *llc = mxGetPr(_llc);
	double *prismbbx = mxGetPr(_prismbbx);
	double *prismp = mxGetPr(_prismp);
	//double *prismn = mxGetPr(_prismn);
	double *prismfbbx = mxGetPr(_prismfbbx);
	
	char *P = (char *) mxGetData(_P);
	double tiny = *mxGetPr(_tiny);
	
	const mwSize  *dims = mxGetDimensions(_P);
	mwSize number_of_dimensions = mxGetNumberOfDimensions(_P);
	if (number_of_dimensions!=3)
		mexErrMsgTxt("\n\tThe input checkerboard is not 3D!\n");
	int nrow = dims[0];
	int ncol = dims[1];
	int npln = dims[2];
	std::vector<int> Psize(3);
	Psize[0] = nrow; Psize[1] = ncol; Psize[2] = npln;
	
	ULONG nf = mxGetM(_prismbbx);
	
	// Allocate memory for intermediate variables
	double *ffbbx = new double[8*6];
	mxArray *coords = mxCreateDoubleMatrix(6,3,mxREAL);
	/*mwSize nsubs = 3;
	mwIndex *subs = (mwIndex*) mxCalloc(nsubs,sizeof(mwIndex));*/
	mxArray *prisme = mxCreateDoubleMatrix(8,3,mxREAL);
	double *fooprisme = mxGetPr(prisme);
	// Load up prism connectivity
	for (int i=0; i<8; ++i) {
		for (int j=0; j<3; ++j) {
			fooprisme[i+j*8] = pconn[i][j];
		}
	}
	
	double sqroot2 = sqrt(2.)/1.4;
	
	for (ULONG i=0; i<nf; ++i) {
		// Check the maximum edge against ds
		double foomax = -std::numeric_limits<double>::max();
		for (int j=0; j<3; ++j) {
			ULONG idx = edgeidx[i+j*nf]-1;
			if (edgelen[idx] > foomax)
				foomax = edgelen[idx];
		}
		if (foomax/sqroot2 < ds)
			continue;
			
		ULONG imin, jmin, kmin, imax, jmax, kmax;
		ULONG istart, iend, jstart, jend, kstart, kend;
		
		double foop[3]; std::vector<ULONG> IJK(3);
		
		for (int j=0; j<3; foop[j] = prismbbx(i,j), ++j);
		mapxyz2ijk(foop,IJK,delta,Psize,llc);
		imin = IJK[0]-1; jmin = IJK[1]-1; kmin = IJK[2]-1;
		
		for (int j=0; j<3; foop[j] = prismbbx(i,j+3), ++j);
		mapxyz2ijk(foop,IJK,delta,Psize,llc);
		imax = IJK[0]-1; jmax = IJK[1]-1; kmax = IJK[2]-1;
		
		istart=std::min(imin,imax); iend=std::max(imin,imax);
		jstart=std::min(jmin,jmax); jend=std::max(jmin,jmax);
		kstart=std::min(kmin,kmax); kend=std::max(kmin,kmax);
		
		istart=std::max(istart,(ULONG)0); jstart=std::max(jstart,(ULONG)0); kstart=std::max(kstart,(ULONG)0);
		iend=std::min(iend,(ULONG)nrow-1); jend=std::min(jend,(ULONG)ncol-1); kend=std::min(kend,(ULONG)npln-1);
		
		//subs[0] = i;
		// Create mxArray for coords of prism
		double *fcoords = (double *) mxGetPr(coords);
		double xMin =  std::numeric_limits<double>::max();
		double xMax = -std::numeric_limits<double>::max();
		for (int ii=0; ii<6; ++ii) {
			//subs[2] = ii;
			for (int jj=0; jj<3; ++jj) {
				//subs[1] = jj;
				fcoords[ii+jj*6] = prismp(i,jj,ii);
				/*mwIndex idx = mxCalcSingleSubscript(_prismp, nsubs, subs);
				fcoords[ii+jj*6] = prismp[idx];*/
				if (jj==0 && fcoords[ii+jj*6] < xMin)
					xMin = fcoords[ii+jj*6];
				if (jj==0 && fcoords[ii+jj*6] > xMax)
					xMax = fcoords[ii+jj*6];
			}
		}
		
		// Create mxArray for bbx of prism facets
		
		for (int ii=0; ii<8; ++ii) {
			//subs[1] = ii;
			for (int jj=0; jj<6; ++jj) {
				//subs[2] = jj;
				ffbbx[ii+jj*8] = prismfbbx(i,ii,jj);
				/*mwIndex idx = mxCalcSingleSubscript(_prismfbbx, nsubs, subs);
				ffbbx[ii+jj*8] = prismfbbx[idx];*/
			}
		}
		
		std::vector<ULONG> int_facets;
		std::vector<points> int_points;
		for (int ii=istart; ii<=iend; ++ii) {
			for (int jj=jstart; jj<=jend; ++jj) {
				for (int kk=kstart; kk<=kend; ++kk) {
					if (P(ii,jj,kk) == 0) {
						double tmpqp[3];
						tmpqp[0] = (jj-2)*delta[0]+llc[0];
						tmpqp[1] = (nrow-ii-1)*delta[1]+llc[1];
						tmpqp[2] = (npln-kk-1)*delta[2]+llc[2];
						if (isinvolume_randRay(tmpqp,coords,prisme,tiny,ffbbx,200,xMin,xMax,int_facets,int_points)==1)
							P(ii,jj,kk) = NA;
					}
				}
			}
		}
		
	}
	
	//mwSize dims[3] = {nrow, ncol, npln};
	plhs[0] = mxCreateNumericArray(3,dims,mxINT8_CLASS,mxREAL);
	char *fout = (char *) mxGetData(plhs[0]);
	for (int i=0; i<nrow; ++i) {
		for (int j=0; j<ncol; ++j) {
			for (int k=0; k<npln; ++k) {
				fout(i,j,k) = P(i,j,k);
			}
		}
	}
	
	mxDestroyArray(prisme);
	mxDestroyArray(coords);
	//mxFree(subs);
	delete [] ffbbx;
}

void mapxyz2ijk(double inp[3], std::vector<ULONG>& IJK, double *delta, std::vector<int> Psize, double *llc) {
	ULONG XI = round( (inp[0]-llc[0])/delta[0] ) + 2;
	ULONG YI = round( (inp[1]-llc[1])/delta[1] ) + 2;
	ULONG ZI = round( (inp[2]-llc[2])/delta[2] ) + 2;
	
	IJK[1] = XI;
	IJK[0] = Psize[0] - YI + 1;
	IJK[2] = Psize[2] - ZI + 1;
}