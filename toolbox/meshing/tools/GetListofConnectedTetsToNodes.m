function [list, badnodes]=GetListofConnectedTetsToNodes(t,p,verbose)
% list=GetListofConnectedTetsToNodes(t,p)
% This function assumes that the mesh in 't' is a valid mesh and has been
% checked by our diagnostic tool CheckMesh3D. It then returns a cell array
% whose members are list of elements attached to each node.
% It also returns list of badnodes which are not associated with any tet
%
% Written by Hamid Ghadyani, 2005, Worcester Polytechnic Institute
% Updated 2012
%

if size(t,2)<4 || size(p,2)<3
    fprintf('GetListofConnectedTetsToNodes can only handle tetrahedral meshes.\n');
    list={};
    return
end
if nargin < 3 || isempty(verbose)
    verbose = 0;
end

if verbose, fprintf('Populating list of connected tets to each node...\n'); end
nn   = size(p,1);
ne   = size(t,1);
list = zeros(nn,60);
idx = ones(nn,1);
for i=1:ne
    n=t(i,:);
    list(n(1), idx(n(1))) = i;
    list(n(2), idx(n(2))) = i;
    list(n(3), idx(n(3))) = i;
    list(n(4), idx(n(4))) = i;
    idx(n) = idx(n) + 1;
    
%     list{n(1)}(idx(n(1))) = i; idx(n(1)) = idx(n(1)) + 1;
%     list{n(2)}(idx(n(2))) = i; idx(n(2)) = idx(n(2)) + 1;
%     list{n(3)}(idx(n(3))) = i; idx(n(3)) = idx(n(3)) + 1;
%     list{n(4)}(idx(n(4))) = i; idx(n(4)) = idx(n(4)) + 1;
end
if verbose, fprintf('Checking the integrity of list of connected tets to each node...\n'); end
badnodes=[]; counter=0;
for i=1:nn
    if list(i,1) == 0
        counter=counter+1;
        badnodes(counter)=i;
    end
end
if verbose, fprintf(' Done.\n\n'); end
if ~isempty(badnodes)
    fprintf(' GetListofConnectedTetsToNodes:\n  There are %d nodes that have no tets attached to them!\n\n', counter);
end
