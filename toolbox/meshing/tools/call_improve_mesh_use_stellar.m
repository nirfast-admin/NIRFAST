function [ele node new_elem_region new_node_region] = ...
    call_improve_mesh_use_stellar(e, p)
% Check if mesh has region information
if size(e,2) > 4
    region_ids = unique(e(:,5));
elseif size(e,2) == 4
    region_ids = 1;
    e(:,5) = ones(size(e,1),1);
else
    error('Mesh needs to be tetrahedral.');
end
if min(region_ids)==0, region_ids=region_ids+1; end

% Assign region info to each node
oldr = zeros(size(p,1),1);
for i=1:length(region_ids)
    relem = e(e(:,5)==region_ids(i),:);
    rnodes = unique([relem(:,1);relem(:,2);relem(:,3);relem(:,4)]);
    oldr(rnodes) = region_ids(i);
end
% Improve the mesh
config.qualmeasure = 0;
[ele node] = improve_mesh_use_stellar(e(:,1:4), p, config);

% Since we get a totally new mesh, we need to
% reassign region propertyies for nodes.
% Find the closest nodes (from old set 'p') to new set of nodes
% Meshes can be huge so we only need to examine nodes within a bounding box
% of the current node being examined.
new_node_region = zeros(size(node,1),1,'int8');
edge_avg = GetEdgeSize(e, p, 4);
% mesh_bbx = max(p(:,1:3)) - min(p(:,1:3));
% diag_len = norm(mesh_bbx);
delta = edge_avg * 2.0;
for i=1:size(node,1)
    bf = abs(node(i,1) - p(:,1)) < delta & ...
        abs(node(i,2) - p(:,2)) < delta & ...
        abs(node(i,3) - p(:,3)) < delta;
    dist = dist2(node(i,:), p(bf,:));
    origr = oldr(bf,:);
    [foo idx] = sort(dist, 'ascend');
    new_node_region(i) = origr(idx(1));
end

% Sort region IDs based on number of nodes they are assigned to
sumr = zeros(1,length(region_ids));
new_elem_region = zeros(size(ele,1),1,'int8');
for i=1:length(region_ids)
    sumr(i) = sum(new_node_region==region_ids(i));
end
[foo idx] = sort(sumr,'ascend');
region_ids = region_ids(idx);
% Assign each element a region ID based on how many nodes of each element
% have been associated with that region ID
for i=1:4 % nnpe
    for j=1:length(region_ids)
        tf1 = ismember(new_node_region(ele(:,1:4)),region_ids(j));
        nc = sum(tf1,2);
        new_elem_region(nc == i) = region_ids(j);
    end
end