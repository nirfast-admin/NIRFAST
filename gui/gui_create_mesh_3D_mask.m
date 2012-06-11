function varargout = gui_create_mesh_3D_mask(varargin)
% GUI_CREATE_MESH_3D_MASK M-file for gui_create_mesh_3D_mask.fig
%      GUI_CREATE_MESH_3D_MASK, by itself, creates a new GUI_CREATE_MESH_3D_MASK or raises the existing
%      singleton*.
%
%      H = GUI_CREATE_MESH_3D_MASK returns the handle to a new GUI_CREATE_MESH_3D_MASK or the handle to
%      the existing singleton*.
%
%      GUI_CREATE_MESH_3D_MASK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CREATE_MESH_3D_MASK.M with the given input arguments.
%
%      GUI_CREATE_MESH_3D_MASK('Property','Value',...) creates a new GUI_CREATE_MESH_3D_MASK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_create_mesh_3D_mask_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_create_mesh_3D_mask_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_create_mesh_3D_mask

% Last Modified by GUIDE v2.5 14-Jun-2010 13:12:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_create_mesh_3D_mask_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_create_mesh_3D_mask_OutputFcn, ...
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


% --- Executes just before gui_create_mesh_3D_mask is made visible.
function gui_create_mesh_3D_mask_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_create_mesh_3D_mask (see VARARGIN)

% Choose default command line output for gui_create_mesh_3D_mask
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
set(hObject,'Name','3D Mask to Mesh');

% find workspace variables
vars = evalin('base','whos;');
varnames = {};
[nv,junk] = size(vars);
nflag = 1;
for i=1:1:nv
    flag = evalin('base',strcat('~isstruct(',vars(i).name,')'));
    flag = evalin('base',strcat('ndims(',vars(i).name,')==3'));
    if flag
        varnames{nflag} = vars(i).name;
        nflag = nflag + 1;
    end
end
if ~isempty(varnames)
    set(handles.variables_mask,'String',varnames);
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_create_mesh_3D_mask wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_create_mesh_3D_mask_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in variables_mask.
function variables_mask_Callback(hObject, eventdata, handles)
% hObject    handle to variables_mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns variables_mask contents as cell array
%        contents{get(hObject,'Value')} returns selected item from variables_mask
contents = get(hObject,'String');
set(handles.mask,'String',contents{get(hObject,'Value')});


% --- Executes during object creation, after setting all properties.
function variables_mask_CreateFcn(hObject, eventdata, handles)
% hObject    handle to variables_mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mask_Callback(hObject, eventdata, handles)
% hObject    handle to mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mask as text
%        str2double(get(hObject,'String')) returns contents of mask as a double


% --- Executes during object creation, after setting all properties.
function mask_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mask (see GCBO)
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



function edgexy_Callback(hObject, eventdata, handles)
% hObject    handle to edgexy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edgexy as text
%        str2double(get(hObject,'String')) returns contents of edgexy as a double


% --- Executes during object creation, after setting all properties.
function edgexy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edgexy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pixelxy_Callback(hObject, eventdata, handles)
% hObject    handle to pixelxy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pixelxy as text
%        str2double(get(hObject,'String')) returns contents of pixelxy as a double


% --- Executes during object creation, after setting all properties.
function pixelxy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixelxy (see GCBO)
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

maskloc = get_pathloc(get(handles.mask,'String'));
saveloc = [tempdir filesep 'temp_node_ele'];
saveloc = ['''' saveloc ''''];

% mask to inp
content{end+1} = strcat('MMC(',maskloc,...
    ',',get(handles.pixelxy,'String'),...
    ',',get(handles.pixelz,'String'),...
    ',',get(handles.edgexy,'String'),...
    ',',saveloc,...
    ');');
if ~batch
    evalin('base',content{end});
end

temp_mesh_fn = ['''' tempdir filesep 'temp_node_ele.ele'''];

savemeshto = get(handles.savemeshto,'String');
if isempty(savemeshto)
    savemeshto = [handles.type '-mesh'];
    set(handles.savemeshto,'String',savemeshto);
    drawnow
end

savemeshto = getfullpath(savemeshto);

if ~canwrite(savemeshto)
    [junk fn ext1] = fileparts(savemeshto);
    savemeshto = [tempdir fn ext1];
    disp(['No write access, writing here instead: ' savemeshto]);
end

% inp to mesh
if strcmp(handles.type,'stnd_bem') || ...
        strcmp(handles.type,'fluor_bem') || strcmp(handles.type,'spec_bem')
    content{end+1} = strcat('surf2nirfast_bem(',temp_mesh_fn,',''',savemeshto,...
        ''',''',handles.type,''');');
    if ~batch
        evalin('base',content{end});
    end
else
    content{end+1} = strcat('checkerboard3dmm_wrapper(',temp_mesh_fn,',''',savemeshto,...
        ''',''',handles.type,''',',get(handles.edgexy,'String'),');');
    if ~batch
        evalin('base',content{end});
    end
end

set(mainGUIdata.script, 'String', content);
guidata(nirfast, mainGUIdata);
gui_place_sources_detectors('mesh',savemeshto);
close(gui_create_mesh_3D_mask);


% --- Executes on button press in browse_mask.
function browse_mask_Callback(hObject, eventdata, handles)
% hObject    handle to browse_mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pn] = myuigetfile('*.bmp','Input Mask');
if fn == 0
    return;
end
temp = [pn fn];
set(handles.mask,'String',temp);

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



function pixelz_Callback(hObject, eventdata, handles)
% hObject    handle to pixelz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pixelz as text
%        str2double(get(hObject,'String')) returns contents of pixelz as a double


% --- Executes during object creation, after setting all properties.
function pixelz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixelz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
