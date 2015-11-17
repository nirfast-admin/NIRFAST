function [st quality area zeroflag edges edgeflag] = CheckMesh2D(e,p,inputflags)
% Checks the 2D triangular mesh for quality and consistency.
% The quality measure is the ratio of circumcircle to incircle and its
% range is between 0 and 1.
% If edgeflag is 1 it means there are edges that are shared by more than
% two triangles.
% zeroflag contains 1 for elements whose area is close to zero.
% 
% st:
% 0: OK
% 2: edge problem, mesh not valid or multi-material
% 4: some of elements' area are close to zero
% 6: both of above problems.

if size(p,2) > 2
    warning('CheckMesh2D:warning','Coordintes have ''z'' component! Only considering first two columns of input coordinates!')
    p = p(:,1:2);
end
if nargin >=3 && ~ismepty(nargin)
    if isfield(inputflags,'verbose')
        verbose = inputflags.verbose;
    else
        verbose = 0;
    end
end

fprintf('\nChecking 2D mesh...\n');
outfn='mesh2d-check';
[area,zeroflag]=checkarea(e,p);
q=checkquality(e,p);
[edgeflag,edges,badedges]=checkedges(e);
tempfn=[outfn '-edges.txt'];
if edgeflag
    fprintf(' Some of the edges of this mesh are shared by more than 2 triangles.\n');
    fprintf(' Check $HOME/mesh2d-check-badedges.txt\n');
    dlmwrite(fullfile(getuserdir,[fn '-badedges.txt']),badedges,' ');
    disp(['Check ' tempfn]);
end
fprintf('\n Quality: ranges between 0 and 1, with 1 being best quality:\n');
fprintf(' Min, Max and Average of triangle quality: %f, %f, %f\n',min(q),max(q),mean(q));
fprintf('\n Min, Max and Average area: %f, %f, %f\n',min(area),max(area),mean(area));
if any(zeroflag)
    fprintf(' There are %d triangles whose area is close to zero\n',sum(zeroflag))
end
e2 = check_element_orientation_2d(e,p);
foo = e2 - e;
if any(sum(foo))
    fprintf('\n Elements of this mesh are not oriented CCW!\n');
end
quality = q;
if edgeflag == 0 && all(~zeroflag)
    st = 0;
end
if edgeflag ~= 0
    st = 2;
end
if any(zeroflag)
    st = bitor(st,4);
end
    

function [area,zeroflag] = checkarea(e,p)
global tiny

if isempty(tiny)
    tiny=1e-6;
end

area = triangle_area_2d(p(e(:,1),:),p(e(:,2),:),p(e(:,3),:));
zeroflag = IsEqual(area,0,tiny);

function q=checkquality(e,p)
% radius ratio
q=simpqual(p,e);


function [retflag edges badedges] = checkedges(e)
badedges=[];
edges = [e(:,[1 2]);e(:,[1 3]);e(:,[2 3])];
[edges ix jx] = unique(sort(edges,2),'rows');
r=1:max(jx);
vec=histc(jx,r);

c = vec>2;
sumc=sum(c);
retflag = 0;
if sumc ~= 0
    jx2=r(c);
    badedges=edges(jx2,:);
    retflag = 1;
end



















