function mesh = create_mesh(outputfn,shape,sizevar,type)

% create_mesh(outputfn,shape,sizevar,type,link,source,meas)
%
% Creates a mesh with the desired properties
%
% outputfn is the filename to save the mesh to
% shape is the shape of the mesh
% sizevar is a structured variable containing the shape sizes
% type is the mesh type


%% error checking
if (strcmp(shape,'circle') || strcmp(shape,'rectangle')) && ...
        (strcmp(type,'stnd_bem') || strcmp(type,'fluor_bem') || strcmp(type,'spec_bem'))
    errordlg('BEM works for 3D shapes only','NIRFAST Error');
    error('BEM works for 3D shapes only');
end

sizevar.outputfn = outputfn;
%% node, elements, bndvtx
if strcmp(type,'stnd_bem') || strcmp(type,'fluor_bem') || strcmp(type,'spec_bem')
    eval(['mesh = make_' lower(shape) '(sizevar,1);']);
else
    eval(['mesh = make_' lower(shape) '(sizevar);']);
end

%% type, name
mesh.type = type;
mesh.name = outputfn;

%% dimension
if strcmp(shape,'Circle') || strcmp(shape,'Rectangle')
    mesh.dimension = 2;
else
    mesh.dimension = 3;
end

%% region
if strcmp(type,'stnd_bem') || strcmp(type,'fluor_bem') || strcmp(type,'spec_bem')
    mesh.region = [ones(size(mesh.elements,1),1) zeros(size(mesh.elements,1),1)];
else
    mesh.region = zeros(size(mesh.nodes,1),1);
end

%% param
mesh = set_mesh_type(mesh,type);

%% save the mesh
save_mesh(mesh,outputfn);
