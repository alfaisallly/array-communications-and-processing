function [covRxCoherent, subarray, covRxSub] = spatial_smoothing(posRxSensor, dirTx, covTxCoherent, varNoise)
%SPATIAL_SMOOTHING Summary of this function goes here
%   Detailed explanation goes here
% number of subarrays equals number of coherent signals
% azimuthAngle = 0: 180;

nSubarrays = length(covTxCoherent) - rank(covTxCoherent) + 1;
sizeSubarray = length(posRxSensor) - nSubarrays + 1;
covRxSub = cell(nSubarrays, 1);
covRxSum = 0;
subarray = cell(nSubarrays, 1);
% spvAllDir = spv(posRxSensor, azimuthAngle)


% diagonalMatrix = diag(spvTheory(2, :));
% S = exp(-j*(array*KI -U0));
for iSubarray = 1: nSubarrays
    subarray{iSubarray} = posRxSensor(iSubarray: (iSubarray + sizeSubarray - 1), :);
%     posSubarray = posRxSensor(iSubarray: (iSubarray + sizeSubarray - 1), :);
    spvTheory = spv(subarray{iSubarray}, dirTx);
    covRxSub{iSubarray} = spvTheory * covTxCoherent * spvTheory' + varNoise * eye(sizeSubarray);
    covRxSum = covRxSum + covRxSub{iSubarray};
end
covRxCoherent = covRxSum / nSubarrays;

