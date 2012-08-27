function mesh = surf2nirfast_bem(filename,savefn,type)

% surf2nirfast_bem(filename,saveloc,type)
%
% Converts inp files to a nirfast bem mesh
%
% filename is the file name of one of the inp files (ex: filename2.inp)
% saveloc is the location to save the mesh to
% type is the mesh type ('stnd', 'fluor', etc)

[saveloc savefn saveext] = fileparts(savefn);
outfnprefix = [savefn saveext];

if isempty(saveloc)
    saveloc = pwd;
end

%% find inp files
% if isempty(fileparts(filename))
%     filename = fullfile(saveloc,filename);
% end

[path fnprefix num_flag myext] = GetFilenameNumbering(filename);
fnprefix=fullfile(path,fnprefix);

no_regions = length(dir([fnprefix '*' myext]));
if no_regions==0
    errordlg(['Cannot find file .inp files whose prefix is ' fnprefix],'NIRFAST Error');
    error(['Cannot find file .inp files whose prefix is ' fnprefix]);
end

fprintf('\n\tConverting inp files and re-orienting. Please wait...\n');

fcounter = num_flag;
if fcounter==-1 % just one inp file
    fcounter = 0; num_flag = 0;
    fn = [fnprefix myext];
else % Multiple inp files
    fn = [fnprefix num2str(fcounter) myext];
end
%%
% maps the new region numbering to original one. original numbering is
% basically the numbers that are found in .inp file names.
region_map =[]; newmatc=1;
newfn_suffix = '_separated';

while true
    fid = fopen(fn,'rt');
    if fid < 0, break; end
    fclose(fid);
    if strcmpi(myext,'.inp')
        [celem,cnode] = abaqus2nodele_surface(fn,saveloc);
    elseif strcmpi(myext,'.ele')
        [celem,cnode] = read_nod_elm(fn,1);
    else
        errordlg([myext ' type for input surface is not supported!']);
        error([myext ' type for input surface is not supported!']);
    end
    output = SeparateSubVolumes(celem,cnode);
    for i=1:length(output.all_regions)
        newfn = sprintf('%s%s%d',fullfile(saveloc,outfnprefix),newfn_suffix,newmatc);
        foo_ele = output.retelem(output.all_regions{i},1:3);
        foo_nodes = unique(foo_ele(:));
        foo_coords = cnode(foo_nodes,:);
        [tf foo_ele] = ismember(foo_ele,foo_nodes);
        writenodelm_nod_elm(newfn,foo_ele,foo_coords);
        region_map(newmatc) = fcounter;
        newmatc = newmatc + 1;
    end
    fcounter = fcounter + 1;
    fn = [fnprefix num2str(fcounter) myext];
end

if (fcounter-num_flag)~=newmatc-1% We have separated disjoint regions within the same material ID
    fprintf('\n\n\t ****  ATTENTION ****\n\n');
    fprintf('  Please note that some of sub-surfaces present in your input files are now separated,\n');
    fprintf('  and thus have their own ''region'' ID. Following is the mapping between new regions and\n');
    fprintf('  the old ones (based on the .inp numberings)\n Maps:\n');
    disp([(1:size(region_map,2))' region_map']);
    warndlg({'Please note that some of sub-surfaces present in your input files',...
        'are now separated, and thus have their own ''region'' ID. Following is the mapping between new regions and',...
        'the old ones (based on the .inp numberings)'},'Region ID Changes!');
end

%% Compute surface relations
mesh = ExtractSurfaceRelations(fullfile(saveloc,[outfnprefix newfn_suffix]), newmatc-1);

%% write nirfast mesh
if nargin >=3
    fprintf('\tWriting nirfast mesh files\n');

    nregions = size(unique(mesh.region),1)-1;
    mesh.dimension = 3;
    mesh.ri = ones(nregions,1)*1.33;
    mesh = set_mesh_type(mesh,type);
    mesh.region_map = region_map;

    save_mesh(mesh,fullfile(saveloc,outfnprefix));
end


