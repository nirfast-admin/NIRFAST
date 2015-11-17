function [P]=ExpandBoundaryBufferZone(t,p,P,shell_normals,density,DELTA,llc)
% Expands each triangular facet of the boundary by a factor (depending on
% local mesh density) and then extrudes a prism out of the expanded
% triangle. Then checks for all the pixels that are within this prism and
% tags them as buffer pixels. This way we can make sure that there is no
% 'hole' in the boundary buffer.
global tiny NA boundary_node_code 
if isempty(tiny), tiny=1e-9; end

fprintf('%s\n','===========================================')

% Mesh template properties
[nrow ncol npln]=size(P);
dx=DELTA(1); dy=DELTA(2); dz=DELTA(3);
xmin=llc(1); ymin=llc(2); zmin=llc(3);

nf = size(t,1);
sqroot2=sqrt(2)/1.4;
bethafactor=sqroot2;

tmp=load('prism_topology');
prism=tmp.prism;
clear tmp;
fprintf('\tCalculating desired length at boundary nodes...')
tp1=p(t(:,1),:); tp2=p(t(:,2),:); tp3=p(t(:,3),:);
[pc]= incircle(tp1,tp2,tp3);
v=[tp1 tp2 tp3]-repmat(pc,1,3);
L=[v_magn(v(:,1:3)) v_magn(v(:,4:6)) v_magn(v(:,7:9))];
sf=ones(nf,3,'single')*density;
% % Or use this one when Size function is available
% for i=1:nf
%     for k=1:3
%         sf(i,j)=GetEdgeSizeAtXY(p(t(i,j),:,density);
%     end
% end
betha=(L+bethafactor*sf)./L;
clear L sf;
tp1=v(:,1:3).*repmat(betha(:,1),1,3)+pc;
tp2=v(:,4:6).*repmat(betha(:,2),1,3)+pc;
tp3=v(:,7:9).*repmat(betha(:,3),1,3)+pc;
clear v pc;
fprintf('\b%s\n',' done.')

% Calculate each face's prism coordinates
pp=zeros(nf,3,6);
pp(:,:,1)=tp1+shell_normals*bethafactor*density;
pp(:,:,2)=tp2+shell_normals*bethafactor*density;
pp(:,:,3)=tp3+shell_normals*bethafactor*density;
pp(:,:,4)=tp1-shell_normals*bethafactor*density;
pp(:,:,5)=tp2-shell_normals*bethafactor*density;
pp(:,:,6)=tp3-shell_normals*bethafactor*density;
% Perturb the above nodes
for i=1:6
    pp(:,:,i)=RandomizeBoundaryPoints(pp(:,:,i),llc,DELTA);
end
    
% Get bbx of prisms' facets
prism_facets_bbx=zeros(nf,8,6,'single');
% prism_normals=zeros(nf,3,8,'double');
fprintf('\tCalculating prism normals and bounding boxes...')
for i=1:nf
    tpp=(reshape(pp(i,:,:),3,6))';
    n1=tpp(prism(:,1),:); n2=tpp(prism(:,2),:); n3=tpp(prism(:,3),:);
    prism_facets_bbx(i,:,1)=min([n1(:,1) n2(:,1) n3(:,1)],[],2);
    prism_facets_bbx(i,:,2)=min([n1(:,2) n2(:,2) n3(:,2)],[],2);
    prism_facets_bbx(i,:,3)=min([n1(:,3) n2(:,3) n3(:,3)],[],2);
    prism_facets_bbx(i,:,4)=max([n1(:,1) n2(:,1) n3(:,1)],[],2);
    prism_facets_bbx(i,:,5)=max([n1(:,2) n2(:,2) n3(:,2)],[],2);
    prism_facets_bbx(i,:,6)=max([n1(:,3) n2(:,3) n3(:,3)],[],2);
%     v1=tpp(prism(:,2),:)-tpp(prism(:,1),:);
%     v2=tpp(prism(:,3),:)-tpp(prism(:,2),:);
%     tmp=cross(v1,v2);
%     norm_len=v_magn(tmp);
%     prism_normals(i,:,:)=(tmp./repmat(norm_len,1,3))';
end
fprintf('\b%s\n',' done.')
% Get bbx of prisms
prisms_bbx=zeros(nf,6);
for i=1:3
    prisms_bbx(:,i)   = min(pp(:,i,:),[],3);
    prisms_bbx(:,i+3) = max(pp(:,i,:),[],3);
end

% First we tag all the pixels around the boundary nodes based on desired
% length
np=size(p,1);
for i=1:np
    [I J K]=mapxyz2ijk(p(i,1:3),[dx dy dz],[nrow ncol npln],[xmin ymin zmin]);
    if P(I,J,K)==boundary_node_code % already tagged as boundary
        continue;
    end
    dd = density; 
    % Or use this one when density function is available
    % dd = GetDensityAtXY(p(i,1:3),density);
    dI = round(dd/dx) - 1;
    dI = round(dI/2); % To address node jumps at boundary
    istart=max(1,I-dI); iend=min(nrow,I+dI);
    for ii=istart:iend
        jstart=max(1,J-dI); jend=min(ncol,J+dI);
        for jj=jstart:jend
            kstart=max(1,K-dI); kend=min(npln,K+dI);
            for kk=kstart:kend
                if P(ii,jj,kk)==0
                    P(ii,jj,kk)=NA;
                end
            end
        end
    end
    P(I,J,K) = boundary_node_code;
end


% Get the maximum edge length of each triangle
edges=[t(:,[1 2]); t(:,[1 3]); t(:,[2 3])];
[edges m n] = unique(sort(edges,2),'rows');
edgelength=sqrt(sum((p(edges(:,2),:)-p(edges(:,1),:)).^2,2));


fprintf('\tSealing boundary buffer zone...')

clear mex
P = expand_bdybuffer_mex(P,pp,density,prisms_bbx,double(prism_facets_bbx),[dx dy dz],[xmin ymin zmin],edgelength,n,tiny);

fprintf('\b%s\n\n',' done.')

