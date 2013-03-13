function varargout = gui_calibrate(varargin)
% GUI_CALIBRATE M-file for gui_calibrate.fig
%      GUI_CALIBRATE, by itself, creates a new GUI_CALIBRATE or raises the existing
%      singleton*.
%
%      H = GUI_CALIBRATE returns the handle to a new GUI_CALIBRATE or the handle to
%      the existing singleton*.
%
%      GUI_CALIBRATE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CALIBRATE.M with the given input arguments.
%
%      GUI_CALIBRATE('Property','Value',...) creates a new GUI_CALIBRATE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_calibrate_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_calibrate_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_calibrate

% Last Modified by GUIDE v2.5 13-Mar-2013 09:31:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_calibrate_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_calibrate_OutputFcn, ...
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


% --- Executes just before gui_calibrate is made visible.
function gui_calibrate_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_calibrate (see VARARGIN)

% Choose default command line output for gui_calibrate
handles.output = hObject;
set(hObject,'Name','Calibrate Data');
if(nargin > 3)
    for index = 1:2:(nargin-3),
        if nargin-3==index, break, end
        switch lower(varargin{index})
         case 'type'
         handles.type = varargin{index+1};
        end
    end
end

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
    set(handles.variables_hmesh,'String',varnames);
    set(handles.variables_amesh,'String',varnames);
end

varnames = {};
nflag = 1;
for i=1:1:nv
    flag = evalin('base',strcat('isfield(',vars(i).name,',''paa'')'));
    if flag
        varnames{nflag} = vars(i).name;
        nflag = nflag + 1;
    end
end
if ~isempty(varnames)
    set(handles.variables_hdata,'String',varnames);
    set(handles.variables_adata,'String',varnames);
end

% find alternative calibration methods
calibrate_loc = what('calibrate');
if strcmp(handles.type,'stnd')
    mytype = 'stnd';
elseif strcmp(handles.type,'spec')
    mytype = 'spectral';
end
calibrates = dir([calibrate_loc.path '/calibrate_' mytype '*']);
varnames = {};
for i=1:size(calibrates)
    varnames{i} = calibrates(i).name(11:end-2);
end
set(handles.method,'String',varnames);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_calibrate wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_calibrate_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function hmesh_Callback(hObject, eventdata, handles)
% hObject    handle to hmesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hmesh as text
%        str2double(get(hObject,'String')) returns contents of hmesh as a double


% --- Executes during object creation, after setting all properties.
function hmesh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hmesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function amesh_Callback(hObject, eventdata, handles)
% hObject    handle to amesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of amesh as text
%        str2double(get(hObject,'String')) returns contents of amesh as a double


% --- Executes during object creation, after setting all properties.
function amesh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hdata_Callback(hObject, eventdata, handles)
% hObject    handle to hdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hdata as text
%        str2double(get(hObject,'String')) returns contents of hdata as a double


% --- Executes during object creation, after setting all properties.
function hdata_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function adata_Callback(hObject, eventdata, handles)
% hObject    handle to adata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of adata as text
%        str2double(get(hObject,'String')) returns contents of adata as a double


% --- Executes during object creation, after setting all properties.
function adata_CreateFcn(hObject, eventdata, handles)
% hObject    handle to adata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function savemeshto_Callback(hObject, eventdata, handles)
% hObject    handle to savemeshto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of savemeshto as text
%        str2double(get(hObject,'String')) returns contents of savemeshto as a double


% --- Executes during object creation, after setting all properties.
function savemeshto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to savemeshto (see GCBO)
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



function frequency_Callback(hObject, eventdata, handles)
% hObject    handle to frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frequency as text
%        str2double(get(hObject,'String')) returns contents of frequency as a double


% --- Executes during object creation, after setting all properties.
function frequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function iterations_Callback(hObject, eventdata, handles)
% hObject    handle to iterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of iterations as text
%        str2double(get(hObject,'String')) returns contents of iterations as a double


% --- Executes during object creation, after setting all properties.
function iterations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iterations (see GCBO)
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

hdataloc = get_pathloc(get(handles.hdata,'String'));
adataloc = get_pathloc(get(handles.adata,'String'));
hmeshloc = get_pathloc(get(handles.hmesh,'String'));
ameshloc = get_pathloc(get(handles.amesh,'String'));

% find calibration method
calibrates = get(handles.method,'String');
calibrate = calibrates(get(handles.method,'Value'));

if get(handles.viewdata,'Value') == 1
    nographs = '0';
else
    nographs = '1';
end

if strcmp(handles.type,'stnd')
    content{end+1} = strcat('[data_cal,mesh_cal]=calibrate_',calibrate{1},'(', hdataloc,...
            ',', adataloc,',', hmeshloc,',', ameshloc,...
            ',', get(handles.frequency,'String'),...
            ',', get(handles.iterations,'String'),...
            ',', nographs,');');
