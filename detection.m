function [nSource, eigVectorSignal] = detection(covRx)
% assume max noise power / min noise power is below noiseRatioThr
% to be determined by actual environments; assume 10 here
noiseRatioThr = 10;
[eigVector, eigValue] = eig(covRx);
eigValue = diag(eigValue);
eigNoiseThr = min(eigValue) * noiseRatioThr;
nSource = sum(eigValue > eigNoiseThr);
eigVectorSignal = eigVector(:, eigValue > eigNoiseThr);
% noiseEigVector = eigVector(:, eigValue <= eigNoiseThr);
end

