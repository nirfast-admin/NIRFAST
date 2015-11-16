function writeOFF(fn,t,p)
% Writes surface mesh defined in 't' and 'p' to a filed called fn
% Note: At the momemnt it assumes mesh is a triangulated surface mesh only
% http://shape.cs.princeton.edu/benchmark/documentation/off_format.html
%
% Written by:
%           Hamid Ghadyani Oct 2010

fid = OpenFile(fn,'wt');
if ~iscell(t)
    nfacets = size(t,1);
else
    nfacets = 0;
    for i=1:size(t,1)
        foo = t{i,1};
        nfacets = nfacets + size(foo,1);
    end
end

fprintf(fid,'OFF\n%d %d 0\n',size(p,1),nfacets);
fprintf(fid,'%.18f %.18f %.18f\n',(p(:,1:3))');

if ~isempty(t)
    if ~iscell(t)    
        fprintf(fid,'3 %d %d %d\n',(t(:,1:3)-1)');
    else
        for i=1:size(t,1)
            foo = t{i,1}-1;
            nn = size(foo,2);
            fs=' %d';
            fs = repmat(fs,1,nn);
            fs = sprintf('%d %s\n',nn,fs);
            fprintf(fid,fs,foo');
        end
    end
end


fclose(fid);
