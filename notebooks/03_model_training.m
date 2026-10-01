%% 03 Model Training
% Explores the CNN-UNet architecture and initiates training.

addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'src'));

%% Model Setup
% Call trainModel to build the layers and configure options.
% Note: actual training takes significant time.
trainModel(10, 16, 1e-3);
