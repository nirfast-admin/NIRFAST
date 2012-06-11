function varargout = gui_analyze_data(varargin)
% GUI_ANALYZE_DATA M-file for gui_analyze_data.fig
%      GUI_ANALYZE_DATA, by itself, creates a new GUI_ANALYZE_DATA or raises the existing
%      singleton*.
%
%      H = GUI_ANALYZE_DATA returns the handle to a new GUI_ANALYZE_DATA or the handle to
%      the existing singleton*.
%
%      GUI_ANALYZE_DATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_ANALYZE_DATA.M with the given input arguments.
%
%      GUI_ANALYZE_DATA('Property','Value',...) creates a new GUI_ANALYZE_DATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_analyze_data_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_analyze_data_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_analyze_data

% Last Modified by GUIDE v2.5 16-Jun-2010 09:19:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_analyze_data_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_analyze_data_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui_analyze_data is made visible.
function gui_analyze_data_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_analyze_data (see VARARGIN)

% Choose default command line output for gui_analyze_data
handles.output = hObject;
set(hObject,'Name','Analyze Data');

% find workspace variables
vars = evalin('base','whos;');
varnames = {};
[nv,junk] = size(vars);
nflag = 1;
for i=1:1:nv
    flag = evalin('base',strcat('isfield(',vars(i).name,',''type'')'));
    if flag
        varnames{nflag} = vars(i).name;
        nflag = nflag + 1;
    end
end
if ~isempty(varnames)
    set(handles.variables_mesh,'String',varnames);
end

varnames = {};
nflag = 1;
for i=1:1:nv
    flag = evalin('base',strcat('isfield(',vars(i).name,',''paa'')'));
    flag2 = evalin('base',strcat('isfield(',vars(i).name,',''amplitudefl'')'));
    if flag || flag2
        varnames{nflag} = vars(i).name;
        nflag = nflag + 1;
    end
end
if ~isempty(varnames)
    set(handles.variables_data,'String',varnames);
end

% set axes titles
axes(handles.amplitude)
hold on;
xlabel('Source/Detector Distance');
ylabel('lnrI');
drawnow
axes(handles.phase)
hold on;
xlabel('Source/Detector Distance');
ylabel('Phase');
drawnow

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_analyze_data wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_analyze_data_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in variables_data.
function variables_data_Callback(hObject, eventdata, handles)
% hObject    handle to variables_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns variables_data contents as cell array
%        contents{get(hObject,'Value')} returns selected item from variables_data
contents = get(hObject,'String');
set(handles.data,'String',contents{get(hObject,'Value')});

