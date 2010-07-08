function nodelm2nirfast(fn,saveloc,type)

% nodelm2nirfast(fn,saveloc,type)
%
% converts .node/.ele files to a nirfast mesh
%
% fn is the location of the .ele file
% saveloc is the location to save the nirfast mesh
% type is the mesh type to use ('stnd','fluor',etc)


%% read .node/.ele files
[mesh.elements,mesh.nodes] = read_nod_elm(fn(1:end-4),1);

%% set mesh properties
mesh = set_mesh_type(mesh,type);
if strcmp(type,'stnd_bem') || strcmp(type,'fluor_bem') || strcmp(type,'spec_bem')
    mesh.region = [ones(size(mesh.elements,1),1) zeros(size(mesh.elements,1),1)];
    mesh.dimension = 3;
    mesh.bndvtx = ones(size(mesh.nodes,1),1);
else
    mesh.region = zeros(size(mesh.nodes,1),1);
    mesh.dimension = size(mesh.elements,2)-1;
end

faces=[mesh.elements(:,[1,2,3]);
       mesh.elements(:,[1,2,4]);
       mesh.elements(:,[1,3,4]);
       mesh.elements(:,[2,3,4])];
faces=sort(faces,2);
[foo,ix,jx]=unique(faces,'rows');
vec=histc(jx,1:max(jx));
qx = vec==1;
bdy_faces=faces(ix(qx),:);
exterior_nodes_id = unique(bdy_faces(:));
mesh.bndvtx = zeros(size(mesh.nodes,1),1);
mesh.bndvtx(exterior_nodes_id) = 1;

%% save the mesh
save_mesh(mesh,saveloc);