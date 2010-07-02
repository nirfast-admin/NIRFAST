function varargout = gui_view_jacobian(varargin)
% GUI_VIEW_JACOBIAN M-file for gui_view_jacobian.fig
%      GUI_VIEW_JACOBIAN, by itself, creates a new GUI_VIEW_JACOBIAN or raises the existing
%      singleton*.
%
%      H = GUI_VIEW_JACOBIAN returns the handle to a new GUI_VIEW_JACOBIAN or the handle to
%      the existing singleton*.
%
%      GUI_VIEW_JACOBIAN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_VIEW_JACOBIAN.M with the given input arguments.
%
%      GUI_VIEW_JACOBIAN('Property','Value',...) creates a new GUI_VIEW_JACOBIAN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_view_jacobian_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_view_jacobian_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_view_jacobian

% Last Modified by GUIDE v2.5 26-Apr-2010 12:36:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_view_jacobian_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_view_jacobian_OutputFcn, ...
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


% --- Executes just before gui_view_jacobian is made visible.
function gui_view_jacobian_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_view_jacobian (see VARARGIN)

% Choose default command line output for gui_view_jacobian
handles.output = hObject;
set(hObject,'Name','View Jacobian');
if(nargin > 3)
    for index = 1:2:(nargin-3),
        if nargin-3==index, break, end
        switch lower(varargin{index})
         case 'type'
         handles.type = varargin{index+1};
        end
    end
end
if ~strcmp(handles.type,'spec') && ~strcmp(handles.type,'spec_bem')
    set(handles.wv_array,'Enable','off');
end
set(handles.spn,'Value',3.0);
if strcmp(handles.type,'stnd_spn')==0
    set(handles.spn,'Enable','off');
end

% find workspace variables
vars = evalin('base','whos;');
varnames = {};
[nv,junk] = size(vars);
nflag = 1;
for i=1:1:nv
    flag = evalin('base',strcat('isfield(',vars(i).name,',''type'')'));
    if flag && strcmp(handles.type,evalin('base',strcat(vars(i).name,'.type')))
        varnames{nflag} = vars(i).name;
        nflag = nflag + 1;
    end
end
if ~isempty(varnames)
    set(handles.variables_mesh,'String',varnames);
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_view_jacobian wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_view_jacobian_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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


% --- Executes on button press in done.
function done_Callback(hObject, eventdata, handles)
% hObject    handle to done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mainGUIhandle = nirfast;
mainGUIdata  = guidata(mainGUIhandle);
content = get(mainGUIdata.script,'String');
batch = get(mainGUIdata.batch_mode,'Value');

wv_array = get(handles.wv_array,'String');
meshloc = get_pathloc(get(handles.mesh,'String'));

if wv_array
    content{end+1} = strcat('J = jacobian(',meshloc,',',...
        get(handles.frequency,'String'),',',wv_array,');');
    if ~batch
        evalin('base',content{end});
    end
elseif strcmp(handles.type,'stnd_spn')
    n = get(handles.spn,'Value');
    content{end+1} = strcat('J = jacobian_sp',num2str(n*2-1),'(',meshloc,',',...
        get(handles.frequency,'String'),');');
    if ~batch
        evalin('base',content{end});
    end
else
    content{end+1} = strcat('J = jacobian(',meshloc,',',...
        get(handles.frequency,'String'),');');
    if ~batch
        evalin('base',content{end});
    end
end

set(mainGUIdata.script, 'String', content);
guidata(nirfast, mainGUIdata);
close(gui_view_jacobian);


% --- Executes on selection change in variables_mesh.
function variables_mesh_Callback(hObject, eventdata, handles)
% hObject    handle to variables_mesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns variables_mesh contents as cell array
%        contents{get(hObject,'Value')} returns selected item from variables_mesh
contents = get(hObject,'String');
meshname = contents{get(hObject,'Value')};
set(handles.mesh,'String',meshname);
mesh = evalin('base',meshname);
if isfield(mesh,'wv')
    set(handles.wv_array,'TooltipString',mat2str(mesh.wv'));
end


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


% --- Executes on selection change in spn.
function spn_Callback(hObject, eventdata, handles)
% hObject    handle to spn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns spn contents as cell array
%        contents{get(hObject,'Value')} returns selected item from spn


% --- Executes during object creation, after setting all properties.
function spn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


