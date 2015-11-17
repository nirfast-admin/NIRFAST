function [vol,vol_ratio,zeroflag,badfaces]=checkmesh3d_solid(e,p,type,nodemap)
% If type=0 then it will only check the volume of each tet, otherwise it
% will also check the quality and output some general ifno
global TetrahedronFailQuality TetrahedronZeroVol
if isempty(TetrahedronFailQuality)
    TetrahedronFailQuality=0.03;
end
badfaces = [];

ntet=size(e,1); np=size(p,1);
os=computer;
if ~isempty(strfind(os,'PCWIN')) % Windows
    newlinech ='pc';
elseif ~isempty(strfind(os,'MAC')) ||  ~isempty(strfind(os,'GLNX')) % Mac OS or Linux
    newlinech ='unix';
end


if nargin~=4
    nodenumbers=(1:size(p,1))';
else
    nodenumbers=nodemap;
end

% check to see if all nodes belong to at least one tet.
tf =ismember(nodenumbers,e);
s=sum(~tf);
if s~=0
    fprintf(...
        'checkmesh3d_solid:\n The provided mesh has extra nodes that are not used in the element list\n');
    warning('Meshing:check', ' Not all nodes are used in the element connectivity list');
end

nodes = unique([e(:,1);e(:,2);e(:,3);e(:,4)]);
if nargin==3
    nodemap=nodes;
end
p=p(nodes,:);
[tf1 ren_tet]=ismember(e(:,1:4),nodemap);
e=ren_tet;
sumtf=sum(tf1,2);
bf=sumtf~=4;
if sum(bf)~=0
    tempe=1:ntet;
    disp('checkmesh3d_solid: Some of the tets are using nodes that are not defined in node list!');
    dlmwrite('tets_with_extra_nodes.txt',tempe(bf),'newline',newlinech);
    error('Some of the tets are using nodes that are not defined in node list!');
end


bbx=[min(p(:,1)) min(p(:,2)) min(p(:,3)) ...
    max(p(:,1)) max(p(:,2)) max(p(:,3))];
for i=1:3
    temp(i)=bbx(i+3)-bbx(i);
end
tiny=max(temp)*1e-6;
if isempty(TetrahedronZeroVol)
    TetrahedronZeroVol = tiny;
end

% Getting the min volume and finding all tets that have volumes close to
% the minimum one
vol=signed_tetrahedron_vol(e(:,1:4),p(:,1),p(:,2),p(:,3));
fprintf('Avg Min Max volume: %f %f %f\n',mean(abs(vol)),min(abs(vol)),max(abs(vol)));
zeroflag = abs(vol) <= TetrahedronZeroVol;

% vol_ratio=quality_vol_ratio(ren_tet,p);
vol_ratio=simpqual(p,ren_tet,'Min_Sin_Dihedral');

qualflag=vol_ratio<=TetrahedronFailQuality;
if type~=0
    fprintf('\nAvg Min Max volume ratio quality: %f %f %f\n',...
        mean(vol_ratio), min(vol_ratio), max(vol_ratio));
end
nvoids=sum(qualflag);
en = (1:ntet)';
if nvoids~=0
    voidfn = [tempdir 'voidelements.txt'];
    fprintf(' There are %d elements with undesirable quality.\n', nvoids);
    fprintf(' Check %s.\n',voidfn);
    [tf idx] = ismember(qualflag,true);
    dlmwrite(voidfn,[en(tf) e(qualflag,:)],'delimiter',' ','newline',newlinech);
end

[st2 badtets bfaces] = check_tetrahedron_faces(e);
if st2~=0
    badfaces.faces = bfaces;
    badfaces.tets = badtets;
end

