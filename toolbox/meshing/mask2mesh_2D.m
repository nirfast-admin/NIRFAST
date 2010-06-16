function mask2mesh_2D(bmpfile,pixeldim,edgesize,triarea,saveloc,type)

% mask2mesh_2D(bmpfile,pixeldim,edgesize,triarea,saveloc,type)
%
% creates a nirfast mesh from a 2D mask (bmp)
%
% bmpfile is the location of the bmp mask
% pixeldim is the pixel dimension of the mask
% triarea is the desired triangle area of the resulting mesh
% saveloc is the location to save the mesh
% type is the mesh type


%% nodes, elements, bndvtx
[mesh.nodes,mesh.elements,mesh.bndvtx,mesh.region] = mask2mesh(bmpfile,pixeldim,edgesize,triarea);
nodes=unique(mesh.elements(:));
mesh.bndvtx = ismember(nodes,mesh.bndvtx);

%% dimension, name, type
mesh.dimension = 2;
mesh.type = type;
mesh.name = saveloc;

%% optical properties
mesh = set_mesh_type(mesh,type);

save_mesh(mesh,saveloc);