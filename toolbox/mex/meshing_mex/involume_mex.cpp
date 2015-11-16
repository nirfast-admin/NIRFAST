#include "involume_mex.h"

#define p(i,j) p[(i)+np*(j)]
#define ele(i,j) ele[(i)+ne*(j)]
#define qp(i,j) qp[(i)+nqp*(j)]



#ifndef pp
#define pp(i,j) pp[(i)+npp*(j)]
#define tt(i,j) tt[(i)+nee*(j)]
#endif

#ifndef myfacets_bbx
#define myfacets_bbx(i,j) myfacets_bbx[(i) + nee*(j)]
#endif

/* To compile this file use:
 * Compile without OpenMP support:
 *-------------
* For Windows:
* mex -v -DWIN32 -I./meshlib involume_mex.cpp isinvolume_randRay.cpp meshlib/geomath.cpp meshlib/vector.cpp
For Linux/Mac:
 * mex -v -I./meshlib involume_mex.cpp isinvolume_randRay.cpp meshlib/geomath.cpp meshlib/vector.cpp
 *
 *Compile with OpenMP support:
 *For Windows:
 *mex -v COMPFLAGS="$COMPFLAGS /openmp" LINKFLAGS="$LINKFLAGS /openmp" -DWIN32 -I./meshlib involume_mex.cpp isinvolume_randRay.cpp meshlib/geomath.cpp meshlib/vector.cpp
 *
 *For Linux/Mac:
 * mex -v CXXFLAGS="\$CXXFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp" -I./meshlib involume_mex.cpp meshlib/geomath.cpp meshlib/vector.cpp
 */

#ifdef _OPENMP
#include "omp.h"
#endif

// st = involume_mex(qp, ele, p, ntries, facets_bbx, xMin, xMax, tiny)
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    if (nrhs!=8 || nlhs!=1) {
        mexPrintf("st = involume_mex(qp, ele, p, facets_bbx, ntries, xMin, xMax, tiny)");
        mexPrintf("It needs 8 inputs and 1 output\n");
        mexErrMsgTxt("involume_mex: Terminatin...");
    }
    if (!mxIsDouble(_innode))
        mexErrMsgTxt("involume_mex: input argument 2 should be of 'double' type");
    
    bool debug=false;
    
    if (mxGetN(_inele)!=3 || mxGetN(_inqp) != 3)
        mexErrMsgTxt("involume_mex: is intended for 3D!");
    double *ele;
    if (mxIsDouble(_inele))
        ele = (double *) mxGetData(prhs[1]);
    else
        mexErrMsgTxt("orient_surface: t needs to be 'double'!");
    
	/*ULONG ne = mxGetM(_inele);
    ULONG np = mxGetM(_innode);*/
    ULONG nqp = (ULONG) mxGetM(_inqp);
    //double *p = mxGetPr(_innode);
    double *qp = mxGetPr(_inqp);
    double tmpqp[3] = {0., 0., 0.};
    
	double ntries = mxGetScalar(_inntries);
    double xMin = mxGetScalar(_inxmin);
    double xMax = mxGetScalar(_inxmax);
    double tiny = mxGetScalar(_intiny);
    
    //     check to see if we need to create facets_bbx
	double *facets_bbx;
   
    if (debug) {
        mexPrintf("Getting facets_bbx\n");
	}
	if (!mxIsEmpty(_infacets))
		facets_bbx = (double *) mxGetData(_infacets);
	else
		mexErrMsgTxt("involume_mex: facets_bbx is empty!\n");
	
    _outst = mxCreateNumericMatrix(nqp, 1, mxUINT8_CLASS, mxREAL);
    unsigned char *st = (unsigned char *) mxGetData(_outst);
    
    if (debug)
        mexPrintf("Entering the loop to call isinvolume_ranRay\n");
	
#ifdef _OPENMP	
	omp_set_num_threads(omp_get_num_procs());
    if (debug)
        mexPrintf("\n    CPUs Available: %d\n\n",omp_get_num_procs());
#endif
	long i;
	int j;
    std::vector<ULONG> int_facets;
    std::vector<points> int_points;
	double *pp = mxGetPr(prhs[2]);
	double *tt = mxGetPr(prhs[1]);
	unsigned long npp=mxGetM(prhs[2]);
	unsigned long nee=mxGetM(prhs[1]);
#ifdef _OPENMP
	#pragma omp parallel default(none) \
	    private(i,j) \
        firstprivate(int_facets,int_points,tmpqp) \
	    shared(st,qp,nqp,tiny,facets_bbx,ntries,xMin,xMax,nee,npp,tt,pp)
