function mimics2nirfast(filename,saveloc,filename_region)

% mimics2nirfast(filename,saveloc,filename_region)
%
% Converts mimics mesh to nirfast mesh (fem)
%
% filename is the cdb file from mimics
% saveloc is the location to save the mesh to
% filename_region is the region information text file (optional)


%% load files
disp('Loading files...');
temp = importdata(filename,' ',7);
nodes = temp.data;
nodes(:,1) = 0;

clear temp;
temp = importdata(filename,' ',length(nodes) + 14);
elem = temp.data(1:(find(temp.data(:,1) == -1)),end-3:end);

clear temp;
line_no = length(nodes) + length(elem) + 17;
surf_temp = importdata(filename,' ',line_no);
surf_nodes = surf_temp.data;
nodes(surf_nodes,1) = 1;

region = zeros(length(nodes),1);
if exist('filename_region','var')
    line_no = 17; 
    mat = importdata(filename_region,',',line_no);
    mat = mat.data;
    for ii = 1:length(mat)
        for jj = 1:4 
        ind = elem(ii,jj);
        region(ind) = mat(ii,1);
        end
    end
    elem = elem(1:length(mat),:);
end

%% save files
disp('Writing files...');
fid = fopen([saveloc,'.node'],'w');
for ii = 1:length(nodes)
    fprintf(fid,'%d %f %f %f \n',nodes(ii,1),nodes(ii,2),nodes(ii,3),nodes(ii,4));
end
fclose(fid);

fid = fopen([saveloc,'.elem'],'w');
for ii = 1:length(elem)
    fprintf(fid,'%d %d %d %d \n',elem(ii,1),elem(ii,2),elem(ii,3),elem(ii,4));
end
fclose(fid);

fid = fopen([saveloc,'.region'],'w');
for ii = 1:length(region)
    fprintf(fid,'%d \n',region(ii));
end
fclose(fid);
        
disp('Done');
