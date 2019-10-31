function main()

% Ignore CUDA warnings
ignoreCudaWarnings()

% Train the network
doTraining = false;

% train the network if doTraining is set to true
if doTraining
    trainNetwork()
end

% loads the semanticNet network
data = load('semanticNet');
net = data.net;
disp('Semantic net loaded successfully into memory');

% runs the detector on webcam video
% runWebcamDetector(net);

% source of video file
videoFileName = 'video/test_video_cam_vid.mp4';
runVideoDetector(net, videoFileName);
disp('done');
end