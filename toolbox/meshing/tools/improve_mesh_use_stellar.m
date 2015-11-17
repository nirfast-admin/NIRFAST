function [e p st] = improve_mesh_use_stellar(e, p, opt_params)
% Use Stellar to improve mesh quality. Note that this routine will add more
% nodes/elements to mesh and hence alter it.
% Therefor no material/region property can be used after this routine is
% done.

if size(e,2) < 4, error(' Can only handle tetrahedral meshes!'); end
if size(e,2) > 4 % region/material info?
    warning('nirfast:meshing:optimize', ...
        [' Mesh optimization routine will produce a mesh with no material info.\n', ...
        ' You should reassign material info to the new mesh produce by this method.']);
    e = e(:,1:4);
end

if nargin < 3 || isempty(opt_params)
    qualmeasure = 0;
    facetsmooth = 0;
    usequadrics = 1;
    opt_params = [];
end
qualmeasure = 0;
facetsmooth = 0;
usequadrics = 1;

orig_nn = size(p,1);
orig_ne = size(e,1);

eorig = e;

mycf = pwd;
foodir = fileparts(which('CheckMesh3D.m'));
stellar_config_fn = fullfile(foodir,'.stellar_config');

h = waitbar(0,'Initializing optimization.');

% Make sure element orientations are OK
e = check_element_orientation_3d(e,p);

% Write temp element files for stellar
tmpfolder = tempdir;
cd(tmpfolder)

fnprefix = fullfile(tmpfolder,'stellar_input');
writenodelm_nod_elm(fnprefix, e, p)

if ~isempty(opt_params) && isfield(opt_params,'qualmeasure')
    qualmeasure = opt_params.qualmeasure;
end
if ~isempty(opt_params) && isfield(opt_params,'facetsmooth')
    facetsmooth = opt_params.facetsmooth;
end
if ~isempty(opt_params) && isfield(opt_params,'usequadrics')
    usequadrics = opt_params.usequadrics;
end
% Create a config file for Stellar based on the template
fid = fopen([stellar_config_fn '_temp'],'rt');
foos = fscanf(fid,'%c',Inf);
fclose(fid);
foos = strrep(foos,'__QUALMEASURE__', num2str(qualmeasure));
foos = strrep(foos,'__FACETSMOOTH__', num2str(facetsmooth));
foos = strrep(foos,'__USEQUADRICS__', num2str(usequadrics));
fid = fopen(stellar_config_fn,'wt');
fprintf(fid,'%c',foos);
fclose(fid);

execname = GetSystemCommand('improve_mesh_stellar');

waitbar(0.1,h,'Running optimization.');

command = ['"' execname '" -s ' '"' stellar_config_fn ...
    '" -j -C -V "' fnprefix '"'];

fprintf('\n ** Running Optimizier, please wait');
tic
[st result] = system(command);
t2=toc;
fprintf(' **\n');

if st~=0
    warning('nirfast:improvemesh', ' --> Could not improve the mesh:');
    fprintf('--------------------------------\n%s',result);
    fprintf('--------------------------------\n');
    e = eorig;
    close(h);
else
    [ms me foo mstr] = regexp(result,'worstqual:\s*[\d.+-]+');
    bqual = mstr{1}; [ms me foo bqual] = regexp(bqual,'[\d.+-]+');
    aqual = mstr{2}; [ms me foo aqual] = regexp(aqual,'[\d.+-]+');
    waitbar(0.96,h,'Reading optimized mesh.');
    [e p] = read_nod_elm([fnprefix '.1.'],1);
    % Remove unused nodes
    [e p] = remove_unused_nodes(e,p);
    
    fprintf('\n -- Quality Optimziation --\n');
    cprintf([0.1 0.5 1],'\tBefore: # of nodes: %d, # of elements: %d\n',...
        orig_nn, orig_ne);
    cprintf('Blue','\tAfter:  # of nodes: %d, # of elements: %d\n',...
        size(p,1), size(e,1));
    cprintf([1 0.3 0.5],'\tBefore:  %.4f\n\tAfter :  %.4f\n'...
        ,str2double(bqual{1}),str2double(aqual{1}));
    fprintf('\tOptimization Time: %.2f secs\n',t2);

    close(h);
end

delete([fnprefix '.*'],stellar_config_fn)
cd(mycf)


