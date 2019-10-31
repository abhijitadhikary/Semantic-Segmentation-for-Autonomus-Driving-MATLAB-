function runWebcamDetector(net)

% clear previously allocated webcam resource
clear cam
cam = webcam;
doCapture = true;

% load the color map
cmap = camvidColorMap;

while doCapture == true
    
    % extract the current frame from the webcam and resize to specified
    % dimentions
    webcamImage = snapshot(cam);
    webcamImage = imresize(webcamImage, [720 960]);
    
    % display the current frame
    %imshow(webcamImage);
    
    % run semantic segmentation on the current frame
    predictedLabel = semanticseg(webcamImage, net);
    
    % overlay the label on the actual image and display it
    overlayedImage = labeloverlay(webcamImage, predictedLabel, 'Colormap', cmap, 'Transparency', 0.4);
    imshow(overlayedImage)
    hold on
   
end

clear cam

end

