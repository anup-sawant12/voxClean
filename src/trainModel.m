function trainModel(epochs, batchSize, learningRate)
    % trainModel Sets up deep learning architecture and trains the model.
    if nargin < 1, epochs = 10; end
    if nargin < 2, batchSize = 16; end
    if nargin < 3, learningRate = 1e-3; end
    
    baseDir = fileparts(mfilename('fullpath'));
    projectRoot = fileparts(baseDir);
    cleanDir = fullfile(projectRoot, 'dataset', 'clean', 'train');
    noiseDir = fullfile(projectRoot, 'dataset', 'noise', 'train');
    
    disp('Checking dataset...');
    if ~exist(cleanDir, 'dir') || ~exist(noiseDir, 'dir')
        error('Dataset folders not found. Please add WAV files to data/clean and data/noise.');
    end
    
    cleanFiles = dir(fullfile(cleanDir, '*.wav'));
    if isempty(cleanFiles)
        disp('No training data found. Please place WAV files in data/clean and data/noise before training.');
        return;
    end
    
    disp('Building neural network architecture...');
    % CNN-UNet equivalent
    layers = [
        imageInputLayer([257 126 1], "Name", "input", "Normalization", "none")
        
        convolution2dLayer([3 3], 16, "Name", "conv1", "Padding", "same")
        batchNormalizationLayer("Name", "bn1")
        leakyReluLayer(0.2, "Name", "lrelu1")
        
        convolution2dLayer([3 3], 32, "Name", "conv2", "Padding", "same")
        batchNormalizationLayer("Name", "bn2")
        leakyReluLayer(0.2, "Name", "lrelu2")
        
        convolution2dLayer([3 3], 16, "Name", "conv3", "Padding", "same")
        batchNormalizationLayer("Name", "bn3")
        leakyReluLayer(0.2, "Name", "lrelu3")
        
        convolution2dLayer([3 3], 1, "Name", "output", "Padding", "same")
        sigmoidLayer("Name", "sigmoid")
        regressionLayer("Name", "regressionoutput")
    ];
    
    options = trainingOptions('adam', ...
        'MaxEpochs', epochs, ...
        'MiniBatchSize', batchSize, ...
        'InitialLearnRate', learningRate, ...
        'Shuffle', 'every-epoch', ...
        'Plots', 'training-progress', ...
        'Verbose', true);
    
    disp('Ready to train. Please uncomment the trainNetwork command below to initiate training.');
    disp('Note: True on-the-fly SNR mixing requires a Custom Mini-Batch Datastore implementation.');
    
    disp('Pre-processing dataset into memory for training...');
    ds = createDataset(cleanDir, noiseDir);
    
    % Limit to 500 samples to prevent running out of RAM during this demo
    numSamples = min(length(ds), 500); 
    
    % X = Noisy Magnitude Spectrograms [257, 126, 1, N]
    % Y = Ideal Ratio Masks (Targets) [257, 126, 1, N]
    X = zeros(257, 126, 1, numSamples, 'single');
    Y = zeros(257, 126, 1, numSamples, 'single');
    
    for i = 1:numSamples
        cleanAudio = loadAudio(ds(i).cleanPath, 16000);
        noiseAudio = loadAudio(ds(i).noisePath, 16000);
        
        % Force 2-second fixed segment (32,000 samples)
        cleanSeg = cleanAudio;
        if length(cleanSeg) < 32000
            cleanSeg = [cleanSeg; zeros(32000 - length(cleanSeg), 1)];
        else
            cleanSeg = cleanSeg(1:32000);
        end
        
        [noisy, cleanTarget, ~] = mixAudioWithSNR(cleanSeg, noiseAudio, ds(i).snr);
        
        magNoisy = computeSTFT(noisy);
        magClean = computeSTFT(cleanTarget);
        
        % Ensure exactly 126 time frames to match the CNN input layer
        if size(magNoisy, 2) < 126
            magNoisy = [magNoisy, zeros(257, 126 - size(magNoisy,2))];
            magClean = [magClean, zeros(257, 126 - size(magClean,2))];
        else
            magNoisy = magNoisy(:, 1:126);
            magClean = magClean(:, 1:126);
        end
        
        irm = computeIdealRatioMask(magClean, magNoisy);
        
        X(:,:,1,i) = single(magNoisy);
        Y(:,:,1,i) = single(irm);
        
        if mod(i, 20) == 0
            fprintf('Processed %d/%d training samples...\n', i, numSamples);
        end
    end
    
    disp('Starting training (this may take a while)...');
    trainedModel = trainNetwork(X, Y, layers, options);
    
    modelDir = fullfile(projectRoot, 'models');
    if ~exist(modelDir, 'dir')
        mkdir(modelDir);
    end
    
    modelPath = fullfile(modelDir, 'trainedModel.mat');
    save(modelPath, 'trainedModel');
    disp(['Model saved to ', modelPath]);
end
