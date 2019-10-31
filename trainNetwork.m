function trainNetwork()

% Feature extraction network (VGG 16)
featureNet = 'vgg16';

% Ratio of training, validation and test data
trainRatio = 0.8;
validationRatio = 0.1;
testRatio = 0.1;

% Image size
height = 720;
width = 960;
numChannels = 3;

% checkpoint directory
checkpointDirectory = fullfile('.\checkpoints'); 

% Reads in the images and labels; stores them in appropreate datastores
[imds, pxds, classes] = readIn();

% Split the data into specified portions for training, validation and
% testing
[imdsTrain, imdsVal, imdsTest, pxdsTrain, pxdsVal, pxdsTest] = splitData(imds,pxds, trainRatio, validationRatio, testRatio);

% Display the total number of instances in each datastore
numTrainingImages = numel(imdsTrain.Files)
numValImages = numel(imdsVal.Files)
numTestingImages = numel(imdsTest.Files)

% extract the number of pixels associated with each label, and extract the
% frequency
table = countEachLabel(pxds)
frequency = table.PixelCount/sum(table.PixelCount);

% Image size of the newtork
imageSize = [height width numChannels];

% Total number of classes
numClasses = numel(classes);

% create semantic segmentation network graph
semanticNet = segnetLayers(imageSize, numClasses, featureNet);

% display the layers of the semantic network
layers = semanticNet.Layers;

% normalize the input data by adding weights. Labels which have lower pixel
% count get higher weights
imageFreq = table.PixelCount ./ table.ImagePixelCount;
classWeights = median(imageFreq) ./ imageFreq;

% add pixel classicication layer at the end with the appropreate number of
% classes of the dataset, also add the class weights
pxLayer = pixelClassificationLayer('Name', 'labels', 'Classes', table.Name, 'ClassWeights', classWeights);

% Remove the last layer of semanticNet and add the pxLayer
semanticNet = removeLayers(semanticNet, {'pixelLabels'});

% add the newly created 'labels' layer
semanticNet = addLayers(semanticNet, pxLayer);


% edit the softmax layer with the number of labels classes of the dataset
semanticNet = connectLayers(semanticNet, 'softmax', 'labels');

% extract the newly created layers from the semanticNet layer graph
alteredLayers = semanticNet.Layers;

% extract the validation images and labels
pximdsVal = pixelLabelImageDatastore(imdsVal, pxdsVal);

% add image augmenter -> reflection and translation
augmenter = imageDataAugmenter('RandXReflection',true,...
    'RandXTranslation',[-15 15],'RandYTranslation',[-15 15]);

% create image datastore with the augmented images and labels
pximds = pixelLabelImageDatastore(imdsTrain,pxdsTrain, ...
    'DataAugmentation',augmenter);

% training options for the network
options = trainingOptions('adam',... % optimization algorithm
    'ValidationFrequency', 300, ... % run validation after every 300 images
    'LearnRateDropPeriod', 5,... % drop learning rate after every 5 epochs 
    'LearnRateDropFactor', 0.005,... % drop llearning rate by 0.005
    'InitialLearnRate', 1e-5, ... % initial learnig rate
    'L2Regularization', 0.005, ... % dropout factor
    'ValidationData', pximdsVal,... % validation datastore
    'MaxEpochs', 50, ...  % maximum number of epochs to train
    'MiniBatchSize', 1, ... % train 1 image at a time
    'Shuffle','every-epoch', ... % shuffle images in the datastore after each epoch
    'CheckpointPath', checkpointDirectory, ... % directory of checkpoint
    'VerboseFrequency', 1,... % print accuracy and loss on the console for each image
    'Plots','training-progress',... % plot the training imformation
    'ValidationPatience', 5); % stop training if there is no significant improvement for 5 epochs

% load checkpoint
%load('checkpoints/net_checkpoint__12342__2019_04_01__17_14_33', 'net');
%[net, info] = trainNetwork(pximds, layerGraph(net), options);

% train network
[net, info] = trainNetwork(pximds, semanticNet, options);

% save the trained network after training
save semanticNet;

% load the pretrained semantic network
networkName = 'semanticNet'
data = load(networkName);
net = data.net;

% display one image
runSingleImageDetector(net, imdsTest, 25);

end

