function writenodelm_abaqus_inp(fn,e,p)
% Writes list of nodes 'p' and elements 'e' into Abaqus .inp file format.
% Written By: Hamid Ghadyani

fprintf('Writing data to file... ')

fn = add_extension(fn,'.inp');

[fid,st]=OpenFile(fn,'wt');
if st~=0
    error('I/O Error.');
end

fprintf(fid,'*HEADING\n');
fprintf(fid,'Written by writenodelm_abaqus_inp\n\n');
% Write nodes
fprintf(fid,'*NODE\n');
formatstring = '%d, %.12f, %.12f, %.12f';
fprintf(fid,[formatstring '\n'],[(1:size(p,1))' p]');

% Write elements
fprintf(fid,'ELEMENT, TYPE=S3R\n');
formatstring = '%d';
for i=1:size(e,2)
    formatstring=[formatstring ', %d'];
end

fprintf(fid,[formatstring '\n'],[(1:size(e,1))' e]');

% Write elements type
fprintf(fid,'*ELSET, ELSET=f_Surface\n');
fprintf(fid,'%d\n',1:size(e,1));

fclose(fid);

[mypath myfn myext]=fileparts(fn);
fprintf('\b%s\n','Done writing surface mesh to:')
if ~isempty(mypath)
    fprintf('\t%s\n',['Path: ' mypath])
end
fprintf('\t%s\n',['Filename: ' myfn myext])


