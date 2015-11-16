function [vol,q,q_area,status] = CheckMesh3D(e,p,nodemap,input_flags)
% Performs some checks on a 3D mesh (either surface or solid) and returns
% volume/area and quality of elements. The mesh elements are defined in 'e'
% and cooridinates are in 'p'. It also returns the validity of mesh
% status in 'status' as:
% For surface inputs, status.surface's appropriate 'bit' will be set to
% indicate the type of problem:
% 0: OK
% 2: (bit 1) non-manifold or multi-material mesh
% 4: (bit 2) open surface
% 8: (bit 3) loq quality elements (<q_tri_area_threshold)
% 
% For solid inputs, status.solid's appropriate 'bit' will be set to
% indicate the type of problem:
% 0: OK
% 2: (bit 1) some elements have close to zero volume
% 4: (bit 2) some elements have very low quality
% 8: (bit 3) serious tetrahedron connectivity issue, some of faces are
%            shared by more than two tetrahedrons
% Written by:
%     Hamid Ghadyani, 2009
% 

if nargin>3 && ~isempty(input_flags)
    if isfield(input_flags,'verbose')
        verbose=input_flags.verbose;
    else
        verbose=0;
    end
elseif nargin<4
    verbose = 1;
    input_flags=[];
end
vol=0;
q=0;
q_area=0;
edgeflag=0;
q_tri_area_threshold=0.1;
status.surface = 0;
status.solid = 0;

global TetrahedronFailQuality
if isempty(TetrahedronFailQuality)
    TetrahedronFailQuality=0.03;
end
fn = fullfile(getuserdir,'Diagnostic-3DMesh');
nnpe = size(e,2);

if nnpe == 5
    warning('checkmesh3d:tetrahedral_mesh','Ignoring last columnn of elements and treating it as a tetrahedral mesh')
    e = e(:,1:4);
    nnpe = 4;
end
if nnpe==3
    if verbose, disp('Checking surface mesh:');end
    if nargin>=3 && ~isempty(nodemap)
        [q,q_area,area,zeroflag,edges,edgeflag]=checkmesh3d_surface(e,p,nodemap);
    else
        [q,q_area,area,zeroflag,edges,edgeflag]=checkmesh3d_surface(e,p);
    end
    vol = area;
elseif nnpe==4
    if verbose, disp('Checking solid mesh:');end
    if nargin>=3 && ~isempty(nodemap)
        [vol,q,zeroflag,badfaces]=checkmesh3d_solid(e,p,1,nodemap);
    else
        [vol,q,zeroflag,badfaces]=checkmesh3d_solid(e,p,1);
    end
end

if nnpe==3
    if edgeflag~=0
        if edgeflag == 1
            status.surface = bitor(status.surface,2);
            if verbose, 
                fprintf('\n Some of mesh edges are shared by more than two triangles!\n');
                fprintf(' This can be caused by a non-manifold mesh or a multi-region one.\n');
                fprintf(' Please check all the diagnostic results stored in SurfaceMesh-InvalidEdges.txt file.\n');
            end
        end
        if edgeflag == 2
            status.surface = bitor(status.surface,4);
            if verbose, 
                fprintf('\n Provided surface is not closed:\n');
                fprintf('  At least one of the edges is only shared by only one triagnle (it should be two, at least)\n');
            end
        end
        if edgeflag ~= 1 && edgeflag ~= 2
            status.surface = bitor(status.surface,6);
            if verbose, fprintf('\n Surface mesh is open AND has edges shared by more than 2 triangles!\n');end
        end
    end
    qcheck=q_area<q_tri_area_threshold;
    a=sum(qcheck);
    if a~=0
        if verbose, fprintf(' There are %d faces with low quality (q<%f).\n', a, q_tri_area_threshold);end
        status.surface = bitor(status.surface,8);
    end
elseif nnpe==4
    if ~isempty(badfaces)
        status.solid = bitor(status.solid,8);
    end
    if any(zeroflag)
        status.solid = bitor(status.solid,2);
        if verbose, fprintf('\n There are %d tetrahedrons with small volume.\n',sum(zeroflag)); end
    end
    qcheck=q<TetrahedronFailQuality;
    a=sum(qcheck);
    if a~=0
        if verbose, fprintf(' There are %d tetrahedrons that have a very low quality (q<%f).\n', a, TetrahedronFailQuality);end
        status.solid = bitor(status.solid,4);
    end
    [foo p]=boundfaces(p,e(:,1:4));
    fprintf('\n----> Checking integrity of the surface of the solid mesh...\n')
    [junk q1 q_area1 status1] = CheckMesh3D(foo,p);
    status.surface = status1.surface;
    fprintf('----> Done.\n\n');
else
    warning('nirfast:meshing:unsupported_nnpe',['CheckMesh3D doesn''t support ' num2str(nnpe) ' nodes per element!'])
end


if isfield(input_flags,'writefiles') && input_flags.writefiles==1
    fprintf('Diagnostic info are being written to %s-*.txt',fn);
    fn1=[fn '-quality-radius.txt'];
    fn2=[fn '-area.txt'];
    fn3=[fn '-edges.txt'];
    fn5=[fn '-volume.txt'];
    os=computer;
    if ~isempty(strfind(os,'PCWIN')) % Windows
        newlinech ='pc';
    elseif ~isempty(strfind(os,'MAC')) ||  ~isempty(strfind(os,'GLNX86')) % Mac OS or Linux
        newlinech ='unix';
    end
    fprintf('\n');
    if ~isempty(q) && nnpe==3
        fprintf(' Avg Quality (radius ratio): %f\n', mean(q));
        fprintf(' Avg Quality (area   ratio): %f\n', mean(q_area));
        dlmwrite(fn1,q,'delimiter',' ','newline',newlinech);
        fn1=[fn '-quality-area.txt'];
        dlmwrite(fn1,q_area,'delimiter',' ','newline',newlinech);
    end
    if nnpe==3 && ~isempty(area)
        fprintf(' Avg Area: %f\n', mean(area));
        dlmwrite(fn2,area,'delimiter',' ','newline',newlinech);
    end
    if nnpe==3 && ~isempty(edges)
        dlmwrite(fn3,edges,'delimiter',' ','newline',newlinech);
    end
    if nnpe==4 && ~isempty(vol)
        [v,idx]=sort(vol);
        dlmwrite(fn5,[idx v],'delimiter',' ','newline',newlinech);
    end
    if nnpe==4 && ~isempty(q)
        dlmwrite([fn 'quality-vol-ratio.txt'],q,'delimiter',' ','newline',newlinech);
    end
end

