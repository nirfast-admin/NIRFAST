function varargout = gui_create_mesh_circ(varargin)
% GUI_CREATE_MESH_CIRC M-file for gui_create_mesh_circ.fig
%      GUI_CREATE_MESH_CIRC, by itself, creates a new GUI_CREATE_MESH_CIRC or raises the existing
%      singleton*.
%
%      H = GUI_CREATE_MESH_CIRC returns the handle to a new GUI_CREATE_MESH_CIRC or the handle to
%      the existing singleton*.
%
%      GUI_CREATE_MESH_CIRC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CREATE_MESH_CIRC.M with the given input arguments.
%
%      GUI_CREATE_MESH_CIRC('Property','Value',...) creates a new GUI_CREATE_MESH_CIRC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_create_mesh_circ_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_create_mesh_circ_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_create_mesh_circ

% Last Modified by GUIDE v2.5 30-Jul-2009 09:11:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_create_mesh_circ_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_create_mesh_circ_OutputFcn, ...
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


% --- Executes just before gui_create_mesh_circ is made visible.
function gui_create_mesh_circ_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_create_mesh_circ (see VARARGIN)

% Choose default command line output for gui_create_mesh_circ
handles.output = hObject;
set(hObject,'Name','Create Mesh');
if(nargin > 3)
    for index = 1:2:(nargin-3),
        if nargin-3==index, break, end
        switch lower(varargin{index})
         case 'type'
         handles.type = varargin{index+1};
        end
    end
end

% Modify GUI based on type
if strcmp(handles.type,'circle')
    set(handles.zcenter,'Enable','off');
    set(handles.hres,'Enable','off');
    set(handles.phires,'Enable','off');
    set(handles.height,'Enable','off');
elseif strcmp(handles.type,'cylinder')
    set(handles.phires,'Enable','off');
elseif strcmp(handles.type,'sphere')
    set(handles.hres,'Enable','off');
    set(handles.hres,'Enable','off');
    set(handles.height,'Enable','off');
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_create_mesh_circ wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_create_mesh_circ_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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



function xcenter_Callback(hObject, eventdata, handles)
% hObject    handle to xcenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xcenter as text
%        str2double(get(hObject,'String')) returns contents of xcenter as a double


% --- Executes during object creation, after setting all properties.
function xcenter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xcenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ycenter_Callback(hObject, eventdata, handles)
% hObject    handle to ycenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ycenter as text
%        str2double(get(hObject,'String')) returns contents of ycenter as a double


% --- Executes during object creation, after setting all properties.
function ycenter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ycenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zcenter_Callback(hObject, eventdata, handles)
% hObject    handle to zcenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zcenter as text
%        str2double(get(hObject,'String')) returns contents of zcenter as a double


% --- Executes during object creation, after setting all properties.
function zcenter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zcenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function radius_Callback(hObject, eventdata, handles)
% hObject    handle to radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of radius as text
%        str2double(get(hObject,'String')) returns contents of radius as a double


% --- Executes during object creation, after setting all properties.
function radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function height_Callback(hObject, eventdata, handles)
% hObject    handle to height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of height as text
%        str2double(get(hObject,'String')) returns contents of height as a double


% --- Executes during object creation, after setting all properties.
function height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rres_Callback(hObject, eventdata, handles)
% hObject    handle to rres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rres as text
%        str2double(get(hObject,'String')) returns contents of rres as a double


% --- Executes during object creation, after setting all properties.
function rres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hres_Callback(hObject, eventdata, handles)
% hObject    handle to hres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hres as text
%        str2double(get(hObject,'String')) returns contents of hres as a double


% --- Executes during object creation, after setting all properties.
function hres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function phires_Callback(hObject, eventdata, handles)
% hObject    handle to phires (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of phires as text
%        str2double(get(hObject,'String')) returns contents of phires as a double


% --- Executes during object creation, after setting all properties.
function phires_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phires (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thres_Callback(hObject, eventdata, handles)
% hObject    handle to thres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thres as text
%        str2double(get(hObject,'String')) returns contents of thres as a double


% --- Executes during object creation, after setting all properties.
function thres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thres (see GCBO)
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

% CIRCLE
if strcmp(handles.type,'circle')
    content{end+1} = strcat('mesh = make_circle(',...
        get(handles.xcenter,'String'),',',...
        get(handles.ycenter,'String'),',',...
        get(handles.radius,'String'),',',...
        get(handles.rres,'String'),',',...
        get(handles.thres,'String'),');');
    if ~batch
        evalin('base',content{end});
    end
   
% CYLINDER
elseif strcmp(handles.type,'cylinder')
    content{end+1} = strcat('mesh = make_cylinder(',...
        get(handles.xcenter,'String'),',',...
        get(handles.ycenter,'String'),',',...
        get(handles.zcenter,'String'),',',...
        get(handles.radius,'String'),',',...
        get(handles.height,'String'),',',...
        get(handles.rres,'String'),',',...
        get(handles.thres,'String'),',',...
        get(handles.hres,'String'),');');
    if ~batch
        evalin('base',content{end});
    end
    
% SPHERE
elseif strcmp(handles.type,'sphere')
    content{end+1} = strcat('mesh = make_sphere(',...
        get(handles.xcenter,'String'),',',...
        get(handles.ycenter,'String'),',',...
        get(handles.zcenter,'String'),',',...
        get(handles.radius,'String'),',',...
        get(handles.rres,'String'),',',...
        get(handles.thres,'String'),',',...
        get(handles.phires,'String'),');');
    if ~batch
        evalin('base',content{end});
    end
end

% FOR ALL TYPES
if get(handles.savemeshto,'String')
    content{end+1} = strcat('save_mesh(mesh,''',...
        get(handles.savemeshto,'String'),''');');
    if ~batch
        evalin('base',content{end});
    end
end

set(mainGUIdata.script, 'String', content);
guidata(nirfast, mainGUIdata);
close(gui_create_mesh_circ);


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


