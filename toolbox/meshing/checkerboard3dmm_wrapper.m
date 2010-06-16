function checkerboard3dmm_wrapper(fnprefix,saveloc,type)

% checkerboard3dmm_wrapper(fnprefix,saveloc,type)
%
% Converts inp files (surface mesh) to a fem nirfast mesh
%
% fnprefix is the location of one of the inp files, or the ele file location
% saveloc is the location to save the mesh to
% type is the mesh type ('stnd', 'fluor', etc)


%% elements, nodes, region, bndvtx, dimension, type, name
mesh = checkerboard3d_mm(fnprefix,type);

%% optical properties
mesh = set_mesh_type(mesh,type);

save_mesh(mesh,saveloc);