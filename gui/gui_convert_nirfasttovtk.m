function varargout = gui_convert_nirfasttovtk(varargin)
% GUI_CONVERT_NIRFASTTOVTK M-file for gui_convert_nirfasttovtk.fig
%      GUI_CONVERT_NIRFASTTOVTK, by itself, creates a new GUI_CONVERT_NIRFASTTOVTK or raises the existing
%      singleton*.
%
%      H = GUI_CONVERT_NIRFASTTOVTK returns the handle to a new GUI_CONVERT_NIRFASTTOVTK or the handle to
%      the existing singleton*.
%
%      GUI_CONVERT_NIRFASTTOVTK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CONVERT_NIRFASTTOVTK.M with the given input arguments.
%
%      GUI_CONVERT_NIRFASTTOVTK('Property','Value',...) creates a new GUI_CONVERT_NIRFASTTOVTK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_convert_nirfasttovtk_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_convert_nirfasttovtk_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_convert_nirfasttovtk

% Last Modified by GUIDE v2.5 29-Apr-2013 10:28:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_convert_nirfasttovtk_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_convert_nirfasttovtk_OutputFcn, ...
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


% --- Executes just before gui_convert_nirfasttovtk is made visible.
function gui_convert_nirfasttovtk_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_convert_nirfasttovtk (see VARARGIN)

% Choose default command line output for gui_convert_nirfasttovtk
handles.output = hObject;
set(hObject,'Name','Convert to VTK');

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

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_convert_nirfasttovtk wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_convert_nirfasttovtk_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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



function vtk_Callback(hObject, eventdata, handles)
% hObject    handle to vtk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vtk as text
%        str2double(get(hObject,'String')) returns contents of vtk as a double


% --- Executes during object creation, after setting all properties.
function vtk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vtk (see GCBO)
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

meshloc = get_pathloc(get(handles.mesh,'String'));

saveto = get(handles.vtk,'String');
if isempty(saveto)
    [junk1 fn1] = fileparts(meshloc);
    saveto = [fn1 '-2-vtk'];
end

saveto = getfullpath(saveto);

if ~canwrite(saveto)
    [junk fn ext1] = fileparts(saveto);
    saveto = [tempdir fn ext1];
    disp(['No write access, writing here instead: ' saveto]);
end

content{end+1} = strcat('nirfast2vtk(',meshloc,',''',saveto,''');');
if ~batch
    evalin('base',content{end});
end

set(mainGUIdata.script, 'String', content);
guidata(nirfast, mainGUIdata);
close(gui_convert_nirfasttovtk);


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


% --- Executes on button press in browse_vtk.
function browse_vtk_Callback(hObject, eventdata, handles)
% hObject    handle to browse_vtk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pn] = myuiputfile('*.vtk','Save VTK To');
if fn == 0
    return;
end
set(handles.vtk,'String',[pn fn]);

guidata(hObject, handles);


% --- Executes on button press in boundary.
function boundary_Callback(hObject, eventdata, handles)
% hObject    handle to boundary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of boundary
