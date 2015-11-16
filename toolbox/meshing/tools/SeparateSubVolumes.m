function output = SeparateSubVolumes(telem,tnode)
% Assuming multiple material regions are delineated in 'telem', this routines
% returns:
% tags : list of nodes inside _every_ subvolume (one node per subvolume)
%        tags{:,1} = coordiantes
%        tags{:,2} = region ID
% 
% extelem : indices to the elements that compose the largest volume
% retelem : re-oriented elements
% allregions : a cell aray containing indices of elements in telem that
% constitute different sub-surfaces of 'telem'
% 
% telem(:,1:3) defines the triagnels in the surface
% telem(:,4:5) defines the two materials on each side of a triangle

if size(telem,2)~=3 && size(telem,2)<5
        error('Input surface mesh does not seem to be a triangular mesh.');
end
if size(telem,2)==3
    nregions=1;
    regions=1;
    telem = [telem repmat([1 0], size(telem,1), 1)];
else
    regions = telem(:,4:5);
    regions = unique(regions(:));
    nregions = length(regions);
end
[tf idx]=ismember(0,regions);
if tf, regions(idx)=[]; nregions=nregions-1; end % Remove 0 (which represents outside space)


% Find a point within each region (note that regions might consist of
% multiple sub-surfaces)
tag_counter = 1;
maxvol = -realmax;

% All input elements will be returned in retelem after their orientation is
% fixed
retelem=telem;

% all_regions will contain list of all individual closed sub-surfaces
% regardless of their corresponding region.
all_regions={};

for i=1:nregions
    inode=[];
    interior_nodes=[];
    % Find elements of current region
    bf=telem(:,4)==regions(i) | telem(:,5)==regions(i);
    idx = find(bf);
    subvol=telem(bf,1:5);
    
    % Get all the sub-surfaces of current region
    ind_regions = GetIndRegions(subvol(:,1:3),tnode);
    
    % Figure out which sub-surface should be used for point coordinate
    % calculations.
    % We do this by using Jordan's theorem.
    % First get one interior node for each sub-surface of current region
    if size(ind_regions,1)>1
        localvol=-realmax;
        for j=1:size(ind_regions,1)
            fooelem = FixPatchOrientation(tnode,subvol(ind_regions{j},1:3),[],1);
            retelem(idx(ind_regions{j}),1:3) = fooelem;
%             all_regions = InsertRegion(all_regions,idx(ind_regions{j}));
            tmpnode = GetOneInteriorNode(fooelem,tnode);
            if isempty(tmpnode)
                errordlg('Could not find an interior point in surface.','Mesh Error');
                error('Could not find an interior point in surface.' );
            end
            inode = cat(1,inode,tmpnode);
            vol = shell_volume(fooelem,tnode);
            if vol>localvol
                localvol=vol;
                myidx=j;
            end
        end
    else
        fooelem = FixPatchOrientation(tnode,subvol(ind_regions{1},1:3),[],1);
        retelem(idx(ind_regions{1}),1:3) = fooelem;
        inode = GetOneInteriorNode(fooelem,tnode);
%         all_regions = InsertRegion(all_regions,idx(ind_regions{1}));
        myidx=1;
    end
    
    % Check if the interior nodes actually belong to current region
    st = IsInsideMatRegion(inode,regions(i),subvol,tnode);
    for k=1:length(st)
        % Check if the current sub-boundary is an exterior boundary, i.e.
        % it separates the domain from nothing (0)
        bf1 = retelem(idx(ind_regions{k}),4) == 0;
        bf2 = retelem(idx(ind_regions{k}),5) == 0;
        assert(sum(bf1)~=sum(bf2) || sum(bf1)==0) % Sanity check
        if sum(bf1) == length(ind_regions{k}) || sum(bf2) == length(ind_regions{k})
             interior_nodes = cat(1,interior_nodes,inode(k,:));
            all_regions = InsertRegion(all_regions,idx(ind_regions{k}));
        elseif st(k)==1
            interior_nodes = cat(1,interior_nodes,inode(k,:));
            all_regions = InsertRegion(all_regions,idx(ind_regions{k}));
        end
    end
    if isempty(interior_nodes)
            errordlg('Could not find an interior point in surface.','Mesh Error');
            error('Could not find an interior point in surface.' );
    end
    
    % Check if this surface is the exterior one, we need it for
    % actual checkerboard3d to work. We do this by calculating the
    % volume of each sub-volume.
    vol = shell_volume(telem(idx(ind_regions{myidx}),1:3),tnode);
    if vol > maxvol
        maxvol = vol;
        extelem = telem(idx(ind_regions{myidx}),1:3);
    end
    for j=1:size(interior_nodes,1);
        tags{tag_counter,1} = interior_nodes(j,:);
        tags{tag_counter,2} = regions(i);
        tag_counter = tag_counter + 1;
    end
end
output.tags = tags;
output.extelem = extelem;
output.retelem = retelem;
output.all_regions = all_regions;








function  all_regions = InsertRegion(all_regions,cregion)
% Adds a new region (i.e. list of indices in original elements to
% 'all_regions'

flag = true;
if isempty(all_regions)
    all_regions{1} = cregion;
    return
end

for i=1:length(all_regions)
    if isempty(setdiff(all_regions{i},cregion))
        flag = false;
        break
    end
end

if flag % cregion is not already in all_regions
    all_regions{end+1} = cregion;
end
