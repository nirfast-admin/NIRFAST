function varargout = gui_create_mesh(varargin)
% GUI_CREATE_MESH M-file for gui_create_mesh.fig
%      GUI_CREATE_MESH, by itself, creates a new GUI_CREATE_MESH or raises the existing
%      singleton*.
%
%      H = GUI_CREATE_MESH returns the handle to a new GUI_CREATE_MESH or the handle to
%      the existing singleton*.
%
%      GUI_CREATE_MESH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CREATE_MESH.M with the given input arguments.
%
%      GUI_CREATE_MESH('Property','Value',...) creates a new GUI_CREATE_MESH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_create_mesh_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_create_mesh_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_create_mesh

% Last Modified by GUIDE v2.5 30-Apr-2012 11:11:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_create_mesh_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_create_mesh_OutputFcn, ...
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


% --- Executes just before gui_create_mesh is made visible.
function gui_create_mesh_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_create_mesh (see VARARGIN)

% Choose default command line output for gui_create_mesh
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

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_create_mesh wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_create_mesh_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in shape.
function shape_Callback(hObject, eventdata, handles)
% hObject    handle to shape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns shape contents as cell array
%        contents{get(hObject,'Value')} returns selected item from shape
contents = get(hObject,'String');

if strcmp(contents{get(hObject,'Value')},'Circle')
    set(handles.x,'Enable','on');
    set(handles.y,'Enable','on');
    set(handles.z,'Enable','off');
    set(handles.radius,'Enable','on');
    set(handles.width,'Enable','off');
    set(handles.height,'Enable','off');
    set(handles.depth,'Enable','off');
elseif strcmp(contents{get(hObject,'Value')},'Rectangle')
    set(handles.x,'Enable','on');
    set(handles.y,'Enable','on');
    set(handles.z,'Enable','off');
    set(handles.radius,'Enable','off');
    set(handles.width,'Enable','on');
    set(handles.height,'Enable','on');
    set(handles.depth,'Enable','off');
elseif strcmp(contents{get(hObject,'Value')},'Cylinder')
    set(handles.x,'Enable','on');
    set(handles.y,'Enable','on');
    set(handles.z,'Enable','on');
    set(handles.radius,'Enable','on');
    set(handles.width,'Enable','off');
    set(handles.height,'Enable','on');
    set(handles.depth,'Enable','off');
elseif strcmp(contents{get(hObject,'Value')},'Slab')
    set(handles.x,'Enable','on');
    set(handles.y,'Enable','on');
    set(handles.z,'Enable','on');
    set(handles.radius,'Enable','off');
    set(handles.width,'Enable','on');
    set(handles.height,'Enable','on');
    set(handles.depth,'Enable','on');
end


% --- Executes during object creation, after setting all properties.
function shape_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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


function set_node_dist(hObject, eventdata, handles)
% hObject    handle to savemeshto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
shapeobj = get(handles.shape,'String');
shape = shapeobj{get(handles.shape,'Value')};

   
if strcmp(shape,'Circle') && ~isempty(get(handles.radius,'String'))
    smallest = str2num(get(handles.radius,'String'));
    if isempty(get(handles.distance,'String'))
        set(handles.distance,'String',num2str(smallest*0.025));
    end
end

if strcmp(shape,'Rectangle') && ~isempty(get(handles.width,'String')) ...
        && ~isempty(get(handles.height,'String'))
    smallest = min([str2num(get(handles.width,'String')), ...
                    str2num(get(handles.height,'String'))]);
    if isempty(get(handles.distance,'String'))
        set(handles.distance,'String',num2str(smallest*0.025));
    end
end

if strcmp(shape,'Cylinder') && ~isempty(get(handles.radius,'String')) ...
        && ~isempty(get(handles.height,'String'))
    smallest = min([str2num(get(handles.radius,'String')), ...
                    str2num(get(handles.height,'String'))]);
    if isempty(get(handles.distance,'String'))
        set(handles.distance,'String',num2str(smallest*0.035));
    end
end

