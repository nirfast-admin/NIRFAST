function varargout = gui_reconstruct_multispectral(varargin)
% GUI_RECONSTRUCT M-file for gui_reconstruct_multispectral.fig
%      GUI_RECONSTRUCT, by itself, creates a new GUI_RECONSTRUCT or raises the existing
%      singleton*.
%
%      H = GUI_RECONSTRUCT returns the handle to a new GUI_RECONSTRUCT or the handle to
%      the existing singleton*.
%
%      GUI_RECONSTRUCT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_RECONSTRUCT.M with the given input arguments.
%
%      GUI_RECONSTRUCT('Property','Value',...) creates a new GUI_RECONSTRUCT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_reconstruct_multispectral_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_reconstruct_multispectral_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_reconstruct_multispectral

% Last Modified by GUIDE v2.5 07-Apr-2016 10:33:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_reconstruct_multispectral_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_reconstruct_multispectral_OutputFcn, ...
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


% --- Executes just before gui_reconstruct_multispectral is made visible.
function gui_reconstruct_multispectral_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_reconstruct_multispectral (see VARARGIN)

% Choose default command line output for gui_reconstruct_multispectral
handles.output = hObject;
set(hObject,'Name','Reconstruct Image');

% find workspace variables
vars = evalin('base','whos;');
varnames = {};
[nv,junk] = size(vars);
nflag = 1;
for i=1:1:nv
    flag = evalin('base',strcat('isfield(',vars(i).name,',''type'')'));
    if flag && strcmp('spec',evalin('base',strcat(vars(i).name,'.type')))
        varnames{nflag} = vars(i).name;
        nflag = nflag + 1;
    end
end
if ~isempty(varnames)
    set(handles.variables_mesh,'String',varnames);
    set(handles.variables_mesh_basis,'String',varnames);
end

varnames = {};
nflag = 1;
for i=1:1:nv
    flag = evalin('base',strcat('isfield(',vars(i).name,',''paa'')'));
    if flag
        varnames{nflag} = vars(i).name;
        nflag = nflag + 1;
    end
end
if ~isempty(varnames)
    set(handles.variables_data,'String',varnames);
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_reconstruct_multispectral wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_reconstruct_multispectral_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in help_pixel_basis.
function help_pixel_basis_Callback(hObject, eventdata, handles)
% hObject    handle to help_pixel_basis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of help_pixel_basis



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



function data_Callback(hObject, eventdata, handles)
% hObject    handle to data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of data as text
%        str2double(get(hObject,'String')) returns contents of data as a double


% --- Executes during object creation, after setting all properties.
function data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function savesolutionto_Callback(hObject, eventdata, handles)
% hObject    handle to savesolutionto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of savesolutionto as text
%        str2double(get(hObject,'String')) returns contents of savesolutionto as a double


% --- Executes during object creation, after setting all properties.
function savesolutionto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to savesolutionto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pixel_basis_Callback(hObject, eventdata, handles)
% hObject    handle to pixel_basis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pixel_basis as text
%        str2double(get(hObject,'String')) returns contents of pixel_basis as a double


% --- Executes during object creation, after setting all properties.
function pixel_basis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixel_basis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mesh_basis_Callback(hObject, eventdata, handles)
% hObject    handle to mesh_basis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mesh_basis as text
%        str2double(get(hObject,'String')) returns contents of mesh_basis as a double


% --- Executes during object creation, after setting all properties.
function mesh_basis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mesh_basis (see GCBO)
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



function iterations_Callback(hObject, eventdata, handles)
% hObject    handle to iterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of iterations as text
%        str2double(get(hObject,'String')) returns contents of iterations as a double


% --- Executes during object creation, after setting all properties.
function iterations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lambda_Callback(hObject, eventdata, handles)
% hObject    handle to lambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lambda as text
%        str2double(get(hObject,'String')) returns contents of lambda as a double


% --- Executes during object creation, after setting all properties.
function lambda_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function filters_Callback(hObject, eventdata, handles)
% hObject    handle to filters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filters as text
%        str2double(get(hObject,'String')) returns contents of filters as a double


% --- Executes during object creation, after setting all properties.
function filters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in view_solution.
function view_solution_Callback(hObject, eventdata, handles)
% hObject    handle to view_solution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of view_solution


% --- Executes on button press in done.
function done_Callback(hObject, eventdata, handles)
% hObject    handle to done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mainGUIhandle = nirfast;
mainGUIdata  = guidata(mainGUIhandle);
content = get(mainGUIdata.script,'String');
batch = get(mainGUIdata.batch_mode,'Value');

