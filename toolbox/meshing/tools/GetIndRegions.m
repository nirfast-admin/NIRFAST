function ind_regions = GetIndRegions(ele,p)
% Assuming all the elements in ele are sharing one material ID (i.e. they
% all belong to a certain region/material) and 'ele' defines only manifold
% surfaces, this routine returns individual
% closed surfaces/loops that constitute the entire 'ele'
% This routine assumes that there are no void/holes in any region, thus if
% 'ele' contains a hole this routine will return two sets of elements one
% defining the exterior of surface and the other defining the boundary of
% the hole within 'ele'
% 
% Input:
% ele : connectivity list of triangles
% nodes : list of vertices
% 
% Output:
% a cell whose entities are list of indeces into 'ele':
% ind_regions{1} == first set of elements in 'ele' that form a closed
%                   surface
% ind_regions{2} == second set elements in 'ele' that form a closed
%                   surface
% and so on...

% Make sure nodes in 't' are numbered from 1 to N
nodes=unique(ele(:));
pp=p(nodes,:);
[tf ee]=ismember(ele,nodes);

foo=double(ee(:,1:3));
% Get tri2tri graph
clear mex
list = GetListOfConnTri2Tri_mex(foo, pp);

% Extract the regions
clear mex
ind_regions = extract_ind_regions_mex(foo, list);

% Check to see if each region has at least 4 surfaces (a tetrahedron)
for i=1:size(ind_regions,1)
    if length(ind_regions{i})<4
        fprintf(' Found a surface with less than 4 triangles!\n');
        error('Aborting');
    end
    % Renumber the nodes in 'ind_regions' back to the way they were before
    % in 'ele'
end



