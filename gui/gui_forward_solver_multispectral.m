function varargout = gui_forward_solver_multispectral(varargin)
% GUI_FORWARD_SOLVER_MULTISPECTRAL M-file for gui_forward_solver_multispectral.fig
%      GUI_FORWARD_SOLVER_MULTISPECTRAL, by itself, creates a new GUI_FORWARD_SOLVER_MULTISPECTRAL or raises the existing
%      singleton*.
%
%      H = GUI_FORWARD_SOLVER_MULTISPECTRAL returns the handle to a new GUI_FORWARD_SOLVER_MULTISPECTRAL or the handle to
%      the existing singleton*.
%
%      GUI_FORWARD_SOLVER_MULTISPECTRAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_FORWARD_SOLVER_MULTISPECTRAL.M with the given input arguments.
%
%      GUI_FORWARD_SOLVER_MULTISPECTRAL('Property','Value',...) creates a new GUI_FORWARD_SOLVER_MULTISPECTRAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_forward_solver_multispectral_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_forward_solver_multispectral_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_forward_solver_multispectral

% Last Modified by GUIDE v2.5 18-Apr-2012 12:05:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_forward_solver_multispectral_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_forward_solver_multispectral_OutputFcn, ...
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


% --- Executes just before gui_forward_solver_multispectral is made visible.
function gui_forward_solver_multispectral_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_forward_solver_multispectral (see VARARGIN)

% Choose default command line output for gui_forward_solver_multispectral
handles.output = hObject;
set(hObject,'Name','Forward Solver');

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

% UIWAIT makes gui_forward_solver_multispectral wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_forward_solver_multispectral_OutputFcn(hObject, eventdata, handles) 
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
meshname = contents{get(hObject,'Value')};
set(handles.mesh,'String',meshname);
mesh = evalin('base',meshname);
if isfield(mesh,'wv')
    set(handles.wv_array_emiss,'TooltipString',mat2str(mesh.wv'));
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



function wv_array_absorb_Callback(hObject, eventdata, handles)
% hObject    handle to wv_array_absorb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wv_array_absorb as text
%        str2double(get(hObject,'String')) returns contents of wv_array_absorb as a double


% --- Executes during object creation, after setting all properties.
function wv_array_absorb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wv_array_absorb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wv_array_emiss_Callback(hObject, eventdata, handles)
% hObject    handle to wv_array_emiss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wv_array_emiss as text
%        str2double(get(hObject,'String')) returns contents of wv_array_emiss as a double


% --- Executes during object creation, after setting all properties.
function wv_array_emiss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wv_array_emiss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wv_excite_Callback(hObject, eventdata, handles)
% hObject    handle to wv_excite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wv_excite as text
%        str2double(get(hObject,'String')) returns contents of wv_excite as a double


% --- Executes during object creation, after setting all properties.
function wv_excite_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wv_excite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function eta_Callback(hObject, eventdata, handles)
% hObject    handle to eta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eta as text
%        str2double(get(hObject,'String')) returns contents of eta as a double


% --- Executes during object creation, after setting all properties.
function eta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function savedatato_spec_Callback(hObject, eventdata, handles)
% hObject    handle to savedatato_spec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of savedatato_spec as text
%        str2double(get(hObject,'String')) returns contents of savedatato_spec as a double


% --- Executes during object creation, after setting all properties.
function savedatato_spec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to savedatato_spec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function savedatato_fluor_Callback(hObject, eventdata, handles)
% hObject    handle to savedatato_fluor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of savedatato_fluor as text
%        str2double(get(hObject,'String')) returns contents of savedatato_fluor as a double


% --- Executes during object creation, after setting all properties.
function savedatato_fluor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to savedatato_fluor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in view_data_spec.
function view_data_spec_Callback(hObject, eventdata, handles)
% hObject    handle to view_data_spec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of view_data_spec


% --- Executes on button press in view_data_fluor.
function view_data_fluor_Callback(hObject, eventdata, handles)
% hObject    handle to view_data_fluor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of view_data_fluor


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
drugloc = get_pathloc(get(handles.drug,'String'));
varname_fluor = [mygenvarname(get(handles.mesh,'String')) '_datafluor'];


content{end+1} = strcat(varname_fluor,...
    ' = femdata_multispectral(',meshloc,',',...
    get(handles.frequency,'String'),...
    ',',drugloc,...
    ',',get(handles.wv_array_emiss,'String'),...
    ',',get(handles.wv_excite,'String'),...
    ',',get(handles.eta,'String'),...
    ',',get(handles.tau,'String'),...
    ');');
if ~batch
    evalin('base',content{end});
end

if get(handles.savedatato_fluor,'String')
    saveto = get(handles.savedatato_fluor,'String');
    if ~canwrite(saveto)
        [junk fn ext1] = fileparts(saveto);
        saveto = [tempdir fn ext1];
        disp(['No write access, writing here instead: ' saveto]);
    end

    content{end+1} = strcat('save_data(',varname_fluor,',''',...
        saveto,''');');
    if ~batch
        evalin('base',content{end});
    end
end

% view data
if get(handles.view_data_fluor,'Value')
    content{end+1} = strcat('plot_data(',varname_fluor,');');
    if ~batch
        evalin('base',content{end});
    end
end


set(mainGUIdata.script, 'String', content);
guidata(nirfast, mainGUIdata);
close(gui_forward_solver_multispectral);



% --- Executes on button press in browse_savedatato_fluor.
function browse_savedatato_fluor_Callback(hObject, eventdata, handles)
% hObject    handle to browse_savedatato_fluor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pn] = myuiputfile('*.paa','Save Data To');
if fn == 0
    return;
end
set(handles.savedatato_fluor,'String',[pn fn]);

guidata(hObject, handles);


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



function drug_Callback(hObject, eventdata, handles)
% hObject    handle to drug (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of drug as text
%        str2double(get(hObject,'String')) returns contents of drug as a double


% --- Executes during object creation, after setting all properties.
function drug_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drug (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browse_drug.
function browse_drug_Callback(hObject, eventdata, handles)
% hObject    handle to browse_drug (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pn] = myuigetfile('*.etaspec','Drug Re-emission Spectrum');
if fn == 0
    return;
end
temp = [pn fn];
set(handles.drug,'String',temp);

guidata(hObject, handles);



function tau_Callback(hObject, eventdata, handles)
% hObject    handle to tau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tau as text
%        str2double(get(hObject,'String')) returns contents of tau as a double


% --- Executes during object creation, after setting all properties.
function tau_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
