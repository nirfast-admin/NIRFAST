function [output extra_edges]=TailToHead(orig_edges,projected_nodes_coords,...
                              projected_nodes,aa,bb,cc,dd,EdgeOrder)
% [output extra_edges]=TailToHead(orig_edges,projected_nodes_coords,...
%                               projected_nodes,aa,bb,cc,dd,EdgeOrder)
% Orders edges in orig_edges such that:
% n1 n2
% n2 n3
% n3 n4
% ....
% if EdgeOrder is specified, it will take it and use it as its first
% element so the rest of edges follow it.
% extra_edges is edges that were not used in order to close one loop
% This routine will assume that all the active edges are either on a
% principal plane or projected to a plane (aa*x+bb*y+cc*z+dd=0).
global tiny
if isempty(tiny), tiny=1e-7; end
ne=size(orig_edges,1);
mark=zeros(ne,1);

if isempty(orig_edges)
    output=[]; extra_edges=[];
    return
end
output=zeros(size(orig_edges));

n=[aa bb cc];
if nargin==8 && ~isempty(EdgeOrder)
    startingElement=EdgeOrder(1:2);
    [tflag idx1]=ismember([EdgeOrder(1) EdgeOrder(2)],orig_edges(:,1:2),'rows');
    if tflag
        mark(idx1)=1;
    else
        [tflag idx1]=ismember([EdgeOrder(2) EdgeOrder(1)],orig_edges(:,1:2),'rows');
        if ~tflag
            error('EdgeOrder provided does not exist in orig_edges list');
        end
        mark(idx1)=1;
    end
elseif nargin==7
    startingElement=orig_edges(1,:);
    mark(1)=1;
else
    error('Not enough arguments provided for TailToHead!');
end


startNode=startingElement(1);
N1=startNode;
N2=startingElement(2);
output(1,:)=startingElement;
counter=2;
while startNode~=N2
    if counter>ne
        error('TailToHead: Number of edges detected are more than what you provide!');
    end
    [tflag idx next_node]=find_connecting_edge(N2,orig_edges,N1);
    MyAssert(tflag,'TailToHead: The provided edge list is corrupted!');
    if length(idx)==1 % Only 1 edge is connected to the current one
        output(counter,1)=N2;
        output(counter,2)=next_node;
        output(counter,3:end) = orig_edges(idx,3:end);
        N1=N2;
        N2=next_node;
        counter=counter+1;
        MyAssert(mark(idx)~=1,'TailToHead: Provided list might have duplicate edges!');
        mark(idx)=1;
    else  %  More than one edge is connected to the current one, use the
          %  provided plane to decide which is the next node that can close
          %  the current loop
        output(counter,1)=N2;
        [next edge_idx]=GetTheLeftMostNode(N1,N2,idx,next_node,projected_nodes,projected_nodes_coords,n);
        output(counter,2)=next;
        output(counter,3:end) = orig_edges(edge_idx,3:end);
        N1=N2;
        N2=next;
        counter=counter+1;
        MyAssert(mark(edge_idx)~=1,'TailToHead: Provided list might have duplicate edges!');
        mark(edge_idx)=1;
    end
end
% MyAssert(sum(mark)==ne,'TailToHead: Not all edges were used in order to close the tail to head loop');
if sum(mark)~=ne
    extra_edges=orig_edges(~mark,:);
else
    extra_edges=[];
end
output=output(1:counter-1,:);


function [next edge_idx]=GetTheLeftMostNode(N1,N2,idx,next_node,projected_nodes,projected_nodes_coords,n)
% Returns the next left most node that is connect to edge 'N1-N2'. This
% routine assumes that all the attached edges to N2 lie in a plane whose
% normal is defined in n. next_node is the list of all nodes that are
% attached to N2. project_nodes is the list of node numbers in the master
% edge list out of which we are trying to extract closed loops.
% It returns the next node and the index of the edge that form 'N2-next'
% edges in the master edge list
global tiny
if isempty(tiny), tiny=1e-7;end
nce=length(idx);
[tflag idx1]=ismember(N1,projected_nodes); MyAssert(tflag);
[tflag idx2]=ismember(N2,projected_nodes); MyAssert(tflag);
v1=projected_nodes_coords(idx2,:)-projected_nodes_coords(idx1,:);
normv1=norm(v1);
% cross_signs=zeros(nce,2); % First column keeps the sign, second one keeps the magnitude of the cross product
left_flag=false; zero_flag=false;
max_angle=0; min_angle=pi+eps;
for i=1:nce
    [tflag idx3]=ismember(next_node(i),projected_nodes);
    v2=projected_nodes_coords(idx3,:)-projected_nodes_coords(idx2,:);
    v1Xv2=cross(v1,v2);
    mysign=sign(dot(v1Xv2,n));
    mynorm=norm(v1Xv2);
    if IsEqual(mysign,0,tiny) && ~left_flag
        MyAssert(~zero_flag);
        next=next_node(i);
        zero_flag=true;
        edge_idx=idx(i);
    elseif mysign>0
        myangle=asin(mynorm/(normv1*norm(v2)));
        if myangle>max_angle
            max_angle=myangle;
            next=next_node(i);
            left_flag=true;
            edge_idx=idx(i);
        end
    elseif mysign<0 && ~left_flag && ~zero_flag
        myangle=asin(mynorm/(normv1*norm(v2)));
        if myangle<min_angle
            min_angle=myangle;
            next=next_node(i);
            edge_idx=idx(i);
        end
    end
end





function [tflag idx next_node]=find_connecting_edge(N2,orig_edges,N1)
% Searches orig_edges and finds the other edges sharing N2 and returns the
% edge index
tflag=false; idx = []; next_node = [];
counter=1;
for i=1:size(orig_edges,1)
    if (orig_edges(i,1)==N2 && orig_edges(i,2)~=N1) || ...
       (orig_edges(i,2)==N2 && orig_edges(i,1)~=N1)
        tflag=true;
        idx(counter)=i;
        if orig_edges(i,1)==N2
            next_node(counter)=orig_edges(i,2);
        else
            next_node(counter)=orig_edges(i,1);
        end
        counter=counter+1;
    end
end












