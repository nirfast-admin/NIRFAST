function [I, J, K]=mapxyz2ijk(p,deltax,matrixdim,llc)
% maps coordinates of point 'p' to a matrix based index.
% dx,dy and dz are the the mapping factors.
% deltax=[dx dy dz] and matrixdim=[nrow ncol npln]
% this routines assume that matrix has 1 extra row/column/plane in each
% dimension such that the real object(mesh) is in the center of matrix
% that's why we are adding +2 in following lines.
dx=deltax(1); dy=deltax(2); dz=deltax(3);
nrow=matrixdim(1); ncol=matrixdim(2); npln=matrixdim(3);
xmin=llc(1); ymin=llc(2); zmin=llc(3);

XI = round( ((p(1)-xmin)/dx) )+2;
YI = round( ((p(2)-ymin)/dy) )+2;
ZI = round( ((p(3)-zmin)/dz) )+2;
J = XI;
I = nrow - YI + 1;
K = npln - ZI + 1;
% I = max(1,I); I = min(nrow,I);
% J = max(1,J); J = min(ncol,J);
% K = max(1,K); K = min(npln,K);