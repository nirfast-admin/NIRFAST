function varargout = gui_place_sources_detectors(varargin)
% GUI_PLACE_SOURCES_DETECTORS M-file for gui_place_sources_detectors.fig
%      GUI_PLACE_SOURCES_DETECTORS, by itself, creates a new GUI_PLACE_SOURCES_DETECTORS or raises the existing
%      singleton*.
%
%      H = GUI_PLACE_SOURCES_DETECTORS returns the handle to a new GUI_PLACE_SOURCES_DETECTORS or the handle to
%      the existing singleton*.
%
%      GUI_PLACE_SOURCES_DETECTORS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PLACE_SOURCES_DETECTORS.M with the given input arguments.
%
%      GUI_PLACE_SOURCES_DETECTORS('Property','Value',...) creates a new GUI_PLACE_SOURCES_DETECTORS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_place_sources_detectors_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_place_sources_detectors_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_place_sources_detectors

% Last Modified by GUIDE v2.5 29-Apr-2010 14:32:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_place_sources_detectors_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_place_sources_detectors_OutputFcn, ...
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


% --- Executes just before gui_place_sources_detectors is made visible.
function gui_place_sources_detectors_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_place_sources_detectors (see VARARGIN)

% Choose default command line output for gui_place_sources_detectors
handles.output = hObject;
set(hObject,'Name','Place Sources and Detectors');
if(nargin > 3)
    for index = 1:2:(nargin-3),
        if nargin-3==index, break, end
        switch lower(varargin{index})
         case 'mesh'
         handles.meshloc = varargin{index+1};
        end
    end
end

handles.sourceflag = 0;
handles.detectorflag = 0;

% draw mesh if exists
if isfield(handles,'meshloc')
    axes(handles.mesh)
    hold on
    mesh = load_mesh(handles.meshloc);
    handles.dimension = mesh.dimension;
    ind = find(mesh.bndvtx==1);
    if mesh.dimension == 2
        xlabel('x')
        ylabel('y')
        plot(mesh.nodes(ind,1),mesh.nodes(ind,2),'c.');
        axis equal;
    elseif mesh.dimension == 3
        xlabel('x')
        ylabel('y')
        zlabel('z')
        if ~strcmp(mesh.type,'stnd_bem') && ...
                ~strcmp(mesh.type,'fluor_bem') && ~strcmp(mesh.type,'spec_bem')
            [mesh.elements,mesh.nodes] = boundfaces(mesh.nodes,mesh.elements);
        end
        trisurf(mesh.elements,mesh.nodes(:,1),mesh.nodes(:,2),mesh.nodes(:,3));
        axis equal;
    end
end

