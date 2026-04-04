function mysave(fn,data)

% mysave(fn,data)
%
% save function that will work with matlab compiler
%
% fn is the filename to be saved
% data is the variable to be saved

data = data';
[nrow,ncol]=size(data);
fid = OpenFile(fn,'w');

% Use %d for integer-valued data (e.g. element indices, region labels)
% to avoid precision loss from %g scientific notation on large integers.
% %g defaults to 6 significant digits, which silently corrupts node
% indices above ~1e6 when saving .elem files, causing invalid
% triangulation errors on mesh reload.
if isequal(data, round(data))
    fmt = '%d';
else
    fmt = '%g';
end

fmtstr = fmt;
for i = 2:nrow
    fmtstr = [fmtstr, '\t', fmt];
end
fmtstr = [fmtstr, '\n'];

fprintf(fid, fmtstr, data);
fclose(fid);
