function [fid st]=OpenFile(fn,att)
% [fid st]=OpenFile(fn,att)
% Opens a file whose file name is 'fn' and attributes of openning is 'att'
% It returns 1 if openning was NOT successful
st=0;
[fid,message]=fopen(fn,att);
if fid == -1 || ~isempty(message)
    fprintf(sprintf('\nFile I/O Error:  %s\n  %s\n\n',message,fn));
    errordlg(sprintf('File I/O Error:  %s\n%s',message,fn),'File I/O Error');
    error(' ');
end