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

% STANDARD OR SPECTRAL
if isfield(data,'paa')
    [j,k] = size(data.paa);
    for i=1:2:k
        figure;
        semilogy(1:1:j,data.paa(:,i),form);
        title('Amplitude');
        figure;
        plot(1:1:j,data.paa(:,i+1),form);
        title('Phase');
    end
% FLUORESCENCE
elseif isfield(data,'paaxflmm')
    [j,k] = size(data.paaxflmm);
    figure;
    semilogy(1:1:j,data.paax(:,1),form);
    title('Excitation Amplitude');
    figure;
    plot(1:1:j,data.paax(:,2),form);
    title('Excitation Phase');
    figure;
    semilogy(1:1:j,data.paafl(:,1),form);
    title('Fluorescence Amplitude');
    figure;
    plot(1:1:j,data.paafl(:,2),form);
    title('Fluorescence Phase');
    figure;
    semilogy(1:1:j,data.paamm(:,1),form);
    title('Emission Amplitude');
    figure;
    plot(1:1:j,data.paamm(:,2),form);
    title('Emission Phase');
elseif isfield(data,'paaxfl')
    [j,k] = size(data.paaxfl);
    figure;
    semilogy(1:1:j,data.paax(:,1),form);
    title('Excitation Amplitude');
    figure;
    plot(1:1:j,data.paax(:,2),form);
    title('Excitation Phase');
    figure;
    semilogy(1:1:j,data.paafl(:,1),form);
    title('Fluorescence Amplitude');
    figure;
    plot(1:1:j,data.paafl(:,2),form);
    title('Fluorescence Phase');
elseif isfield(data,'paax')
    [j,k] = size(data.paax);
    figure;
    semilogy(1:1:j,data.paax(:,1),form);
    title('Excitation Amplitude');
    figure;
    plot(1:1:j,data.paax(:,2),form);
    title('Excitation Phase');
elseif isfield(data,'paafl')
    [j,k] = size(data.paafl);
    figure;
    semilogy(1:1:j,data.paafl(:,1),form);
    title('Fluorescence Amplitude');
    figure;
    plot(1:1:j,data.paafl(:,2),form);
    title('Fluorescence Phase');
elseif isfield(data,'paamm')
    [j,k] = size(data.paamm);
    figure;
    semilogy(1:1:j,data.paamm(:,1),form);
    title('Emission Amplitude');
    figure;
    plot(1:1:j,data.paamm(:,2),form);
    title('Emission Phase');
elseif isfield(data,'amplitudefl')
    [j,k] = size(data.amplitudefl);
    figure;
    semilogy(1:1:j,data.amplitudefl,form);
    title('Fluorescence Amplitude');
else
    errordlg('Data not found or not properly formatted','NIRFAST Error');
    error('Data not found or not properly formatted');
end