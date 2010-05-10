function [data,mesh]=femdata_fl(mesh,frequency)

% [data,mesh]=femdata_fl(fn,frequency)
%
% Calculates fluorescence data (phase and amplitude) for a given
% problem (fn) at a given frequency (MHz).
% outputs phase and amplitude in structure data
% and mesh information in mesh



% error checking
if frequency < 0
    errordlg('Frequency must be nonnegative','NIRFAST Error');
    error('Frequency must be nonnegative');
end

% If not a workspace variable, load mesh
if ischar(mesh)== 1
    mesh = load_mesh(mesh);
end

% modulation frequency
omega = 2*pi*frequency*1e6;

% set fluorescence variables
mesh.gamma = (mesh.eta.*mesh.muaf)./(1+(omega.*mesh.tau).^2);

% Create FEM matricex
if mesh.dimension == 2
    % Excitation FEM matrix
    [i,j,s] = gen_matrices_2d(mesh.nodes(:,1:2),...
        sort(mesh.elements')', ...
        mesh.bndvtx,...
        mesh.muax,...
        mesh.kappax,...
        mesh.ksi,...
        mesh.c,...
        omega);
    junk = length(find(i==0));
    MASS_x = sparse(i(1:end-junk),j(1:end-junk),s(1:end-junk));
    clear junk i j s;
    % Emission FEM matrix
    [i,j,s] = gen_matrices_2d(mesh.nodes(:,1:2),...
        sort(mesh.elements')', ...
        mesh.bndvtx,...
        mesh.muam,...
        mesh.kappam,...
        mesh.ksi,...
        mesh.c,...
        omega);
    junk = length(find(i==0));
    MASS_m = sparse(i(1:end-junk),j(1:end-junk),s(1:end-junk));
    clear junk i j s;
elseif mesh.dimension ==3
    % Excitation FEM matrix
    [i,j,s] = gen_matrices_3d(mesh.nodes,...
        sort(mesh.elements')', ...
        mesh.bndvtx,...
        mesh.muax,...
        mesh.kappax,...
        mesh.ksi,...
        mesh.c,...
        omega);
    junk = length(find(i==0));
    MASS_x = sparse(i(1:end-junk),j(1:end-junk),s(1:end-junk));
    clear junk i j s;
    % Emission FEM matrix
    [i,j,s] = gen_matrices_3d(mesh.nodes,...
        sort(mesh.elements')', ...
        mesh.bndvtx,...
        mesh.muam,...
        mesh.kappam,...
        mesh.ksi,...
        mesh.c,...
        omega);
    junk = length(find(i==0));
    MASS_m = sparse(i(1:end-junk),j(1:end-junk),s(1:end-junk));
    clear junk i j s;
end

% If the fn.ident exists, then we must modify the FEM matrices to
% account for refractive index mismatch within internal boundaries
if isfield(mesh,'ident') == 1
    disp('Modifying for refractive index')
    M = bound_int(MASS,mesh);
    MASS = M;
    clear M
end

% Calculate the RHS (the source vectors. For simplicity, we are
% just going to use a Gaussian Source, The width of the Gaussian is
% changeable (last argument). The source is assumed to have a
% complex amplitude of complex(cos(0.15),sin(0.15));

% Now calculate source vector
% NOTE last term in mex file 'qvec' is the source FWHM
%
[nnodes,junk]=size(mesh.nodes);
[nsource,junk]=size(mesh.source.coord);
qvec = spalloc(nnodes,nsource,nsource*100);
if mesh.dimension == 2
  for i = 1 : nsource
    if mesh.source.fwhm(i) == 0
        qvec(:,i) = gen_source_point(mesh,mesh.source.coord(i,1:2));
    else
      qvec(:,i) = gen_source(mesh.nodes(:,1:2),...
			   sort(mesh.elements')',...
			   mesh.dimension,...
			   mesh.source.coord(i,1:2),...
			   mesh.source.fwhm(i));
    end
  end
elseif mesh.dimension == 3
  for i = 1 : nsource
    if mesh.source.fwhm(i) == 0
        qvec(:,i) = gen_source_point(mesh,mesh.source.coord(i,1:3));
    else
    qvec(:,i) = gen_source(mesh.nodes,...
			   sort(mesh.elements')',...
			   mesh.dimension,...
			   mesh.source.coord(i,:),...
			   mesh.source.fwhm(i));
    end
  end
end

clear junk i;

% catch error in source vector
junk = sum(qvec);
junk = find(junk==0);
if ~isempty(junk)
    display(['WARNING...Check the FWHM of Sources ' num2str(junk)]);
end
clear junk

% Catch zero frequency (CW) here
if frequency == 0
  MASS_x = real(MASS_x);
  MASS_m = real(MASS_m);
  qvec = real(qvec);
%   [i,j,s]=find(qvec);
%   [m,n] = size(s);
%   s = complex(s,1e-20);
%   qvec = sparse(i,j,s,nnodes,nsource);
%   clear i j s m n
end

%*******************************************************
% Calculate INTRINSIC FIELDS:

% Calculate INTRINSIC EXCITATION field for all sources
[data.phix]=get_field(MASS_x,mesh,qvec);

% Calculate INTRINSIC field at EMISSION WAVELENGTH laser source
[data.phimm]=get_field(MASS_m,mesh,qvec);
clear qvec;

%********************************************************
% Calculate the RHS (the source vectors) for the FLUORESCENCE EMISSION.
[nnodes,junk]=size(mesh.nodes);
[nsource,junk]=size(mesh.source.coord);
qvec = zeros(nnodes,nsource);
% Simplify the RHS of emission equation
beta = mesh.gamma.*(1-(sqrt(-1).*omega.*mesh.tau));
% get rid of any zeros!
if frequency == 0
    beta(find(beta==0)) = 1e-20;
else
    beta(find(beta==0)) = complex(1e-20,1e-20);
end

if mesh.dimension == 2
    for i = 1 : nsource
        val = beta.*data.phix(:,i);
        qvec(:,i) = gen_source_fl(mesh.nodes(:,1:2),...
            sort(mesh.elements')',...
            mesh.dimension,...
            val);
    end
elseif mesh.dimension == 3
    for i = 1 : nsource
        val = beta.*data.phix(:,i);
        qvec(:,i) = gen_source_fl(mesh.nodes,...
            sort(mesh.elements')',...
            mesh.dimension,...
            val);
    end
end
clear junk i nnodes nsource val beta;

% Catch zero frequency (CW) here
if frequency == 0
    qvec = real(qvec);
end

%*********************************************************
% Calculate FLUORESCENCE EMISSION field for all sources
[data.phifl]=get_field(MASS_m,mesh,qvec);
clear qvec;

%*********************************************************
% Calculate boundary data
[data.complexx]=get_boundary_data(mesh,data.phix);
[data.complexfl]=get_boundary_data(mesh,data.phifl);
[data.complexmm]=get_boundary_data(mesh,data.phimm);

% Map complex data to amplitude
data.amplitudex = abs(data.complexx);
data.amplitudefl = abs(data.complexfl);
data.amplitudemm = abs(data.complexmm);

% Map complex data to phase
data.phasex = atan2(imag(data.complexx),...
    real(data.complexx));
data.phasefl = atan2(imag(data.complexfl),...
    real(data.complexfl));
data.phasemm = atan2(imag(data.complexmm),...
    real(data.complexmm));

% Calculate phase in degrees
data.phasex(find(data.phasex<0)) = data.phasex(find(data.phasex<0)) + (2*pi);
data.phasefl(find(data.phasefl<0)) = data.phasefl(find(data.phasefl<0)) + (2*pi);
data.phasemm(find(data.phasemm<0)) = data.phasemm(find(data.phasemm<0)) + (2*pi);
data.phasex = data.phasex*180/pi;
data.phasefl = data.phasefl*180/pi;
data.phasemm = data.phasemm*180/pi;

% Build data formats
data.paax = [data.amplitudex data.phasex];
data.paamm = [data.amplitudemm data.phasemm];
data.paafl = [data.amplitudefl data.phasefl];
data.paaxfl = [data.amplitudex data.phasex data.amplitudefl data.phasefl];
data.paaxflmm = [data.amplitudex data.phasex data.amplitudefl data.phasefl data.amplitudemm data.phasemm];
