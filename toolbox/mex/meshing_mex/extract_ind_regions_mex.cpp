#include "extract_ind_regions_mex.h"

#define ele(i,j) ele[(i)+ne*(j)]
#define list(i,j) list[(i)+ne*(j)];

// [status,tc]=extract_ind_regions_mex(ele,list)

/*

How to mex:
All platforms:

>> mex -v extract_ind_regions_mex.cpp

*/

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    if (nrhs!=2 || nlhs!=1)
        mexErrMsgTxt("extract_ind_regions_mex: Needs 2 input and 1 output arguments!");
	
    if (mxIsDouble(prhs[0]))
        ele = (double *) mxGetData(prhs[0]);
    else
        mexErrMsgTxt("extract_ind_regions_mex: t needs to be 'double'!");

#ifdef debugme
	mexPrintf("Checked ele list\n");
#endif

	ne = mxGetM(prhs[0]);
	
	// Check 'list' argument
	if (!mxIsCell(prhs[1]))
		mexErrMsgTxt("extract_ind_regions_mex: 'list' needs to be cell!");
	else
		list = prhs[1];	
		

	// Vector whose entities are different closed surfaces within the input 'ele'
	std::vector< std::vector<ulong> > regions;
	std::vector<ulong> current_region;
	
	mxArray *tmpArray;
	double *tris;
	
	bool endflag = false;
	bool firstTimeFlag = true;
	ulong starte = 1;
	
	std::queue<ulong> q; // Queue of elements
	std::vector<short> color(ne, White); // Keep track of which elements have been completely used

#ifdef debugme
	mexPrintf("Starting main while loop\n");
#endif	
	while (!endflag) {
		
		q.push(starte);
		current_region.push_back(starte);
		while (!q.empty()) {
			#ifdef debugme
				mexPrintf("Entered queue loop\n");
			#endif
			ulong u = q.front();
			ulong v, index;
			// Get the list of connected triangles to element number 'u' from 'list' ('list' is a cell)
			index = u-1 + 0*ne;
			#ifdef debugme
				mexPrintf("tmpArray 1 ===========\n");
			#endif
			tmpArray = mxGetCell(list,index);
			if (!mxIsDouble(tmpArray))
				mexErrMsgTxt("entries of 'list' should be 'double' type!");
			#ifdef debugme
				mexPrintf("tmpArray 2 ===========\n");
			#endif
			int nconn_tris = mxGetNumberOfElements(tmpArray);
			if (nconn_tris>3 && firstTimeFlag) {
				mexPrintf("\tFound a triangle with more than 3 neighbors!\n");
				firstTimeFlag = false;
			}
			if (nconn_tris==0) {
				mexPrintf("\tList of neighboring triangles to face number %d is empty!\n",u);
				mexErrMsgTxt("\tAborting...");
			}
			tris = (double *) mxGetData(tmpArray);
			for (int i=0; i<nconn_tris; ++i) {
				v = (ulong) tris[i];
				if (v<1 || v>ne) {
					mexPrintf(" extract_ind_regions_mex: Given connectivity 'list' refers \
						to elements not available in the input 'ele' list!\n");
						mexErrMsgTxt("  Exitting...\n\n");
				}
				if (color[v-1] == White) {  // First time visit
					current_region.push_back(v);
					color[v-1] = Gray;  // Mark and
					q.push(v);  // add to the queue
				}
			}
			q.pop();
			color[u-1] = Black;
		}
#ifdef debugme
		mexPrintf("Done with a queue loop\n");
#endif		
		// Add the current set of triangles to 'regions' as an individual closed surface
		regions.push_back(current_region);
		current_region.clear();
		// Assume we are dont with all the elements unless proven otherwise
		endflag=true;
		for (ulong i=0; i<ne; ++i) {
			if (color[i]!=Black)  {
				starte = i+1;
				endflag=false;
				break;
			}
		}
	}
	
	// Prepare the output
	mxArray *cell_pointer = mxCreateCellMatrix(regions.size(),1);
	plhs[0] = cell_pointer;
	
	for (ulong i=0; i<regions.size(); ++i){
		SetCell(cell_pointer, regions[i], i);
	}
}

void SetCell(mxArray* cell_pointer, std::vector<ulong> elements, ulong i) {

	mwSize dims[2] = {1, elements.size()};
	mxArray *tmpArray2=mxCreateNumericArray(2,dims,mxDOUBLE_CLASS,mxREAL);
    double *temp2 = (double *) mxGetData(tmpArray2);

	ulong counter=0;
	for (std::vector<ulong>::iterator j=elements.begin(); j!=elements.end(); 
		 temp2[counter]=(double)*j, ++counter, ++j);

	mxSetCell(cell_pointer, i, mxDuplicateArray(tmpArray2));

	mxDestroyArray(tmpArray2);
}












