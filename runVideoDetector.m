function runVideoDetector(net, videoFileName)

% loads the specified video
video = VideoReader(videoFileName);

% loads the color map
cmap = camvidColorMap;
% loop runs for the length of frame size of the video

% condition for saving the output frames to specified location
saveOutputFrames = false;

% path of output folder
outputFolder = 'outputLabels';

for frame = 1: video.NumberOfFrames;
    
    % extracts the current frame and resizes it to the specified dimentions
    currentFrame = read(video, frame);
    currentFrame = imresize(currentFrame, [720 960]);
    
    % displays the current frame
    %figure, imshow(currentFrame)
    %hold on
    
    % runs semantic segmentation on the current frame
    predictedLabel = semanticseg(currentFrame, net);
    
    % places the label on top of the current frame and displays it
    overlayedImage = labeloverlay(currentFrame, predictedLabel, 'Colormap', cmap, 'Transparency', 0.4);
 
    imshow(overlayedImage)
    hold on
    
    % if save condition is set to true, saves the segmented images to the 
    % specifiedfolder
    if saveOutputFrames
        outputBaseFileName = sprintf('%3.3d.png', frame);
        outputFullFileName = fullfile(outputFolder, outputBaseFileName);
        imwrite(overlayedImage, outputFullFileName, 'png');
    end
end