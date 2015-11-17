function [tets, points_from_tetgen] = checkerboard3d(e,p,myargs)
% Creates a solid (tetrahedral mesh) using the surface mesh defined in 'e'
% and 'p'. 
% myargs is a structure of following format:
% myargs.{silentflag,bdyfn,regions,edgesize,examineinpmesh}:
% 
% myargs.silentflag: if it is 1, it will assume that user doesn't
% want to intervene and will use default setting to create the mesh. In
% this case myargs.bdyfn should be specified.
% 
% myargs.regions: for multiple material meshes specifies the tagging node
% of each region and each regions id. It is in form of:
% regions: a cell array which identifies a point inside a given region
% (material). It also can contain region ID and the volume constraint.
% regions{:,1} : coordinaets of a point inside the region
% regions{:,2} : material/attribute ID for the hole and volume constraint.
%                if region{:,2} has more than one entity the second one
%                will be used a scaling factor for the maximum size of a
%                tetraheron volume in that region
% myargs.extelem : list of elements of the most exterior surface that
% encloses all other sub surfaces
% 
% For more info check:
% http://tetgen.berlios.de/fformats.poly.html
% 
% myargs.edgesize: If it is specified, this routine uses the given length
% as its basis to create tetrahedra rather than computing the average edge
% size of the input surface.
% 
% myargs.examineinpmesh
% 'true': will check the integreity of input surface mesh
% Otherwise dialg boxes will be shown to get the input settings.


% clear global
% ### codes used to mark pixels ###
global outside inside NA node_code boundary_node_code on_facet
outside=5;
inside =6;
NA=3;
node_code = 2;
boundary_node_code=1;
on_facet=7;

if nargin==0
    [orige,p,nodemap,elemap,dim,nnpe,filename,filetype]=ui_read_nod_elm(nargin);
    if nnpe~=3
        error('You need to input a 3D closed surface with triangular patches!');
    end
    [bf e]=ismember(orige,nodemap);
elseif nargin>=2
    silentflag = myargs.silentflag;
    bdyfn = myargs.bdyfn;
    orige = e;
    filetype = 'tetgen';
    filename = bdyfn;
    nnpe = size(e,2);
    dim = size(p,2);
    nodemap=1:size(p,1);
end
if nnpe~=3 || dim~=3
    errordlg(['Input mesh is not a 3D shell surface! - ' filename],'NIRFAST Error');
    error('Input mesh is not a 3D shell surface!');
end
if nargin==0 || nargin==2
    silentflag=0;
end

% get the output filename
if silentflag==0
    defaultextension='.node';
    [savefilename savefiletype]=ui_savemeshfilename([filename '-cb3d'],defaultextension);
else
    savefilename = [filename '-cb3d'];
end


if silentflag==0 || (isfield(myargs,'examineinpmesh') && myargs.examineinpmesh)
    if silentflag==0
        value = uigetpref('advoptions','set','Check integrity of input surface?',...
            {'Do you want to check integrity and quality of the input surface mesh?',...
            ''},{'Yes','No'},'DefaultButton','No');
    end
    if (strcmpi(value,'yes') || (isfield(myargs,'examineinpmesh') && myargs.examineinpmesh))
        status=RunQualityCheckon3DSurface(orige,p,nodemap);
        if status.a~=0 || status.b~=0 % Stop! surface needs to be corrected before using this routine
            errordlg(['Input surface mesh needs to be corrected! - ' filename],'NIRFAST Error');
            error(['Input surface mesh needs to be corrected! - ' filename]);
        end
    end
    if silentflag==0
        % Ask if users wants to recovery physical boundary after mesh generation
        recoverflag = uigetpref('advoptions','set','Recover physical boundary?',...
        {'Do you want to recover original physical boundary after mesh generation is done?',...
         ''},{'Yes','No'},'DefaultButton','No');
    end
end

% Until we implement a density function, we will use the average edge size
% as the initial desired length.
edgesize = GetEdgeSize(e, p);

if silentflag==0
    prompt='Please enter Average Desired Mesh Length:';
    name='Input desired element length:  ';
    numlines=1;
    defaultanswer={num2str(edgesize)};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    % We should add an option that user can choose an Size function:
    % ds=GetEdgeSizeAtXY(p(t(i,j),:),density);
    ds = str2num(answer{1});
    % ds=2;
else
    if isfield(myargs,'edgesize') && ~isempty(myargs.edgesize)
        ds = myargs.edgesize;
    else
        ds = edgesize;
    end
end

% Fix the facets orientation to make sure their normal is poiting outward.
% [e]=FixPatchOrientation(p,e);

clear P Q;
resolution=2;

% Bounding Box of the input surface mesh
llc = [min(p(:,1)) min(p(:,2)) min(p(:,3))];
urc = [max(p(:,1)) max(p(:,2)) max(p(:,3))];

