function varargout = gui_convert_inptonirfast(varargin)
% GUI_CONVERT_INPTONIRFAST M-file for gui_convert_inptonirfast.fig
%      GUI_CONVERT_INPTONIRFAST, by itself, creates a new GUI_CONVERT_INPTONIRFAST or raises the existing
%      singleton*.
%
%      H = GUI_CONVERT_INPTONIRFAST returns the handle to a new GUI_CONVERT_INPTONIRFAST or the handle to
%      the existing singleton*.
%
%      GUI_CONVERT_INPTONIRFAST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CONVERT_INPTONIRFAST.M with the given input arguments.
%
%      GUI_CONVERT_INPTONIRFAST('Property','Value',...) creates a new GUI_CONVERT_INPTONIRFAST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_convert_inptonirfast_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_convert_inptonirfast_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_convert_inptonirfast

% Last Modified by GUIDE v2.5 24-Feb-2012 17:51:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_convert_inptonirfast_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_convert_inptonirfast_OutputFcn, ...
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


% --- Executes just before gui_convert_inptonirfast is made visible.
function gui_convert_inptonirfast_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_convert_inptonirfast (see VARARGIN)

% Choose default command line output for gui_convert_inptonirfast
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
set(hObject,'Name','Convert surface mesh');

% Disable mesh grading for bem type meshes.
if strfind(handles.type,'bem')
    set(handles.gradingmesh_checkbox,'Enable','off')
    set(handles.text7,'Enable','off')
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_convert_inptonirfast wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_convert_inptonirfast_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function inp_Callback(hObject, eventdata, handles)
% hObject    handle to inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inp as text
%        str2double(get(hObject,'String')) returns contents of inp as a double


% --- Executes during object creation, after setting all properties.
function inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inp (see GCBO)
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


% --- Executes on button press in done.
function done_Callback(hObject, eventdata, handles)
% hObject    handle to done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mainGUIhandle = nirfast;
mainGUIdata  = guidata(mainGUIhandle);
content = get(mainGUIdata.script,'String');
batch = get(mainGUIdata.batch_mode,'Value');

inploc = strcat('''',get(handles.inp,'String'),'''');

handles.gradingmesh = get(handles.gradingmesh_checkbox,'Value');

savemeshto = get(handles.savemeshto,'String');
if isempty(savemeshto)
    savemeshto = ['nirfast-' handles.type];
end

savemeshto = getfullpath(savemeshto);

if ~canwrite(savemeshto)
    [junk fn ext1] = fileparts(savemeshto);
    savemeshto = [tempdir fn ext1];
    disp(['No write access, writing here instead: ' savemeshto]);
end

if strcmp(handles.type,'stnd_bem') || ...
        strcmp(handles.type,'fluor_bem') || strcmp(handles.type,'spec_bem')
    content{end+1} = strcat('surf2nirfast_bem(',inploc,',''',savemeshto,...
        ''',''',handles.type,''');');
    if ~batch
        evalin('base',content{end});
    end
else
    content{end+1} = strcat('checkerboard3dmm_wrapper(',inploc,',''',savemeshto,...
        ''',''',handles.type,''',[],',num2str(handles.gradingmesh),');');
    if ~batch
        evalin('base',content{end});
    end
end

set(mainGUIdata.script, 'String', content);
guidata(nirfast, mainGUIdata);
gui_place_sources_detectors('mesh',savemeshto);
close(gui_convert_inptonirfast);


% --- Executes on button press in browse_inp.
function browse_inp_Callback(hObject, eventdata, handles)
% hObject    handle to browse_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pn] = myuigetfile({'*.inp';'*.ele'},'Input inp or ele File');
if fn == 0
    return;
end
temp = [pn fn];
set(handles.inp,'String',temp);

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


% --- Executes on button press in gradingmesh_checkbox.
function gradingmesh_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to gradingmesh_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gradingmesh_checkbox
handles.gradingmesh = get(hObject,'Value');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function gradingmesh_checkbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gradingmesh_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