set(hObject,'toolbar','figure');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_place_sources_detectors wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_place_sources_detectors_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function sources_Callback(hObject, eventdata, handles)
% hObject    handle to sources (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sources as text
%        str2double(get(hObject,'String')) returns contents of sources as a double


% --- Executes during object creation, after setting all properties.
function sources_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sources (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function detectors_Callback(hObject, eventdata, handles)
% hObject    handle to detectors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of detectors as text
%        str2double(get(hObject,'String')) returns contents of detectors as a double


% --- Executes during object creation, after setting all properties.
function detectors_CreateFcn(hObject, eventdata, handles)
% hObject    handle to detectors (see GCBO)
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


% --- Executes on button press in done.
function done_Callback(hObject, eventdata, handles)
% hObject    handle to done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mainGUIhandle = nirfast;
mainGUIdata  = guidata(mainGUIhandle);
content = get(mainGUIdata.script,'String');
batch = get(mainGUIdata.batch_mode,'Value');

link = get(handles.link,'String');
link_string = strcat('[', link(1,:));
for i=2:size(link,1)
    link_string = strcat(link_string, ';', link(i,:));
end
link_string = strcat(link_string, ']');

sources = get(handles.sources,'String');
sources_string = strcat('[', sources(1,:));
for i=2:size(sources,1)
    sources_string = strcat(sources_string, ';', sources(i,:));
end
sources_string = strcat(sources_string, ']');
sources_string = char(sources_string);

detectors = get(handles.detectors,'String');
detectors_string = strcat('[', detectors(1,:));
for i=2:size(detectors,1)
    detectors_string = strcat(detectors_string, ';', detectors(i,:));
end
detectors_string = strcat(detectors_string, ']');
detectors_string = char(detectors_string);

content{end+1} = strcat('mesh_tmp = load_mesh(''',handles.meshloc,''');');
if ~batch
    evalin('base',content{end});
end
content{end+1} = strcat('mesh_tmp.link = ',link_string,';');
if ~batch
    evalin('base',content{end});
end
content{end+1} = strcat('mesh_tmp.source.coord = ',sources_string,';');
if ~batch
    evalin('base',content{end});
end
content{end+1} = strcat('mesh_tmp.source.fixed = 0;');
if ~batch
    evalin('base',content{end});
end
content{end+1} = strcat('mesh_tmp.meas.coord = ',detectors_string,';');
if ~batch
    evalin('base',content{end});
end
content{end+1} = strcat('mesh_tmp.meas.fixed = 0;');
if ~batch
    evalin('base',content{end});
end
content{end+1} = strcat('save_mesh(mesh_tmp,''',handles.meshloc,''');');
if ~batch
    evalin('base',content{end});
end
        
set(mainGUIdata.script, 'String', content);
guidata(nirfast, mainGUIdata);
close(gui_place_sources_detectors);


% --- Executes on button press in addsource.
function addsource_Callback(hObject, eventdata, handles)
% hObject    handle to addsource (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'dimension')
    if handles.dimension == 2
        axes(handles.mesh)
        [x,y] = ginput(1);
        sources = get(handles.sources,'String');
        sources{end+1} = [num2str(x) ' ' num2str(y)];
        set(handles.sources,'String',sources);
    elseif handles.dimension == 3
        axes(handles.mesh)
        fig = gcf;
        figure(fig);
        uistate = uiclearmode(fig);
        set(fig,'windowbuttondownfcn',...
         'gui_place_sources_detectors(''figure1_WindowButtonDownFcn'',gcbo,[],guidata(gcbo))');
        handles.sourceflag = 1;
        handles.detectorflag = 0;
    end
end

guidata(hObject, handles);




% --- Executes on button press in adddetector.
function adddetector_Callback(hObject, eventdata, handles)
% hObject    handle to adddetector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'dimension')
    if handles.dimension == 2
        axes(handles.mesh)
        [x,y] = ginput(1);
        detectors = get(handles.detectors,'String');
        detectors{end+1} = [num2str(x) ' ' num2str(y)];
        set(handles.detectors,'String',detectors);
    elseif handles.dimension == 3
        axes(handles.mesh)
        fig = gcf;
        figure(fig);
        uistate = uiclearmode(fig);
        set(fig,'windowbuttondownfcn',...
         'gui_place_sources_detectors(''figure1_WindowButtonDownFcn'',gcbo,[],guidata(gcbo))');
        handles.sourceflag = 0;
        handles.detectorflag = 1;
    end
end

guidata(hObject, handles);


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.dimension == 3
    p = select3d
    if ~isempty(p)
        if handles.sourceflag == 1
            sources = get(handles.sources,'String');
            sources{end+1} = [num2str(p(1)) ' ' num2str(p(2)) ' ' num2str(p(3))];
            set(handles.sources,'String',sources);
            axes(handles.mesh)
        elseif handles.detectorflag == 1
            detectors = get(handles.detectors,'String');
            detectors{end+1} = [num2str(p(1)) ' ' num2str(p(2)) ' ' num2str(p(3))];
            set(handles.detectors,'String',detectors);
        end
    end
end

