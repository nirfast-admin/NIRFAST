function create_mesh(outputfn,shape,sizevar,type)

% create_mesh(outputfn,shape,sizevar,type,link,source,meas)
%
% Creates a mesh with the desired properties
%
% outputfn is the filename to save the mesh to
% shape is the shape of the mesh
% sizevar is a structured variable containing the shape sizes
% type is the mesh type


%% error checking
if (strcmp(shape,'circle') || strcmp(shape,'rectangle')) && strcmp(type,'stnd_bem')
    errordlg('BEM works for 3D shapes only','NIRFAST Error');
    error('BEM works for 3D shapes only');
end

%% node, elements, bndvtx
if strcmp(type,'stnd_bem')
    eval(['mesh = make_' lower(shape) '(sizevar,1);']);
else
    eval(['mesh = make_' lower(shape) '(sizevar);']);
end

%% type, name
mesh.type = type;
mesh.name = outputfn;

%% dimension
if strcmp(shape,'circle') || strcmp(shape,'rectangle')
    mesh.dimension = 2;
else
    mesh.dimension = 3;
end

%% region
if strcmp(type,'stnd_bem')
    mesh.region = [ones(size(mesh.elements,1),1) zeros(size(mesh.elements,1),1)];
else
    mesh.region = zeros(size(mesh.nodes,1),1);
end

%% param
if strcmp(type,'stnd')
    mesh.mua = ones(length(mesh.nodes),1);
    mesh.mus = ones(length(mesh.nodes),1);
    mesh.kappa = 1./(3.*(mesh.mua+mesh.mus));
    mesh.ri = ones(length(mesh.nodes),1);
elseif strcmp(type,'fluor')
    mesh.muax = ones(length(mesh.nodes),1);
    mesh.musx = ones(length(mesh.nodes),1);
    mesh.kappax = 1./(3.*(mesh.muax+mesh.musx));
    mesh.muam = ones(length(mesh.nodes),1);
    mesh.musm = ones(length(mesh.nodes),1);
    mesh.kappam = 1./(3.*(mesh.muam+mesh.musm));
    mesh.muaf = ones(length(mesh.nodes),1);
    mesh.eta = ones(length(mesh.nodes),1);
    mesh.tau = ones(length(mesh.nodes),1);
    mesh.ri = ones(length(mesh.nodes),1);
elseif strcmp(type,'spec')
    mesh.sa = ones(length(mesh.nodes),1);
    mesh.sp = ones(length(mesh.nodes),1);
    mesh.chromscattlist = [{'S-Amplitude'};{'S-Power'}];
    mesh.wv = [661];
    mesh.excoef = [];
    mesh.ri = ones(length(mesh.nodes),1);
elseif strcmp(type,'stnd_spn')
    mesh.mua = ones(length(mesh.nodes),1);
    mesh.mus = ones(length(mesh.nodes),1);
    mesh.kappa = 1./(3.*(mesh.mua+mesh.mus));
    mesh.g = ones(length(mesh.nodes),1);
    mesh.ri = ones(length(mesh.nodes),1);
elseif strcmp(type,'stnd_bem')
    mesh.mua = ones(1,1);
    mesh.mus = ones(1,1);
    mesh.kappa = 1./(3.*(mesh.mua+mesh.mus));
    mesh.ri = ones(1,1);
else
    errordlg('Invalid mesh type','NIRFAST Error');
    error('Invalid mesh type');
end

%% save the mesh
save_mesh(mesh,outputfn);
