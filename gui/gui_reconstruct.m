function varargout = gui_reconstruct(varargin)
% GUI_RECONSTRUCT M-file for gui_reconstruct.fig
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
%      applied to the GUI before gui_reconstruct_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_reconstruct_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_reconstruct

% Last Modified by GUIDE v2.5 11-Aug-2011 08:30:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_reconstruct_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_reconstruct_OutputFcn, ...
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


% --- Executes just before gui_reconstruct is made visible.
function gui_reconstruct_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_reconstruct (see VARARGIN)

% Choose default command line output for gui_reconstruct
handles.output = hObject;
set(hObject,'Name','Reconstruct Image');
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
if strcmp(handles.type,'fluor')
    set(handles.frequency,'String','0');
    set(handles.frequency,'Enable','off');
end
set(handles.spn,'Value',3.0);
if strcmp(handles.type,'stnd_spn')==0
    set(handles.spn,'Enable','off');
else
    set(handles.hard_priori,'Enable','off');
    set(handles.soft_priori,'Enable','off');
end
if strcmp(handles.type,'stnd_bem') || strcmp(handles.type,'spec_bem')
    set(handles.hard_priori,'Enable','off');
    set(handles.soft_priori,'Enable','off');
    set(handles.mesh_basis,'Enable','off');
    set(handles.pixel_basis,'Enable','off');
    set(handles.regmethod,'Enable','off');
end
if ~strcmp(handles.type,'spec') && ~strcmp(handles.type,'stnd')
    set(handles.conjugate_gradient,'Enable','off');
end

% find solvers
solver_loc = what('solvers');
solvers = dir([solver_loc.path '/solver_*']);
varnames = {'automatic'};
for i=1:size(solvers)
    varnames{i+1} = solvers(i).name(8:end-2);
end
set(handles.solver,'String',varnames);

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
    set(handles.variables_mesh_basis,'String',varnames);
end

varnames = {};
nflag = 1;
for i=1:1:nv
    flag = evalin('base',strcat('isfield(',vars(i).name,',''paa'')'));
    flag2 = evalin('base',strcat('isfield(',vars(i).name,',''amplitudefl'')'));
    if flag || flag2
        varnames{nflag} = vars(i).name;
        nflag = nflag + 1;
    end
