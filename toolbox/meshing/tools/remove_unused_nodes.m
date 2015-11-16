function [e p] = remove_unused_nodes(e,p)
% Removes the nodes from 'p' that are not being used/referred in 'e'.
% The return 'e' is renumbered based on new list of nodes.

nids = unique(e(:));
[tf e] = ismember(e,nids);

p = p(nids,:);