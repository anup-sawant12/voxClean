function audio = loadAudio(filePath, targetSR)
    % loadAudio Loads an audio file, converts to mono, and resamples.
    % Returns normalized float audio in [-1.0, 1.0].
    
    if nargin < 2
        targetSR = 16000;
    end
    
    if ~isfile(filePath)
        error('Audio file not found: %s', filePath);
    end
    
    [audio, originalSR] = audioread(filePath);
    
    % Convert to mono if stereo
    if size(audio, 2) > 1
        audio = mean(audio, 2);
    end
    
    % Resample if necessary
    if originalSR ~= targetSR
        audio = resample(audio, targetSR, originalSR);
    end
    
    % Normalize amplitude
    maxAmp = max(abs(audio));
    if maxAmp > 1.0
        audio = audio / (maxAmp + 1e-8);
    end
end
