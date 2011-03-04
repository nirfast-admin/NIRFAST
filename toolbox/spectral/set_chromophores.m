function set_chromophores(meshloc,chrom_list,wv)

% set_chromophores( meshloc, chrom_list, wv )
%
% meshloc is the location of the mesh (not a workspace variable)
% chrom_list is the chromophore list
% wv is the wavelength array
%
% This function supplies the extinction coefficient file to a spectral mesh
% based on the desired wavelengths and chromophores to be studied

mesh = load_mesh(meshloc);
mesh.wv=wv';
mesh.excoef=[];
mesh.chromscattlist=chrom_list;
mesh.chromscattlist{end+1,1} = 'S-Amplitude';
mesh.chromscattlist{end+1,1} = 'S-Power';
excoef = importdata('excoef.txt');

for i = 1 : length(mesh.wv)
    if (wv(i)<600) || (wv(i)>1000)
        errordlg(['The Wavelength ' num2str(mesh.wv(i)) ...
            ' is not between 600 and 1000 nm'],'NIRFAST Error');
        error(['The Wavelength ' char(mesh.chromscattlist(i,1)) ...
            ' is not between 600 and 1000 nm']);
    end
    k=1;
    for j=1:length(chrom_list)
        ind = find(strcmpi(excoef.textdata,chrom_list(j)));
        if isempty(ind)
            errordlg(['The Chromophore ' char(chrom_list(j)) ...
                ' is not defined in extinction coefficient file'],'NIRFAST Error');
            error(['The Chromophore ' char(chrom_list(j)) ...
                ' is not defined in extinction coefficient file']);
        else
            mesh.excoef(i,k) = excoef.data(wv(i)-599,ind+1);
            k=k+1;
        end
    end
end

c1 = ones(length(mesh.nodes),1).*0.01;
c2 = ones(length(mesh.nodes),1).*0.4;
mesh.conc = [];
for i=1:length(chrom_list)
    if strcmp('HbO',chrom_list(i)) || strcmp('deoxyHb',chrom_list(i))
        mesh.conc = [mesh.conc c1];
    else
        mesh.conc = [mesh.conc c2];
    end
end

save_mesh(mesh,meshloc);
