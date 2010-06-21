function mesh = minband_opt(mesh)

% mesh = minband_opt(mesh)
%
% takes an element list and node list and
% sorts nodes to give mimimum BW.
%
% mesh is the mesh variable or filename

if ~(strcmp(mesh.type,'stnd_bem') || strcmp(mesh.type,'fluor_bem') || strcmp(mesh.type,'spec_bem'))
    gr=sparse(length(mesh.nodes),length(mesh.nodes));
    for i = 1 : length(mesh.elements)
        for j = 1 : 3
            for k = 1 : 3
                gr(mesh.elements(i,k),mesh.elements(i,j))=1;
            end
        end
    end
    figure
    spy(gr)
    
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
    
    
    for i = 1 : length(mesh.elements);
        elm_new(i,:) = invsort(mesh.elements(i,:));
    end
    mesh.elements = elm_new;
    
    gr=sparse(length(mesh.nodes),length(mesh.nodes));
    for i = 1 : length(mesh.elements)
        for j = 1 : 3
            for k = 1 : 3
                gr(mesh.elements(i,k),mesh.elements(i,j))=1;
            end
        end
    end
    figure
    spy(gr)
end

