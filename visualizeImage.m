function visualizeImage(imageDatastore, pixelDatastore, imageNumber)

% read and show specified image from the datastore
image = readimage(imageDatastore, imageNumber);
image = histeq(image);
imshow(image);

% load the labels and color map
label = readimage(pixelDatastore, imageNumber);
colorMap = camvidColorMap;

% overlay the labels on top of the image and display it
overlayedImage = labeloverlay(image, label, 'ColorMap', colorMap);
imshow(overlayedImage);

end

