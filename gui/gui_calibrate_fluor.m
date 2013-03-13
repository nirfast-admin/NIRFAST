function varargout = gui_calibrate_fluor(varargin)
% GUI_CALIBRATE_FLUOR M-file for gui_calibrate_fluor.fig
%      GUI_CALIBRATE_FLUOR, by itself, creates a new GUI_CALIBRATE_FLUOR or raises the existing
%      singleton*.
%
%      H = GUI_CALIBRATE_FLUOR returns the handle to a new GUI_CALIBRATE_FLUOR or the handle to
%      the existing singleton*.
%
%      GUI_CALIBRATE_FLUOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CALIBRATE_FLUOR.M with the given input arguments.
%
%      GUI_CALIBRATE_FLUOR('Property','Value',...) creates a new GUI_CALIBRATE_FLUOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_calibrate_fluor_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_calibrate_fluor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_calibrate_fluor

% Last Modified by GUIDE v2.5 13-Mar-2013 09:49:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_calibrate_fluor_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_calibrate_fluor_OutputFcn, ...
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


% --- Executes just before gui_calibrate_fluor is made visible.
function gui_calibrate_fluor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_calibrate_fluor (see VARARGIN)

% Choose default command line output for gui_calibrate_fluor
handles.output = hObject;
set(hObject,'Name','Calibrate Data');

% find workspace variables
vars = evalin('base','whos;');
varnames = {};
[nv,junk] = size(vars);
nflag = 1;
for i=1:1:nv
    flag = evalin('base',strcat('isfield(',vars(i).name,',''type'')'));
    if flag && strcmp('fluor',evalin('base',strcat(vars(i).name,'.type')))
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
    flag = evalin('base',strcat('isfield(',vars(i).name,',''amplitudex'')'));
    if flag
        varnames{nflag} = vars(i).name;
        nflag = nflag + 1;
    end
end
if ~isempty(varnames)
    set(handles.variables_data,'String',varnames);
end

% find alternative calibration methods
calibrate_loc = what('calibrate');
calibrates = dir([calibrate_loc.path '/calibrate_fl*']);
varnames = {};
for i=1:size(calibrates)
    varnames{i} = calibrates(i).name(11:end-2);
end
set(handles.method,'String',varnames);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_calibrate_fluor wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_calibrate_fluor_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on selection change in variables_mesh.
function variables_mesh_Callback(hObject, eventdata, handles)
% hObject    handle to variables_mesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns variables_mesh contents as cell array
%        contents{get(hObject,'Value')} returns selected item from variables_mesh
contents = get(hObject,'String');
set(handles.mesh,'String',contents{get(hObject,'Value')});


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
%        str2double(get(hObject,'String')) returns contents of mesh as a double


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



function data_Callback(hObject, eventdata, handles)
% hObject    handle to data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of data as text
%        str2double(get(hObject,'String')) returns contents of data as a double


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

% find calibration method
calibrates = get(handles.method,'String');
calibrate = calibrates(get(handles.method,'Value'));

content{end+1} = strcat('[data_cal,mesh_cal]=calibrate_',calibrate{1},'(', meshloc,...
        ',', dataloc, ',', get(handles.frequency,'String'),',',...
        get(handles.iterations,'String'),',',get(handles.tolerance,'String'),');');

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
close(gui_calibrate_fluor);


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

guidata(hObject, handles);


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

guidata(hObject, handles);



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



function tolerance_Callback(hObject, eventdata, handles)
% hObject    handle to tolerance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tolerance as text
%        str2double(get(hObject,'String')) returns contents of tolerance as a double


% --- Executes during object creation, after setting all properties.
function tolerance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tolerance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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
