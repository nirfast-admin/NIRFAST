function varargout = optimize_mesh_gui(varargin)
% OPTIMIZE_MESH_GUI MATLAB code for optimize_mesh_gui.fig
%      OPTIMIZE_MESH_GUI by itself, creates a new OPTIMIZE_MESH_GUI or raises the
%      existing singleton*.
%
%      H = OPTIMIZE_MESH_GUI returns the handle to a new OPTIMIZE_MESH_GUI or the handle to
%      the existing singleton*.
%
%      OPTIMIZE_MESH_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OPTIMIZE_MESH_GUI.M with the given input arguments.
%
%      OPTIMIZE_MESH_GUI('Property','Value',...) creates a new OPTIMIZE_MESH_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before optimize_mesh_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to optimize_mesh_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help optimize_mesh_gui

% Last Modified by GUIDE v2.5 21-Aug-2012 01:26:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @optimize_mesh_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @optimize_mesh_gui_OutputFcn, ...
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

% --- Executes just before optimize_mesh_gui is made visible.
function optimize_mesh_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to optimize_mesh_gui (see VARARGIN)

% Choose default command line output for optimize_mesh_gui
handles.output = 'Yes';

% Update handles structure
guidata(hObject, handles);

% Insert custom Title and Text if specified by the user
% Hint: when choosing keywords, be sure they are not easily confused 
% with existing figure properties.  See the output of set(figure) for
% a list of figure properties.
if(nargin > 3)
    for index = 1:2:(nargin-3),
        if nargin-3==index, break, end
        switch lower(varargin{index})
         case 'title'
          set(hObject, 'Name', varargin{index+1});
         case 'string'
          set(handles.q_text, 'String', varargin{index+1});
         case 'flag'
          myflag = varargin{index+1};
        end
    end
end

if myflag
    set(handles.text4,'String','Optimization is highly recommended for your mesh due to very poor quality elements!');
else
    set(handles.text4,'String','');
end

% Determine the position of the dialog - centered on the callback figure
% if available, else, centered on the screen
FigPos=get(0,'DefaultFigurePosition');
OldUnits = get(hObject, 'Units');
set(hObject, 'Units', 'pixels');
OldPos = get(hObject,'Position');
FigWidth = OldPos(3);
FigHeight = OldPos(4);
if isempty(gcbf)
    ScreenUnits=get(0,'Units');
    set(0,'Units','pixels');
    ScreenSize=get(0,'ScreenSize');
    set(0,'Units',ScreenUnits);

    FigPos(1)=1/2*(ScreenSize(3)-FigWidth);
    FigPos(2)=2/3*(ScreenSize(4)-FigHeight);
else
    GCBFOldUnits = get(gcbf,'Units');
    set(gcbf,'Units','pixels');
    GCBFPos = get(gcbf,'Position');
    set(gcbf,'Units',GCBFOldUnits);
    FigPos(1:2) = [(GCBFPos(1) + GCBFPos(3) / 2) - FigWidth / 2, ...
                   (GCBFPos(2) + GCBFPos(4) / 2) - FigHeight / 2];
end
FigPos(3:4)=[FigWidth FigHeight];
set(hObject, 'Position', FigPos);
set(hObject, 'Units', OldUnits);

% Show a question icon from dialogicons.mat - variables questIconData
% and questIconMap
load dialogicons.mat

IconData=questIconData;
questIconMap(256,:) = get(handles.figure1, 'Color');
IconCMap=questIconMap;

Img=image(IconData, 'Parent', handles.axes1);
set(handles.figure1, 'Colormap', IconCMap);

set(handles.axes1, ...
    'Visible', 'off', ...
    'YDir'   , 'reverse'       , ...
    'XLim'   , get(Img,'XData'), ...
    'YLim'   , get(Img,'YData')  ...
    );

% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')

% UIWAIT makes optimize_mesh_gui wait for user response (see UIRESUME)
uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = optimize_mesh_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.optimize_flag;
% The figure can be deleted now
delete(handles.figure1);

% --- Executes on button press in contbutton.
function contbutton_Callback(hObject, eventdata, handles)
% hObject    handle to contbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = get(hObject,'String');

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.figure1);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end


% --- Executes on key press over figure1 with no controls selected.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check for "enter" or "escape"
if isequal(get(hObject,'CurrentKey'),'escape')
    % User said no by hitting escape
    handles.output = 'No';
    
    % Update handles structure
    guidata(hObject, handles);
    
    uiresume(handles.figure1);
end    
    
if isequal(get(hObject,'CurrentKey'),'return')
    uiresume(handles.figure1);
end    

% --- Executes during object creation, after setting all properties.
function noradio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Value',1.0)
handles.optimize_flag = false;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function yesradio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yesradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Value',0.0)


% --- Executes during object creation, after setting all properties.
function q_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc
    set(hObject,'FontSize',11);
    set(hObject,'FontWeight','bold')
end
if isunix
    set(hObject,'FontSize',12);
    set(hObject,'FontWeight','bold')
end

% --- Executes during object creation, after setting all properties.
function desc_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to desc_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ~ismac
    set(hObject,'FontSize',10);
else
    set(hObject,'FontSize',12);
end


% --- Executes during object creation, after setting all properties.
function text3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ~ismac
    set(hObject,'FontSize',10);
else
    set(hObject,'FontSize',12);
end
if isunix || ispc
    set(hObject,'FontWeight','bold');
    set(hObject,'ForegroundColor', [0.6 0 0.2]);
end


% --- Executes during object creation, after setting all properties.
function text4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ismac
    set(hObject,'FontSize',12);
elseif isunix
    set(hObject,'FontSize',10);
    set(hObject,'FontWeight','bold')
end
if ispc
    set(hObject,'FontWeight','bold')
    set(hObject,'FontSize',9)
end


% --- Executes when selected object is changed in opt_panel.
function opt_panel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in opt_panel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if strcmp(eventdata.EventName,'SelectionChanged')
%     fprintf('old %d\n',get(eventdata.OldValue,'Value'))
    if strcmp(get(eventdata.NewValue,'Tag'),'yesradio')
        handles.optimize_flag = true;
    else
        handles.optimize_flag = false;
    end
    guidata(hObject,handles)
end
