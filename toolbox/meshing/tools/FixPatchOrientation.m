function [tc,nodes,status]=FixPatchOrientation(p,sfaces,meshnodemap,silentflag)
% [tc,nodes,status]=FixPatchOrientation(p,sfaces,meshnodemap)
% Assuming the 3D shell defined by p and sfaces is a closed one, this
% routine will make sure that all the facets are pointing outward.

status=0;
if nargin<=3 || silentflag==0
    fprintf('%s\n','===========================================')
    fprintf('%s\n','Entered FixPatchOrientation() function')
end

nodes=[sfaces(:,1);sfaces(:,2);sfaces(:,3)];
nodes=unique(nodes);
if nargin==2 || (nargin>=3 && isempty(meshnodemap))
    ren_nodes=nodes;
elseif nargin>=3 && ~isempty(meshnodemap)
    [tflag1 ren_nodes]=ismember(nodes,meshnodemap);
    MyAssert(sum(tflag1)==size(nodes,1),'Error in meshnodemap!');
end
pp=p(ren_nodes,:);
[tf ee]=ismember(sfaces,nodes);

ee=double(ee);
clear mex
list=GetListOfConnTri2Tri_mex(ee,pp); 
clear mex
[status tc1]=orient_surface_mex(ee,pp,list);
if status~=0
    warning('nirfast:MeshingWarning','Could not orient the given surface. Error Code: %d\n', status);
    tc=sfaces;
    return
else
    tc=nodes(tc1);
    new_nodes=unique([tc(:,1);tc(:,2);tc(:,3)]);
    MyAssert(length(new_nodes)==length(nodes),sprintf(' FixPatchOrientation has altered the number of input points.\n Probably your input surface had a dangling triangle/edge/node!'))
    if nargin<=3 || silentflag==0
        fprintf('%s\n','Exitting FixPatchOrientation() function.')
        fprintf('%s\n','===========================================')
    end
end

