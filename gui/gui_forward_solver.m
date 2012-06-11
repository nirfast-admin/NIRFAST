function varargout = gui_forward_solver(varargin)
% GUI_FORWARD_SOLVER M-file for gui_forward_solver.fig
%      GUI_FORWARD_SOLVER, by itself, creates a new GUI_FORWARD_SOLVER or raises the existing
%      singleton*.
%
%      H = GUI_FORWARD_SOLVER returns the handle to a new GUI_FORWARD_SOLVER or the handle to
%      the existing singleton*.
%
%      GUI_FORWARD_SOLVER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_FORWARD_SOLVER.M with the given input arguments.
%
%      GUI_FORWARD_SOLVER('Property','Value',...) creates a new GUI_FORWARD_SOLVER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_forward_solver_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_forward_solver_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_forward_solver

% Last Modified by GUIDE v2.5 03-Feb-2012 09:31:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_forward_solver_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_forward_solver_OutputFcn, ...
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


% --- Executes just before gui_forward_solver is made visible.
function gui_forward_solver_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_forward_solver (see VARARGIN)

% Choose default command line output for gui_forward_solver
handles.output = hObject;
set(hObject,'Name','Forward Solver');
if(nargin > 3)
    for index = 1:2:(nargin-3),
        if nargin-3==index, break, end
        switch lower(varargin{index})
         case 'type'
         handles.type = varargin{index+1};
        end
    end
end

% Modify GUI based on type of forward solver
if ~strcmp(handles.type,'spec') && ~strcmp(handles.type,'spec_bem')
    set(handles.wv_array,'Enable','off');
end
if strcmp(handles.type,'stnd')==0
    set(handles.view_solution,'Enable','off');
end
if strcmp(handles.type,'stnd')==0 && strcmp(handles.type,'fluor')==0
    set(handles.time_resolved,'Enable','off');
end
if strcmp(handles.type,'fluor')
    set(handles.frequency,'String','0');
end
set(handles.source1,'Enable','off');
set(handles.source2,'Enable','off');
set(handles.spn,'Value',3.0);
if strcmp(handles.type,'stnd_spn')==0
    set(handles.spn,'Enable','off');
end
set(handles.total_time,'Enable','off');
set(handles.time_interval,'Enable','off');

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

% UIWAIT makes gui_forward_solver wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_forward_solver_OutputFcn(hObject, eventdata, handles) 
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



function save_data_to_Callback(hObject, eventdata, handles)
% hObject    handle to save_data_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of save_data_to as text
%        str2double(get(hObject,'String')) returns contents of save_data_to as a double


% --- Executes during object creation, after setting all properties.
function save_data_to_CreateFcn(hObject, eventdata, handles)
% hObject    handle to save_data_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browse_data.
function browse_data_Callback(hObject, eventdata, handles)
% hObject    handle to browse_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pn] = myuiputfile('*.paa','Save Data To');
if fn == 0
    return;
end
set(handles.save_data_to,'String',[pn fn]);

guidata(hObject, handles);



function excitation_Callback(hObject, eventdata, handles)
% hObject    handle to excitation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of excitation as text
%        str2double(get(hObject,'String')) returns contents of excitation as a double


