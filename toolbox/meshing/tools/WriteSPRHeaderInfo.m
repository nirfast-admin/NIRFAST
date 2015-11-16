function WriteSPRHeaderInfo(fn,props)
% props is a structure:
% .dim : number of dimensions
% .mysize : array with information about the size of each dim
% .fov : field of view
% .interval : spacing between pixels and slices
% .orient : 'axis' ,...
% .datatype : 'WORD' , ...
% .endian : 'ieee-le' , ...

fn = remove_extension(fn);
[fid st]=OpenFile([fn '.spr'],'wt');
if st, error('I/O Error!'); end

fprintf(fid,'numDim: %d\n',props.dim);
s=[];
for i=1:props.dim
    s=[s '%d '];
end
s=[s '\n'];
mysize=props.mysize;
fprintf(fid,['dim: ' s],mysize(:));

s=[];
for i=1:props.dim
    s=[s '%f '];
end
s=[s '\n'];
fov=props.fov;
fprintf(fid,['fov: ' s],fov(:));

s=[];
for i=1:props.dim
    s=[s '%f '];
end
s=[s '\n'];
interval=props.interval;
fprintf(fid,['interval: ' s],interval(:));

fprintf(fid,'sdtOrient: %s\n',props.orient);
fprintf(fid,'dataType: %s\n', props.datatype);
fprintf(fid,'endian: %s\n',props.endian);

fclose(fid);