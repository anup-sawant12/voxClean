%% 02 Preprocessing & Feature Extraction
% Demonstrates STFT, iSTFT, and SNR mixing using src functions.

addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'src'));

%% Load Audio
% cleanAudio = loadAudio('data/clean/example.wav');
% noiseAudio = loadAudio('data/noise/example.wav');
% [noisy, clean, scale] = mixAudioWithSNR(cleanAudio, noiseAudio, 5);

%% STFT Visualization
% [mag, phase] = computeSTFT(noisy);
% imagesc(mag);
% colormap(jet);
% title('Magnitude Spectrogram');
