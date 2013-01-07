function varargout = gui_create_mesh_3D_volume(varargin)
% GUI_CREATE_MESH_3D_VOLUME M-file for gui_create_mesh_3D_volume.fig
%      GUI_CREATE_MESH_3D_VOLUME, by itself, creates a new GUI_CREATE_MESH_3D_VOLUME or raises the existing
%      singleton*.
%
%      H = GUI_CREATE_MESH_3D_VOLUME returns the handle to a new GUI_CREATE_MESH_3D_VOLUME or the handle to
%      the existing singleton*.
%
%      GUI_CREATE_MESH_3D_VOLUME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CREATE_MESH_3D_VOLUME.M with the given input arguments.
%
%      GUI_CREATE_MESH_3D_VOLUME('Property','Value',...) creates a new GUI_CREATE_MESH_3D_VOLUME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_create_mesh_3D_volume_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_create_mesh_3D_volume_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_create_mesh_3D_volume

% Last Modified by GUIDE v2.5 28-Feb-2012 16:45:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_create_mesh_3D_volume_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_create_mesh_3D_volume_OutputFcn, ...
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


% --- Executes just before gui_create_mesh_3D_volume is made visible.
function gui_create_mesh_3D_volume_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_create_mesh_3D_volume (see VARARGIN)

% Choose default command line output for gui_create_mesh_3D_volume
handles.output = hObject;
if(nargin > 3)
    for index = 1:2:(nargin-3),
        if nargin-3==index, break, end
        switch lower(varargin{index})
         case 'type'
         handles.type = varargin{index+1};
        end
    end
end
set(hObject,'Name','Convert volume mesh');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_create_mesh_3D_volume wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_create_mesh_3D_volume_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function ele_Callback(hObject, eventdata, handles)
% hObject    handle to ele (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ele as text
%        str2double(get(hObject,'String')) returns contents of ele as a double


% --- Executes during object creation, after setting all properties.
function ele_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ele (see GCBO)
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


% --- Executes on button press in done.
function done_Callback(hObject, eventdata, handles)
% hObject    handle to done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mainGUIhandle = nirfast;
mainGUIdata  = guidata(mainGUIhandle);
content = get(mainGUIdata.script,'String');
batch = get(mainGUIdata.batch_mode,'Value');

eleloc = strcat('''',get(handles.ele,'String'),'''');

savemeshto = get(handles.savemeshto,'String');
if isempty(savemeshto)
    [junk1 fn1] = fileparts(eleloc);
    savemeshto = [fn1 '-2-nirfast-' handles.type];
    set(handles.savemeshto,'String',savemeshto);
end

savemeshto = getfullpath(savemeshto);

if ~canwrite(savemeshto)
    [junk fn ext1] = fileparts(savemeshto);
    savemeshto = [tempdir fn ext1];
    disp(['No write access, writing here instead: ' savemeshto]);
end

content{end+1} = strcat('solidmesh2nirfast(',eleloc,',''',savemeshto,...
    ''',''',handles.type,'''');
if isempty(get(handles.sdfile_name,'String'))
    content{end} = strcat(content{end},');');
else
    content{end} = strcat(content{end},',''',get(handles.sdfile_name,'String'),''');');
end

if ~batch
    evalin('base',content{end});
end

set(mainGUIdata.script, 'String', content);
guidata(nirfast, mainGUIdata);
if isempty(get(handles.sdfile_name,'String'))
    gui_place_sources_detectors('mesh',savemeshto);
end
close(gui_create_mesh_3D_volume);


% --- Executes on button press in browse_ele.
function browse_ele_Callback(hObject, eventdata, handles)
% hObject    handle to browse_ele (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pn] = myuigetfile({'*.ele;*.mesh;*.vtk;*.inp','Solid Mesh Files';...
    '*.ele','.ele';'*.mesh','.mesh';'*.vtk','.vtk';'*.inp','.inp'},'Select Mesh File');
if fn == 0
    return;
end
temp = [pn fn];
set(handles.ele,'String',temp);

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
temp = [pn fn];
set(handles.savemeshto,'String',temp);

guidata(hObject, handles);



function sdfile_name_Callback(hObject, eventdata, handles)
% hObject    handle to sdfile_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sdfile_name as text
%        str2double(get(hObject,'String')) returns contents of sdfile_name as a double


% --- Executes during object creation, after setting all properties.
function sdfile_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sdfile_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browse_fiducials.
function browse_fiducials_Callback(hObject, eventdata, handles)
% hObject    handle to browse_fiducials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pn] = myuigetfile({'*.csv;*.txt'},'Select Source/Detector coordinates file');
if fn == 0
    return;
end
temp = [pn fn];
set(handles.sdfile_name,'String',temp);

guidata(hObject, handles);
