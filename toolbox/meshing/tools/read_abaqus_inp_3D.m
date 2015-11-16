function [elem, points, surf_elem nnpe] = read_abaqus_inp_3D(mesh_fn)
% Reads abaqus mesh files exported by Mimics V.13
% 
% Written by Hamid Ghadyani, Apr 2010
% The old version which is very slow is now called read_abaqus_inp_line
% 

if(nargin~=1)
    [fname,pname]=uigetfile('*.inp','Please pick the inp file');
else
    pname = [];
	fname=mesh_fn;
end
[fid st]=OpenFile([pname fname],'r');
if st~=0, error(' '); end

flag=false;
% read header junk
while true
    junk = fgetl(fid);
    if ~isempty(regexp(junk,'\<NODE\>', 'once')) % found the node section
        flag=true;
        break;
    end
end
if ~flag
    errordlg('Could not find the node section in inp file!')
    erro('Could not find the node section in inp file!')
end
% read node coordinates
data=textscan(fid,' %u64, %.54f, %.54f, %.54f%*[^\n]');
points = [data{2} data{3} data{4}];


endflag=true;
surf_flag= false;
elem=[];
surf_elem=[];
elset=1;
while endflag
    flag=false;
    % read header junk
    while ~flag && ~feof(fid)
        s = fgetl(fid);
        if ~isempty(regexp(s,'\<ELEMENT\>', 'once')) % found the node section
            flag=true;
            break;
        end
    end
    if ~flag && isempty(elem) && isempty(surf_elem)
        errordlg('Could not find the element section in inp file!')
        error('Could not find the element section in inp file!')
    elseif ~flag
        endflag=false;
        continue
    end
    
    if ~isempty(strfind(s,'TYPE=S3'))
        surf_flag=true;
        pattern = '%u64, %u64, %u64, %u64%*[^\n]'; % surface mesh
        nnpe = 3;
    elseif ~isempty(strfind(s,'TYPE=C3D4'))
        pattern = ' %u64, %u64, %u64, %u64, %u64%*[^\n]'; % solid/tetrahedral mesh
        nnpe = 4;
    elseif ~isempty(strfind(s,'TYPE=C3D8'))
        pattern = '%u64, %u64, %u64, %u64, %u64, %u64, %u64, %u64, %u64%*[^\n]'; % Hexahedral mesh
        nnpe = 8;
    else
        error('read_abaqus_inp_3D: this type of CELL (%s) is not supported.\n',s)
    end

    % read element list
    data=textscan(fid,pattern);
    if ~isempty(strfind(s,'TYPE=S3'))
        surf_elem  = double([data{2} data{3} data{4}]); % surface mesh
    elseif ~isempty(strfind(s,'TYPE=C3D4'))
        elem  = cat(1,elem,double([data{2} data{3} data{4} data{5} ones(size(data{5},1),1)*elset])); % solid/tetrahedral mesh
        elset = elset + 1;
    elseif ~isempty(strfind(s,'TYPE=C3D8'))
        foo = cell2mat(data);
        elem = cat(1,elem,double([foo(:,2:9) ones(size(foo(:,9),1),1)*elset]));
        elset = elset + 1;
    end
end

fclose(fid);
