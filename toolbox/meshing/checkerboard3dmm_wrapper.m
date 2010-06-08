function checkerboard3dmm_wrapper(fnprefix,saveloc,type)

% checkerboard3dmm_wrapper(fnprefix,saveloc,type)
%
% Converts inp files (surface mesh) to a fem nirfast mesh
%
% fnprefix is the prefix location of the inp files
% saveloc is the location to save the mesh to
% type is the mesh type ('stnd', 'fluor', etc)


%% elements, nodes, region, bndvtx, dimension, type, name
mesh = checkerboard3d_mm(fnprefix,type);

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
    c1 = ones(length(mesh.nodes),1).*0.01;
    c2 = ones(length(mesh.nodes),1).*0.01;
    c3 = ones(length(mesh.nodes),1).*0.4;
    mesh.conc = [c1 c2 c3];
    mesh.chromscattlist = [{'HbO'};{'deoxyHb'};{'Water'};{'S-Amplitude'};{'S-Power'}];
    mesh.wv = [661;735;761;785;808;826;849];
    mesh.excoef = [0.0741    0.8500    0.0015;
                    0.0989    0.2400    0.0038;
                    0.1185    0.3292    0.0043;
                    0.1500    0.2056    0.0038;
                    0.1741    0.1611    0.0033;
                    0.2278    0.1611    0.0040;
                    0.2370    0.1556    0.0058];
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