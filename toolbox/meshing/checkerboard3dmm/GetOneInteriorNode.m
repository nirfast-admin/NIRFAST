function pin = GetOneInteriorNode(t,p)
% Asssuming a closed manifold surface is defined in 't' and 'p'
% this routine returns coordinates of a point within the surface.
% It assumes the surface is oriented and the normals of the triangles are
% pointing outward.

pin = [];

bbx1=max(p);
bbx2=min(p);
ld=min(bbx1-bbx2);

tiny = eps;
offset = tiny*100 * ld;

if offset < eps
    pin=[];
    return
end

% Make sure nodes in 't' are numbered from 1 to N
nodes=unique(t(:));
pp=p(nodes,:);
[tf ee]=ismember(t,nodes);

% Check the subvolume's integrity
input_args.verbose=0;
input_args.type=1;
[junk,junk,junk,myst] = CheckMesh3D(ee,pp,[],input_args);

if isfield(myst,'surface') % && myst.b~=0 && myst.b~=4
%     writenodelm_surface_medit('foo.mesh',ee,pp)
%     system('/usr/local/bin/medit foo.mesh')
%     disp(' ')
    st_ = myst.surface;
    if bitand(st_,2) || bitand(st_,4)
        fprintf('Warning (GetOneInteriorNode.m):\n   The given surface is not closed, single material or manifold!\n');
    end
end

facets_bbx = GetFacetsBBX(ee,pp);

v1=pp(ee(:,2),1:3)-pp(ee(:,1),1:3);
v2=pp(ee(:,3),1:3)-pp(ee(:,2),1:3);
v3=pp(ee(:,3),1:3)-pp(ee(:,1),1:3);
normal = cross(v1,v2);
norm_len = sqrt(sum(normal.^2,2));
normal = -normal ./ repmat(norm_len,1,3);
cent = (pp(ee(:,1),:)+pp(ee(:,2),:)+pp(ee(:,3),:))/3;
offset = min([sqrt(sum(v1.^2,2)) sqrt(sum(v2.^2,2)) sqrt(sum(v3.^2,2))],[],2);
offsetp = cent + 0.01 * repmat(offset,1,3) .* normal;

for i=1:size(offsetp,1)
    st = involume_mex(offsetp(i,1:3), double(ee), pp, 200, facets_bbx, min(pp(:,1)), max(pp(:,1)), tiny);
    if st == 1
        pin = offsetp(i,:);
        return
    end
end

    




