function writeSTL(filename,bel,nod)
% convert2STL(filename,bel,nod)
%
% Dartmouth College
% Written by Andrea Borsic using chunks of code from surf2stl of Bill McDonald
% Hanover, 06/10/06

% Modified by Hamid Ghadyani 03/14/2009 Worcester, WPI
% Added I/O checks

% This function converts a *.bel and a *.nod file to and STL file
%
% Use: convert2STL(filename);
%
% INPUTS:
% filename = name of the files to convert (without the .bel and .nod extensions)
% OUTPUTS:
% STL file = an STL file of the geometry with the same name as 'filename'

filename=remove_extension(filename);
stlfile=[filename '.stl'];

[fid st]=OpenFile(stlfile,'wt');

fprintf(fid,'solid\r\n');

fprintf('\n%s','Writing data to file... ')

for i=1:size(bel,1)

   local_write_facet(fid,nod(bel(i,1),:),nod(bel(i,2),:),nod(bel(i,3),:));

end

fclose(fid);

[mypath myfn myext]=fileparts(filename);
fprintf('\b%s\n','Done writing surface mesh to:')
if ~isempty(mypath)
    fprintf('\t%s',['Path: ' mypath])
end
fprintf('\t%s\n',['Filename: ' myfn '.stl'])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function local_write_facet(fid,p1,p2,p3)

n = local_find_normal(p1,p2,p3);

fprintf(fid,'facet normal %.7E %.7E %.7E\r\n', n(1),n(2),n(3) );
fprintf(fid,'outer loop\r\n');
fprintf(fid,'vertex %.7E %.7E %.7E\r\n', p1);
fprintf(fid,'vertex %.7E %.7E %.7E\r\n', p2);
fprintf(fid,'vertex %.7E %.7E %.7E\r\n', p3);
fprintf(fid,'endloop\r\n');
fprintf(fid,'endfacet\r\n');


function n = local_find_normal(p1,p2,p3)

v1 = p2-p1;
v2 = p3-p1;
v3 = cross(v1,v2);
n = v3 ./ sqrt(sum(v3.*v3));