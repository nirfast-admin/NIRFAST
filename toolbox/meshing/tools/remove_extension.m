function [fn extension]=remove_extension(fname)
% [fn extension]=remove_extension(fname)
% removes the extension from string 'fn'
% it returns the removed extension too.

[fdir fname extension] = fileparts(fname);
fn = fullfile(fdir, fname);
