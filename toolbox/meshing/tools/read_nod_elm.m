function [e,p,nodemap,elemap,dim,nnpe]=read_nod_elm(infn,tetgenflag)
% [e,p,nodemap,elemap,dim,nnpe]=read_nod_elm(fn,tetgenflag) reads the node/elm list 
% from a file whose format is as follows. fn should not have any extension.
% The format of .nod header is:
% <# of points> <dimension> <# of attributes> <# of boundary markers (0 or 1)>
% # Remaining lines list # of points:
% <point #> <x> <y> <z> [attributes] [boundary marker]
% The format for .elm is:
% <# of elements> <nodes per element> <# of attributes>
% # Remaining lines list of # of elements:
% <elm #> <node> <node> <node> <node> ... [attributes]
% if tetgenflag is supplied, then the extension .ele and .node will be
% used.
% this function also returns the nodemap and elemap arrays which can be
% used for files in which node/element numbers don't start from 1.

e=[];p=[];dim=[];nnpe=[];nodemap=[];elemap=[];

[path foo ext]=fileparts(infn);

if isempty(ext) || length(ext) == 1 ...
        || strcmp(ext,'.node') || strcmp(ext,'.ele')
    fn = foo;
else
    fn = [foo ext];
end

ext1='.node';
ext2='.ele';

% first read the node file
tempfn=add_extension(fn,ext1);
fid = fopen(fullfile(path,tempfn),'rt');

if nargin < 2 || isempty(tetgenflag) || tetgenflag == 1
    format = 1;
else
    format = tetgenflag;
end
if format == 1 % tetgen format
% read the header line:
    header=textscan(fid,'%u32 %d8 %d8 %d8',1);
    nn=header{1}; dim=header{2}; natt=header{3}; bdymark=header{4};
    if dim==3
        data = textscan(fid,'%u32 %f %f %f%*[^\n]','bufsize',409500);
        p=[data{2} data{3} data{4}];
    elseif dim==2
        data = textscan(fid,'%u32 %f %f%*[^\n]');
        p=[data{2} data{3}];
    end
    nodemap=data{1};
    if size(p,1)~=nn
        error('The input .node file is corrupt. Check the header or the last section of .node file.');
    end
elseif format==2 % .nod, .elm format
    header = textscan(fid,'%d8 %u32',1);
    nn=header{2}; numflag=header{1};
    if numflag~=0
        data=textscan(fid,'%u32 %f %f %f%*[^\n]',1);
        if isnan(data{4}) % 2D
            dim=2;
            p(1,:)=[data{2} data{3}];
            nodemap(1,:)=data{1};
            data=textscan(fid,'%u32 %f %f%*[^\n]');
            p=cat(1,p,[data{2} data{3}]);
            nodemap=cat(1,nodemap,data{1});
        else % 3D
            dim=3;
            p(1,:)=[data{2} data{3} data{4}];
            nodemap(1,:)=data{1};
            data=textscan(fid,'%u32 %f %f %f%*[^\n]');
            p=cat(1,p,[data{2} data{3} data{4}]);
            nodemap=cat(1,nodemap,data{1});
        end
    else
        data=textscan(fid,'%f %f %f%*[^\n]',1);
        if isnan(data{3}) % 2D
            dim=2;
            p(1,:)=[data{1} data{2}];
            data=textscan(fid,'%f %f%*[^\n]');
            p=cat(1,p,[data{1} data{2}]);
        else % 3D
            dim=3;
            p(1,:)=[data{1} data{2} data{3}];
            data=textscan(fid,'%f %f %f%*[^\n]');
            p=cat(1,p,[data{1} data{2} data{3}]);
        end
        nodemap=(1:nn)';
    end
    if size(p,1)~=nn
        error('The input .nod file is corrupt. Check the header or the last section of .nod file.');
    end
end
fclose(fid);

% Now read the element file
tempfn=add_extension(fn,ext2);
fid = fopen(fullfile(path,tempfn),'rt');

if format==1
    header=textscan(fid,'%u32 %d8 %d8',1);
    ne=header{1}; nnpe=header{2}; natt=header{3};
    format='%u32 ';
    for ii=1:(nnpe+natt)
        format=[format '%u32'];
    end
    format=[format '%*[^\n]'];
    data=textscan(fid,format);
    e=[data{2:end}];
    elemap=data{1};
elseif format==2
    header=textscan(fid,'%d8 %d8 %d8 %u32',1);
    if size(header,2)~=4, error(['Corrupt header line in ' tempfn]), end
    numflag=header{1}; nnpe=header{2}; nmat=header{3}; ne=header{4};
    if numflag~=0
        format='%u32 ';
    else
        format='';
    end
    for ii=1:(nnpe+nmat)
        format=[format '%u32'];
    end
    format=[format '%*[^\n]'];
    data=textscan(fid,format);
    e=[data{2:end}];
    MyAssert(size(e,1)==ne);
    if numflag~=0
        elemap=data{1};
    else
        elemap=(1:ne)';
    end
end
fclose(fid);

if size(e,1)~=ne
        error('The input .ele file is corrupt. Check the header of .ele file!');
end



