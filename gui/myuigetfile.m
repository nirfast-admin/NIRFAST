function [fn,pn] = myuigetfile(ext,title)

%****************************************
% Part of NIRFAST
% Last Updated 8/10/09 - M Jermyn
%****************************************
%
% [fn,pn] = myuigetfile(ext,title)
%
% Allows the user to browse for a file, remembers last path.
%
% ext is the file extension to look for
% title is the title of the window
% fn is the resulting filename
% pn is the resulting path


% retrieve last used path
if ispref('nirfast_gui','lastpath')
    lastpath = getpref('nirfast_gui','lastpath');
else
    lastpath = pwd;
end

% get file
[fn,pn] = uigetfile(ext,title,lastpath);

% save path
if pn
    setpref('nirfast_gui','lastpath',pn);
end