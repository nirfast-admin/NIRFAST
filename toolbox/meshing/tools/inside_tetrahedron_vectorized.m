function st = inside_tetrahedron_vectorized(P,tets, nodes)
% 
% st = inside_tetrahedron_vectorized(P,tets, nodes)
%
% This is vectorized vertion of 'inside_tetrahedron'
%
% Inputs:
%   P: Query point
%   tets: tetrahedron connectivity (n x 4)
%   nodes: coordinates of tets (m x 3)
% st:
%   rows of 'st' are 1 (true) if P is inside tetrahedron defined in the
%   corresponding rows of 'tets'
% 
% Note that it is assumed that tetrahedra defined by 'tets' are not
% overlapping, i.e., each point in 'P' can only be in either one or zero
% tetrahedron
% 
% Written by Hamid Ghaydani, 2012, Dartmouth College
% 

if sum(size(P)) ~= 4 && (size(P,1) == 3 || size(P,2) == 3)
    error('nirfast:intetrahedron','\n Query node can only be a single 3D point');
end

nn = size(nodes,1);
bsn = ones(size(tets,1),1) * (nn+1);
nodes(end+1,:) = P;

V0 = abs(signed_tetrahedron_vol(tets, nodes(:,1), nodes(:,2), nodes(:,3)));
totv = ...
    abs(signed_tetrahedron_vol([bsn tets(:,2) tets(:,3) tets(:,4)],...
    nodes(:,1), nodes(:,2), nodes(:,3))) + ...
    abs(signed_tetrahedron_vol([tets(:,1) bsn tets(:,3) tets(:,4)],...
    nodes(:,1), nodes(:,2), nodes(:,3))) + ...
    abs(signed_tetrahedron_vol([tets(:,1) tets(:,2) bsn tets(:,4)],...
    nodes(:,1), nodes(:,2), nodes(:,3))) + ...
    abs(signed_tetrahedron_vol([tets(:,1) tets(:,2) tets(:,3) bsn],...
    nodes(:,1), nodes(:,2), nodes(:,3)));
st = (totv - V0) ./ V0 < 1e-6;
