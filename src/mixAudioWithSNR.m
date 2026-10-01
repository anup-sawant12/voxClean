function [noisyAudio, cleanAudio, scale] = mixAudioWithSNR(cleanAudio, noiseAudio, snrDB)
    % mixAudioWithSNR Mixes clean speech and noise audio at an exact target SNR (dB).
    
    cleanLen = length(cleanAudio);
    noiseLen = length(noiseAudio);
    
    if noiseLen < cleanLen
        % Tile noise if shorter
        repeatTimes = ceil(cleanLen / noiseLen);
        noiseAudio = repmat(noiseAudio, repeatTimes, 1);
        noiseLen = length(noiseAudio);
    end
    
    % Randomly slice matching segment from noise
    if noiseLen > cleanLen
        startIdx = randi([1, noiseLen - cleanLen + 1]);
        noiseSeg = noiseAudio(startIdx : startIdx + cleanLen - 1);
    else
        noiseSeg = noiseAudio(1:cleanLen);
    end
    
    % Calculate signal powers (RMS)
    cleanPower = mean(cleanAudio.^2);
    noisePower = mean(noiseSeg.^2);
    
    if cleanPower < 1e-12
        cleanPower = 1e-12;
    end
    if noisePower < 1e-12
        noisePower = 1e-12;
    end
    
    % Calculate scale for target SNR
    targetNoisePower = cleanPower / (10^(snrDB / 10.0));
    scale = sqrt(targetNoisePower / noisePower);
    
    scaledNoise = scale * noiseSeg;
    noisyAudio = cleanAudio + scaledNoise;
    
    % Prevent clipping while maintaining SNR
    maxVal = max(abs(noisyAudio));
    if maxVal > 0.99
        normFactor = 0.95 / maxVal;
        noisyAudio = noisyAudio * normFactor;
        cleanAudio = cleanAudio * normFactor;
    end
end
