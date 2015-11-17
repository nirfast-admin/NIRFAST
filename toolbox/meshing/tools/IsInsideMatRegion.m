function st = IsInsideMatRegion(inode,regionID,inele,node)
% Checks if points in 'inode' are inside sub-surfaces that are tagged as
% 'regionID'
% Inputs:
% ele : ns x 5 matrix, list of triangles along with two region id's that are
% being separated by the surface:
%       n1 n2 n3 m1 m2
% node : np x 3, coordinats of nodes of the surface
% 
% Output:
% st : ninode x 1, an array for status of nodes defined in 'inode', 1 for
% inside 0 for outside and 3 for unsucessful test


st = zeros(size(inode,1),1,'int8');
% Make sure nodes in 'ele' are numbered from 1 to N
ele=inele(:,1:3);
nodes=unique(ele(:));
pp=node(nodes,:);
[tf ee]=ismember(ele,nodes);

% Get the BBX of each triangular facet
facets_bbx = GetFacetsBBX(ee,pp);

for i=[200,400]
    clear mex
    [all_ok st1 intpnts intersected_facets] = ...
        get_ray_shell_intersections(inode,pp,double(ee),1e-12,facets_bbx,min(pp(:,1)),max(pp(:,1)),i);
    if all_ok
        break;
    end
end

if ~all_ok
    error('get_ray_shell_intersections can not propery perform containment tests!');
end

for i=1:size(inode,1)
    if st1(i)==1
        c=0;
        for j=1:length(intersected_facets{i})
            mats = inele(intersected_facets{i}(j),4:5);
            if ismember(regionID,mats)
                c=c+1;
            end
        end
        if mod(c,2)==1
            st(i)=1;
        end
    end
end