% Calculate size of the matrix based on edgesize
dx = ds/resolution; dy = ds/resolution; dz = ds/resolution;
ncol = ceil((urc(1) - llc(1)) / dx)+3;
nrow = ceil((urc(2) - llc(2)) / dy)+3;
npln = ceil((urc(3) - llc(3)) / dz)+3;

global P
global tiny
tiny = 1e-12*max(urc-llc);
P = zeros(nrow,ncol,npln,'int8');

% Tag the 'pixels' inside P and create nodes for each tagged pixel
[PP] = TagBoundary3d(p,e,ds,dx,dy,dz,llc,myargs);

tmpath=tempdir;
noPLCp = size(p,1);
warning('off','MATLAB:DELETE:FileNotFound');
delete(fullfile(tmpath,'input4delaunay.*'),fullfile(tmpath,'junk.txt'));
warning('on','MATLAB:DELETE:FileNotFound');

% Write input files for delaunaygen
maxtetvol = sqrt(2)/12*edgesize^3;
inpolyfn = fullfile(tmpath,'input4delaunay');
junkfn = fullfile(tmpath,'junk.txt');

writenodes_tetgen(fullfile(tmpath,'input4delaunay.a.node'),PP);
if isfield(myargs,'regions') && ~isempty(myargs.regions)
    for i=1:size(myargs.regions,1)
        ttags = myargs.regions{i,2};
        if length(ttags) == 1
            myargs.regions{i,2} = [myargs.regions{i,2} maxtetvol];
        elseif length(ttags) == 2
            foo = myargs.regions{i,2};
            myargs.regions{i,2} = [foo(1) foo(2)*maxtetvol];
        end
    end
    writenodelm_poly3d(inpolyfn,e,p,[],[],myargs.regions,1,[]);
else
    writenodelm_poly3d(inpolyfn,e,p,[],[],[],1,[]);
end

delaunaycommand = 'delaunaygen';
systemcommand = GetSystemCommand(delaunaycommand);

fprintf('\n---------> Running Delaunay, please wait...');

delaunay_cmd = sprintf('! "%s" -pqgjGViA "%s.poly" > "%s"',systemcommand,inpolyfn,junkfn);
% delaunay_cmd = sprintf('! "%s" -pq1.5gjGVAa "%s.poly" > "%s"',systemcommand,inpolyfn,junkfn);
eval(delaunay_cmd);
if ~exist(fullfile(tmpath,'input4delaunay.1.ele'),'file')
    warning('nirfast_meshing:retry_delaunay',...
        ' Delaunay Generator failed. Trying again...');
    delaunay_cmd = sprintf('! "%s" -pq1.7gjGVAa%.12f "%s.poly" > "%s"',systemcommand,sqrt(2)*maxtetvol,inpolyfn,junkfn);
    eval(delaunay_cmd);
    if ~exist(fullfile(tmpath,'input4delaunay.1.ele'),'file')
        error(' Delaunay Generator failed again. Check your input setting!')
    end
end

fprintf(' done. <---------\n\n');

[tets,points_from_tetgen,nodemap_fromtetgen] = ...
    read_nod_elm(fullfile(tmpath,'input4delaunay.1.'),1);


function [PP] = TagBoundary3d(p,t,ds,dx,dy,dz,llc,myargs)
global P
global tiny


xmin = llc(1); ymin = llc(2); zmin = llc(3);
% Get normals of each triangular face
v1=p(t(:,2),:)-p(t(:,1),:);
v2=p(t(:,3),:)-p(t(:,2),:);
shell_normals = cross(v1,v2);
norm_len = sqrt(sum(shell_normals.^2,2));
shell_normals=shell_normals./repmat(norm_len,1,3);

% Create a zone around each triangular face to avoid placing nodes too
% close to them
[P]=ExpandBoundaryBufferZone(t,p,P,shell_normals,ds,[dx dy dz],llc);
clear mex
fprintf('\t Tagging interior nodes... ');

if isfield(myargs,'gradingflag') && myargs.gradingflag ~= 0
    grading_flag = 1;
    grading_rate = 0.75;
else
    grading_flag = 0;
    grading_rate = 0;
end
% [nodes] = tag_checkerbaord3d_mex(P, delta, llc, ds, grading_flag, grading_rate)
interior_p0 = tag_checkerboard3d_mex(P, [dx dy dz], [xmin ymin zmin], ds, grading_flag, grading_rate);

fprintf('done\n');

t=double(myargs.extelem(:,1:3));
extnoden=unique(t(:));
[tf t]=ismember(t, extnoden);
p=p(extnoden,1:3);
fbbx = GetFacetsBBX(t,p);
fprintf('-----> Running BSP tree to filter out nodes.\n');
clear mex
% st1 = PointInPolyhedron_mex(interior_p0, t, p, tiny);
st1 = involume_mex(interior_p0, t, p, 200, fbbx, min(p(:,1)), max(p(:,1)), tiny);
fprintf('\n-----> done.\n');

% sum(abs(double(st2) - foost))
PP = interior_p0((st1==1),:);
% PP = mypoints;




    

     

