recbasis = get(handles.pixel_basis,'String');
if isempty(recbasis)
    recbasis = get_pathloc(get(handles.mesh_basis,'String'));
end

meshloc = get_pathloc(get(handles.mesh,'String'));
dataloc = get_pathloc(get(handles.data,'String'));
drugloc = get_pathloc(get(handles.drug,'String'));

%regularization
regtype=get(handles.regmethod,'Value');
if regtype == 1
    regtype = 'Automatic';
elseif regtype == 2
    regtype = 'JJt';
elseif regtype == 3
    regtype = 'JtJ';
end
content{end+1} = strcat('lambda.type=''',regtype,''';');
if ~batch
    evalin('base',content{end});
end
content{end+1} = strcat('lambda.value=',get(handles.lambda,'String'),';');
if ~batch
    evalin('base',content{end});
end

%check write access
saveto = get(handles.savesolutionto,'String');
if ~canwrite(saveto)
    [junk fn ext1] = fileparts(saveto);
    saveto = [tempdir fn ext1];
    disp(['No write access, writing here instead: ' saveto]);
    set(handles.savesolutionto,'String',saveto);
end


content{end+1} = strcat(...
    '[mesh,pj] = reconstruct_multispectral(',meshloc,...
    ',',recbasis,...
    ',',get(handles.frequency,'String'),...
    ',',dataloc,...
    ',',get(handles.iterations,'String'),...
    ',lambda',...
    ',''',get(handles.savesolutionto,'String'),...
    ''',',get(handles.filters,'String'),...
    ',',drugloc,...
    ',',get(handles.wv_array_emiss,'String'),...
    ',',get(handles.wv_excite,'String'),...
    ',',get(handles.eta,'String'),...
    ',',get(handles.tau,'String'),...
    ');'...
    );
if ~batch
    evalin('base',content{end});
end

        
if get(handles.view_solution,'Value')
    content{end+1} = strcat('read_solution(mesh,''',...
        get(handles.savesolutionto,'String'),''');');
    if ~batch
        evalin('base',content{end});
    end
end

set(mainGUIdata.script, 'String', content);
guidata(nirfast, mainGUIdata);
close(gui_reconstruct_multispectral);


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


% --- Executes on button press in browse_data.
function browse_data_Callback(hObject, eventdata, handles)
% hObject    handle to browse_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pn] = myuigetfile('*.paa','Input Data');
if fn == 0
    return;
end
set(handles.data,'String',[pn fn]);

guidata(hObject, handles);


% --- Executes on button press in browse_savesolutionto.
function browse_savesolutionto_Callback(hObject, eventdata, handles)
% hObject    handle to browse_savesolutionto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pn] = myuiputfile('','Save Solution To');
if fn == 0
    return;
end
set(handles.savesolutionto,'String',[pn fn]);

guidata(hObject, handles);


% --- Executes on button press in browse_mesh_basis.
function browse_mesh_basis_Callback(hObject, eventdata, handles)
% hObject    handle to browse_mesh_basis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pn] = myuigetfile('*.node','Mesh Basis');
if fn == 0
    return;
end
temp = [pn fn];
set(handles.mesh_basis,'String',temp(1:end-5));

guidata(hObject, handles);


% --- Executes on selection change in variables_mesh_basis.
function variables_mesh_basis_Callback(hObject, eventdata, handles)
% hObject    handle to variables_mesh_basis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns variables_mesh_basis contents as cell array
%        contents{get(hObject,'Value')} returns selected item from variables_mesh_basis
contents = get(hObject,'String');
set(handles.mesh_basis,'String',contents{get(hObject,'Value')});


% --- Executes during object creation, after setting all properties.
function variables_mesh_basis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to variables_mesh_basis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in variables_data.
function variables_data_Callback(hObject, eventdata, handles)
% hObject    handle to variables_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns variables_data contents as cell array
%        contents{get(hObject,'Value')} returns selected item from variables_data
contents = get(hObject,'String');
set(handles.data,'String',contents{get(hObject,'Value')});


% --- Executes during object creation, after setting all properties.
function variables_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to variables_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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


% --- Executes on selection change in regmethod.
function regmethod_Callback(hObject, eventdata, handles)
% hObject    handle to regmethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns regmethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from regmethod


% --- Executes during object creation, after setting all properties.
function regmethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to regmethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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
set(handles.drug,'String',[pn fn]);

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
