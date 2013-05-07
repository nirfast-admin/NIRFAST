function nirfast2vtk(mesh,outfname)

% nirfast2vtk(mesh,outfname)
%
% convert nirfast mesh into vtk format
%
% mesh is the nirfast mesh
% outfname is the location to save the vtk file


%% load mesh and get optical properties
if ischar(mesh)== 1
  mesh = load_mesh(mesh);
end

listsolfnames = {};
soldata = [];

if isfield(mesh,'region')
    listsolfnames{end+1} = 'region';
    soldata(:,end+1) = mesh.region(:,1);
end
if isfield(mesh,'mua')
    listsolfnames{end+1} = 'mua';
    soldata(:,end+1) = mesh.mua(:,1);
end
if isfield(mesh,'mus')
    listsolfnames{end+1} = 'mus';
    soldata(:,end+1) = mesh.mus(:,1);
end
if isfield(mesh,'kappa')
    listsolfnames{end+1} = 'kappa';
    soldata(:,end+1) = mesh.kappa(:,1);
end
if isfield(mesh,'muax')
    listsolfnames{end+1} = 'muax';
    soldata(:,end+1) = mesh.muax;
end
if isfield(mesh,'musx')
    listsolfnames{end+1} = 'musx';
    soldata(:,end+1) = mesh.musx;
end
if isfield(mesh,'muam')
    listsolfnames{end+1} = 'muam';
    soldata(:,end+1) = mesh.muam;
end
if isfield(mesh,'musm')
    listsolfnames{end+1} = 'musm';
    soldata(:,end+1) = mesh.musm;
end
if isfield(mesh,'muaf')
    listsolfnames{end+1} = 'muaf';
    soldata(:,end+1) = mesh.muaf;
    if isfield(mesh,'eta') && ~isfield(mesh,'etamuaf')
        mesh.etamuaf = mesh.eta.*mesh.muaf;
    end
end
if isfield(mesh,'eta')
    listsolfnames{end+1} = 'eta';
    soldata(:,end+1) = mesh.eta;
end
if isfield(mesh,'tau')
    listsolfnames{end+1} = 'tau';
    soldata(:,end+1) = mesh.tau;
end
if isfield(mesh,'sa')
    listsolfnames{end+1} = 'sa';
    soldata(:,end+1) = mesh.sa;
end
if isfield(mesh,'sp')
    listsolfnames{end+1} = 'sp';
    soldata(:,end+1) = mesh.sp;
end
if isfield(mesh,'phi')
    listsolfnames{end+1} = 'phi';
    soldata(:,end+1) = mesh.phi;
end
if isfield(mesh,'etamuaf')
    listsolfnames{end+1} = 'etamuaf';
    soldata(:,end+1) = mesh.etamuaf;
end

hbo_loc = -1;
deoxyhb_loc = -1;

if isfield(mesh,'conc') && isfield (mesh,'chromscattlist')
    [nc,junk]=size(mesh.chromscattlist);
    for i = 1 : nc-2
        if strcmp(mesh.chromscattlist{i},'HbO')
            mesh.conc(:,i) = 1000*mesh.conc(:,i);
            hbo_loc = i;
            disp('HbO converted to millimolar');
        end
        if strcmp(mesh.chromscattlist{i},'deoxyHb')
            mesh.conc(:,i) = 1000*mesh.conc(:,i);
            deoxyhb_loc = i;
            disp('deoxyHb converted to millimolar');
        end
        if strcmp(mesh.chromscattlist{i},'Water')
            mesh.conc(:,i) = 100*mesh.conc(:,i);
            disp('Water converted to %');
        end
        listsolfnames{end+1} = mesh.chromscattlist{i};
        soldata(:,end+1) = mesh.conc(:,i);
    end
end

if hbo_loc ~= -1 && deoxyhb_loc ~= -1
    listsolfnames{end+1} = 'HbT';
    soldata(:,end+1) = mesh.conc(:,hbo_loc)+mesh.conc(:,deoxyhb_loc);
    listsolfnames{end+1} = 'StO2';
    soldata(:,end+1) = 100*mesh.conc(:,hbo_loc)./soldata(:,end);
    disp('HbT is in millimolar');
    disp('StO2 is in %');
end

%% write to vtk

nodes = mesh.nodes;
elems = mesh.elements;

numnodes = length(nodes);
numelems = length(elems);

outfname = add_extension(outfname,'.vtk');

if ~canwrite(outfname)
    [junk fn ext1] = fileparts(outfname);
    outfname = [tempdir fn ext1];
    disp(['No write access, writing here instead: ' outfname]);
end
fid = fopen(outfname,'w');

%define an VTK header for FEM mesh representation
line0 = '# vtk DataFile Version 2.0';
line1 = 'NIRFAST mesh with solutions';
line2 = 'ASCII';
line3 = 'DATASET UNSTRUCTURED_GRID';
fprintf(fid,'%s\n%s\n%s\n',line0,line1,line2,line3);

line4 = ['POINTS ', num2str(numnodes), ' float']; %node defs
fprintf(fid,'%s\n',line4);
fprintf(fid, '%f %f %f\n', nodes');

if mesh.dimension == 2
    line5 = ['CELLS ',num2str(numelems),' ',num2str(numelems*3+numelems)]; %connectivity maps
    fprintf(fid,'%s\n',line5);
    fprintf(fid,'%d %d %d %d\n',[3*ones(numelems,1) elems-1]');
    line6 = ['CELL_TYPES ', num2str(numelems)]; %specify the mesh basis 10-tetrahedral for all connectivity maps 
    fprintf(fid,'%s\n',line6);
    fprintf(fid,'%d\n', ones(numelems,1)*5);
else
    line5 = ['CELLS ',num2str(numelems),' ',num2str(numelems*4+numelems)]; %connectivity maps
    fprintf(fid,'%s\n',line5);
    fprintf(fid,'%d %d %d %d %d\n',[4*ones(numelems,1) elems-1]');
    line6 = ['CELL_TYPES ', num2str(numelems)]; %specify the mesh basis 10-tetrahedral for all connectivity maps 
    fprintf(fid,'%s\n',line6);
    fprintf(fid,'%d\n', ones(numelems,1)*10);
    fprintf(fid,'%s\n',['POINT_DATA ',num2str(numnodes)]); %specify the data that follows is defined on the nodes
end

for i = 1:size(soldata,2)
    fprintf(fid,'%s\n',['SCALARS ', listsolfnames{i}, ' float 1']);
    fprintf(fid,'%s\n','LOOKUP_TABLE default');
    fprintf(fid,'%e\n', soldata(:,i));
end

fclose(fid);