#endif
	{
#ifdef _OPENMP
        #pragma omp for
#endif
        for (i=0; i<nqp; ++i) {
    	    for (j=0; j<3; ++j)
                tmpqp[j] = qp(i,j);
    		//st[i] = isinvolume_randRay(tmpqp,prhs[2],prhs[1],tiny,facets_bbx,(int)ntries,xMin,xMax,int_facets,int_points);
			/*st[i] = isinvolume_randRay(tmpqp, pp, npp, tt, nee, tiny, facets_bbx, (int) ntries,
                            	       xMin, xMax, int_facets, int_points);*/
			double *p0 = tmpqp;
			double *myfacets_bbx = facets_bbx;
			int numPerturb = ntries;
			double minX=xMin;
			double maxX=xMax;
			unsigned char tmpst;
								{

								    unsigned char st;
								    bool debug=false;
								    int_facets.clear();
									int_points.clear();

								    if (debug)
								        mexPrintf("p0 = %lf %lf %lf\n",p0[0],p0[1],p0[2]);

								    points p1;

								    if (debug)
								        mexPrintf("Calculating ray's bbx\n");

								    // mxArrays to be passed down to intersect_RayTriangle
								    // double *pr;
								    if (debug)
								        mexPrintf("Duplicating input arguments\n");


								    double rp1[3], rp2[3];
								    for (int i=0; i<3; rp1[i]=p0[i], rp2[i]=p0[i], ++i);
								    // and add 2*AbsMaxX (as infinite point)
									rp2[0] = fabs(maxX-minX)*10 + maxX;

								    unsigned long int nintpnts;
									bool forever = true;
								    bool brokenloop = false;
								    bool rayPerturbed=false;
								    double R = -std::numeric_limits<double>::max();

								    if (debug)
								        mexPrintf("Entering the main loop\n");
									while (forever) {
								        for (ULONG i=0; i<nee; ++i) {
								            if (!rayPerturbed) {
								                double MaxX = myfacets_bbx(i,3); 
								                double MaxY = myfacets_bbx(i,4); double MinY = myfacets_bbx(i,1);
								                double MaxZ = myfacets_bbx(i,5); double MinZ = myfacets_bbx(i,2);
								                if (debug) {
								//                     mexPrintf("Ray Is Perturbed! i = %d\n",i);
								                }
								                if (p0[0]>MaxX || p0[1]>MaxY || p0[1]<MinY || p0[2]>MaxZ || p0[2]<MinZ)
								                    continue;
								            }
								            // get coordinates of tp1, tp2 and tp3 into mxArrays of *rhs1[]
								            double tp1[3], tp2[3], tp3[3];
								            for (int k=0; k<3; ++k) {
												ULONG idx = (ULONG) tt(i,0) - 1;
												assert(idx>=0 && idx<=npp);
										                tp1[k] = pp(idx, k);
												idx = (ULONG) tt(i,1) - 1;
												assert(idx>=0 && idx<=npp);
										                tp2[k] = pp(idx, k);
												idx = (ULONG) tt(i,2) - 1;
												assert(idx>=0 && idx<=npp);
										                tp3[k] = pp(idx, k);
								            }

								            if (debug) {
								//                 mexPrintf("Calling intersect_RayTriangle\n");
								            }
								            // [st I]=intersect_RayTriangle(rp1, rp2, tp1, tp2, tp3, global_tiny)
								            double ipnt[3];
								            int ret = 
								            intersect_RayTriangle(rp1, rp2, tp1, tp2, tp3, ipnt, tiny);
								            if (ret==1) {
								                for (int j=0;j<3;p1.c[j]=ipnt[j],++j);
												int_points.push_back(p1);
												int_facets.push_back(i+1);
								                if (debug)
								                    mexPrintf("i=%d \t intp = %lf %lf %lf\n",i,p1.c[0], p1.c[1], p1.c[2]);
								                continue;
								            }
								            else if (ret==10 || ret==11 || ret==12 || ret==20 || ret==21 || ret==22
								                     || ret>100) {
								                if (!rayPerturbed) {
								                    R = -std::numeric_limits<double>::max();
								                    for (ULONG j=0;j<npp;++j) {
								                        double temp = length(p0[0]-pp(j,0), p0[1]-pp(j,1), p0[2]-pp(j,2));
								                        if (temp > R)
								                            R = temp;
								                    }
								                    R *= 100;
								                    rayPerturbed=true;
								                    if (debug)
								                        mexPrintf("Calculated R is : %lf\n",R);
								                }
								                brokenloop=true;
												int_points.clear();
												int_facets.clear();
								                break;
								            }
								        }
								        nintpnts = int_points.size();
								        if (!brokenloop) {
								            (nintpnts%2==1) ? st=1 : st=0;
								            if (debug) {
								                mexPrintf("numPerturb is %d\n",numPerturb);
								                mexPrintf("nintpnts=%d st=%d\n",nintpnts,st);
								            }
								            forever=false;
								        }
								        else if (brokenloop && numPerturb>0) {
								            double u[3] = { rand(), rand(), rand() };
								            double temp = length(u[0],u[1],u[2]);
								            for (int j=0; j<3; u[j] /= temp/*, mexPrintf("u= %.12f\n",u[j])*/, ++j);
								            for (int j=0; j<3; rp2[j]=R*u[j], ++j);
								            --numPerturb;
								            if (debug)
								                mexPrintf("numPerturb=%d\n",numPerturb);
								            brokenloop=false;
								        }
								        else if (brokenloop && numPerturb<=0) {
								            st=255;
								            forever=false;
								        }   
								    }

									tmpst = st;

								    // Exit
								}
            st[i]=tmpst;

    	}
	}
}





