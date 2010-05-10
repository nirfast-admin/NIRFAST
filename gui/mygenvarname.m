function varname = mygenvarname(pathloc)

%****************************************
% Part of NIRFAST
% Last Updated 8/11/09 - M Jermyn
%****************************************
%
% varname = mygetvarname(pathloc)
%
% Generates a valid variable name based on a file path
%
% pathloc is a file path
% varname is the resulting variable name


k1 = findstr(pathloc,'/');
k2 = findstr(pathloc,'\');
p = findstr(pathloc,'.');
if isempty(p)
    varname = genvarname(pathloc(max([k1 k2 [0]])+1:end));
elseif p > max([k1 k2 [0]])
    varname = genvarname(pathloc(max([k1 k2 [0]])+1:p-1));
else
    varname = 'varb';
end