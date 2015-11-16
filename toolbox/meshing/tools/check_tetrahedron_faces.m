function [st badtets badfaces] = check_tetrahedron_faces(e)
% check faces to make sure every face is only used by 1 or 2 tetrahedrons
% Returns:
% 0: OK
% 2: invalid mesh with more than 2 tetrahedron per face
% 
% Written by:
%     Hamid Ghadyani, 2009
st = 0;

fprintf('\nChecking tetrahedral faces..... ')
faces=[e(:,[1 2 3]);e(:,[1 2 4]);e(:,[2 3 4]);e(:,[1 3 4])];
faces=sort(faces,2);
[foo ix jx]=unique(faces,'rows');
range=1:max(jx);
vec=histc(jx,range);

bf = vec>2 | vec==0;

ntet = size(e,1);
nbadfaces=sum(bf);
jx2=range(bf);
badfaces=foo(jx2,:);
badtets=[];
if nbadfaces~=0 % Some of faces are shared by more than tetrahedron: a definite problem
    fprintf('\t\n------------ Invalid solid mesh! ------------\n')
    fprintf('\tA total %d faces of the mesh are shared by more than two tetrahedrons!\n',nbadfaces)
    fprintf(['\tThose faces can be found in ' tempdir 'bad_faces_extra_shared_solid.txt\n'])
    fid = OpenFile([tempdir 'bad_faces_extra_shared_solid.txt'],'wt');
    for i=1:nbadfaces
        fprintf(fid,'Face: %d %d %d\t',badfaces(i,:));
        [tf idx]=ismember(badfaces(i,:),foo,'rows');
        MyAssert(vec(idx)>2);
        tmpjx = jx;
        fprintf(fid,'Tets: ');
        for j=1:vec(idx)
            [tf2 idx2]=ismember(idx,tmpjx);
            MyAssert(tf2);
            idx3 = mod(idx2,ntet); if idx3==0, idx3=ntet; end
            badtets=[badtets idx3];
            fprintf(fid,'%d ',idx3);
            tmpjx(idx2)=0;
        end
        fprintf(fid,'\n');
    end
    fclose(fid);
    badtets=unique(badtets);
    st = 2;
%     writenodelm_3dm('bad_faces_extra_shared_solid.3dm',e(badtets,:),p);
end
fprintf('\bDone\n');