if strcmp(shape,'Slab') && ~isempty(get(handles.width,'String')) ...
        && ~isempty(get(handles.height,'String')) ...
        && ~isempty(get(handles.depth,'String'))
    smallest = min([str2num(get(handles.width,'String')), ...
                    str2num(get(handles.height,'String')), ...
                    str2num(get(handles.depth,'String'))]);
    if isempty(get(handles.distance,'String'))
        set(handles.distance,'String',num2str(smallest*0.035));
    end
end



function radius_Callback(hObject, eventdata, handles)
% hObject    handle to radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of radius as text
%        str2double(get(hObject,'String')) returns contents of radius as a double
set_node_dist(hObject, eventdata, handles);

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
set_node_dist(hObject, eventdata, handles);

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



function width_Callback(hObject, eventdata, handles)
% hObject    handle to width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of width as text
%        str2double(get(hObject,'String')) returns contents of width as a double
set_node_dist(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_Callback(hObject, eventdata, handles)
% hObject    handle to x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x as text
%        str2double(get(hObject,'String')) returns contents of x as a double


% --- Executes during object creation, after setting all properties.
function x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_Callback(hObject, eventdata, handles)
% hObject    handle to y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y as text
%        str2double(get(hObject,'String')) returns contents of y as a double


% --- Executes during object creation, after setting all properties.
function y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_Callback(hObject, eventdata, handles)
% hObject    handle to z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z as text
%        str2double(get(hObject,'String')) returns contents of z as a double


% --- Executes during object creation, after setting all properties.
function z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function distance_Callback(hObject, eventdata, handles)
% hObject    handle to distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of distance as text
%        str2double(get(hObject,'String')) returns contents of distance as a double


% --- Executes during object creation, after setting all properties.
function distance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function link_Callback(hObject, eventdata, handles)
% hObject    handle to link (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of link as text
%        str2double(get(hObject,'String')) returns contents of link as a double


% --- Executes during object creation, after setting all properties.
function link_CreateFcn(hObject, eventdata, handles)
% hObject    handle to link (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function source_Callback(hObject, eventdata, handles)
% hObject    handle to source (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of source as text
%        str2double(get(hObject,'String')) returns contents of source as a double


% --- Executes during object creation, after setting all properties.
function source_CreateFcn(hObject, eventdata, handles)
% hObject    handle to source (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function meas_Callback(hObject, eventdata, handles)
% hObject    handle to meas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of meas as text
%        str2double(get(hObject,'String')) returns contents of meas as a double


% --- Executes during object creation, after setting all properties.
function meas_CreateFcn(hObject, eventdata, handles)
% hObject    handle to meas (see GCBO)
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

shapeobj = get(handles.shape,'String');
shape = shapeobj{get(handles.shape,'Value')};

if strcmp(get(handles.x,'Enable'),'on')
    content{end+1} = strcat('sizevar.xc=',get(handles.x,'String'),';');
    if ~batch
        evalin('base',content{end});
    end
end

if strcmp(get(handles.y,'Enable'),'on')
    content{end+1} = strcat('sizevar.yc=',get(handles.y,'String'),';');
    if ~batch
        evalin('base',content{end});
    end
end

if strcmp(get(handles.z,'Enable'),'on')
    content{end+1} = strcat('sizevar.zc=',get(handles.z,'String'),';');
    if ~batch
        evalin('base',content{end});
    end
end

if strcmp(get(handles.radius,'Enable'),'on')
    content{end+1} = strcat('sizevar.r=',get(handles.radius,'String'),';');
    if ~batch
        evalin('base',content{end});
    end
end

if strcmp(get(handles.width,'Enable'),'on')
    content{end+1} = strcat('sizevar.width=',get(handles.width,'String'),';');
    if ~batch
        evalin('base',content{end});
    end
end

if strcmp(get(handles.height,'Enable'),'on')
    content{end+1} = strcat('sizevar.height=',get(handles.height,'String'),';');
    if ~batch
        evalin('base',content{end});
    end
end

if strcmp(get(handles.depth,'Enable'),'on')
    content{end+1} = strcat('sizevar.depth=',get(handles.depth,'String'),';');
    if ~batch
        evalin('base',content{end});
    end
end

content{end+1} = strcat('sizevar.dist=',get(handles.distance,'String'),';');
if ~batch
    evalin('base',content{end});
end

savemeshto = get(handles.savemeshto,'String');
if isempty(savemeshto)
    savemeshto = [shape '-' handles.type '-mesh'];
    set(handles.savemeshto,'String',savemeshto);
    drawnow;
end

if ~canwrite(savemeshto)
    [junk fn ext1] = fileparts(savemeshto);
    savemeshto = [tempdir fn ext1];
    disp(['No write access, writing here instead: ' savemeshto]);
end

savemeshto = getfullpath(savemeshto);

content{end+1} = strcat('create_mesh(''',...
    savemeshto,''',''',...
    shape,''',',...
    'sizevar,''',...
    handles.type,''');');
if ~batch
    mesh = evalin('base',content{end});
end

%% Optimize?
if ~(strcmp(handles.type,'stnd_bem') || strcmp(handles.type,'fluor_bem')...
        || strcmp(handles.type,'spec_bem')) && mesh.dimension == 3
    if ~isfield(mesh,'optimize_my_mesh')
        [junk optimize_flag] = optimize_mesh_gui;
    else
        if mesh.optimize_my_mesh == 1
            optimize_flag = 1;
        else
            optimize_flag = 0;
        end
    end
    if optimize_flag
        content{end+1} = 'clear mesh;';
        if ~batch, evalin('base', content{end}); end
        content{end+1} = sprintf('foomesh = load_mesh(''%s'');',...
            savemeshto);
        if ~batch, evalin('base', content{end}); end
        content{end+1} = sprintf('foomesh.optimize_my_mesh = 1;');
        if ~batch, evalin('base', content{end}); end
        content{end+1} = sprintf('%s\n%s\n%s\n%s\n%s',...
            'opt_params.qualmeasure = 0;',...
            'opt_params.facetsmooth = 0;',...
            'opt_params.usequadrics = 0;',...
            'opt_params.opt_params = [];');
        if ~batch, evalin('base', content{end}); end
        content{end+1} = sprintf('%s = %s%s;',...
        '[mesh.elements, mesh.nodes, optimize_status]',...
        'improve_mesh_use_stellar(',...
        'foomesh.elements, foomesh.nodes, opt_params)');
        if ~batch, evalin('base', content{end}); end
        content{end+1} = 'clear foomesh;';
        if ~batch, evalin('base', content{end}); end
        content{end+1} = sprintf('%s;',...
            'ffaces = boundfaces(mesh.nodes, mesh.elements, 0)');
        if ~batch, evalin('base', content{end}); end
        content{end+1} = sprintf('%s;',...
            'mesh.bndvtx = zeros(size(mesh.nodes,1),1)');
        if ~batch, evalin('base', content{end}); end
        content{end+1} = sprintf('%s;',...
            'mesh.bndvtx(unique(ffaces(:))) = 1');
        if ~batch, evalin('base', content{end}); end
        content{end+1} = sprintf('%s ''%s'');',...
            'mesh = set_mesh_type(mesh,',handles.type);
        if ~batch, evalin('base', content{end}); end
        content{end+1} = sprintf('%s ''%s'');',...
            'save_mesh(mesh,',savemeshto);
        if ~batch, evalin('base', content{end}); end
        content{end+1} = sprintf('mesh.optimize_my_mesh = 0;');
        if ~batch, evalin('base', content{end}); end
    end
end

% delete temp variables
tempvar = {'sizevar', 'ffaces', 'opt_params', 'optimize_status'};
foo= 'clear';
for i_=1:length(tempvar)
    foo = horzcat(foo,' ',tempvar{i_});
end
content{end+1} = foo;

if ~batch
    evalin('base',content{end});
end

set(mainGUIdata.script, 'String', content);
guidata(nirfast, mainGUIdata);
gui_place_sources_detectors('mesh',savemeshto);
close(gui_create_mesh);




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



function depth_Callback(hObject, eventdata, handles)
% hObject    handle to depth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of depth as text
%        str2double(get(hObject,'String')) returns contents of depth as a double
set_node_dist(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function depth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to depth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
