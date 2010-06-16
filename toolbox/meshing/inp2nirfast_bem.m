function inp2nirfast_bem(filename,saveloc,type)

% inp2nirfast_bem(filename,saveloc,type)
%
% Converts inp files to a nirfast bem mesh
%
% filename is the file name of one of the inp files (ex: filename2.inp)
% saveloc is the location to save the mesh to
% type is the mesh type ('stnd', 'fluor', etc)


%% find inp files
[path fnprefix num_flag myext] = GetFilenameNumbering(filename);
fnprefix=fullfile(path,fnprefix);

no_regions = length(dir([fnprefix '*' myext]));
if no_regions==0
    errordlg(['Cannot find file .inp files whose prefix is ' fnprefix],'NIRFAST Error');
    error(['Cannot find file .inp files whose prefix is ' fnprefix]);
end

fprintf('\n\tConverting inp files and re-orienting\n');

fcounter = num_flag;
if fcounter==0 % just one inp file
    fn = [fnprefix myext];
else % Multiple inp files
    fn = [fnprefix num2str(fcounter) myext];
end

while true
    fid = fopen(fn,'rt');
    if fid < 0, break; end
    fclose(fid);
    abaqus2nodele_surface(fn);
    fcounter = fcounter + 1;
    fn = [fnprefix num2str(fcounter) myext];
end


%% Compute surface relations
mesh = ExtractSurfaceRelations(fnprefix, no_regions);

%% write nirfast mesh
fprintf('\tWriting nirfast mesh files\n');

nregions = size(unique(mesh.region),1)-1;
mesh.dimension = 3;
mesh.ri = ones(nregions,1)*1.33;
mesh = set_mesh_type(mesh,type);

save_mesh(mesh,saveloc);

