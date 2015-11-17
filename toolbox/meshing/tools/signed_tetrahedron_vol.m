function vol = signed_tetrahedron_vol(TET,X,Y,Z)
% function vol = signed_tetrahedron_vol(TET, X, Y, Z);
% 
% Fully vetorized to compute the signed volume of tetrahedral (TET4)
% elements.  TET (nX4) specifies node connectivity, X,Y,Z (all are nX1) are
% node coordinates.  An element in TET matrix (e.g., TET(m,n)=9;)
% implicitly assumes it corresponds to the index of X,Y,Z (i.e., 9th
% element of X,Y and Z).  The returned volume is positive if normal
% direction defined by node (1, 2, 3) is pointing opposite to the 4th node.
% Or negative if otherwise.  NOTE, there is no standard convention how the
% nodes are ordered in the element TET, so may need to use absolute values.
%
% The volume of the tet elements are basically the determinant of the
% matrix: [x1,y1,z1,1;x2,y2,z2,1;x3,y3,z3,1;x4,y4,z4,1] (then divide by 6).
% The forumla calculating the determinant is on my sketch sheet.
%
% Songbai Ji (6/28/2006).

% m is of size: nX12, do not have ones vector.  In the matrix
% operation later, need to be careful of the columns of matrix selected for
% computation in each term.


X=X(:); Y=Y(:); Z=Z(:); %make sure to be column vectors
m = [X(TET(:,1)), Y(TET(:,1)), Z(TET(:,1)), ...
    X(TET(:,2)), Y(TET(:,2)), Z(TET(:,2)),  ...
    X(TET(:,3)), Y(TET(:,3)), Z(TET(:,3)),  ...
    X(TET(:,4)), Y(TET(:,4)), Z(TET(:,4))];


term1 =  m(:,5).*m(:,9) + m(:,8).*m(:,12) + m(:,11).*m(:,6) + ...
       - m(:,5).*m(:,12) - m(:,6).*m(:,8) - m(:,9).*m(:,11) ;

term2 =  m(:,4).*m(:,9) + m(:,7).*m(:,12) + m(:,10).*m(:,6) + ...
       - m(:,4).*m(:,12) - m(:,6).*m(:,7) - m(:,9).*m(:,10) ;

term3 =  m(:,4).*m(:,8) + m(:,7).*m(:,11) + m(:,10).*m(:,5) + ...
       - m(:,4).*m(:,11) - m(:,5).*m(:,7) - m(:,8).*m(:,10) ;

term4 =  m(:,4).*m(:,8).*m(:,12) + m(:,7).*m(:,11).*m(:,6) + m(:,10).*m(:,9).*m(:,5) + ...
       - m(:,4).*m(:,11).*m(:,9) - m(:,5).*m(:,7).*m(:,12) - m(:,6).*m(:,8).*m(:,10) ;

vol = m(:,1).*term1 - m(:,2).*term2 + m(:,3).*term3 - term4;
vol = vol/6;