function plot_data(data)

% plot_data(data)
%
% Plots phase and amplitude of the data
%
% data is the structured data variable


form = 'b.-';

% load from file if path given
if ischar(data)
    data = load_data(data);
end

% TIME RESOLVED
if isfield(data,'tpsf')
    figure
    imagesc(log(abs(data.tpsf)));
    xlabel('time point');
    ylabel('source/detector pair');
    title('Time Resolved Data');
elseif isfield(data,'tpsfx')
    figure
    imagesc(log(abs(data.tpsfx)));
    xlabel('time point');
    ylabel('source/detector pair');
    title('Time Resolved Data');
% STANDARD OR SPECTRAL
elseif isfield(data,'paa')
    [j,k] = size(data.paa);
    m = 1;
    for i=1:2:k
        figure;
        linki = logical(data.link(:,m+2));
        m = m + 1;
        semilogy(data.paa(linki,i),form);
        title('Amplitude');
        figure;
        plot(data.paa(linki,i+1),form);
        title('Phase');
    end
% FLUORESCENCE
elseif isfield(data,'paaxflmm')
    linki = logical(data.link(:,3));
    [j,k] = size(data.paaxflmm);
    figure;
    semilogy(data.paax(linki,1),form);
    title('Excitation Amplitude');
    figure;
    plot(data.paax(linki,2),form);
    title('Excitation Phase');
    figure;
    semilogy(data.paafl(linki,1),form);
    title('Fluorescence Amplitude');
    figure;
    plot(data.paafl(linki,2),form);
    title('Fluorescence Phase');
    figure;
    semilogy(data.paamm(linki,1),form);
    title('Emission Amplitude');
    figure;
    plot(data.paamm(linki,2),form);
    title('Emission Phase');
elseif isfield(data,'paaxfl')
    linki = logical(data.link(:,3));
    [j,k] = size(data.paaxfl);
    figure;
    semilogy(data.paax(linki,1),form);
    title('Excitation Amplitude');
    figure;
    plot(data.paax(linki,2),form);
    title('Excitation Phase');
    figure;
    semilogy(data.paafl(linki,1),form);
    title('Fluorescence Amplitude');
    figure;
    plot(data.paafl(linki,2),form);
    title('Fluorescence Phase');
elseif isfield(data,'paax')
    linki = logical(data.link(:,3));
    [j,k] = size(data.paax);
    figure;
    semilogy(data.paax(linki,1),form);
    title('Excitation Amplitude');
    figure;
    plot(data.paax(linki,2),form);
    title('Excitation Phase');
elseif isfield(data,'paafl')
    linki = logical(data.link(:,3));
    [j,k] = size(data.paafl);
    figure;
    semilogy(data.paafl(linki,1),form);
    title('Fluorescence Amplitude');
    figure;
    plot(data.paafl(linki,2),form);
    title('Fluorescence Phase');
elseif isfield(data,'paamm')
    linki = logical(data.link(:,3));
    [j,k] = size(data.paamm);
    figure;
    semilogy(data.paamm(linki,1),form);
    title('Emission Amplitude');
    figure;
    plot(data.paamm(linki,2),form);
    title('Emission Phase');
elseif isfield(data,'amplitudefl')
    linki = logical(data.link(:,3));
    [j,k] = size(data.amplitudefl);
    figure;
    semilogy(data.amplitudefl(linki),form);
    title('Fluorescence Amplitude');
else
    errordlg('Data not found or not properly formatted','NIRFAST Error');
    error('Data not found or not properly formatted');
end