function inp2nirfast_bem(fnprefix,saveloc,type)

% inp2nirfast_bem(fnprefix,saveloc,type)
%
% Converts inp files to a nirfast bem mesh
%
% fnprefix is the prefix  of the inp files ('fnprefix1.inp or
% fnprefix_2.inp or ...)
% saveloc is the location to save the mesh to
% type is the mesh type ('stnd', 'fluor', etc)


%% find inp files
no_regions = length(dir([fnprefix '*.inp']));
if no_regions==0
    errordlg(['Cannot find file .inp files whose prefix is ' fnprefix],'NIRFAST Error');
    error(['Cannot find file .inp files whose prefix is ' fnprefix]);
end

fprintf('\n\tConverting inp files and re-orienting\n');
for i=1:no_regions
    fn = [fnprefix num2str(i) '.inp'];
    abaqus2nodele_surface(fn);
end

%% Compute surface relations
mesh = ExtractSurfaceRelations(fnprefix, no_regions);

%% write nirfast mesh
fprintf('\tWriting nirfast mesh files\n');

nregions = size(unique(mesh.region),1)-1;
mesh.dimension = 3;
mesh.ri = ones(nregions,1)*1.33;
mesh.type = type;

if strcmp(mesh.type,'stnd_bem')
    mesh.mua = ones(nregions,1)*0.006;
    mesh.mus = ones(nregions,1)*2;
    mesh.kappa = 1./(3.*(mesh.mua+mesh.mus));
elseif strcmp(mesh.type,'fluor_bem')
    mesh.muax = ones(nregions,1)*0.006;
    mesh.musx = ones(nregions,1)*2;
    mesh.kappax = 1./(3.*(mesh.muax+mesh.musx));
    mesh.muam = ones(nregions,1)*0.006;
    mesh.musm = ones(nregions,1)*2;
    mesh.kappam = 1./(3.*(mesh.muam+mesh.musm));
    mesh.eta = ones(nregions,1);
    mesh.tau = ones(nregions,1);
    mesh.muaf = ones(nregions,1);
elseif strcmp(mesh.type,'spec_bem')
    mesh.sa = ones(nregions,1);
    mesh.sp = ones(nregions,1);
    c1 = ones(nregions,1).*0.01;
    c2 = ones(nregions,1).*0.01;
    c3 = ones(nregions,1).*0.4;
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
    errordlg('Invalid BEM mesh type','NIRFAST Error');
    error('Invalid BEM mesh type');
end

save_mesh(mesh,saveloc);

