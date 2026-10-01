function ds = createDataset(cleanDir, noiseDir, segmentSeconds, snrRange, sampleRate)
    % createDataset Configures a dataset representation for training.
    % Returns a struct array of file paths that can be used to build a custom Mini-Batch Datastore.
    
    if nargin < 3, segmentSeconds = 2.0; end
    if nargin < 4, snrRange = [-5.0, 15.0]; end
    if nargin < 5, sampleRate = 16000; end
    
    cleanFiles = dir(fullfile(cleanDir, '*.wav'));
    noiseFiles = dir(fullfile(noiseDir, '*.wav'));
    
    if isempty(cleanFiles)
        error('No WAV files found in %s', cleanDir);
    end
    if isempty(noiseFiles)
        error('No WAV files found in %s', noiseDir);
    end
    
    numSamples = length(cleanFiles);
    ds = struct('cleanPath', {}, 'noisePath', {}, 'snr', {});
    for i = 1:numSamples
        ds(i).cleanPath = fullfile(cleanFiles(i).folder, cleanFiles(i).name);
        nIdx = randi(length(noiseFiles));
        ds(i).noisePath = fullfile(noiseFiles(nIdx).folder, noiseFiles(nIdx).name);
        ds(i).snr = snrRange(1) + rand() * (snrRange(2) - snrRange(1));
    end
end
