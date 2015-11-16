function [edgesize edgelength] = GetAverageEdgeSize(e,p)
% Assuming e and p define a 3D shell surface, this function returns the
% average edge size of the triangular patches.

edges=[e(:,[1 2]); e(:,[1 3]); e(:,[2 3])];
edges = unique(sort(edges,2),'rows');
edgelength=sqrt(sum((p(edges(:,2),:)-p(edges(:,1),:)).^2,2));
edgesize=mean(edgelength);