% load data
loc = get(handles.data,'String');
if isempty(findstr(loc,'/')) && isempty(findstr(loc,'\'))...
        && evalin('base',strcat('exist(''',loc,''',''var'')'))
    handles.datavar = evalin('base',loc);
elseif exist(loc) == 2
    handles.datavar = load_data(loc);
else
    return
end

% update the plots
handles = display_plots(handles);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function variables_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to variables_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function data_Callback(hObject, eventdata, handles)
% hObject    handle to data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of data as text
%        str2double(get(hObject,'String')) returns contents of data as a double

% load data
loc = get(handles.data,'String');
if isempty(findstr(loc,'/')) && isempty(findstr(loc,'\'))...
        && evalin('base',strcat('exist(''',loc,''',''var'')'))
    handles.datavar = evalin('base',loc);
elseif exist(loc) == 2
    handles.datavar = load_data(loc);
else
    return
end

% update the plots
handles = display_plots(handles);

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function savedatato_Callback(hObject, eventdata, handles)
% hObject    handle to savedatato (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of savedatato as text
%        str2double(get(hObject,'String')) returns contents of savedatato as a double


% --- Executes during object creation, after setting all properties.
function savedatato_CreateFcn(hObject, eventdata, handles)
% hObject    handle to savedatato (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in done.
function done_Callback(hObject, eventdata, handles)
% hObject    handle to done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mainGUIhandle = nirfast;
mainGUIdata  = guidata(mainGUIhandle);
content = get(mainGUIdata.script,'String');
batch = get(mainGUIdata.batch_mode,'Value');

dataloc = get_pathloc(get(handles.data,'String'));
meshloc = get_pathloc(get(handles.mesh,'String'));
varname = [mygenvarname(get(handles.data,'String')) '_good'];
tolamp = num2str(100*get(handles.tolerance_amplitude,'Value'));
tolph = num2str(100*get(handles.tolerance_phase,'Value'));

if isempty(get(handles.wavelength,'String'))
    content{end+1} = strcat(varname, ' = analyze_data(',...
        dataloc, ',',meshloc,',',...
        tolamp,',',...
        tolph,',',...
        num2str(get(handles.upper,'Value')),',',...
        num2str(get(handles.lower,'Value')),...
        ');');
else
    content{end+1} = strcat(varname, ' = analyze_data(',...
        dataloc, ',',meshloc,',',...
        '[',num2str(handles.tolampwv*100),'],',...
        '[',num2str(handles.tolphwv*100),'],',...
        '[',num2str(handles.upperwv),'],',...
        '[',num2str(handles.lowerwv),']',...
        ');');
end
if ~batch
    evalin('base',content{end});
end
    
if get(handles.savedatato,'String')
    saveto = get(handles.savedatato,'String');
    if ~canwrite(saveto)
        [junk fn ext1] = fileparts(saveto);
        saveto = [tempdir fn ext1];
        disp(['No write access, writing here instead: ' saveto]);
    end
    
    content{end+1} = strcat('save_data(',varname,','''...
        ,saveto,''');');
    if ~batch
        evalin('base',content{end});
    end
end


set(mainGUIdata.script, 'String', content);
guidata(nirfast, mainGUIdata);
close(gui_analyze_data);


% --- Executes on button press in browse_data.
function browse_data_Callback(hObject, eventdata, handles)
% hObject    handle to browse_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pn] = myuigetfile('*.paa','Input Data');
if fn == 0
    return;
end
set(handles.data,'String',[pn fn]);

% load data
loc = get(handles.data,'String');
if isempty(findstr(loc,'/')) && isempty(findstr(loc,'\'))...
        && evalin('base',strcat('exist(''',loc,''',''var'')'))
    handles.datavar = evalin('base',loc);
elseif exist(loc) == 2
    handles.datavar = load_data(loc);
else
    return
end

% update the plots
handles = display_plots(handles);

guidata(hObject, handles);








% *******************************************
% *******************************************
% *******************************************
% Display the two plots
function handles = display_plots(handles)
% handles    structure with handles and user data (see GUIDATA)


% check if the mesh and data exist to be displayed
if ~isfield(handles,'datavar') || ~isfield(handles,'meshvar')
    return
end

% obtain data constraints
if isempty(get(handles.wavelength,'String'))
    tolamp = get(handles.tolerance_amplitude,'Value');
    tolph = get(handles.tolerance_phase,'Value');
    
    upper = get(handles.upper,'Value');
    lower = get(handles.lower,'Value');
else
    tolamp = handles.tolampwv(get(handles.wavelength,'Value'));
    tolph = handles.tolphwv(get(handles.wavelength,'Value'));
    upper = handles.upperwv(get(handles.wavelength,'Value'));
    lower = handles.lowerwv(get(handles.wavelength,'Value'));
end

% account for how the slider stores values (not as percent)
tolamp = tolamp*100;
tolph = tolph*100;

% set variables
idata = handles.datavar;
mesh = handles.meshvar;

% find data
phasedata = 0;
if isfield(idata,'paa')
    data_big = idata.paa;
    phasedata = 1;
else
    if isfield(idata,'paafl')
        data_big = idata.paafl;
        phasedata = 1;
    else
        data_big = idata.amplitudefl;
    end
end

if phasedata
    i = 2*get(handles.wavelength,'Value')-1;
else
    i = get(handles.wavelength,'Value');
end
    
if phasedata
    data = data_big(:,i:i+1);
else
    data = data_big(:,i);
end

% source/detector distances
dist = zeros(length(mesh.link),1);
for i = 1:length(mesh.link)
    snum = mesh.link(i,1);
    mnum = mesh.link(i,2);
    snum = mesh.source.num == snum;
    mnum = mesh.meas.num == mnum;
    if sum(snum)==0 || sum(mnum)==0
        dist_full(i,1)=0;
        mesh.link(i,3)=0;
    else
        dist_full(i,1) = sqrt(sum((mesh.source.coord(snum,:) - ...
        mesh.meas.coord(mnum,:)).^2,2)); 
    end
end

% get an index from link file of data to actually use
linki = logical(mesh.link(:,3));

% Set lnrI, ph
data_tmp = data(linki,:);
dist = dist_full(linki);
[j,k] = size(data_tmp(:,1));
[j2,k2] = size(dist);
lnrI = log(data_tmp(:,1).*dist);
if phasedata
    ph = data_tmp(:,2);
end

% remove data based on upper and lower bounds (just for the fitting
% here)
lnrI_tmp = lnrI;
if phasedata
    ph_tmp = ph;
end

for k=1:1:j
    if dist(k) > upper || dist(k) < lower
        lnrI_tmp(k)=NaN;
        if phasedata
            ph_tmp(k)=NaN;
        end
    end   
end

% Calculate best fit line
m1 = polyfit(dist(isnan(lnrI_tmp)==0),lnrI(isnan(lnrI_tmp)==0),1);
if phasedata
    m2 = polyfit(dist(isnan(ph_tmp)==0),ph(isnan(ph_tmp)==0),1);
end

lnrI = log(data(:,1).*dist_full);
if phasedata
    ph = data(:,2);
end

% Remove points too far from the line
badpoints_amp = zeros(length(dist_full),1);
badpoints_ph = zeros(length(dist_full),1);
for k=1:1:length(dist_full)
    if abs((lnrI(k) - (m1(1)*dist_full(k)+m1(2)))) > tolamp...
            || dist_full(k) > upper || dist_full(k) < lower
        badpoints_amp(k)=1;
    end
    if phasedata &&...
            (abs((ph(k) - (m2(1)*dist_full(k)+m2(2)))) > tolph...
            || dist_full(k) > upper || dist_full(k) < lower )
        badpoints_ph(k)=1;
    end     
end

% view the data and which were dropped
axes(handles.amplitude)
cla
hold on;
xlabel('Source/Detector Distance');
ylabel('lnrI');
drawnow
bp0 = (badpoints_amp==0).*(~isnan(lnrI));
bp1 = (badpoints_amp==1).*(~isnan(lnrI));
plot(dist_full(bp0==1),lnrI(bp0==1),'b.')
plot(dist_full(bp1==1),lnrI(bp1==1),'r.')
x=min(dist_full):max(dist_full)-min(dist_full):max(dist_full);
plot(x,m1(1)*x+m1(2))
hold off;

axes(handles.phase)
cla
hold on;
xlabel('Source/Detector Distance');
ylabel('Phase');
drawnow
bp0 = (badpoints_ph==0).*(~isnan(lnrI));
bp1 = (badpoints_ph==1).*(~isnan(lnrI));
plot(dist_full(bp0==1),ph(bp0==1),'b.')
plot(dist_full(bp1==1),ph(bp1==1),'r.')
x=min(dist_full):max(dist_full)-min(dist_full):max(dist_full);
plot(x,m2(1)*x+m2(2))
hold off;

drawnow
pause(0.001)
datacursormode on

% *******************************************
% *******************************************
% *******************************************










% --- Executes on slider movement.
function tolerance_amplitude_Callback(hObject, eventdata, handles)
% hObject    handle to tolerance_amplitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.tolerance_amplitude_text,'String',num2str(round(100*get(hObject,'Value'))));
if ~isempty(get(handles.wavelength,'String'))
    handles.tolampwv(get(handles.wavelength,'Value')) = get(hObject,'Value');
end

handles = display_plots(handles);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function tolerance_amplitude_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tolerance_amplitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function tolerance_phase_Callback(hObject, eventdata, handles)
% hObject    handle to tolerance_phase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.tolerance_phase_text,'String',num2str(round(100*get(hObject,'Value'))));
if ~isempty(get(handles.wavelength,'String'))
    handles.tolphwv(get(handles.wavelength,'Value')) = get(hObject,'Value');
end

handles = display_plots(handles);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function tolerance_phase_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tolerance_phase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in browse_savedatato.
function browse_savedatato_Callback(hObject, eventdata, handles)
% hObject    handle to browse_savedatato (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pn] = myuiputfile('*.paa','Save Data To');
if fn == 0
    return;
end
set(handles.savedatato,'String',[pn fn]);

guidata(hObject, handles);



function tolerance_amplitude_text_Callback(hObject, eventdata, handles)
% hObject    handle to tolerance_amplitude_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tolerance_amplitude_text as text
%        str2double(get(hObject,'String')) returns contents of tolerance_amplitude_text as a double
set(handles.tolerance_amplitude,'Value',0.01*str2num(get(hObject,'String')));
if ~isempty(get(handles.wavelength,'String'))
    handles.tolampwv(get(handles.wavelength,'Value')) = 0.01*str2num(get(hObject,'String'));
end

handles = display_plots(handles);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function tolerance_amplitude_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tolerance_amplitude_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tolerance_phase_text_Callback(hObject, eventdata, handles)
% hObject    handle to tolerance_phase_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tolerance_phase_text as text
%        str2double(get(hObject,'String')) returns contents of tolerance_phase_text as a double
set(handles.tolerance_phase,'Value',0.01*str2num(get(hObject,'String')));
if ~isempty(get(handles.wavelength,'String'))
    handles.tolphwv(get(handles.wavelength,'Value')) = 0.01*str2num(get(hObject,'String'));
end

handles = display_plots(handles);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function tolerance_phase_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tolerance_phase_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in variables_mesh.
function variables_mesh_Callback(hObject, eventdata, handles)
% hObject    handle to variables_mesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns variables_mesh contents as cell array
%        contents{get(hObject,'Value')} returns selected item from variables_mesh
contents = get(hObject,'String');
set(handles.mesh,'String',contents{get(hObject,'Value')});

% load the mesh
loc = get(handles.mesh,'String');
if isempty(findstr(loc,'/')) && isempty(findstr(loc,'\'))...
        && evalin('base',strcat('exist(''',loc,''',''var'')'))
    handles.meshvar = evalin('base',loc);
elseif exist([loc '.node']) == 2
    handles.meshvar = load_mesh(loc);
else
    return
end

% update upper and lower bounds
mesh = handles.meshvar;
k=1;
[ns,junk]=size(mesh.source.coord);
for i = 1 : ns
  for j = 1 : length(mesh.link(i,:))
    if mesh.link(i,j) ~= 0
      jj = mesh.link(i,j);
      dist(k,1) = sqrt(sum((mesh.source.coord(i,:) - ...
                mesh.meas.coord(jj,:)).^2));
        k = k+1;
    end
  end
end
set(handles.upper,'Max',max(dist));
set(handles.lower,'Max',max(dist));
set(handles.upper,'Min',min(dist));
set(handles.lower,'Min',min(dist));
set(handles.upper,'Value',max(dist));
set(handles.lower,'Value',min(dist));
set(handles.upper_text,'String',num2str(round(get(handles.upper,'Value'))));
set(handles.lower_text,'String',num2str(round(get(handles.lower,'Value'))));

% update wavelengths
if isfield(mesh,'wv')
    varnames = num2cell(mesh.wv);
    if ~isempty(varnames)
        set(handles.wavelength,'String',varnames);
    end

    handles.upperwv = zeros(1,size(get(handles.wavelength,'String'),1));
    handles.lowerwv = zeros(1,size(get(handles.wavelength,'String'),1));
    handles.tolampwv = zeros(1,size(get(handles.wavelength,'String'),1));
    handles.tolphwv = zeros(1,size(get(handles.wavelength,'String'),1));
    handles.tolampwv(:) = 0.2;
    handles.tolphwv(:) = 0.2;
    handles.upperwv(:) = max(dist);
    handles.lowerwv(:) = min(dist);
end

% update the plots
handles = display_plots(handles);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function variables_mesh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to variables_mesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mesh_Callback(hObject, eventdata, handles)
% hObject    handle to mesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mesh as text
%        str2double(get(hObject,'String')) returns contents of mesh as a
%        double

% load the mesh
loc = get(handles.mesh,'String');
if isempty(findstr(loc,'/')) && isempty(findstr(loc,'\'))...
        && evalin('base',strcat('exist(''',loc,''',''var'')'))
    handles.meshvar = evalin('base',loc);
elseif exist([loc '.node']) == 2
    handles.meshvar = load_mesh(loc);
else
    return
end

% update upper and lower bounds
mesh = handles.meshvar;
k=1;
[ns,junk]=size(mesh.source.coord);
for i = 1 : ns
  for j = 1 : length(mesh.link(i,:))
    if mesh.link(i,j) ~= 0
      jj = mesh.link(i,j);
      dist(k,1) = sqrt(sum((mesh.source.coord(i,:) - ...
                mesh.meas.coord(jj,:)).^2));
        k = k+1;
    end
  end
end
set(handles.upper,'Max',max(dist));
set(handles.lower,'Max',max(dist));
set(handles.upper,'Min',min(dist));
set(handles.lower,'Min',min(dist));
set(handles.upper,'Value',max(dist));
set(handles.lower,'Value',min(dist));
set(handles.upper_text,'String',num2str(round(get(handles.upper,'Value'))));
set(handles.lower_text,'String',num2str(round(get(handles.lower,'Value'))));

% update wavelengths
if isfield(mesh,'wv')
    varnames = num2cell(mesh.wv);
    if ~isempty(varnames)
        set(handles.wavelength,'String',varnames);
    end

    handles.upperwv = zeros(1,size(get(handles.wavelength,'String'),1));
    handles.lowerwv = zeros(1,size(get(handles.wavelength,'String'),1));
    handles.tolampwv = zeros(1,size(get(handles.wavelength,'String'),1));
    handles.tolphwv = zeros(1,size(get(handles.wavelength,'String'),1));
    handles.tolampwv(:) = 0.2;
    handles.tolphwv(:) = 0.2;
    handles.upperwv(:) = max(dist);
    handles.lowerwv(:) = min(dist);
end

% update the plots
handles = display_plots(handles);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function mesh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browse_mesh.
function browse_mesh_Callback(hObject, eventdata, handles)
% hObject    handle to browse_mesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pn] = myuigetfile('*.node','Input Mesh');
if fn == 0
    return;
end
temp = [pn fn];
set(handles.mesh,'String',temp(1:end-5));

% load the mesh
loc = get(handles.mesh,'String');
if isempty(findstr(loc,'/')) && isempty(findstr(loc,'\'))...
        && evalin('base',strcat('exist(''',loc,''',''var'')'))
    handles.meshvar = evalin('base',loc);
elseif exist([loc '.node']) == 2
    handles.meshvar = load_mesh(loc);
else
    return
end

% update upper and lower bounds
mesh = handles.meshvar;
k=1;
[ns,junk]=size(mesh.source.coord);
for i = 1 : ns
  for j = 1 : length(mesh.link(i,:))
    if mesh.link(i,j) ~= 0
      jj = mesh.link(i,j);
      dist(k,1) = sqrt(sum((mesh.source.coord(i,:) - ...
                mesh.meas.coord(jj,:)).^2));
        k = k+1;
    end
  end
end
set(handles.upper,'Max',max(dist));
set(handles.lower,'Max',max(dist));
set(handles.upper,'Min',min(dist));
set(handles.lower,'Min',min(dist));
set(handles.upper,'Value',max(dist));
set(handles.lower,'Value',min(dist));
set(handles.upper_text,'String',num2str(round(get(handles.upper,'Value'))));
set(handles.lower_text,'String',num2str(round(get(handles.lower,'Value'))));

% update wavelengths
if isfield(mesh,'wv')
    varnames = num2cell(mesh.wv);
    if ~isempty(varnames)
        set(handles.wavelength,'String',varnames);
    end

    handles.upperwv = zeros(1,size(get(handles.wavelength,'String'),1));
    handles.lowerwv = zeros(1,size(get(handles.wavelength,'String'),1));
    handles.tolampwv = zeros(1,size(get(handles.wavelength,'String'),1));
    handles.tolphwv = zeros(1,size(get(handles.wavelength,'String'),1));
    handles.tolampwv(:) = 0.2;
    handles.tolphwv(:) = 0.2;
    handles.upperwv(:) = max(dist);
    handles.lowerwv(:) = min(dist);
end

% update the plots
handles = display_plots(handles);

guidata(hObject, handles);


% --- Executes on selection change in wavelength.
function wavelength_Callback(hObject, eventdata, handles)
% hObject    handle to wavelength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns wavelength contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        wavelength

% set wavelength specific tolerances and bounds
set(handles.tolerance_amplitude,'Value',handles.tolampwv(get(handles.wavelength,'Value')));
set(handles.tolerance_amplitude_text,'String',...
    num2str(round(100*handles.tolampwv(get(handles.wavelength,'Value')))));

set(handles.tolerance_phase,'Value',handles.tolphwv(get(handles.wavelength,'Value')));
set(handles.tolerance_phase_text,'String',...
    num2str(round(100*handles.tolphwv(get(handles.wavelength,'Value')))));

set(handles.upper,'Value',handles.upperwv(get(handles.wavelength,'Value')));
set(handles.upper_text,'String',...
    num2str(round(handles.upperwv(get(handles.wavelength,'Value')))));

set(handles.lower,'Value',handles.lowerwv(get(handles.wavelength,'Value')));
set(handles.lower_text,'String',...
    num2str(round(handles.lowerwv(get(handles.wavelength,'Value')))));


handles = display_plots(handles);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function wavelength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wavelength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function lower_Callback(hObject, eventdata, handles)
% hObject    handle to lower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.lower_text,'String',num2str(round(get(hObject,'Value'))));
if ~isempty(get(handles.wavelength,'String'))
    handles.lowerwv(get(handles.wavelength,'Value')) = get(hObject,'Value');
end

handles = display_plots(handles);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function lower_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function lower_text_Callback(hObject, eventdata, handles)
% hObject    handle to lower_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lower_text as text
%        str2double(get(hObject,'String')) returns contents of lower_text as a double
set(handles.lower,'Value',str2num(get(hObject,'String')));
if ~isempty(get(handles.wavelength,'String'))
    handles.lowerwv(get(handles.wavelength,'Value')) = str2num(get(hObject,'String'));
end

handles = display_plots(handles);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function lower_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lower_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function upper_Callback(hObject, eventdata, handles)
% hObject    handle to upper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.upper_text,'String',num2str(round(get(hObject,'Value'))));
if ~isempty(get(handles.wavelength,'String'))
    handles.upperwv(get(handles.wavelength,'Value')) = get(hObject,'Value');
end

handles = display_plots(handles);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function upper_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function upper_text_Callback(hObject, eventdata, handles)
% hObject    handle to upper_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of upper_text as text
%        str2double(get(hObject,'String')) returns contents of upper_text as a double
set(handles.upper,'Value',str2num(get(hObject,'String')));
if ~isempty(get(handles.wavelength,'String'))
    handles.upperwv(get(handles.wavelength,'Value')) = str2num(get(hObject,'String'));
end

handles = display_plots(handles);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function upper_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upper_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
