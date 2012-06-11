function checkerboard3dmm_wrapper(fnprefix,savefn,type,edgesize,gradingflag)

% checkerboard3dmm_wrapper(fnprefix,saveloc,type,edgesize)
%
% Converts inp files (surface mesh) to a fem nirfast mesh
%
% fnprefix is the location of one of the inp files, or the ele file location
% saveloc is the location to save the mesh to
% type is the mesh type ('stnd', 'fluor', etc)
% edgesize is the average size of tetrahedra edges


%% elements, nodes, region, bndvtx, dimension, type, name
if nargin < 4 || isempty(edgesize)
    edgesize = [];
end
if nargin<5 || (nargin>=5 && isempty(gradingflag))
    gradingflag = 0;
end
mesh = checkerboard3d_mm(fnprefix,type,edgesize,gradingflag,savefn);

%% optical properties
mesh = set_mesh_type(mesh,type);

save_mesh(mesh,savefn);