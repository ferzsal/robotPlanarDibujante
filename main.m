function varargout = main(varargin)
% main MATLAB code for main.fig
%      main, by itself, creates a new main or raises the existing
%      singleton*.
%
%      H = main returns the handle to a new main or the handle to
%      the existing singleton*.
%
%      main('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in main.M with the given input arguments.
%
%      main('Property','Value',...) creates a new main or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 11-May-2021 01:33:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in InicioCamara.
function InicioCamara_Callback(hObject, eventdata, handles)
% hObject    handle to InicioCamara (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ini
ini=1;
VIDEO(hObject, eventdata, handles)


% --- Executes on button press in Capturar.
function Capturar_Callback(hObject, eventdata, handles)
% hObject    handle to Capturar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cap 
cap=1;
%VIDEO(hObject, eventdata, handles)


function VIDEO(hObject, eventdata, handles)
global ini 
global cap
global vid
global photo
global ready

if ini==1
    objects = imaqfind;
    delete(objects);
    clear objects;
    vid=videoinput('winvideo',1,'MJPG_1280x720');
    triggerconfig(vid,'manual');
    start(vid)
    while 1
        axes(handles.axes1)
        photo = getsnapshot(vid);
        imshow(photo,'Parent',handles.axes1);
        if cap==1
            ready = 1;
            break;
        end 
    end 
    cap=0;
    stop(vid);
    delete(vid);
    
%     if(finalpic==1)
%     [c d]=uigetfile(handles.axes1);
%     photo=imread([d c]);
%     imshow(photo,'Parent',handles.axes1);
%     end
end 
 

% --- Executes on button press in Browse.
function Browse_Callback(hObject, eventdata, handles)
% hObject    handle to Browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global photo
global ready

[a b]=uigetfile({'*.jpeg';'*.jpg'});    
photo=imread([b a]);
imshow(photo,'Parent',handles.axes1);
ready = 1;


% --- Executes on button press in Clear.
function Clear_Callback(hObject, eventdata, handles)
% hObject    handle to Clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ready
ready = 0;
cla(handles.axes1,'reset');


% --- Executes on button press in usepic.
function usepic_Callback(hObject, eventdata, handles)
% hObject    handle to usepic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global finalpic
global animation_ik
global animation_ik_TB
finalpic=1;
animation_ik = 0;
animation_ik_TB = 0;


% --- Executes on button press in applyfilter.
function applyfilter_Callback(hObject, eventdata, handles)
% hObject    handle to applyfilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global photo
global sigma
%% crear img binaria
%     RGB = imread(filepath);
    img = rgb2gray(photo);
    img = imgaussfilt(img,sigma);
    [BW, thcanny] = edge(img,'canny');
    %% procesamiento de la imagen binaria
    a = 5.5; % Modificación del threshold
    BW1 = edge(img,'canny', thcanny * a);
    imshow(BW1,'Parent',handles.axes1)


% --- Executes on button press in Animation_ik.
function Animation_ik_Callback(hObject, eventdata, handles)
% hObject    handle to Animation_ik (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global animation_ik
global animation_ik_TB
global finalpic
global photo
global sigma
global ready
animation_ik = 1;
if ((ready == 1 && finalpic == 1) && (animation_ik == 1 && animation_ik_TB == 0))
    Animation_ik(photo, sigma);
else
    animation_ik = 0;
end

% --- Executes on button press in Animation_ik_TB.
function Animation_ik_TB_Callback(hObject, eventdata, handles)
% hObject    handle to Animation_ik_TB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global animation_ik_TB
global animation_ik
global finalpic
global photo
global sigma
global ready
animation_ik_TB = 1;
if ((ready == 1 && finalpic == 1) && (animation_ik_TB==1 && animation_ik==0))
    Animation_ik_TB(photo, sigma);
else
    animation_ik_TB = 0;
end


% --- Executes on slider movement.
function sigmaSlider_Callback(hObject, eventdata, handles)
% hObject    handle to sigmaSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global sigma
sigma =  get(hObject,'value');


% --- Executes during object creation, after setting all properties.
function sigmaSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sigmaSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
