function writenodelm_nod_elm(fn,e,p,nodemap,no_of_att,quiet)
% writenodelm_nod_elm(fn,e,p,nodemap,no_of_att)
% writes nodes and elements to two seperate files with .node and .ele
% extension. the format of the files is as follows.
% User should not provide any extension in fn.
% The format of .nod header is:
% <# of points> <dimension> <# of attributes> <# of boundary markers (0 or 1)>
% # Remaining lines list # of points:
% <point #> <x> <y> <z> [attributes] [boundary marker]
% The format for .elm is:
% <# of elements> <nodes per element> <# of attributes>
% # Remaining lines list of # of elements:
% <elm #> <node> <node> <node> <node> ... [attributes]
% 
% fn: file name
% e: element list (which will include attributes if needed
% P: coordinate list
% nodemap: node map for renumbering
% natt: number of attributes that each element might have. If natt~=0 but
% nodemap is empty just use [] instead of nodemap to call this function
if nargin<6 || isempty(quiet)
    quiet=0;
end
if ~quiet
    fprintf('%s','Writing data to file... ')
end
dim=size(p,2);
if dim~=2 && dim~=3
    disp('Only 2D or 3D meshes are supported!');
    return
end
nn=size(p,1);
ne=size(e,1);

if nargin>=4
    if nargin==4
        natt=0; 
    else
        if ~isempty(no_of_att)
            natt=no_of_att;
        else
            natt=0;
        end
    end
    if isempty(nodemap)
        nodenum=(1:nn)';
    end
    if size(nodemap,1)==1
        nodenum=nodemap';
    elseif size(nodemap,2)==1
        nodenum=nodemap;
    elseif size(nodemap,2)~=1 && ~isempty(nodemap)
        error('The nodemap list provided should be an n by 1 vector');
    end
    nnpe=size(e,2)-natt;
    if nnpe~=2 && nnpe~=3 && nnpe~=4
        error([nnpe ' per element is not supported!']);
    end
    mytflag=ismember(e(:,1:nnpe),nodenum);
    sum1=sum(mytflag,2);
    sumbflag=sum1==nnpe;
    if sum(sumbflag)~=ne % not all vertices of 'faces' are given in nodemap list!
        disp(' ');
        disp('writenodelm_nod_elm: Not all vertices of the input faces/tets could be found in given nodemap list!')
        error('writenodelm_nod_elm: faces/tetrahedrons and nodemap lists are not compatible!')
    end
    newelm=e;
elseif nargin==3
    nodenum=(1:nn)';
    newelm=e;
    natt=0;
    nnpe=size(e,2)-natt;
    if nnpe~=2 && nnpe~=3 && nnpe~=4
        error([nnpe ' per element is not supported!']);
    end
else
    error('At least 4 input arguments are required');
end

fn = remove_extension(fn);

f=add_extension(fn,'.node');
fid = OpenFile(f,'wt');
fprintf(fid,'%d %d 0 0\n',nn,dim);
if dim==2
    fs='%d %.32f %.32f\n';
else
    fs='%d %.32f %.32f %.32f\n';
end
fprintf(fid,fs,[nodenum p]');
fclose(fid);

f=add_extension(fn,'.ele');
fid = OpenFile(f,'wt');
if nnpe==3
    fs='%d %d %d %d';
elseif nnpe==4
    fs='%d %d %d %d %d';
elseif nnpe==2
    fs='%d %d %d';
end

for i=1:natt
    fs=[fs ' %d'];
end
fs=[fs '\n'];
fprintf(fid,'%d %d %d\n',ne,nnpe,natt);
fprintf(fid,fs,[(1:ne)' newelm(:,1:(nnpe+natt))]');
fclose(fid);

if ~quiet
    [mypath myfn myext]=fileparts(fn);
    fprintf('\b%s\n','Done writing mesh to:')
    if ~isempty(mypath)
        fprintf('\t%s\n',['Path: ' mypath])
    end
    fprintf('\t%s\n',['Filename: ' myfn '.node/.ele'])
end


