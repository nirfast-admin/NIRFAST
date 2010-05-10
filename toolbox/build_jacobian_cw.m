function [J] = build_jacobian_cw(mesh,data)

% J = build_jacobian(mesh,data)
%
% Builds Jacobian, both complex and in terms of log amplitude and
% phase using direct field, data.phi, and adjoint field,
% data.aphi. For structure of Jacobian see any of Dartmouth
% publications.
%
% mesh is the mesh
% data is the data
% J is the resulting Jacobian



[ncol,junk] = size(mesh.nodes);
[nrow] = length(find(mesh.link~=0));
[nsource,junk] = size(mesh.source.coord);
[nmeas,junk] = size(mesh.meas.coord);

J.complex = zeros(nrow,ncol);
J.complete = zeros(nrow,ncol);

% create a fake imaginary part here as mex files assume complex
% numbers
fake_i = ones(ncol,1).*1e-20;

k = 1;
for i = 1 : nsource
  for j = 1 : length(mesh.link(i,:))
    if mesh.link(i,j) ~= 0
      jj = mesh.link(i,j);
      if mesh.dimension == 2
	
	% Calculate the absorption part here
	J.complex(k,:) = ...
	    -IntFG(mesh.nodes(:,1:2),...
		   sort(mesh.elements')',...
		   mesh.element_area,...
		   complex(full(data.phi(:,i)),fake_i),...
		   conj(complex(full(data.aphi(:,jj)),fake_i)));
	% Extract log amplitude
	J.complete(k,:) = ...
	    real(J.complex(k,:)./data.complex(k));
      elseif mesh.dimension == 3
	
	% Calculate the absorption part here
	J.complex(k,:) = ...
	    -IntFG_tet4(mesh.nodes,...
			sort(mesh.elements')',...
			mesh.element_area,...
			complex(full(data.phi(:,i)),fake_i),...
			conj(complex(full(data.aphi(:,jj)),fake_i)));
	% Extract log amplitude
	J.complete(k,:) = ...
	    real(J.complex(k,:)./data.complex(k));
      end
      k = k + 1;
    end
  end
end
