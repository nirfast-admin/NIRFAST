%%
nodes=unique(reg_ele(:));
myp=tnode(nodes,:);
[bf mye]=ismember(reg_ele,nodes);
writenodelm_surface_medit('tmp1.mesh',mye(:,1:3),myp(:,1:3))
% CheckMesh3D(1,mye,myp)