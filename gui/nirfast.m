function varargout = nirfast(varargin)
% NIRFAST M-file for nirfast.fig
%      NIRFAST, by itself, creates a new NIRFAST or raises the existing
%      singleton*.
%
%      H = NIRFAST returns the handle to a new NIRFAST or the handle to
%      the existing singleton*.
%
%      NIRFAST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NIRFAST.M with the given input arguments.
%
%      NIRFAST('Property','Value',...) creates a new NIRFAST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before nirfast_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to nirfast_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help_main nirfast

% Last Modified by GUIDE v2.5 24-Aug-2012 13:32:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @nirfast_OpeningFcn, ...
                   'gui_OutputFcn',  @nirfast_OutputFcn, ...
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


% --- Executes just before nirfast is made visible.
function nirfast_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to nirfast (see VARARGIN)

% Choose default command line output for nirfast
handles.output = hObject;
set(hObject,'Name','NIRFASTMatlab 9.1');

if ismac
    set(handles.script,'FontSize',13);
    set(handles.script,'FontName','Consolas');
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes nirfast wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = nirfast_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in add_anomaly.
function add_anomaly_Callback(hObject, eventdata, handles)
% hObject    handle to add_anomaly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in forward_solver.
function forward_solver_Callback(hObject, eventdata, handles)
% hObject    handle to forward_solver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in add_noise.
function add_noise_Callback(hObject, eventdata, handles)
% hObject    handle to add_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_add_noise();


% --- Executes on button press in calibrate_data.
function calibrate_data_Callback(hObject, eventdata, handles)
% hObject    handle to calibrate_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_calibrate();


% --- Executes on button press in view_jacobian.
function view_jacobian_Callback(hObject, eventdata, handles)
% hObject    handle to view_jacobian (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function script_CreateFcn(hObject, eventdata, handles)
% hObject    handle to script (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
content = get(handles.script,'String');
% if (ischar(content)~=0)
%     content = cellstr(content);
% end
if ischar(content)
    content = cellstr(content);
end
set(handles.script,'String',content);
for i=1:1:numel(content)
    evalin('base',content{i});
end


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
content = get(handles.script,'String');
[fn,pn] = myuiputfile('*.m','Save Script');
if fn == 0
    return;
end
fid = fopen([pn fn],'w');
if (ischar(content)~=0)
    content = cellstr(content);
end
for i=1:1:numel(content)
    fprintf(fid,'%s\n',content{i});
end
fclose(fid);


% --- Executes on button press in new.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pn] = myuigetfile('*.m','Load Script');
if fn == 0
    return;
end
content = importdata([pn fn]);
set(handles.script, 'String', content);
guidata(hObject, handles);



% --- Executes on button press in new.
function new_Callback(hObject, eventdata, handles)
% hObject    handle to new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.script,'String','');
guidata(hObject, handles);



% --- Executes on button press in reconstruct_image.
function reconstruct_image_Callback(hObject, eventdata, handles)
% hObject    handle to reconstruct_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%gui_file('text','Input Mesh :','button','Continue','title',...
%    'Reconstruct','function','gui_reconstruct(''location'',location);','expr','*.node');


% --- Executes on button press in help_main.
function help_main_Callback(hObject, eventdata, handles)
% hObject    handle to help_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in view_mesh.
function view_mesh_Callback(hObject, eventdata, handles)
% hObject    handle to view_mesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_view_mesh();


