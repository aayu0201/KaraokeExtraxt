function varargout = project(varargin)
% PROJECT MATLAB code for project.fig
%      PROJECT, by itself, creates a new PROJECT or raises the existing
%      singleton*.
%
%      H = PROJECT returns the handle to a new PROJECT or the handle to
%      the existing singleton*.
%
%      PROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECT.M with the given input arguments.
%
%      PROJECT('Property','Value',...) creates a new PROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before project_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to project_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help project

% Last Modified by GUIDE v2.5 15-Apr-2021 11:40:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @project_OpeningFcn, ...
                   'gui_OutputFcn',  @project_OutputFcn, ...
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


% --- Executes just before project is made visible.
function project_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to project (see VARARGIN)

% Choose default command line output for project
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.Convert,'Enable','off')
set(handles.Karaoke,'Enable','off')
set(handles.PlaySong,'Enable','off')
set(handles.Stop,'Enable','off')
set(handles.edit1,'Enable','on')
set(handles.ErrorMsg,'Visible','off')
set(handles.text5,'Enable','off')
set(handles.text5,'Enable','off')
% UIWAIT makes project wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = project_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Browse.
function Browse_Callback(hObject, eventdata, handles)
% hObject    handle to Browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global file
[file path]=uigetfile({'*.wav';'*.mp3'});
file=[path,file];
[filepath,name,ext]=fileparts(file);
if ext=='.mp3'
    set(handles.edit1,'String',file)
    set(handles.ErrorMsg,'Visible','on')
    set(handles.Convert,'Enable','on')
elseif ext=='.wav'
    set(handles.edit1,'String',file)
    set(handles.Karaoke,'Enable','on')
else
    f= msgbox('Invalid File Format, please select file again')
    pause(5);
    project;
end
% --- Executes on button press in Convert.
function Convert_Callback(hObject, eventdata, handles)
% hObject    handle to Convert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global file Y fs
[Y fs]= audioread(file);
audiowrite('ConvertAudioFile.wav',Y,fs)
set(handles.ErrorMsg,'Visible','off')

% --- Executes on button press in Karaoke.
function Karaoke_Callback(hObject, eventdata, handles)
% hObject    handle to Karaoke (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global file Y fs voiceSignal tp M
[Y fs]=audioread(file);
[M,N]=size(Y);
if N==1
    error('Music is recorded in Mono Input Type')
elseif N>2
    error('Music has more than 2 channels')
end
tp=linspace(0,M/fs,M)';
leftSignal=Y(:,1);
rightSignal=Y(:,2);
voiceSignal=leftSignal - rightSignal;
set(handles.text4,'Enable','on')
set(handles.text5,'Enable','on')
axes(handles.axes1)
plot(tp,Y);xlim([0,M/fs]);
axes(handles.axes2)
plot(tp,voiceSignal);xlim([0,M/fs]);
set(handles.PlaySong,'Enable','on')
set(handles.Stop,'Enable','on')


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PlaySong.
function PlaySong_Callback(hObject, eventdata, handles)
% hObject    handle to PlaySong (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global voiceSignal fs  M
sound(voiceSignal,fs);

% --- Executes on button press in Stop.
function Stop_Callback(hObject, eventdata, handles)
% hObject    handle to Stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all;
close all;
project;