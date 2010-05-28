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
[mesh.nodes,mesh.elements,mesh.bndvtx,mesh.region] = checkerboard2D(bmpfile,pixeldim,edgesize,triarea);

%% dimension, name, type
mesh.dimension = 2;
mesh.type = type;
mesh.name = saveloc;

%% optical properties
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
else
    errordlg('Invalid mesh type','NIRFAST Error');
    error('Invalid mesh type');
end

save_mesh(mesh,saveloc);