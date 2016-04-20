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

% Last Modified by GUIDE v2.5 26-Jul-2011 10:00:59

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
rotate3d on

if ~isfield(handles,'dimension')
    % remove source/meas/link files if they exist
    if exist([handles.meshloc '.source'],'file')
        delete([handles.meshloc '.source']);
    end
    if exist([handles.meshloc '.meas'],'file')
        delete([handles.meshloc '.meas']);
    end
    if exist([handles.meshloc '.link'],'file')
        delete([handles.meshloc '.link']);
    end

    % draw mesh if exists
    if isfield(handles,'meshloc') && exist([handles.meshloc '.node'],'file')
        axes(handles.mesh)
        hold on
        mesh = load_mesh(handles.meshloc);
        handles.mymesh = mesh;
        handles.dimension = mesh.dimension;
        ind = find(mesh.bndvtx==1);
        if mesh.dimension == 2
            xlabel('x')
            ylabel('y')
            %plot(mesh.nodes(ind,1),mesh.nodes(ind,2),'c.');
            trimesh(mesh.elements,mesh.nodes(:,1),mesh.nodes(:,2),mesh.nodes(:,3),'edgecolor','black');
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
end

% find fiducial files
fid_loc = what('fiducials');
foote = fid_loc.path;
fids = dir([foote '/fiducials_*']);
varnames = {'Select System'};
for i=1:size(fids)
    varnames{i+1} = fids(i).name(11:end-2);
end
set(handles.fiducial_file,'String',varnames);

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
temp = get(hObject,'String');
set(handles.sources,'String',cellstr(temp));


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

s = eval(sources_string);
d = eval(detectors_string);
link_string = '[';
for si=1:size(s,1)
    for di=1:size(d,1)
        link_string = [link_string ' ' num2str(si) ' ' num2str(di) ' 1;'];
    end
end
link_string = strcat(link_string, ']');

fixed = get(handles.fix_sd,'Value');
distributed_source = get(handles.distributed_source,'Value');

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
content{end+1} = strcat('mesh_tmp.source.num = (1:size(',sources_string,',1))'';');
if ~batch
    evalin('base',content{end});
end
content{end+1} = strcat('mesh_tmp.source.fwhm = zeros(size(',sources_string,',1),1);');
if ~batch
    evalin('base',content{end});
end
content{end+1} = strcat('mesh_tmp.source.fixed = ',num2str(fixed),';');
if ~batch
    evalin('base',content{end});
end
content{end+1} = strcat('mesh_tmp.source.distributed = ',num2str(distributed_source),';');
if ~batch
    evalin('base',content{end});
end
content{end+1} = strcat('mesh_tmp.meas.coord = ',detectors_string,';');
if ~batch
    evalin('base',content{end});
end
content{end+1} = strcat('mesh_tmp.meas.num = (1:size(',detectors_string,',1))'';');
if ~batch
    evalin('base',content{end});
end
content{end+1} = strcat('mesh_tmp.meas.fixed = ',num2str(fixed),';');
if ~batch
    evalin('base',content{end});
end
content{end+1} = strcat('mesh_tmp = minband_opt(mesh_tmp);');
if ~batch
    evalin('base',content{end});
