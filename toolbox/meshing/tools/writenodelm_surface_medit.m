function writenodelm_surface_medit(fn,faces,p,nodemap,verbose)
% writenodelm_surface_medit(fn,faces,p,nodemap)
% Writes a shell surface defined in 'faces' and 'p' to a file called 'fn'
% in medit format (.mesh) so it can be viewed using medit.
% Note that this routine renumbers the node numbers from 1 to N and accordingly
% adjust the node numbers in face list.

if nargin<5
    verbose=1;
end

if verbose
    fprintf('%s','Writing data to file... ')
end

ref=0;
face_att=1;
np=size(p,1); dim=size(p,2);
nf=size(faces,1);
nnpe = size(faces,2);
if dim~=3
    error('Input points are not 3D');
end
if isempty(fn), error('Filename should be specified'), end
os=computer;
if ~isempty(strfind(os,'PCWIN')) % Windows
    newlinech ='pc';
elseif ~isempty(strfind(os,'MAC')) ||  ~isempty(strfind(os,'GLNX86')) % Mac OS or Linux
    newlinech ='unix';
end
fn = add_extension(fn,'.mesh');
    
fid=fopen(fn,'wt');
fprintf(fid,'MeshVersionFormatted 1\r');
fprintf(fid,'Dimension\n3\nVertices\n%u\r',np);

if nargin == 3 || isempty(nodemap)
    nn = (1:np)';
elseif size(nodemap,1)==1
    nn=nodemap';
elseif size(nodemap,2)==1
    nn=nodemap;
elseif size(nodemap,2)~=1
    error('The nodemap list provided should be an n by 1 vector');
end
[mytflag newfaces]=ismember(faces,nn);
sum1=sum(mytflag,2);
sumbflag = sum1==nnpe;
if sum(sumbflag)~=nf % not all vertices of 'faces' are given in nodemap list!
    fprintf('\nwritenodelm_surface_medit: Not all vertices of the input face could be found in given nodemap list!')
    error('writenodelm_surface_medit: faces and nodemap lists are not compatible!')
end

fprintf(fid,'%.10f %.10f %.10f %d\n',[p(:,1:3) ones(size(p,1),1)*ref]');
if nnpe == 3
    fprintf(fid,'Triangles\n%u\n',nf);
elseif nnpe == 4
    fprintf(fid,'Quadrilaterals\n%u\n',nf);
else
    error(' this type of element is not supported');
end
sf = repmat('%d ',1,nnpe); 
fprintf(fid,[sf '%d\n'],[newfaces ones(nf,1)*face_att]');
fprintf(fid,'End\n');
fclose(fid);


[mypath myfn myext]=fileparts(fn);
if verbose
    fprintf('\b%s\n','Done writing surface mesh to:')
    if ~isempty(mypath)
        fprintf('\t%s\n',['Path: ' mypath])
    end
    fprintf('\t%s\n',['Filename: ' myfn myext])
end
