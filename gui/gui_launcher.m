function varargout = gui_launcher(varargin)
% GUI_LAUNCHER M-file for gui_launcher.fig
%      GUI_LAUNCHER, by itself, creates a new GUI_LAUNCHER or raises the existing
%      singleton*.
%
%      H = GUI_LAUNCHER returns the handle to a new GUI_LAUNCHER or the handle to
%      the existing singleton*.
%
%      GUI_LAUNCHER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_LAUNCHER.M with the given input arguments.
%
%      GUI_LAUNCHER('Property','Value',...) creates a new GUI_LAUNCHER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_launcher_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_launcher_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_launcher

% Last Modified by GUIDE v2.5 29-Aug-2011 09:51:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_launcher_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_launcher_OutputFcn, ...
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


% --- Executes just before gui_launcher is made visible.
function gui_launcher_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_launcher (see VARARGIN)

% Choose default command line output for gui_launcher
handles.output = hObject;
set(hObject,'Name','Launcher');
handles.mesh = evalin('base','mesh');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_launcher wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_launcher_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in forward.
function forward_Callback(hObject, eventdata, handles)
% hObject    handle to forward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = gui_forward_solver('type',handles.mesh.type);
hdata = guidata(h);
set(hdata.mesh,'String','mesh');
close(gui_launcher);

% --- Executes on button press in inverse.
function inverse_Callback(hObject, eventdata, handles)
% hObject    handle to inverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = gui_reconstruct('type',handles.mesh.type);
hdata = guidata(h);
set(hdata.mesh,'String','mesh');
if handles.mesh.dimension==3
    set(hdata.pixel_basis,'String','[30 30 30]');
end
close(gui_launcher);