end
content{end+1} = strcat('save_mesh(mesh_tmp,''',handles.meshloc,''');');
if ~batch
    evalin('base',content{end});
end
content{end+1} = 'clear mesh_tmp';
if ~batch
    evalin('base',content{end});
end
content{end+1} = strcat('mesh = load_mesh(''',handles.meshloc,''');');
if ~batch
    evalin('base',content{end});
end
        
set(mainGUIdata.script, 'String', content);
guidata(nirfast, mainGUIdata);

mesh = load_mesh(handles.meshloc);
if strcmp(mesh.type,'spec') || strcmp(mesh.type,'spec_bem')   
    gui_set_chromophores('mesh',handles.meshloc);
else
   % gui_launcher
end


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
        plot(x,y,'ro');
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
        plot(x,y,'bx');
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
    p = select3d;
    if ~isempty(p)
        if handles.sourceflag == 1
            sources = get(handles.sources,'String');
            sources{end+1} = [num2str(p(1)) ' ' num2str(p(2)) ' ' num2str(p(3))];
            set(handles.sources,'String',sources);
            axes(handles.mesh)
            plot3(p(1),p(2),p(3),'ro');
        elseif handles.detectorflag == 1
            detectors = get(handles.detectors,'String');
            detectors{end+1} = [num2str(p(1)) ' ' num2str(p(2)) ' ' num2str(p(3))];
            set(handles.detectors,'String',detectors);
            plot3(p(1),p(2),p(3),'bx');
        end
    end
end


% --- Executes on selection change in row_type.
function row_type_Callback(hObject, eventdata, handles)
% hObject    handle to row_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns row_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from row_type


% --- Executes during object creation, after setting all properties.
function row_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to row_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function row_number_Callback(hObject, eventdata, handles)
% hObject    handle to row_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of row_number as text
%        str2double(get(hObject,'String')) returns contents of row_number as a double


% --- Executes during object creation, after setting all properties.
function row_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to row_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function row_position1_Callback(hObject, eventdata, handles)
% hObject    handle to row_position1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of row_position1 as text
%        str2double(get(hObject,'String')) returns contents of row_position1 as a double


% --- Executes during object creation, after setting all properties.
function row_position1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to row_position1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function row_position2_Callback(hObject, eventdata, handles)
% hObject    handle to row_position2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of row_position2 as text
%        str2double(get(hObject,'String')) returns contents of row_position2 as a double


% --- Executes during object creation, after setting all properties.
function row_position2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to row_position2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in row_create.
function row_create_Callback(hObject, eventdata, handles)
% hObject    handle to row_create (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.row_type,'Value')==1
    p1 = get(handles.row_position1,'String');
    p2 = get(handles.row_position2,'String');
    sources = get(handles.sources,'String');
    data1 = textscan(p1,'%.54f');
    data2 = textscan(p2,'%.54f');
    numpoints = str2num(get(handles.row_number,'String'));
    point1 = data1{1};
    point2 = data2{1};
    vec = (point2 - point1)/(numpoints-1);
    newpoint = point1;
    axes(handles.mesh)
    for i=1:numpoints
        temppoint = mat2str(newpoint');
        sources{end+1} = temppoint(2:end-1);
        if handles.dimension == 2
            plot(newpoint(1),newpoint(2),'ro');
        else
            plot3(newpoint(1),newpoint(2),newpoint(3),'ro');
        end
        newpoint = newpoint + vec;
    end
    set(handles.sources,'String',sources);
else
    p1 = get(handles.row_position1,'String');
    p2 = get(handles.row_position2,'String');
    detectors = get(handles.detectors,'String');
    data1 = textscan(p1,'%.54f');
    data2 = textscan(p2,'%.54f');
    numpoints = str2num(get(handles.row_number,'String'));
    point1 = data1{1};
    point2 = data2{1};
    vec = (point2 - point1)/(numpoints-1);
    newpoint = point1;
    axes(handles.mesh)
    for i=1:numpoints
        temppoint = mat2str(newpoint');
        detectors{end+1} = temppoint(2:end-1);
        if handles.dimension == 2
            plot(newpoint(1),newpoint(2),'bx');
        else
            plot3(newpoint(1),newpoint(2),newpoint(3),'bx');
        end
        newpoint = newpoint + vec;
    end
    set(handles.detectors,'String',detectors);
end


% --- Executes on button press in fiducial_create.
function fiducial_create_Callback(hObject, eventdata, handles)
% hObject    handle to fiducial_create (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get fiducials
sources = get(handles.sources,'String');
sources_string = strcat('[', sources(1,:));
for i=2:size(sources,1)
    sources_string = strcat(sources_string, ';', sources(i,:));
end
sources_string = strcat(sources_string, ']');
sources_string = char(sources_string);

% generate sources/detectors
fids = get(handles.fiducial_file,'String');
fid = fids(get(handles.fiducial_file,'Value'));
eval(strcat('[s,d]=fiducials_',fid{1},'(',sources_string,',handles.mymesh);'));

% put new sources/detectors into the gui
sources = {};
for i=1:1:size(s,1)
    p = mat2str(s(i,:));
    sources{end+1} = p(2:end-1);
end
set(handles.sources,'String',sources);

detectors = {};
for i=1:1:size(d,1)
    p = mat2str(d(i,:));
    detectors{end+1} = p(2:end-1);
end
set(handles.detectors,'String',detectors);





% --- Executes on selection change in fiducial_file.
function fiducial_file_Callback(hObject, eventdata, handles)
% hObject    handle to fiducial_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fiducial_file contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fiducial_file


% --- Executes during object creation, after setting all properties.
function fiducial_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fiducial_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fix_sd.
function fix_sd_Callback(hObject, eventdata, handles)
% hObject    handle to fix_sd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fix_sd


% --- Executes on button press in distributed_source.
function distributed_source_Callback(hObject, eventdata, handles)
% hObject    handle to distributed_source (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of distributed_source
