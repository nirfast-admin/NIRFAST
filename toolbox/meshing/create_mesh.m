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
if (strcmp(shape,'circle') || strcmp(shape,'rectangle')) && ...
        (strcmp(type,'stnd_bem') || strcmp(type,'fluor_bem') || strcmp(type,'spec_bem'))
    errordlg('BEM works for 3D shapes only','NIRFAST Error');
    error('BEM works for 3D shapes only');
end

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
if strcmp(shape,'circle') || strcmp(shape,'rectangle')
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
elseif strcmp(type,'stnd_bem')
    mesh.mua = ones(1,1);
    mesh.mus = ones(1,1);
    mesh.kappa = 1./(3.*(mesh.mua+mesh.mus));
    mesh.ri = ones(1,1);
elseif strcmp(type,'fluor_bem')
    mesh.muax = ones(1,1);
    mesh.musx = ones(1,1);
    mesh.kappax = 1./(3.*(mesh.muax+mesh.musx));
    mesh.muam = ones(1,1);
    mesh.musm = ones(1,1);
    mesh.kappam = 1./(3.*(mesh.muam+mesh.musm));
    mesh.muaf = ones(1,1);
    mesh.eta = ones(1,1);
    mesh.tau = ones(1,1);
    mesh.ri = ones(1,1);
elseif strcmp(type,'spec_bem')
    mesh.sa = ones(1,1);
    mesh.sp = ones(1,1);
    c1 = ones(1,1).*0.01;
    c2 = ones(1,1).*0.01;
    c3 = ones(1,1).*0.4;
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
else
    errordlg('Invalid mesh type','NIRFAST Error');
    error('Invalid mesh type');
end

%% save the mesh
save_mesh(mesh,outputfn);
