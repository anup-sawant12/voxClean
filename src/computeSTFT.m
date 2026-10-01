function [magnitude, phase] = computeSTFT(waveform, nFFT, hopLength, winLength)
    % computeSTFT Computes the Short-Time Fourier Transform.
    if nargin < 2, nFFT = 512; end
    if nargin < 3, hopLength = 256; end
    if nargin < 4, winLength = 512; end
    
    window = hann(winLength, 'periodic');
    
    % Use MATLAB's stft function with 'onesided' to get 257 frequency bins
    S = stft(waveform, 'Window', window, 'OverlapLength', winLength - hopLength, 'FFTLength', nFFT, 'FrequencyRange', 'onesided');
    
    magnitude = abs(S);
    phase = angle(S);
end