% --- Executes during object creation, after setting all properties.
function excitation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to excitation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function emission_Callback(hObject, eventdata, handles)
% hObject    handle to emission (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of emission as text
%        str2double(get(hObject,'String')) returns contents of emission as a double


% --- Executes during object creation, after setting all properties.
function emission_CreateFcn(hObject, eventdata, handles)
% hObject    handle to emission (see GCBO)
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
varname = [mygenvarname(get(handles.mesh,'String')) '_data'];


if strcmp(handles.type,'stnd_spn')
    % spn
    if get(handles.spn,'Value')==1
        content{end+1} = strcat(varname,' = femdata_sp1(',meshloc,',',...
            get(handles.frequency,'String'),');');
        if ~batch
            evalin('base',content{end});
        end
    elseif get(handles.spn,'Value')==2
        content{end+1} = strcat(varname,' = femdata_sp3(',meshloc,',',...
            get(handles.frequency,'String'),');');
        if ~batch
            evalin('base',content{end});
        end
    elseif get(handles.spn,'Value')==3
        content{end+1} = strcat(varname,' = femdata_sp5(',meshloc,',',...
            get(handles.frequency,'String'),');');
        if ~batch
            evalin('base',content{end});
        end
    elseif get(handles.spn,'Value')==4
        content{end+1} = strcat(varname,' = femdata_sp7(',meshloc,',',...
            get(handles.frequency,'String'),');');
        if ~batch
            evalin('base',content{end});
        end
    end
elseif strcmp(handles.type,'stnd_bem')
    % bem stnd
    content{end+1} = strcat(varname,' = bemdata_stnd(',meshloc,',',...
        get(handles.frequency,'String'),');');
    if ~batch
        evalin('base',content{end});
    end
elseif strcmp(handles.type,'spec_bem')
    % bem spec
    if wv_array
        content{end+1} = strcat(varname,' = bemdata_spectral(',meshloc,',',...
            get(handles.frequency,'String'),',',wv_array,');');
        if ~batch
            evalin('base',content{end});
        end
    else
        content{end+1} = strcat(varname,' = bemdata_spectral(',meshloc,',',...
            get(handles.frequency,'String'),');');
        if ~batch
            evalin('base',content{end});
        end
    end
else
    % not spn or bem
    if get(handles.time_resolved,'Value')
        % time resolved
        if strcmp(handles.type,'stnd')
            content{end+1} = strcat(varname,' = femdata_stnd_tr(',meshloc,',',...
                get(handles.total_time,'String'),',',...
                get(handles.time_interval,'String'),');');
            if ~batch
                evalin('base',content{end});
            end
        elseif strcmp(handles.type,'fluor')
            content{end+1} = strcat(varname,' = femdata_fl_tr(',meshloc,',',...
                get(handles.total_time,'String'),',',...
                get(handles.time_interval,'String'),');');
            if ~batch
                evalin('base',content{end});
            end
        end
    else
        % not time resolved
        if wv_array
            content{end+1} = strcat(varname,' = femdata(',meshloc,',',...
                get(handles.frequency,'String'),',',wv_array,');');
            if ~batch
                evalin('base',content{end});
            end
        else
            content{end+1} = strcat(varname,' = femdata(',meshloc,',',...
                get(handles.frequency,'String'),');');
            if ~batch
                evalin('base',content{end});
            end
        end
    end
end

if get(handles.save_data_to,'String')
    saveto = get(handles.save_data_to,'String');
    if ~canwrite(saveto)
        [junk fn ext1] = fileparts(saveto);
        saveto = [tempdir fn ext1];
        disp(['No write access, writing here instead: ' saveto]);
    end

    content{end+1} = strcat('save_data(',varname,',''',...
        saveto,''');');
    if ~batch
        evalin('base',content{end});
    end
end

% view solution
if get(handles.view_solution,'Value')
    if meshloc(1)==''''
        % mesh must be in a variable for plotimage
        content{end+1} = strcat('mesh = load_mesh(''',get(handles.mesh,'String'),''');');
        if ~batch
            evalin('base',content{end});
        end
    else
        content{end+1} = strcat('mesh = ',get(handles.mesh,'String'),';');
        if ~batch
            evalin('base',content{end});
        end
    end
    src1 = str2num(get(handles.source1,'String'));
    src2 = str2num(get(handles.source2,'String'));
    for i=src1:1:src2
        content{end+1} = strcat('plotimage(mesh',...
            ',log(',varname,'.phi(:,',num2str(i),'))); pause(0.2);');
        if ~batch
            evalin('base',content{end});
        end
    end
end

% view data
if get(handles.view_data,'Value')
    content{end+1} = strcat('plot_data(',varname,');');
    if ~batch
        evalin('base',content{end});
    end
end


set(mainGUIdata.script, 'String', content);
guidata(nirfast, mainGUIdata);
close(gui_forward_solver);



function fluor_param_Callback(hObject, eventdata, handles)
% hObject    handle to fluor_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fluor_param as text
%        str2double(get(hObject,'String')) returns contents of fluor_param as a double


% --- Executes during object creation, after setting all properties.
function fluor_param_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fluor_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browse_fluor_param.
function browse_fluor_param_Callback(hObject, eventdata, handles)
% hObject    handle to browse_fluor_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pn] = myuigetfile('*','Fluorescence Param File');
if fn == 0
    return;
end
set(handles.fluor_param,'String',[pn fn]);

guidata(hObject, handles);


% --- Executes on button press in view_solution.
function view_solution_Callback(hObject, eventdata, handles)
% hObject    handle to view_solution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of view_solution
if get(hObject,'Value')
    set(handles.source1,'Enable','on');
    set(handles.source2,'Enable','on');
else
    set(handles.source1,'Enable','off');
    set(handles.source2,'Enable','off');
end

guidata(hObject, handles);



function source1_Callback(hObject, eventdata, handles)
% hObject    handle to source1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of source1 as text
%        str2double(get(hObject,'String')) returns contents of source1 as a double


% --- Executes during object creation, after setting all properties.
function source1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to source1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function source2_Callback(hObject, eventdata, handles)
% hObject    handle to source2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of source2 as text
%        str2double(get(hObject,'String')) returns contents of source2 as a double


% --- Executes during object creation, after setting all properties.
function source2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to source2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
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


% --- Executes on button press in view_data.
function view_data_Callback(hObject, eventdata, handles)
% hObject    handle to view_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of view_data


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


% --- Executes on button press in time_resolved.
function time_resolved_Callback(hObject, eventdata, handles)
% hObject    handle to time_resolved (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of time_resolved
if get(hObject,'Value')
    set(handles.total_time,'Enable','on');
    set(handles.time_interval,'Enable','on');
    set(handles.frequency,'Enable','off');
else
    set(handles.total_time,'Enable','off');
    set(handles.time_interval,'Enable','off');
    set(handles.frequency,'Enable','on');
end


function total_time_Callback(hObject, eventdata, handles)
% hObject    handle to total_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of total_time as text
%        str2double(get(hObject,'String')) returns contents of total_time as a double


% --- Executes during object creation, after setting all properties.
function total_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to total_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function time_interval_Callback(hObject, eventdata, handles)
% hObject    handle to time_interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time_interval as text
%        str2double(get(hObject,'String')) returns contents of time_interval as a double


% --- Executes during object creation, after setting all properties.
function time_interval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
