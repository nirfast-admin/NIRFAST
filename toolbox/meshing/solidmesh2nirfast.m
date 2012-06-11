function solidmesh2nirfast(fn,saveloc,type,sdfile)

% solidmesh2nirfast(fn,saveloc,type)
%
% converts solid/tetrahedral meshes that are generated in outside
% applications to nirfast mesh format.
%
% fn is the location of the .ele file or a structure
% saveloc is the location to save the nirfast mesh
% type is the mesh type to use ('stnd','fluor',etc)
% sdfile is optional and is the file name of a text file containign the
% list of source coordinates

if isstruct(fn)
    mesh.elements = fn.ele;
    mesh.nodes = fn.node;
    nnpe = fn.nnpe;
    dim = fn.dim;
else
    [pathstr filename ext] = fileparts(fn);
    fprintf(' Converting %s%s to nirfast mesh...\n',filename,ext);
    if strcmpi(ext,'.ele')
        [mesh.elements,mesh.nodes,nodemap,elemap,dim,nnpe] = read_nod_elm(fn(1:end-4),1);
    elseif strcmpi(ext,'.mesh')
        [mesh.elements mesh.nodes tri_ nnpe] = readMEDIT(fn);
    elseif strcmpi(ext,'.vtk')
        [mesh.elements mesh.nodes nnpe]= readVTK(fn);
    elseif strcmpi(ext,'.inp')
        [mesh.elements, mesh.nodes, surf_elem nnpe] = read_abaqus_inp_3D(fn);
        if isempty(mesh.elements)
            error('solidmesh2nirfast: input mesh is not a solid/volume mesh.');
        end
    end
    if nnpe ~=4 || size(mesh.elements,2)<4
            error('solidmesh2nirfast: Expects a tetrahedral mesh!');
    end
    nnpe = 4;
    dim = size(mesh.nodes,2);
end

%% Check Mesh Quality
[vol q q_area status]=CheckMesh3D(mesh.elements(:,nnpe),mesh.nodes);
if status.surface ~=0 || status.solid ~= 0
    ws = sprintf(' The mesh being imported has\n some quality issues that might cause errors later on!\n Check the log messages!\n');
    warning('Nirfast:MeshQuality',ws);
end
%% set mesh properties
mesh = set_mesh_type(mesh,type);
if strcmp(type,'stnd_bem') || strcmp(type,'fluor_bem') || strcmp(type,'spec_bem')
    if size(mesh.elements,2)>=nnpe+2
        mesh.region = mesh.elements(:,nnpe+1:nnpe+2);
        mesh.elements = mesh.elements(:,1:nnpe);
    else
        mesh.region = [ones(size(mesh.elements,1),1) zeros(size(mesh.elements,1),1)];
    end
    mesh.dimension = 3;
    mesh.bndvtx = ones(size(mesh.nodes,1),1);
else
    if size(mesh.elements,2)>nnpe
        % Get region info
        % Since NIRFAST is a node based FEM package we need to assign
        % material/region IDs to nodes rather than elements!
        region_ids = unique(mesh.elements(:,nnpe+1));
        if min(region_ids)==0, region_ids=region_ids+1; end
        mesh.region = zeros(size(mesh.nodes,1),1);
        for i=1:length(region_ids)
            relem = mesh.elements(mesh.elements(:,nnpe+1)==region_ids(i),:);
            foo = relem(:,1:nnpe);
            rnodes = unique(foo(:));
            mesh.region(rnodes) = region_ids(i);
        end
        mesh.elements=mesh.elements(:,1:4);
    else
        mesh.region = ones(size(mesh.nodes,1),1);
    end
    mesh.dimension = dim;
end

faces=[mesh.elements(:,[1,2,3]);
       mesh.elements(:,[1,2,4]);
       mesh.elements(:,[1,3,4]);
       mesh.elements(:,[2,3,4])];
faces=sort(faces,2);
[foo,ix,jx]=unique(faces,'rows');
vec=histc(jx,1:max(jx));
qx = vec==1;
bdy_faces=faces(ix(qx),:);
exterior_nodes_id = unique(bdy_faces(:));
mesh.bndvtx = zeros(size(mesh.nodes,1),1);
mesh.bndvtx(exterior_nodes_id) = 1;


%% save the mesh
save_mesh(mesh,saveloc);

if nargin>=4 && ~isempty(sdfile)
    % Load the S/D locations from file
    sdcoords = load(sdfile);
    if size(sdcoords,2)>3
        sdcoords = sortrows(sdcoords);
        num = sdcoords(:,1);
        sdcoords = sdcoords(:,2:end);
    else
        num = (1:size(sdcoords,1))';
    end
    % Set up mesh fields for S/D
    mesh.name = saveloc;
    mesh.source.coord = sdcoords;
    mesh.source.num = num;
    mesh.source.fixed = 0;
    mesh.source.distributed = 0;
    mesh.source.fwhm = zeros(size(sdcoords,1),1,'int8');
    
    mesh.meas.coord = sdcoords;
    mesh.meas.fixed = 0;
    mesh.meas.num = num;

    % Compute mus in order to move sources
    if strcmp(mesh.type,'stnd') == 1 || strcmp(mesh.type,'stnd_spn')
        mus_eff = mesh.mus;
    elseif strcmp(mesh.type,'stnd_bem') == 1
        mus_eff = mesh.mus(1);
    elseif strcmp(mesh.type,'fluor') || strcmp(mesh.type,'fluor_bem')
        mus_eff = mesh.musx;
    elseif strcmp(mesh.type,'spec') || strcmp(mesh.type,'spec_bem')
        [mua,mus] = calc_mua_mus(mesh,mesh.wv(1));
        mus_eff = mus;
        clear mua mus
    end
    
    % Populate link table
    nsrcs = size(sdcoords,1);
    link = zeros(nsrcs*(nsrcs-1),3,'int32');
    c=1;
    for si=1:size(sdcoords,1)
        for di=1:size(sdcoords,1)
            if num(si) == num(di)
                continue;
            end
            link(c,:) = [num(si) num(di) 1];
            c = c + 1;
        end
    end
    mesh.link = link;
    
    % Move source/detectors
    mesh = move_detector(mesh);
    mesh = move_source(mesh,mus_eff,100);
    
    save_mesh(mesh,saveloc);
    % Set up chromophores for spectral meshes
    if strcmp(mesh.type,'spec') || strcmp(mesh.type,'spec_bem')   
        h = gui_set_chromophores('mesh',saveloc);
        uiwait(h)
    end
end


