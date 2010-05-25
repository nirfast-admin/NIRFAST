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
fprintf('\tSurface detection.\n\t\t');
surface_relations_mex(fnprefix,no_regions);
relations = textread('surface_relations.txt');

region_id=zeros(no_regions,1);
idcounter=1;
for i=1:size(relations,1)
    if i==1
        fn = [fnprefix num2str(relations(i,1))];
        [mesh.elements,mesh.nodes] = read_nod_elm(fn,1);
        region1 = repmat(1,[size(mesh.elements,1) 1]);
        region2 = repmat(0,[size(mesh.elements,1) 1]);
        no_ext_nodes = size(mesh.nodes,1);
        NoBdyNodes(i) = no_ext_nodes;
        NoBdyElems(i) = size(mesh.elements,1);
    end
    if region_id(relations(i,1)) == 0
        region_id(relations(i,1)) = idcounter;
        idcounter = idcounter + 1;
    end
    momid = region_id(relations(i,1));
    for j=2:size(relations,2)
        if relations(i,j)==0, continue; end
            fn = [fnprefix num2str(relations(i,j))];
            kidid = idcounter;
            region_id(relations(i,j)) = idcounter;
            
            [fooele,foonode] = read_nod_elm(fn,1);
            mesh.elements=[mesh.elements;fooele+size(mesh.nodes,1)]; %#ok<AGROW>
            mesh.nodes=[mesh.nodes; foonode]; %#ok<AGROW>
            region1 = cat(1,region1,repmat(momid,[size(fooele,1) 1]));
            region2 = cat(1,region2,repmat(kidid,[size(fooele,1) 1]));
            
            NoBdyNodes(idcounter) = size(foonode,1);
            NoBdyElems(idcounter) = size(fooele,1);
            idcounter = idcounter + 1;
    end
end
foo=zeros(size(mesh.nodes,1),1);
foo(1:no_ext_nodes,:) = 1;

mesh.bndvtx = foo;
mesh.region = [region1 region2];

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
    mesh.chromscattlist = [{'S-Amplitude'};{'S-Power'}];
    mesh.wv = [661];
    mesh.excoef = [];
else
    errordlg('Invalid BEM mesh type','NIRFAST Error');
    error('Invalid BEM mesh type');
end

save_mesh(mesh,saveloc);

