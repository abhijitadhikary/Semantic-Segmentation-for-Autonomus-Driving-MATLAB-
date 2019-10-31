function varargout = GUI(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

% display the legend of labels
axes(handles.axes_legend);
legend_image_name = 'images/legend.jpg';
imshow(imread(legend_image_name));

% hide the original video axes
handles.axes_original.Visible = 'off';
handles.axes_segmented.Visible = 'off';

% hide the segmented video axes
handles.text_original.Visible = 'off';
handles.text_segmented.Visible = 'off';


% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

function axes_original_CreateFcn(hObject, eventdata, handles)


% --- Executes on button press in pushbutton_webcam.
function pushbutton_webcam_Callback(hObject, eventdata, handles)

set(handles.text_fileName, 'String', 'Source: Webcam');
% display the original video axes
handles.axes_original.Visible = 'on';
handles.axes_segmented.Visible = 'on';

axes(handles.axes_original);

% test webcam image
clear cam
cam = webcam;
doCapture = true;

% loads the semanticNet network
data = load('semanticNet');
net = data.net;
disp('Semantic net loaded successfully into memory');

while doCapture == true
    
    webcamImage = snapshot(cam);
    webcamImage = imresize(webcamImage, [720 960]);
    image(webcamImage, 'Parent', handles.axes_original);
    handles.axes_original.Visible = 'off';
    
    predictedLabel = semanticseg(webcamImage, net);
    
    cmap = camvidColorMap;
    overlayedImage = labeloverlay(webcamImage, predictedLabel, 'Colormap', cmap, 'Transparency', 0.4);
    
    image(overlayedImage, 'Parent', handles.axes_segmented);
    handles.axes_segmented.Visible = 'off';
    
    pause(0.0020);
   
end

clear cam


% --- Executes on button press in pushbutton_select_file.
function pushbutton_select_file_Callback(hObject, eventdata, handles)
[fileName pathName] = uigetfile({'*.mp4'; '*.jpg'; '*.avi'}, 'File Selector');
fullName = strcat(pathName, fileName);

set(handles.text_fileName, 'String', fullName);


% --- Executes on button press in pushbutton_run.
function pushbutton_run_Callback(hObject, eventdata, handles)
handles.axes_original.Visible = 'on';
handles.axes_segmented.Visible = 'on';

axes(handles.axes_original);

videoFileName = get(handles.text_fileName, 'String');

originalVideo = VideoReader(videoFileName);
%segmentedVideo = VideoReader('./video/dashcam2.mp4');


% loads the semanticNet network
data = load('semanticNet');
net = data.net;
disp('Semantic net loaded successfully into memory');

cmap = camvidColorMap;



while hasFrame(originalVideo)
    currentFrameOriginal = readFrame(originalVideo);
    image(currentFrameOriginal, 'Parent', handles.axes_original);
    handles.axes_original.Visible = 'off';
    %pause(1/originalVideo.FrameRate);
    
    currentFrameOriginal = imresize(currentFrameOriginal, [720 960]);
    predictedLabel = semanticseg(currentFrameOriginal, net);
    overlayedImage = labeloverlay(currentFrameOriginal, predictedLabel, 'Colormap', cmap, 'Transparency', 0.4);
    
    image(overlayedImage, 'Parent', handles.axes_segmented);
    handles.axes_segmented.Visible = 'off';
    %pause(1/originalVideo.FrameRate);
    pause(0.0020);
end