end
if ~isempty(varnames)
    set(handles.variables_data,'String',varnames);
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_reconstruct wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_reconstruct_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in soft_priori.
function soft_priori_Callback(hObject, eventdata, handles)
% hObject    handle to soft_priori (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of soft_priori
if get(hObject,'Value')
    set(handles.hard_priori,'Value',0);
    set(handles.regmethod,'Enable','off');
    set(handles.pixel_basis,'Enable','on');
    set(handles.mesh_basis,'Enable','on');
else
    set(handles.regmethod,'Enable','on');
end

guidata(hObject, handles);


% --- Executes on button press in hard_priori.
function hard_priori_Callback(hObject, eventdata, handles)
% hObject    handle to hard_priori (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hard_priori
if get(hObject,'Value')
    set(handles.soft_priori,'Value',0);
    set(handles.regmethod,'Enable','off');
    set(handles.pixel_basis,'Enable','off');
    set(handles.mesh_basis,'Enable','off');
else
    set(handles.regmethod,'Enable','on');
    set(handles.pixel_basis,'Enable','on');
    set(handles.mesh_basis,'Enable','on');
end

guidata(hObject, handles);



function regions_Callback(hObject, eventdata, handles)
% hObject    handle to regions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of regions as text
%        str2double(get(hObject,'String')) returns contents of regions as a double


% --- Executes during object creation, after setting all properties.
function regions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to regions (see GCBO)
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
meshloc = get_pathloc(get(handles.mesh,'String'));
dataloc = get_pathloc(get(handles.data,'String'));

if isempty(recbasis)
    if isempty(get(handles.mesh_basis,'String'))
        error('\nYou need to specify a form of reconstruction basis.');
    end
    recbasis = get_pathloc(get(handles.mesh_basis,'String'));
else
    if  evalin('base',['ischar(' meshloc ')'])
        foo = evalin('base',['load_mesh(' meshloc ')']);
    else
        foo = evalin('base',meshloc);
    end
    if ~isempty(get(handles.mesh_basis,'String'))
        warndlg({'Both type of mesh basis are specified!',...
            'nirfast will use ''pixel basis''!'},'Pixel Bais dilemma!');
    end
    clear foo;
end

%solver
solvers = get(handles.solver,'String');
solver = solvers(get(handles.solver,'Value'));
if ~strcmp(solver,'automatic')
    content{end+1} = strcat('setpref(''nirfast'',''solver'',''',solver{1},''');');
    if ~batch
        evalin('base',content{end});
    end
end

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

% parsing
% CONJUGATE GRADIENT
% NOT CONJUGATE GRADIENT
    % WAVELENGTH INFO
        % SOFT PRIORI
            % CW
            % NO CW
        % HARD PRIORI
            % CW
            % NO CW
        % NO PRIORI
            % BEM SPECTRAL
            % SPECTRAL - NOT BEM
    % NO WAVELENGTH INFO
        % HARD PRIORI
            % STND
                % CW
                % NO CW
            % FLUOR
            % SPEC
                % CW
                % NO CW
        % SOFT PRIORI
            % STND
                % CW
                % NO CW
            % FLUOR
            % SPEC
                % CW
                % NO CW
        % NO PRIORI
            % SPN
                % CW
                % NO CW
            % BEM
            % BEM SPECTRAL
            % OTHER

% CONJUGATE GRADIENT
if get(handles.conjugate_gradient,'Value')
    content{end+1} = strcat(...
    '[recParam regParam mesh] = getDefaultRecRegSettings(',...
    meshloc,',',dataloc,',',get(handles.frequency,'String'),');'...
    );
    if ~batch
        evalin('base',content{end});
    end
    
    content{end+1} = strcat('recParam.numberIterations = ',...
        get(handles.iterations,'String'),';');
    if ~batch
        evalin('base',content{end});
    end
    
    content{end+1} = strcat('recParam.pixelBasis = ',...
        recbasis,';');
    if ~batch
        evalin('base',content{end});
    end
    
    content{end+1} = strcat('recParam.useHardPrior = ',...
        num2str(get(handles.hard_priori,'Value')),';');
    if ~batch
        evalin('base',content{end});
    end
    
    content{end+1} = strcat('regParam.lambda = ',...
        get(handles.lambda,'String'),';');
    if ~batch
        evalin('base',content{end});
    end
    
    content{end+1} = strcat(...
    'mesh = conjugateGradientReconstruction(mesh',...
    ',',dataloc,...
    ',',get(handles.frequency,'String'),...
    ',recParam,regParam,''',get(handles.savesolutionto,'String'),''');'...
    );
    if ~batch
        evalin('base',content{end});
    end
else
    % WAVELENGTH INFO
    if get(handles.wv_array,'String')
        % SOFT PRIORI
        if get(handles.soft_priori,'Value')
            if strcmp(get(handles.frequency,'String'),'0')
                content{end+1} = strcat(...
                '[mesh,pj] = reconstruct_spectral_cw_spatial(',meshloc,...
                ',',recbasis,...
                ',',dataloc,...
                ',',get(handles.iterations,'String'),...
                ',',get(handles.lambda,'String'),...
                ',''',get(handles.savesolutionto,'String'),...
                ''',',get(handles.filters,'String'),...
                ',',get(handles.wv_array,'String'),...
                ');'...
                );
                if ~batch
                    evalin('base',content{end});
                end
            else
                content{end+1} = strcat(...
                '[mesh,pj] = reconstruct_spectral_spatial(',meshloc,...
                ',',recbasis,...
                ',',get(handles.frequency,'String'),...
                ',',dataloc,...
                ',',get(handles.iterations,'String'),...
                ',',get(handles.lambda,'String'),...
                ',''',get(handles.savesolutionto,'String'),...
                ''',',get(handles.filters,'String'),...
                ',',get(handles.wv_array,'String'),...
                ');'...
                );
                if ~batch
                    evalin('base',content{end});
                end
            end
        % HARD PRIORI
        elseif get(handles.hard_priori,'Value')
            if strcmp(get(handles.frequency,'String'),'0')
                content{end+1} = strcat(...
                '[mesh,pj] = reconstruct_spectral_cw_region(',meshloc,...
                ',',dataloc,...
                ',',get(handles.iterations,'String'),...
                ',',get(handles.lambda,'String'),...
                ',''',get(handles.savesolutionto,'String'),...
                ''',',get(handles.filters,'String'),...
                ',[],',get(handles.wv_array,'String'),...
                ');'...
                );
                if ~batch
                    evalin('base',content{end});
                end
            else
                content{end+1} = strcat(...
                '[mesh,pj] = reconstruct_spectral_region(',meshloc,...
                ',',get(handles.frequency,'String'),...
                ',',dataloc,...
                ',',get(handles.iterations,'String'),...
                ',',get(handles.lambda,'String'),...
                ',''',get(handles.savesolutionto,'String'),...
                ''',',get(handles.filters,'String'),...
                ',[],',get(handles.wv_array,'String'),...
                ');'...
                );
                if ~batch
                    evalin('base',content{end});
                end
            end
        % NO PRIORI
        else
            if strcmp(handles.type,'spec_bem')
                % BEM SPECTRAL
                if strcmp(get(handles.frequency,'String'),'0')
                    content{end+1} = strcat(...
                    '[mesh,pj] = reconstruct_spectral_cw_bem(',meshloc,...
                    ',',dataloc,...
                    ',',get(handles.iterations,'String'),...
                    ',',get(handles.lambda,'String'),...
                    ',''',get(handles.savesolutionto,'String'),...
                    ''',',get(handles.filters,'String'),...
                    ',',get(handles.wv_array,'String'),...
                    ');'...
                    );
                    if ~batch
                        evalin('base',content{end});
                    end
                else
                    content{end+1} = strcat(...
                    '[mesh,pj] = reconstruct_spectral_bem(',meshloc,...
                    ',',get(handles.frequency,'String'),...
                    ',',dataloc,...
                    ',',get(handles.iterations,'String'),...
                    ',',get(handles.lambda,'String'),...
                    ',''',get(handles.savesolutionto,'String'),...
                    ''',',get(handles.filters,'String'),...
                    ',',get(handles.wv_array,'String'),...
                    ');'...
                    );
                    if ~batch
                        evalin('base',content{end});
                    end
                end
            else
                % SPECTRAL - NOT BEM
                content{end+1} = strcat(...
                '[mesh,pj] = reconstruct(',meshloc,...
                ',',recbasis,...
                ',',get(handles.frequency,'String'),...
                ',',dataloc,...
                ',',get(handles.iterations,'String'),...
                ',lambda',...
                ',''',get(handles.savesolutionto,'String'),...
                ''',',get(handles.filters,'String'),...
                ',',get(handles.wv_array,'String'),...
                ');'...
                );
                if ~batch
                    evalin('base',content{end});
                end
            end
        end

    % NO WAVELENGTH INFO
    else
        % HARD PRIORI
        if get(handles.hard_priori,'Value')
            % STANDARD
            if strcmp(handles.type,'stnd')~=0
                % CW
                if strcmp(get(handles.frequency,'String'),'0')
                    content{end+1} = strcat(...
                    '[mesh,pj] = reconstruct_stnd_cw_region(',meshloc,...
                    ',',dataloc,...
                    ',',get(handles.iterations,'String'),...
                    ',',get(handles.lambda,'String'),...
                    ',''',get(handles.savesolutionto,'String'),...
                    ''',',get(handles.filters,'String'),...
                    ');'...
                    );
                    if ~batch
                        evalin('base',content{end});
                    end
                % not CW
                else
                    content{end+1} = strcat(...
                    '[mesh,pj] = reconstruct_stnd_region(',meshloc,...
                    ',',get(handles.frequency,'String'),...
                    ',',dataloc,...
                    ',',get(handles.iterations,'String'),...
                    ',',get(handles.lambda,'String'),...
                    ',''',get(handles.savesolutionto,'String'),...
                    ''',',get(handles.filters,'String'),...
                    ');'...
                    );
                    if ~batch
                        evalin('base',content{end});
                    end
                end
            % FLUORESCENCE
            elseif strcmp(handles.type,'fluor')~=0
                content{end+1} = strcat(...
                '[mesh,pj] = reconstruct_fl_region(',meshloc,...
                ',',get(handles.frequency,'String'),...
                ',',dataloc,...
                ',',get(handles.iterations,'String'),...
                ',',get(handles.lambda,'String'),...
                ',''',get(handles.savesolutionto,'String'),...
                ''',',get(handles.filters,'String'),...
                ');'...
                );
                if ~batch
                    evalin('base',content{end});
                end
            % SPECTRAL
            elseif strcmp(handles.type,'spec')~=0
                if strcmp(get(handles.frequency,'String'),'0')
                    content{end+1} = strcat(...
                    '[mesh,pj] = reconstruct_spectral_cw_region(',meshloc,...
                    ',',dataloc,...
                    ',',get(handles.iterations,'String'),...
                    ',',get(handles.lambda,'String'),...
                    ',''',get(handles.savesolutionto,'String'),...
                    ''',',get(handles.filters,'String'),...
                    ');'...
                    );
                    if ~batch
                        evalin('base',content{end});
                    end
                else
                    content{end+1} = strcat(...
                    '[mesh,pj] = reconstruct_spectral_region(',meshloc,...
                    ',',get(handles.frequency,'String'),...
                    ',',dataloc,...
                    ',',get(handles.iterations,'String'),...
                    ',',get(handles.lambda,'String'),...
                    ',''',get(handles.savesolutionto,'String'),...
                    ''',',get(handles.filters,'String'),...
                    ');'...
                    );
                    if ~batch
                        evalin('base',content{end});
                    end
                end
            end
        % SOFT PRIORI
        elseif get(handles.soft_priori,'Value')
            % STANDARD
            if strcmp(handles.type,'stnd')~=0
                if strcmp(get(handles.frequency,'String'),'0')
                    content{end+1} = strcat(...
                    '[mesh,pj] = reconstruct_stnd_cw_spatial(',meshloc,...
                    ',',recbasis,...
                    ',',dataloc,...
                    ',',get(handles.iterations,'String'),...
                    ',',get(handles.lambda,'String'),...
                    ',''',get(handles.savesolutionto,'String'),...
                    ''',',get(handles.filters,'String'),...
                    ');'...
                    );
                    if ~batch
                        evalin('base',content{end});
                    end
                else
                    content{end+1} = strcat(...
                    '[mesh,pj] = reconstruct_stnd_spatial(',meshloc,...
                    ',',recbasis,...
                    ',',get(handles.frequency,'String'),...
                    ',',dataloc,...
                    ',',get(handles.iterations,'String'),...
                    ',',get(handles.lambda,'String'),...
                    ',''',get(handles.savesolutionto,'String'),...
                    ''',',get(handles.filters,'String'),...
                    ');'...
                    );
                    if ~batch
                        evalin('base',content{end});
                    end
                end
            % FLUORESCENCE
            elseif strcmp(handles.type,'fluor')~=0
                content{end+1} = strcat(...
                '[mesh,pj] = reconstruct_fl_spatial(',meshloc,...
                ',',recbasis,...
                ',',get(handles.frequency,'String'),...
                ',',dataloc,...
                ',',get(handles.iterations,'String'),...
                ',',get(handles.lambda,'String'),...
                ',''',get(handles.savesolutionto,'String'),...
                ''',',get(handles.filters,'String'),...
                ');'...
                );
                if ~batch
                    evalin('base',content{end});
                end
            % SPECTRAL
            elseif strcmp(handles.type,'spec')~=0
                if strcmp(get(handles.frequency,'String'),'0')
                    content{end+1} = strcat(...
                    '[mesh,pj] = reconstruct_spectral_cw_spatial(',meshloc,...
                    ',',recbasis,...
                    ',',dataloc,...
                    ',',get(handles.iterations,'String'),...
                    ',',get(handles.lambda,'String'),...
                    ',''',get(handles.savesolutionto,'String'),...
                    ''',',get(handles.filters,'String'),...
                    ');'...
                    );
                    if ~batch
                        evalin('base',content{end});
                    end
                else
                    content{end+1} = strcat(...
                    '[mesh,pj] = reconstruct_spectral_spatial(',meshloc,...
                    ',',recbasis,...
                    ',',get(handles.frequency,'String'),...
                    ',',dataloc,...
                    ',',get(handles.iterations,'String'),...
                    ',',get(handles.lambda,'String'),...
                    ',''',get(handles.savesolutionto,'String'),...
                    ''',',get(handles.filters,'String'),...
                    ');'...
                    );
                    if ~batch
                        evalin('base',content{end});
                    end
                end
            end
        % NO PRIORI
        else
            if strcmp(handles.type,'stnd_spn')
                % SPN
                if strcmp(get(handles.frequency,'String'),'0')
                    content{end+1} = strcat(...
                    '[mesh,pj] = reconstruct_stnd_cw_spn(',meshloc,...
                    ',',recbasis,...
                    ',',dataloc,...
                    ',',get(handles.iterations,'String'),...
                    ',lambda',...
                    ',''',get(handles.savesolutionto,'String'),...
                    ''',',get(handles.filters,'String'),...
                    ',',num2str(get(handles.spn,'Value')*2-1),...
                    ');'...
                    );
                    if ~batch
                        evalin('base',content{end});
                    end
                else
                    content{end+1} = strcat(...
                    '[mesh,pj] = reconstruct_stnd_spn(',meshloc,...
                    ',',recbasis,...
                    ',',get(handles.frequency,'String'),...
                    ',',dataloc,...
                    ',',get(handles.iterations,'String'),...
                    ',lambda',...
                    ',''',get(handles.savesolutionto,'String'),...
                    ''',',get(handles.filters,'String'),...
                    ',',num2str(get(handles.spn,'Value')*2-1),...
                    ');'...
                    );
                    if ~batch
                        evalin('base',content{end});
                    end
                end
            elseif strcmp(handles.type,'stnd_bem')
                % BEM
                if strcmp(get(handles.frequency,'String'),'0')
                    content{end+1} = strcat(...
                    '[mesh,pj] = reconstruct_stnd_cw_bem(',meshloc,...
                    ',',dataloc,...
                    ',',get(handles.iterations,'String'),...
                    ',',get(handles.lambda,'String'),...
                    ',''',get(handles.savesolutionto,'String'),...
                    ''',',get(handles.filters,'String'),...
                    ');'...
                    );
                    if ~batch
                        evalin('base',content{end});
                    end
                else
                    content{end+1} = strcat(...
                    '[mesh,pj] = reconstruct_stnd_bem(',meshloc,...
                    ',',get(handles.frequency,'String'),...
                    ',',dataloc,...
                    ',',get(handles.iterations,'String'),...
                    ',',get(handles.lambda,'String'),...
                    ',''',get(handles.savesolutionto,'String'),...
                    ''',',get(handles.filters,'String'),...
                    ');'...
                    );
                    if ~batch
                        evalin('base',content{end});
                    end
                end
            elseif strcmp(handles.type,'spec_bem')
                % BEM SPECTRAL
                if strcmp(get(handles.frequency,'String'),'0')
                    content{end+1} = strcat(...
                    '[mesh,pj] = reconstruct_spectral_cw_bem(',meshloc,...
                    ',',dataloc,...
                    ',',get(handles.iterations,'String'),...
                    ',',get(handles.lambda,'String'),...
                    ',''',get(handles.savesolutionto,'String'),...
                    ''',',get(handles.filters,'String'),...
                    ');'...
                    );
                    if ~batch
                        evalin('base',content{end});
                    end
                else
                    content{end+1} = strcat(...
                    '[mesh,pj] = reconstruct_spectral_bem(',meshloc,...
                    ',',get(handles.frequency,'String'),...
                    ',',dataloc,...
                    ',',get(handles.iterations,'String'),...
                    ',',get(handles.lambda,'String'),...
                    ',''',get(handles.savesolutionto,'String'),...
                    ''',',get(handles.filters,'String'),...
                    ');'...
                    );
                    if ~batch
                        evalin('base',content{end});
                    end
                end
            else
                % NOT SPN
                content{end+1} = strcat(...
                '[mesh,pj] = reconstruct(',meshloc,...
                ',',recbasis,...
                ',',get(handles.frequency,'String'),...
                ',',dataloc,...
                ',',get(handles.iterations,'String'),...
                ',lambda',...
                ',''',get(handles.savesolutionto,'String'),...
                ''',',get(handles.filters,'String'),...
                ');'...
                );
                if ~batch
                    evalin('base',content{end});
                end
            end
        end
    end
end

if get(handles.view_solution,'Value')
    content{end+1} = 'plotmesh(mesh);';
    if ~batch
        evalin('base',content{end});
    end
end
set(mainGUIdata.script, 'String', content);
guidata(nirfast, mainGUIdata);
close(gui_reconstruct);


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


% --- Executes on selection change in solver.
function solver_Callback(hObject, eventdata, handles)
% hObject    handle to solver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns solver contents as cell array
%        contents{get(hObject,'Value')} returns selected item from solver


% --- Executes during object creation, after setting all properties.
function solver_CreateFcn(hObject, eventdata, handles)
% hObject    handle to solver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in conjugate_gradient.
function conjugate_gradient_Callback(hObject, eventdata, handles)
% hObject    handle to conjugate_gradient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of conjugate_gradient
