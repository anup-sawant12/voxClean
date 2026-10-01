%% 🎙️ VoxClean AI — 01 Dataset Analysis & Exploration
% Welcome to the VoxClean AI dataset analysis notebook.
% Run this as a Live Script in MATLAB to visualize waveforms.

%% 1. Dataset File Inventory
baseDir = fileparts(mfilename('fullpath'));
projectRoot = fileparts(baseDir);
cleanDir = fullfile(projectRoot, 'dataset', 'clean', 'train');
noiseDir = fullfile(projectRoot, 'dataset', 'noise', 'train');

cleanFiles = dir(fullfile(cleanDir, '*.wav'));
noiseFiles = dir(fullfile(noiseDir, '*.wav'));

fprintf('📊 Clean Files: %d\n', length(cleanFiles));
fprintf('🔊 Noise Files: %d\n', length(noiseFiles));

%% 2. Waveform Visualization
if ~isempty(cleanFiles) && ~isempty(noiseFiles)
    cleanPath = fullfile(cleanFiles(1).folder, cleanFiles(1).name);
    noisePath = fullfile(noiseFiles(1).folder, noiseFiles(1).name);
    
    [cleanAudio, sr] = audioread(cleanPath);
    [noiseAudio, srN] = audioread(noisePath);
    
    figure('Name', 'Waveform Analysis');
    subplot(2,1,1);
    plot((0:length(cleanAudio)-1)/sr, cleanAudio, 'b');
    title('Clean Speech Waveform');
    xlabel('Time (s)');
    
    subplot(2,1,2);
    plot((0:length(noiseAudio)-1)/srN, noiseAudio, 'r');
    title('Noise Waveform');
    xlabel('Time (s)');
end
