function generateTestAudio()
    % generateTestAudio Automatically mixes a clean and noise file for testing.
    disp('Mixing a clean voice and background noise to create a test file...');
    
    cleanList = dir('dataset/clean/test/*.wav');
    noiseList = dir('dataset/noise/test/*.wav');
    
    if isempty(cleanList) || isempty(noiseList)
        disp('Error: Could not find WAV files in dataset/clean/test/ or dataset/noise/test/');
        return;
    end
    
    % Pick the first file from each
    cleanPath = fullfile(cleanList(1).folder, cleanList(1).name);
    noisePath = fullfile(noiseList(1).folder, noiseList(1).name);
    
    % Load audio
    cleanAudio = loadAudio(cleanPath, 16000);
    noiseAudio = loadAudio(noisePath, 16000);
    
    % Mix them together at 5 dB (moderately noisy)
    [mixedAudio, ~, ~] = mixAudioWithSNR(cleanAudio, noiseAudio, 5);
    
    % Save to the project folder
    outPath = 'messy_test_file.wav';
    audiowrite(outPath, mixedAudio, 16000);
    
    disp('=======================================');
    disp(['Success! Created: ', outPath]);
    disp('Go to VoxCleanApp, click "Select Audio", and pick this exact file!');
    disp('=======================================');
end
