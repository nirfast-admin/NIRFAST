function mesh = minband_opt(mesh)

% mesh = minband_opt(mesh)
%
% takes an element list and node list and
% sorts nodes to give mimimum BW.
%
% mesh is the mesh variable or filename

disp('Optimizing Mesh...');

if ~(strcmp(mesh.type,'stnd_bem') || strcmp(mesh.type,'fluor_bem') || strcmp(mesh.type,'spec_bem'))

    ni = zeros(9*size(mesh.elements,1),1);
    nj = zeros(9*size(mesh.elements,1),1);
    nk = 1;
    for i = 1 : length(mesh.elements)
        for j = 1:3
            for k = 1:3
                ni(nk) = mesh.elements(i,k);
                nj(nk) = mesh.elements(i,j);
                nk = nk + 1;
            end
        end
    end
    gr = sparse(ni,nj,ones(size(ni,1),1),size(mesh.nodes,1),size(mesh.nodes,1));
%     figure
%     spy(gr)
    
    NodeSort = symrcm(gr);
    for i = 1 : length(mesh.nodes)
        invsort(NodeSort(1,i)) = i;
    end
    
    mesh.nodes = mesh.nodes(NodeSort,:);
    mesh.bndvtx = mesh.bndvtx(NodeSort);
    mesh.ri = mesh.ri(NodeSort);
    if isfield(mesh,'region')==1
        mesh.region = mesh.region(NodeSort);
    end
    
    % Standard
    if isfield(mesh,'mua')==1
        mesh.mua = mesh.mua(NodeSort);
    elseif isfield(mesh,'mus')==1
        mesh.mus = mesh.mus(NodeSort);
    elseif isfield(mesh,'kappa')==1
        mesh.kappa = mesh.kappa(NodeSort);
        % Fluroescence
    elseif isfield(mesh,'muax')==1
        mesh.muax = mesh.muax(NodeSort);
    elseif isfield(mesh,'musx')==1
        mesh.musx = mesh.musx(NodeSort);
    elseif isfield(mesh,'kappax')==1
        mesh.kappax = mesh.kappax(NodeSort);
    elseif isfield(mesh,'muam')==1
        mesh.muam = mesh.muam(NodeSort);
    elseif isfield(mesh,'musm')==1
        mesh.musm = mesh.musm(NodeSort);
    elseif isfield(mesh,'kappam')==1
        mesh.kappam = mesh.kappam(NodeSort);
    elseif isfield(mesh,'muaf')==1
        mesh.muaf = mesh.muaf(NodeSort);
    elseif isfield(mesh,'eta')==1
        mesh.eta = mesh.eta(NodeSort);
    elseif isfield(mesh,'tau')==1
        mesh.tau = mesh.tau(NodeSort);
        % Spectral
    elseif isfield(mesh,'conc')==1
        mesh.conc = mesh.conc(NodeSort,:);
    elseif isfield(mesh,'sa')==1
        mesh.sa = mesh.sa(NodeSort);
    elseif isfield(mesh,'sa')==1
        mesh.sp = mesh.sp(NodeSort);
        % SPN
    elseif isfield(mesh,'g') == 1
        mesh.g == mesh.g(NodeSort);
    end
    
    elm_new = zeros(size(mesh.elements,1),size(mesh.elements,2));
    for i = 1 : length(mesh.elements);
        elm_new(i,:) = invsort(mesh.elements(i,:));
    end
    mesh.elements = elm_new;
    
    ni = zeros(9*size(mesh.elements,1),1);
    nj = zeros(9*size(mesh.elements,1),1);
    nk = 1;
    for i = 1 : length(mesh.elements)
        for j = 1:3
            for k = 1:3
                ni(nk) = mesh.elements(i,k);
                nj(nk) = mesh.elements(i,j);
                nk = nk + 1;
            end
        end
    end
    gr = sparse(ni,nj,ones(size(ni,1),1),size(mesh.nodes,1),size(mesh.nodes,1));
%     figure
%     spy(gr)
end

disp('Mesh Optimization Complete');

