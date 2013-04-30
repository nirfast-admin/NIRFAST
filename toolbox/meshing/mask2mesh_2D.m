function mask2mesh_2D(bmpfile,pixeldim,edgesize,triarea,saveloc,type,offset)

% mask2mesh_2D(bmpfile,pixeldim,edgesize,triarea,saveloc,type)
%
% creates a nirfast mesh from a 2D mask (bmp)
%
% bmpfile is the location of the bmp mask
% pixeldim is the pixel dimension of the mask, 2 values, x and y
% triarea is the desired triangle area of the resulting mesh
% saveloc is the location to save the mesh
% type is the mesh type
% offset is the translation of the mesh corner from (0,0,0)


%% nodes, elements, bndvtx
[mesh.nodes,mesh.elements,mesh.bndvtx,mesh.region] = mask2mesh(bmpfile,pixeldim,edgesize,triarea);
nodes=unique(mesh.elements(:));
mesh.bndvtx = ismember(nodes,mesh.bndvtx);

if exist('offset','var')
    mesh.nodes(:,1) = mesh.nodes(:,1) + offset(1);
    mesh.nodes(:,2) = mesh.nodes(:,2) + offset(2);
end

%% dimension, name, type
mesh.dimension = 2;
mesh.type = type;
mesh.name = saveloc;

%% optical properties
mesh = set_mesh_type(mesh,type);

save_mesh(mesh,saveloc);