function [edge_avg edgesizes] = GetEdgeSize(e, p, nnpe, average_only)
% Assuming e and p define a 3D shell surface, or tetrahedral mesh,
% this function returns the list of all edge lengths or their average
% By default this routine returns the average of edges only
edgesizes = [];
if nargin < 4 || isempty(average_only)
    average_only = 1;
end
if nargin < 3
    nnpe = size(e,2);
end
if nargin < 2
    error(' Usage: [edge_avg] = GetEdgeSize(e,p,nnpe);');
end

if nnpe == 3
    edges=[e(:,[1 2]); e(:,[1 3]); e(:,[2 3])];
elseif nnpe == 4
    edges=[e(:,[1 2]); e(:,[1 3]); e(:,[1 4]);
        e(:,[2 3]); e(:,[2 4]); e(:,[3 4]);];
else
    error(' Only accepts triangular or tetrahedral meshes!');
end

edges = unique(sort(edges,2),'rows');
if average_only
    edge_avg=mean(sqrt(sum((p(edges(:,2),:)-p(edges(:,1),:)).^2,2)));
else
    edgesizes=sqrt(sum((p(edges(:,2),:)-p(edges(:,1),:)).^2,2));
    edge_avg=mean(edgesizes);
end