% --------------------------------------------------------------------
function Script_Callback(hObject, eventdata, handles)
% hObject    handle to Script (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in set_mesh.
function set_mesh_Callback(hObject, eventdata, handles)
% hObject    handle to set_mesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function data_Callback(hObject, eventdata, handles)
% hObject    handle to data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function calibrate_Callback(hObject, eventdata, handles)
% hObject    handle to calibrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function set_values_Callback(hObject, eventdata, handles)
% hObject    handle to set_values (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to forward_solver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function reconstruct_stnd_Callback(hObject, eventdata, handles)
% hObject    handle to reconstruct_stnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_reconstruct('type','stnd');


% --------------------------------------------------------------------
function reconstruct_fluor_Callback(hObject, eventdata, handles)
% hObject    handle to reconstruct_fluor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_reconstruct('type','fluor');


% --------------------------------------------------------------------
function reconstruct_spec_Callback(hObject, eventdata, handles)
% hObject    handle to reconstruct_spec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_reconstruct('type','spec');


% --------------------------------------------------------------------
function reconstruct_multispectral_Callback(hObject, eventdata, handles)
% hObject    handle to reconstruct_multispectral (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_reconstruct_multispectral();


% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
web 'http://code.google.com/p/nirfast/' -browser


% --------------------------------------------------------------------
function forward_solver_stnd_Callback(hObject, eventdata, handles)
% hObject    handle to forward_solver_stnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_forward_solver('type','stnd');


% --------------------------------------------------------------------
function forward_solver_fluor_Callback(hObject, eventdata, handles)
% hObject    handle to forward_solver_fluor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_forward_solver('type','fluor');


% --------------------------------------------------------------------
function forward_solver_spec_Callback(hObject, eventdata, handles)
% hObject    handle to forward_solver_spec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_forward_solver('type','spec');


% --------------------------------------------------------------------
function forward_solver_multispectral_Callback(hObject, eventdata, handles)
% hObject    handle to forward_solver_multispectral (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_forward_solver_multispectral();


% --------------------------------------------------------------------
function add_anomaly_stnd_Callback(hObject, eventdata, handles)
% hObject    handle to add_anomaly_stnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_add_anomaly('type','stnd');


% --------------------------------------------------------------------
function add_anomaly_fluor_Callback(hObject, eventdata, handles)
% hObject    handle to add_anomaly_fluor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_add_anomaly('type','fluor');


% --------------------------------------------------------------------
function add_anomaly_spec_Callback(hObject, eventdata, handles)
% hObject    handle to add_anomaly_spec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_add_anomaly('type','spec');


% --------------------------------------------------------------------
function view_jacobian_stnd_Callback(hObject, eventdata, handles)
% hObject    handle to view_jacobian_stnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_view_jacobian('type','stnd');


% --------------------------------------------------------------------
function view_jacobian_fluor_Callback(hObject, eventdata, handles)
% hObject    handle to view_jacobian_fluor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_view_jacobian('type','fluor');


% --------------------------------------------------------------------
function view_jacobian_spec_Callback(hObject, eventdata, handles)
% hObject    handle to view_jacobian_spec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_view_jacobian('type','spec');


% --------------------------------------------------------------------
function create_mesh_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function create_mesh_import_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function create_mesh_simple_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_simple (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function create_mesh_spectral_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_spectral (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function create_mesh_spn_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_spn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_create_mesh('type','stnd_spn');


% --------------------------------------------------------------------
function create_mesh_bem_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_bem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_create_mesh('type','stnd_bem');


% --------------------------------------------------------------------
function set_values_stnd_Callback(hObject, eventdata, handles)
% hObject    handle to set_values_stnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_set_values('type','stnd');


% --------------------------------------------------------------------
function set_values_fluor_Callback(hObject, eventdata, handles)
% hObject    handle to set_values_fluor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_set_values('type','fluor');


% --------------------------------------------------------------------
function set_values_spec_Callback(hObject, eventdata, handles)
% hObject    handle to set_values_spec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_set_values('type','spec');



% --------------------------------------------------------------------
function script_Callback(hObject, eventdata, handles)
% hObject    handle to set_values_spec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function solution_Callback(hObject, eventdata, handles)
% hObject    handle to solution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function view_solution_Callback(hObject, eventdata, handles)
% hObject    handle to view_solution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_view_solution();


% --- Executes on button press in batch_mode.
function batch_mode_Callback(hObject, eventdata, handles)
% hObject    handle to batch_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of batch_mode


% --------------------------------------------------------------------
function load_mesh_Callback(hObject, eventdata, handles)
% hObject    handle to load_mesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_load_mesh();


% --------------------------------------------------------------------
function view_data_Callback(hObject, eventdata, handles)
% hObject    handle to view_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_view_data();


% --------------------------------------------------------------------
function calibrate_stnd_Callback(hObject, eventdata, handles)
% hObject    handle to calibrate_stnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_calibrate('type','stnd');


% --------------------------------------------------------------------
function calibrate_fluor_Callback(hObject, eventdata, handles)
% hObject    handle to calibrate_fluor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_calibrate_fluor();


% --------------------------------------------------------------------
function calibrate_spec_Callback(hObject, eventdata, handles)
% hObject    handle to calibrate_spec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_calibrate('type','spec');


% --------------------------------------------------------------------
function save_mesh_Callback(hObject, eventdata, handles)
% hObject    handle to save_mesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_save_mesh();


% --------------------------------------------------------------------
function load_data_Callback(hObject, eventdata, handles)
% hObject    handle to load_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_load_data();


% --------------------------------------------------------------------
function save_data_Callback(hObject, eventdata, handles)
% hObject    handle to save_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_save_data();


% --------------------------------------------------------------------
function analyze_data_Callback(hObject, eventdata, handles)
% hObject    handle to analyze_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_analyze_data();


% --------------------------------------------------------------------
function forward_solver_spn_Callback(hObject, eventdata, handles)
% hObject    handle to forward_solver_spn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_forward_solver('type','stnd_spn');


% --------------------------------------------------------------------
function add_anomaly_spn_Callback(hObject, eventdata, handles)
% hObject    handle to add_anomaly_spn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_add_anomaly('type','stnd_spn');


% --------------------------------------------------------------------
function set_values_spn_Callback(hObject, eventdata, handles)
% hObject    handle to set_values_spn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_set_values('type','stnd_spn');


% --------------------------------------------------------------------
function set_values_bem_Callback(hObject, eventdata, handles)
% hObject    handle to set_values_bem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_set_values('type','stnd_bem');


% --------------------------------------------------------------------
function forward_solver_bem_Callback(hObject, eventdata, handles)
% hObject    handle to forward_solver_bem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_forward_solver('type','stnd_bem');


% --------------------------------------------------------------------
function create_mesh_stnd_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_stnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_create_mesh('type','stnd');


% --------------------------------------------------------------------
function create_mesh_fluor_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_fluor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_create_mesh('type','fluor');

% --------------------------------------------------------------------
function create_mesh_spec_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_spec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_create_mesh('type','spec');


% --------------------------------------------------------------------
function add_anomaly_bem_Callback(hObject, eventdata, handles)
% hObject    handle to add_anomaly_bem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_add_anomaly('type','stnd_bem');


% --------------------------------------------------------------------
function export_Callback(hObject, eventdata, handles)
% hObject    handle to export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function plot_emiss_spec_Callback(hObject, eventdata, handles)
% hObject    handle to plot_emiss_spec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_plot_emiss_spec();


% --------------------------------------------------------------------
function view_jacobian_stnd_bem_Callback(hObject, eventdata, handles)
% hObject    handle to view_jacobian_stnd_bem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_view_jacobian('type','stnd_bem');


% --------------------------------------------------------------------
function export_vtk_Callback(hObject, eventdata, handles)
% hObject    handle to export_vtk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_convert_nirfasttovtk();


% --------------------------------------------------------------------
function view_jacobian_stnd_spn_Callback(hObject, eventdata, handles)
% hObject    handle to view_jacobian_stnd_spn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_view_jacobian('type','stnd_spn');


% --------------------------------------------------------------------
function reconstruct_stnd_spn_Callback(hObject, eventdata, handles)
% hObject    handle to reconstruct_stnd_spn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_reconstruct('type','stnd_spn');



% --------------------------------------------------------------------
function create_mesh_2D_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_2D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function create_mesh_3D_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function create_mesh_3D_stnd_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_3D_stnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_convert_inptonirfast('type','stnd');


% --------------------------------------------------------------------
function create_mesh_3D_fluor_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_3D_fluor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_convert_inptonirfast('type','fluor');


% --------------------------------------------------------------------
function create_mesh_3D_spec_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_3D_spec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_convert_inptonirfast('type','spec');


% --------------------------------------------------------------------
function create_mesh_3D_stnd_spn_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_3D_stnd_spn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_convert_inptonirfast('type','stnd_spn');


% --------------------------------------------------------------------
function create_mesh_3D_stnd_bem_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_3D_stnd_bem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_convert_inptonirfast('type','stnd_bem');



% --------------------------------------------------------------------
function create_mesh_2D_stnd_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_2D_stnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_create_mesh_2D('type','stnd');


% --------------------------------------------------------------------
function create_mesh_2D_fluor_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_2D_fluor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_create_mesh_2D('type','fluor');


% --------------------------------------------------------------------
function create_mesh_2D_spec_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_2D_spec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_create_mesh_2D('type','spec');


% --------------------------------------------------------------------
function create_mesh_2D_stnd_spn_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_2D_stnd_spn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_create_mesh_2D('type','stnd_spn');


% --------------------------------------------------------------------
function reconstruct_stnd_bem_Callback(hObject, eventdata, handles)
% hObject    handle to reconstruct_stnd_bem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_reconstruct('type','stnd_bem');


% --------------------------------------------------------------------
function set_values_fluor_bem_Callback(hObject, eventdata, handles)
% hObject    handle to set_values_fluor_bem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_set_values('type','fluor_bem');


% --------------------------------------------------------------------
function set_values_spec_bem_Callback(hObject, eventdata, handles)
% hObject    handle to set_values_spec_bem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_set_values('type','spec_bem');


% --------------------------------------------------------------------
function add_anomaly_fluor_bem_Callback(hObject, eventdata, handles)
% hObject    handle to add_anomaly_fluor_bem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_add_anomaly('type','fluor_bem');


% --------------------------------------------------------------------
function add_anomaly_spec_bem_Callback(hObject, eventdata, handles)
% hObject    handle to add_anomaly_spec_bem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_add_anomaly('type','spec_bem');


% --------------------------------------------------------------------
function create_mesh_3D_fluor_bem_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_3D_fluor_bem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_convert_inptonirfast('type','fluor_bem');


% --------------------------------------------------------------------
function create_mesh_3D_spec_bem_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_3D_spec_bem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_convert_inptonirfast('type','spec_bem');


% --------------------------------------------------------------------
function create_mesh_fluor_bem_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_fluor_bem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_create_mesh('type','fluor_bem');


% --------------------------------------------------------------------
function create_mesh_spec_bem_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_spec_bem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_create_mesh('type','spec_bem');


% --------------------------------------------------------------------
function forward_solver_spec_bem_Callback(hObject, eventdata, handles)
% hObject    handle to forward_solver_spec_bem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_forward_solver('type','spec_bem');


% --------------------------------------------------------------------
function view_jacobian_spec_bem_Callback(hObject, eventdata, handles)
% hObject    handle to view_jacobian_spec_bem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_view_jacobian('type','spec_bem');


% --------------------------------------------------------------------
function reconstruct_spec_bem_Callback(hObject, eventdata, handles)
% hObject    handle to reconstruct_spec_bem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_reconstruct('type','spec_bem');


% --------------------------------------------------------------------
function create_mesh_3D_mask_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_3D_mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image2mesh_gui();


% --------------------------------------------------------------------
function create_mesh_3D_surface_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_3D_surface (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function create_mesh_3D_surface_stnd_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_3D_surface_stnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_convert_inptonirfast('type','stnd','structure','surface');


% --------------------------------------------------------------------
function create_mesh_3D_surface_fluor_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_3D_surface_fluor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_convert_inptonirfast('type','fluor','structure','surface');


% --------------------------------------------------------------------
function create_mesh_3D_surface_spec_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_3D_surface_spec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_convert_inptonirfast('type','spec','structure','surface');


% --------------------------------------------------------------------
function create_mesh_3D_surface_spn_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_3D_surface_spn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_convert_inptonirfast('type','stnd_spn','structure','surface');



% --------------------------------------------------------------------
function set_mesh_type_Callback(hObject, eventdata, handles)
% hObject    handle to set_mesh_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_set_mesh_type();


% --------------------------------------------------------------------
function reconstruct_menu_Callback(hObject, eventdata, handles)
% hObject    handle to reconstruct_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function create_mesh_3D_volume_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_3D_volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function create_mesh_3D_volume_stnd_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_3D_volume_stnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_create_mesh_3D_volume('type','stnd');


% --------------------------------------------------------------------
function create_mesh_3D_volume_fluor_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_3D_volume_fluor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_create_mesh_3D_volume('type','fluor');


% --------------------------------------------------------------------
function create_mesh_3D_volume_spec_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_3D_volume_spec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_create_mesh_3D_volume('type','spec');


% --------------------------------------------------------------------
function create_mesh_3D_volume_spn_Callback(hObject, eventdata, handles)
% hObject    handle to create_mesh_3D_volume_spn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_create_mesh_3D_volume('type','stnd_spn');


% --- Executes during object deletion, before destroying properties.
function script_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to script (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
