function irm = computeIdealRatioMask(cleanMag, noisyMag, epsVal)
    % computeIdealRatioMask Computes the Ideal Ratio Mask (IRM).
    if nargin < 3
        epsVal = 1e-8;
    end
    
    irm = cleanMag ./ (noisyMag + epsVal);
    irm(irm > 1.0) = 1.0;
    irm(irm < 0.0) = 0.0;
end
