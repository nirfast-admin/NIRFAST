function write_medit_sol_file(infn,sol,type)
% writes a solution file for medit (xxxx.bb)
% sol is m by n matrix where m is number of nodes/elements
% and n is number of solutions/fields attached to each node/element
% type specifies if the 'sol' is for nodes or elements

fn = add_extension(remove_extension(infn),'.bb');
fid = fopen(fn,'wt');

nbmet = size(sol,2);
nentities = size(sol,1);
fprintf(fid,'3 %d %d %d\n', nbmet, nentities, type);
sf = repmat('%d ',1,nbmet * 5); sf(end)=[];
sf = [sf '\n'];
fprintf(fid, sf, sol);
fclose(fid);
