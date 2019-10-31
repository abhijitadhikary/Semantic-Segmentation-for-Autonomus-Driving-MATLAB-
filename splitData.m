function [imdsTrain, imdsVal, imdsTest, pxdsTrain, pxdsVal, pxdsTest] = splitData(imds, pxds, train, validation, test)
% partition CamVid data by randomly according to the supplied ratio.
    
% set initial random state for example reproducibility.
rng(0); 
numFiles = numel(imds.Files);
shuffledIndices = randperm(numFiles);

% use specified number of the images for training.
numTrain = round(train * numFiles);
trainingIdx = shuffledIndices(1: numTrain);

% use specified number of the images for validation
numVal = round(validation * numFiles);
valIdx = shuffledIndices(numTrain + 1:numTrain + numVal);

% use the rest for testing.
testIdx = shuffledIndices(numTrain + numVal + 1: end);

% create image datastores for training and test.
trainingImages = imds.Files(trainingIdx);
valImages = imds.Files(valIdx);
testImages = imds.Files(testIdx);

imdsTrain = imageDatastore(trainingImages);
imdsVal = imageDatastore(valImages);
imdsTest = imageDatastore(testImages);

% extract class and label IDs info.
classes = pxds.ClassNames;
labelIDs = camvidPixelLabelIDs();

% create pixel label datastores for training and test.
trainingLabels = pxds.Files(trainingIdx);
valLabels = pxds.Files(valIdx);
testLabels = pxds.Files(testIdx);

pxdsTrain = pixelLabelDatastore(trainingLabels, classes, labelIDs);
pxdsVal = pixelLabelDatastore(valLabels, classes, labelIDs);
pxdsTest = pixelLabelDatastore(testLabels, classes, labelIDs);

end
