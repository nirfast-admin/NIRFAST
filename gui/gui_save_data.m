function varargout = gui_save_data(varargin)
% GUI_SAVE_DATA M-file for gui_save_data.fig
%      GUI_SAVE_DATA, by itself, creates a new GUI_SAVE_DATA or raises the existing
%      singleton*.
%
%      H = GUI_SAVE_DATA returns the handle to a new GUI_SAVE_DATA or the handle to
%      the existing singleton*.
%
%      GUI_SAVE_DATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SAVE_DATA.M with the given input arguments.
%
%      GUI_SAVE_DATA('Property','Value',...) creates a new GUI_SAVE_DATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_save_data_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_save_data_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_save_data

% Last Modified by GUIDE v2.5 25-Nov-2009 09:55:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_save_data_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_save_data_OutputFcn, ...
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


% --- Executes just before gui_save_data is made visible.
function gui_save_data_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_save_data (see VARARGIN)

% Choose default command line output for gui_save_data
handles.output = hObject;
set(hObject,'Name','Save Data');

% find workspace variables
vars = evalin('base','whos;');
varnames = {};
[nv,junk] = size(vars);
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

% UIWAIT makes gui_save_data wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_save_data_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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



function savedatato_Callback(hObject, eventdata, handles)
% hObject    handle to savedatato (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of savedatato as text
%        str2double(get(hObject,'String')) returns contents of savedatato as a double


% --- Executes during object creation, after setting all properties.
function savedatato_CreateFcn(hObject, eventdata, handles)
% hObject    handle to savedatato (see GCBO)
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

dataloc = get_pathloc(get(handles.data,'String'));

saveto = get(handles.savedatato,'String');
if ~canwrite(saveto)
    [junk fn ext1] = fileparts(saveto);
    saveto = [tempdir fn ext1];
    disp(['No write access, writing here instead: ' saveto]);
end

content{end+1} = strcat('save_data(',...
    dataloc, ',''',saveto,''');');
if ~batch
    evalin('base',content{end});
end


set(mainGUIdata.script, 'String', content);
guidata(nirfast, mainGUIdata);
close(gui_save_data);



% --- Executes on button press in browse_savedatato.
function browse_savedatato_Callback(hObject, eventdata, handles)
% hObject    handle to browse_savedatato (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pn] = myuiputfile('*.paa','Save Data To');
if fn == 0
    return;
end
set(handles.savedatato,'String',[pn fn]);

guidata(hObject, handles);


