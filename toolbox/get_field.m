function [phi,R]=get_field(Mass,mesh,qvec)

% [phi,R]=get_field(Mass,mesh,qvec,R)
%
% Used by femdata and jacobian
% Calculates the field, given the Mass matrix and RHS source
% vector.
%
% Mass is the mass matrix
% mesh is the input mesh
% qvec is the RHS source vector
% R is the preconditioner
% phi is the field

env = getenv('LD_LIBRARY_PATH');
if isempty(findstr(env,'pardiso'))
    pardiso = 0;
else
    pardiso = 1;
end
if exist('pardisolist')
    eval('pardisolist')
    hostname = getComputerName();
    hostname = cellstr(repmat(hostname,length(pardisohost),1));
else
    hostname = 'a';
    pardisohost = 'b';
end



[nnodes,nsource]=size(qvec);
phi=zeros(nnodes,nsource);
msg=[];
flag = 0;

if sum(strcmp(pardisohost,hostname)) == 0 
    % calculate the preconditioner
    if isfield(mesh,'R') == 0 % for spec, this may have been calculated
        if length(mesh.nodes) >= 3800
            R = cholinc(Mass,1e-3);
        elseif length(mesh.nodes) < 3800
            R = [];
        end
    else
        R = mesh.R;
    end
    
    if length(mesh.nodes) >= 3800
        for i = 1 : nsource
            [x,flag] = bicgstab(Mass,qvec(:,i),1e-12,100,R',R);
            msg = [msg flag];
            phi(:,i) = x;
        end
    else
        phi = Mass\qvec;
    end
    
    if isempty(msg)
        %   disp('Used backslash!')
    elseif any(msg==1)
        disp('some solutions did not converge')
        errordlg('Some solutions did not converge; this could be caused by noisy/bad data','NIRFAST Error');
        error('Some solutions did not converge; this could be caused by noisy/bad data');
    elseif any(msg==2)
        disp('some solutions are unusable')
        errordlg('Some solutions are unusable; this could be caused by noisy/bad data','NIRFAST Error');
        error('Some solutions are unusable; this could be caused by noisy/bad data');
    elseif any(msg==3)
        disp('some solutions from stagnated iterations')
        errordlg('Some solutions are unusable; this could be caused by noisy/bad data','NIRFAST Error');
        error('Some solutions are unusable; this could be caused by noisy/bad data');
    end
    
elseif sum(strcmp(pardisohost,hostname)) ~= 0 & pardiso == 1
    phi = solve_pardiso(Mass,qvec,0);
    R = [];
end
