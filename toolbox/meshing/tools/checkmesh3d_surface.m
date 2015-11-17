function [q_radius_ratio,q_area_ratio,area,zeroflag,...
    edges,edgeflag]=checkmesh3d_surface(e,p,nodemap)
% Checks the integrity of a surface mesh by running following diagnosis:
% 'type' = 
% 0- all
% 1- area of each patch
% 2- face connectivity
% 3- edge connectivity
% 4- quality of each surface patch
e=e(:,1:3);
if nargin~=3
    nodenumbers=(1:size(p,1))';
else
    nodenumbers=nodemap;
end

[tf ee]=ismember(e,nodenumbers);
if sum(sum(~tf))~=0
    error('checkmesh3d_surface:BadSurfaceMesh',...
        'The provided mesh uses node numbers that are not part of the node list!');
end

tf =ismember(nodenumbers,e);
s=sum(~tf);
if s~=0
    fprintf(...
        'checkmesh3d_surface:\n The provided mesh has extra nodes that are not used in the patch element list\n');
    warning('Meshing:check', ' Not all nodes are used in the element connectivity list');
end

% Check edge integrity
[edgeflag, edges] = checkedges(e);

ee=uint32(ee);
% check for small triangle areas
[area,zeroflag]=checkarea(ee,p);

% Calculate two different element quality
q_radius_ratio=quality_triangle_radius(p,ee);
q_area_ratio=quality_triangle_area(p,ee,area);

if sum(zeroflag)>0;
    fprintf('At least one of the patches has a very small area!\n');
    fprintf('Avg Min Max of patch areas: %f %f %f\n\n',mean(area), min(area), max(area));
end



function [area,zeroflag] = checkarea(e,p)
global tiny
zeroflag=false;
if isempty(tiny)
    tiny=1e-6;
end
ne=size(e,1);
area=zeros(ne,1);
area = triangle_area_3d(p(e(:,1),:),p(e(:,2),:),p(e(:,3),:));
zeroflag = IsEqual(area,0,tiny);
if sum(zeroflag)~=0
    zeroflag=true;
else
    zeroflag=false;
end







