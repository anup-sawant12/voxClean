function enhancedAudio = enhanceSpeech(audioPath, outputPath)
    % enhanceSpeech Enhances an input audio file using the trained model.
    baseDir = fileparts(mfilename('fullpath'));
    projectRoot = fileparts(baseDir);
    modelPath = fullfile(projectRoot, 'models', 'trainedModel.mat');
    
    if ~exist(modelPath, 'file')
        error('Trained model not found at %s. Please run trainModel first.', modelPath);
    end
    
    disp('Loading trained model...');
    load(modelPath, 'trainedModel');
    
    disp('Loading audio...');
    audio = loadAudio(audioPath, 16000);
    sr = 16000; % Hardcoded to match since it was resampled
    
    disp('Computing STFT...');
    [mag, phase] = computeSTFT(audio);
    totalFrames = size(mag, 2);
    
    disp(sprintf('Processing audio (%d STFT frames, approx. %.1f seconds)...', totalFrames, length(audio)/sr));
    
    % The trained CNN accepts blocks of 126 time frames.
    % Process the full spectrogram in chunks of 126 frames to support any audio duration.
    chunkSize = 126;
    numChunks = ceil(totalFrames / chunkSize);
    predMaskFull = zeros(257, totalFrames, 'single');
    
    for c = 1:numChunks
        startIdx = (c - 1) * chunkSize + 1;
        endIdx = min(c * chunkSize, totalFrames);
        actualWidth = endIdx - startIdx + 1;
        
        chunkMag = mag(:, startIdx : endIdx);
        
        % Pad chunk if it has fewer than 126 frames
        if actualWidth < chunkSize
            chunkMag = [chunkMag, zeros(257, chunkSize - actualWidth, 'like', chunkMag)];
        end
        
        % Predict mask for this 126-frame block
        inputBlock = reshape(chunkMag, [257, chunkSize, 1]);
        maskBlock = predict(trainedModel, inputBlock);
        
        % Store the valid frames
        predMaskFull(:, startIdx : endIdx) = single(squeeze(maskBlock(:, 1:actualWidth, 1)));
    end
    
    disp('Applying Full Mask...');
    enhancedMag = mag .* predMaskFull;
    
    disp('Reconstructing Audio (iSTFT)...');
    S_enhanced = enhancedMag .* exp(1i * phase);
    enhancedAudio = real(istft(S_enhanced, 'Window', hann(512, 'periodic'), 'OverlapLength', 256, 'FFTLength', 512, 'FrequencyRange', 'onesided'));
    
    % Match output length to original input audio
    if length(enhancedAudio) > length(audio)
        enhancedAudio = enhancedAudio(1:length(audio));
    end
    
    if nargin > 1 && ~isempty(outputPath)
        audiowrite(outputPath, enhancedAudio, sr);
        disp(['Enhanced audio saved to ', outputPath]);
    end
end