else
    content{end+1} = strcat('[data_cal,mesh_cal]=calibrate_',calibrate{1},'(', hdataloc,...
            ',', adataloc,',', hmeshloc,',', ameshloc,...
            ',', get(handles.frequency,'String'),...
            ',', get(handles.iterations,'String'),...
            ',', nographs,');');
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
    
    content{end+1} = strcat('save_data(data_cal,''',...
        saveto,''');');
    if ~batch
        evalin('base',content{end});
    end
end
if get(handles.savemeshto,'String')
    saveto = get(handles.savemeshto,'String');
    if ~canwrite(saveto)
        [junk fn ext1] = fileparts(saveto);
        saveto = [tempdir fn ext1];
        disp(['No write access, writing here instead: ' saveto]);
    end
    
    content{end+1} = strcat('save_mesh(mesh_cal,''',...
        saveto,''');');
    if ~batch
        evalin('base',content{end});
    end
end


set(mainGUIdata.script, 'String', content);
guidata(nirfast, mainGUIdata);
close(gui_calibrate);


% --- Executes on button press in browse_hmesh.
function browse_hmesh_Callback(hObject, eventdata, handles)
% hObject    handle to browse_hmesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pn] = myuigetfile('*.node','Input Homogeneous Mesh');
if fn == 0
    return;
end
temp = [pn fn];
set(handles.hmesh,'String',temp(1:end-5));

guidata(hObject, handles);


% --- Executes on button press in browse_amesh.
function browse_amesh_Callback(hObject, eventdata, handles)
% hObject    handle to browse_amesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pn] = myuigetfile('*.node','Input Anomaly Mesh');
if fn == 0
    return;
end
temp = [pn fn];
set(handles.amesh,'String',temp(1:end-5));

guidata(hObject, handles);


% --- Executes on button press in browse_hdata.
function browse_hdata_Callback(hObject, eventdata, handles)
% hObject    handle to browse_hdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pn] = myuigetfile('*.paa','Input Homogeneous Data');
if fn == 0
    return;
end
set(handles.hdata,'String',[pn fn]);

guidata(hObject, handles);


% --- Executes on button press in browse_adata.
function browse_adata_Callback(hObject, eventdata, handles)
% hObject    handle to browse_adata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pn] = myuigetfile('*.paa','Input Anomaly Data');
if fn == 0
    return;
end
set(handles.adata,'String',[pn fn]);

guidata(hObject, handles);


% --- Executes on button press in browse_savemeshto.
function browse_savemeshto_Callback(hObject, eventdata, handles)
% hObject    handle to browse_savemeshto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pn] = myuiputfile('','Save Mesh To');
if fn == 0
    return;
end
set(handles.savemeshto,'String',[pn fn]);

guidata(hObject, handles);


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



function wv_array_Callback(hObject, eventdata, handles)
% hObject    handle to wv_array (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wv_array as text
%        str2double(get(hObject,'String')) returns contents of wv_array as a double


% --- Executes during object creation, after setting all properties.
function wv_array_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wv_array (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in variables_hmesh.
function variables_hmesh_Callback(hObject, eventdata, handles)
% hObject    handle to variables_hmesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns variables_hmesh contents as cell array
%        contents{get(hObject,'Value')} returns selected item from variables_hmesh
contents = get(hObject,'String');
set(handles.hmesh,'String',contents{get(hObject,'Value')});


% --- Executes during object creation, after setting all properties.
function variables_hmesh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to variables_hmesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in variables_adata.
function variables_adata_Callback(hObject, eventdata, handles)
% hObject    handle to variables_adata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns variables_adata contents as cell array
%        contents{get(hObject,'Value')} returns selected item from variables_adata
contents = get(hObject,'String');
set(handles.adata,'String',contents{get(hObject,'Value')});


% --- Executes during object creation, after setting all properties.
function variables_adata_CreateFcn(hObject, eventdata, handles)
% hObject    handle to variables_adata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in variables_hdata.
function variables_hdata_Callback(hObject, eventdata, handles)
% hObject    handle to variables_hdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns variables_hdata contents as cell array
%        contents{get(hObject,'Value')} returns selected item from variables_hdata
contents = get(hObject,'String');
set(handles.hdata,'String',contents{get(hObject,'Value')});


% --- Executes during object creation, after setting all properties.
function variables_hdata_CreateFcn(hObject, eventdata, handles)
% hObject    handle to variables_hdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in variables_amesh.
function variables_amesh_Callback(hObject, eventdata, handles)
% hObject    handle to variables_amesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns variables_amesh contents as cell array
%        contents{get(hObject,'Value')} returns selected item from variables_amesh
contents = get(hObject,'String');
set(handles.amesh,'String',contents{get(hObject,'Value')});


% --- Executes during object creation, after setting all properties.
function variables_amesh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to variables_amesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in viewdata.
function viewdata_Callback(hObject, eventdata, handles)
% hObject    handle to viewdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of viewdata


% --- Executes on selection change in method.
function method_Callback(hObject, eventdata, handles)
% hObject    handle to method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from method


% --- Executes during object creation, after setting all properties.
function method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
