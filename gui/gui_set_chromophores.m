function varargout = gui_set_chromophores(varargin)
% GUI_SET_CHROMOPHORES M-file for gui_set_chromophores.fig
%      GUI_SET_CHROMOPHORES, by itself, creates a new GUI_SET_CHROMOPHORES or raises the existing
%      singleton*.
%
%      H = GUI_SET_CHROMOPHORES returns the handle to a new GUI_SET_CHROMOPHORES or the handle to
%      the existing singleton*.
%
%      GUI_SET_CHROMOPHORES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SET_CHROMOPHORES.M with the given input arguments.
%
%      GUI_SET_CHROMOPHORES('Property','Value',...) creates a new GUI_SET_CHROMOPHORES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_set_chromophores_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_set_chromophores_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_set_chromophores

% Last Modified by GUIDE v2.5 24-Mar-2011 11:15:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_set_chromophores_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_set_chromophores_OutputFcn, ...
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


% --- Executes just before gui_set_chromophores is made visible.
function gui_set_chromophores_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_set_chromophores (see VARARGIN)

% Choose default command line output for gui_set_chromophores
handles.output = hObject;
set(hObject,'Name','Set Chromophores');
if(nargin > 3)
    for index = 1:2:(nargin-3),
        if nargin-3==index, break, end
        switch lower(varargin{index})
         case 'mesh'
         handles.meshloc = varargin{index+1};
        end
    end
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_set_chromophores wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_set_chromophores_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in done.
function done_Callback(hObject, eventdata, handles)
% hObject    handle to done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mainGUIhandle = nirfast;
mainGUIdata  = guidata(mainGUIhandle);
content = get(mainGUIdata.script,'String');
batch = get(mainGUIdata.batch_mode,'Value');

wv = get(handles.wv,'String');
mesh = handles.meshloc;
chrom = '{';
if get(handles.hbo,'Value')==1
    chrom = [chrom '''HbO'';'];
end
if get(handles.deoxyhb,'Value')==1
    chrom = [chrom '''deoxyHb'';'];
end
if get(handles.water,'Value')==1
    chrom = [chrom '''Water'';'];
end
if get(handles.lipids,'Value')==1
    chrom = [chrom '''Lipids'';'];
end
if get(handles.lutex,'Value')==1
    chrom = [chrom '''LuTex'';'];
end
if get(handles.gdtex,'Value')==1
    chrom = [chrom '''GdTex'';'];
end
chrom = [chrom '}'];

content{end+1} = strcat('set_chromophores(''',mesh,''',',chrom,',',wv,');');
if ~batch
    evalin('base',content{end});
end
content{end+1} = strcat('mesh = load_mesh(''',mesh,''');');
if ~batch
    evalin('base',content{end});
end

set(mainGUIdata.script, 'String', content);
guidata(nirfast, mainGUIdata);

gui_launcher

close(gui_set_chromophores);



function wv_Callback(hObject, eventdata, handles)
% hObject    handle to wv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wv as text
%        str2double(get(hObject,'String')) returns contents of wv as a double


% --- Executes during object creation, after setting all properties.
function wv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in hbo.
function hbo_Callback(hObject, eventdata, handles)
% hObject    handle to hbo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hbo


% --- Executes on button press in deoxyhb.
function deoxyhb_Callback(hObject, eventdata, handles)
% hObject    handle to deoxyhb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of deoxyhb


% --- Executes on button press in water.
function water_Callback(hObject, eventdata, handles)
% hObject    handle to water (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of water


% --- Executes on button press in lipids.
function lipids_Callback(hObject, eventdata, handles)
% hObject    handle to lipids (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lipids


% --- Executes on button press in sp.
function sp_Callback(hObject, eventdata, handles)
% hObject    handle to sp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sp


% --- Executes on button press in lutex.
function lutex_Callback(hObject, eventdata, handles)
% hObject    handle to lutex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lutex


% --- Executes on button press in gdtex.
function gdtex_Callback(hObject, eventdata, handles)
% hObject    handle to gdtex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gdtex
