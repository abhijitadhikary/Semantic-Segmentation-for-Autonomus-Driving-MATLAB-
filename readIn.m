function [imds, pixelDatastore, classes] = readIn()

% reads the images and labels of the dataset
path = ".\";
datasetFolder = fullfile(path, 'dataset'); 

% reads all the images
imDirectory = fullfile(datasetFolder, 'images');

% reads images and applies readAndResize function to resize the images
% imds = imageDatastore(imDirectory, 'ReadFcn', @readAndResize);
imds = imageDatastore(imDirectory);

% load the image labels
labelIDs = camvidPixelLabelIDs();

% loads the label classes
classes = loadClasses();

% path to the labels dataset
labelDirectory = fullfile(datasetFolder, 'labels');

% stores the labels in a pixel label datastore
pixelDatastore = pixelLabelDatastore(labelDirectory, classes, labelIDs);
end

