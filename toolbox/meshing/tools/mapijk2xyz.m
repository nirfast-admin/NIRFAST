function p=mapijk2xyz(i,j,k,deltax,matrixdim,llc)
% maps matrix coordinates of (i,j,k) back to real world coordinates.
% deltax=[dx dy dz] and llc=[xmin ymin zmin]
% this routines assume that matrix has 1 extra row/column/plane in each
% dimension such that the real object(mesh) is in the center of matrix
dx=deltax(1); dy=deltax(2); dz=deltax(3);
nrow=matrixdim(1); ncol=matrixdim(2); npln=matrixdim(3);
xmin=llc(1); ymin=llc(2); zmin=llc(3);

p = [(j-2)*dx+xmin (nrow-i-1)*dy+ymin (npln-k-1)*dz+zmin];




