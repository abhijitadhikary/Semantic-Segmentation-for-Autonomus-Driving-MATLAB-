function runSingleImageDetector(net, imdsTest, imageNum)

% reads in the specified image of the test set
originalImage = readimage(imdsTest, imageNum);

% reads in the label of the specified image of the test set
predictedLabel = semanticseg(originalImage, net);

% loads the colormap
cmap = camvidColorMap;

% overlays the label on the image and shows the images
overlayedImage = labeloverlay(originalImage, predictedLabel, 'Colormap', cmap, 'Transparency', 0.4);
imshow(overlayedImage)

end

