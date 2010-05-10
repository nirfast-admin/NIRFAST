function inp2nirfast_fem(fnprefix,saveloc,type)

% inp2nirfast(fnprefix,saveloc,type)
%
% Converts inp files to a nirfast mesh
%
% fnprefix is the prefix location of the inp files
% saveloc is the location to save the mesh to
% type is the mesh type ('stnd', 'fluor', etc)


%% find inp files
no_regions = length(dir([fnprefix '*.inp']));
if no_regions==0
    errordlg(['Cannot find file .inp files whose prefix is ' fnprefix],'NIRFAST Error');
    error(['Cannot find file .inp files whose prefix is ' fnprefix]);
end

mesh.elements = [];
mesh.nodes = [];
mesh.region = [];
for i=1:no_regions
    fn = [fnprefix num2str(i) '.inp'];
    [elem,node] = read_abaqus_inp_3D(fn);
    prior_size = size(mesh.nodes,1);
    mesh.nodes = [mesh.nodes; node];
    mesh.elements = [mesh.elements; elem + prior_size];
    mesh.region = [mesh.region; repmat(i,size(node,1),1)];
end

%% write nirfast mesh
mesh.dimension = 3;
mesh.type = type;
mesh.name = saveloc;

% find boundary nodes
faces=[mesh.elements(:,[1,2,3]);
      mesh.elements(:,[1,2,4]);
      mesh.elements(:,[1,3,4]);
      mesh.elements(:,[2,3,4])];
faces=sort(faces,2);
[foo,ix,jx]=unique(faces,'rows');
vec=histc(jx,1:max(jx));
qx= vec==1;
bdy_faces=faces(ix(qx),:);
mesh.bndvtx = zeros(size(mesh.nodes,1),1);
mesh.bndvtx(unique(bdy_faces))=1;

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
