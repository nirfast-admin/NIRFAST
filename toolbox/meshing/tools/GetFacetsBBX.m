function facets_bbx = GetFacetsBBX(tf,tp)
% Returns an nf x 6 matrix containing the bbx of each triangular facets:
% [xmin ymin zmin xmax ymax zmax]

n1=tp(tf(:,1),:); n2=tp(tf(:,2),:); n3=tp(tf(:,3),:);
facets_bbx(:,1)=min([n1(:,1) n2(:,1) n3(:,1)],[],2);
facets_bbx(:,2)=min([n1(:,2) n2(:,2) n3(:,2)],[],2);
facets_bbx(:,3)=min([n1(:,3) n2(:,3) n3(:,3)],[],2);
facets_bbx(:,4)=max([n1(:,1) n2(:,1) n3(:,1)],[],2);
facets_bbx(:,5)=max([n1(:,2) n2(:,2) n3(:,2)],[],2);
facets_bbx(:,6)=max([n1(:,3) n2(:,3) n3(:,3)],[],2);