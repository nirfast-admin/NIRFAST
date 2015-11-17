function [eout p] = remove_unused_nodes(ein,p,nnpe)
% Removes the nodes from 'p' that are not being used/referred in 'e'.
% The return 'e' is renumbered based on new list of nodes.
% Only supports hexahedrons, tetrahedrons and triangles
% ein: elements
% p: coordinates
% nnpe: optional number of node per element value

if nargin < 3 || isempty(nnpe)
    nnpe = size(ein,2);
    if nnpe>=8
        e = ein(:,1:8);
        nnpe = 8;
    elseif nnpe>=4
        e = ein(:,1:4);
        nnpe = 4;
    elseif nnpe>=3
        e = ein(:,1:3);
        nnpe = 3;
    end
else
    e = ein(:,1:nnpe);
end

nids = unique(e(:));
[tf e] = ismember(e,nids);

n = size(p,1);
p = p(nids,:);
eout = [e ein(:,nnpe+1:end)];

if size(p,1)~=n
    fprintf(' Removed %d unused nodes from mesh!\n', n - size(p,1));
end
