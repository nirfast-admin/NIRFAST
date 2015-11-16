function writenodelm_mesh_medit(infn,elm,p,nodemap,nnpe)
% writenodelm_mesh_medit(fn,tet,p)
% Writes a tetrahedral mesh defined in 'tet' and 'p' to a file called 'fn'
% in medit format (.mesh) so it can be viewed using medit.
% Note that this routine renumbers the node numbers from 1 to N and accordingly
% adjust the node numbers in mesh list.

if isempty(infn), error('Filename should be specified'), end

np=size(p,1); dim=size(p,2);
nelm=size(elm,1);
if dim<3
    error('Input points are not 3D');
end

k = size(elm,2);
if nargin < 5 || isempty(nnpe) || nnpe == 0
    if k >= 8
        nnpe = 8;
    elseif k>=4
        nnpe = 4;
    elseif k>=3
        nnpe = 3;
    else
        error('writenodelm_mesh_medit: input element type not supported. (only tri/tet/hex)')
    end
end

if k - nnpe > 0
    mmflag = 1;
    eID = elm(:,nnpe+1);
else
    mmflag = 0;
    eID = ones(nelm,1);
end

if size(p,2) > 3
    nsol = p(:,4:end);
end


fprintf('%s','Writing data to file... ')

if nargin < 4 || isempty(nodemap)
    nn=(1:np)';
else
    if size(nodemap,1)==1
        nn=nodemap';
    elseif size(nodemap,2)==1
        nn=nodemap;
    elseif size(nodemap,2)~=1
        error('The nodemap list provided should be an n by 1 vector');
    end
end
[mytflag newelm]=ismember(elm(:,1:nnpe),nn);
sum1=sum(mytflag,2);
sumbflag = sum1==nnpe;
if sum(sumbflag)~=nelm % not all vertices of 'faces' are given in nodemap list!
    disp(' ');
    disp('writenodelm_surface_medit: Not all vertices of the input mesh could be found in given nodemap list!')
    error('writenodelm_surface_medit: mesh and nodemap lists are not compatible!')
end

newelm = [newelm eID];

fn = add_extension(infn,'.mesh');
try
    fid=fopen(fn,'wt');
    fprintf(fid,'MeshVersionFormatted 1\n');
catch err
    cprintf('Error',' Can''t open the file: %s\n',fn);
    disp(err)
    rethrow(err)
end
fprintf(fid,'Dimension\n3\nVertices\n%u\n',np);


fprintf(fid,'%.12f %.12f %.12f %d\n',[p(:,1:3) ones(np,1)]');

if nnpe == 4
    ekeyword = 'Tetrahedra';
elseif nnpe == 8
    ekeyword = 'Hexahedra';
elseif nnpe == 3
    ekeyword = 'Triangles';
end
fprintf(fid,'%s\n%u\n',ekeyword,nelm);

sf = repmat('%d ',1,nnpe);
sf = [sf '%d\n'];

fprintf(fid,sf,newelm');

fprintf(fid,'End\n');
fclose(fid);

type = 0;
if size(p,2) > 3
    type = 2;
    sol = nsol;
elseif mmflag
    type = 1;
    sol = elm(:,(nnpe+1):end);
end
if type
    write_medit_sol_file(infn,sol,type);
end

[mypath myfn myext]=fileparts(fn);
fprintf('\b\b%s\n','Done writing mesh to:');
if ~isempty(mypath)
    fprintf('\t%s\n',['Path: ' mypath])
end
fprintf('\t%s\n',['Filename: ' myfn myext]);
if type
    fprintf('\t%s\n',['Solution: ' infn '.bb']);
end

