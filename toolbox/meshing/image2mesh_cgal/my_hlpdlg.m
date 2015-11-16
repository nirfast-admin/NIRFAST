function varargout = my_hlpdlg(varargin)
% MY_HLPDLG MATLAB code for my_hlpdlg.fig
%      MY_HLPDLG, by itself, creates a new MY_HLPDLG or raises the existing
%      singleton*.
%
%      H = MY_HLPDLG returns the handle to a new MY_HLPDLG or the handle to
%      the existing singleton*.
%
%      MY_HLPDLG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MY_HLPDLG.M with the given input arguments.
%
%      MY_HLPDLG('Property','Value',...) creates a new MY_HLPDLG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before my_hlpdlg_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to my_hlpdlg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help my_hlpdlg

% Last Modified by GUIDE v2.5 02-Apr-2012 12:20:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @my_hlpdlg_OpeningFcn, ...
                   'gui_OutputFcn',  @my_hlpdlg_OutputFcn, ...
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


% --- Executes just before my_hlpdlg is made visible.
function my_hlpdlg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to my_hlpdlg (see VARARGIN)

% Choose default command line output for my_hlpdlg
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes my_hlpdlg wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = my_hlpdlg_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function text2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc
    set(hObject,'FontSize',11);
end

