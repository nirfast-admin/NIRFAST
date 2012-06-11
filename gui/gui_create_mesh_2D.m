function varargout = gui_create_mesh_2D(varargin)
% GUI_CREATE_MESH_2D M-file for gui_create_mesh_2D.fig
%      GUI_CREATE_MESH_2D, by itself, creates a new GUI_CREATE_MESH_2D or raises the existing
%      singleton*.
%
%      H = GUI_CREATE_MESH_2D returns the handle to a new GUI_CREATE_MESH_2D or the handle to
%      the existing singleton*.
%
%      GUI_CREATE_MESH_2D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CREATE_MESH_2D.M with the given input arguments.
%
%      GUI_CREATE_MESH_2D('Property','Value',...) creates a new GUI_CREATE_MESH_2D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_create_mesh_2D_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_create_mesh_2D_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_create_mesh_2D

% Last Modified by GUIDE v2.5 28-May-2010 12:41:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_create_mesh_2D_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_create_mesh_2D_OutputFcn, ...
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


% --- Executes just before gui_create_mesh_2D is made visible.
function gui_create_mesh_2D_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_create_mesh_2D (see VARARGIN)

% Choose default command line output for gui_create_mesh_2D
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
set(hObject,'Name','2D Mask to Mesh');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_create_mesh_2D wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_create_mesh_2D_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function bmp_Callback(hObject, eventdata, handles)
% hObject    handle to bmp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bmp as text
%        str2double(get(hObject,'String')) returns contents of bmp as a double


% --- Executes during object creation, after setting all properties.
function bmp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bmp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pixel_Callback(hObject, eventdata, handles)
% hObject    handle to pixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pixel as text
%        str2double(get(hObject,'String')) returns contents of pixel as a double


% --- Executes during object creation, after setting all properties.
function pixel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edge_Callback(hObject, eventdata, handles)
% hObject    handle to edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edge as text
%        str2double(get(hObject,'String')) returns contents of edge as a double


% --- Executes during object creation, after setting all properties.
function edge_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function triangle_Callback(hObject, eventdata, handles)
% hObject    handle to triangle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of triangle as text
%        str2double(get(hObject,'String')) returns contents of triangle as a double


% --- Executes during object creation, after setting all properties.
function triangle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to triangle (see GCBO)
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

bmploc = strcat('''',get(handles.bmp,'String'),'''');

savemeshto = get(handles.savemeshto,'String');
if isempty(savemeshto)
    savemeshto = [handles.type '-2D'];
end

savemeshto = getfullpath(savemeshto);

if ~canwrite(savemeshto)
    [junk fn ext1] = fileparts(savemeshto);
    savemeshto = [tempdir fn ext1];
    disp(['No write access, writing here instead: ' savemeshto]);
end

content{end+1} = strcat('mask2mesh_2D(',bmploc,...
    ',',get(handles.pixel,'String'),...
    ',',get(handles.edge,'String'),...
    ',',get(handles.triangle,'String'),...
    ',''',savemeshto,...
    ''',''',handles.type,''');');
if ~batch
    evalin('base',content{end});
end

set(mainGUIdata.script, 'String', content);
guidata(nirfast, mainGUIdata);
gui_place_sources_detectors('mesh',savemeshto);
close(gui_create_mesh_2D);


% --- Executes on button press in browse_bmp.
function browse_bmp_Callback(hObject, eventdata, handles)
% hObject    handle to browse_bmp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pn] = myuigetfile('*.bmp','Input Mask');
if fn == 0
    return;
end
temp = [pn fn];
set(handles.bmp,'String',temp);

guidata(hObject, handles);



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
