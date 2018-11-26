function [nSource, eigVectorSignal] = detection(covRx)
[eigVector, eigValue] = eig(covRx);
eigValue = abs(diag(eigValue));
% assume max noise power / min noise power is below noiseRatioThr
% to be determined by actual environments; TO BE DESIGNED
if min(eigValue) >= 1e-5
    noiseRatioThr = 1.5;
else
    noiseRatioThr = 1e4;
end
eigNoiseThr = min(eigValue) * noiseRatioThr;
nSource = sum(eigValue > eigNoiseThr);
eigVectorSignal = eigVector(:, eigValue > eigNoiseThr);
% noiseEigVector = eigVector(:, eigValue <= eigNoiseThr);
end

