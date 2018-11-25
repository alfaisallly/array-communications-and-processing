function [covRxCoherent] = spatial_smoothing_temp(posRxSensor, dirTx, covTxCoherent, varNoise)
%SPATIAL_SMOOTHING Summary of this function goes here
%   Detailed explanation goes here
% number of subarrays equals number of coherent signals
% azimuthAngle = 0: 180;

nSubarrays = length(covTxCoherent) - rank(covTxCoherent) + 1;
sizeSubarray = length(posRxSensor) - nSubarrays + 1;
covRxSub = cell(nSubarrays, 1);
covRxSum = 0;

% spvAllDir = spv(posRxSensor, azimuthAngle)

spvTheory = spv(posRxSensor, dirTx);
% spvTheory = [spvTheory(:, 1) + spvTheory(:, 2) spvTheory(:, 3)];
steeringVector = steervec(posRxSensor', dirTx');
diagonalMatrix = diag(spvTheory(1, :));
% S = exp(-j*(array*KI -U0));
for iSubarray = 1: nSubarrays
%     subarray{iSubarray} = posRxSensor(iSubarray: (iSubarray + sizeSubarray - 1), :);
    posSubarray = posRxSensor(iSubarray: (iSubarray + sizeSubarray - 1), :);
    covRxSub{iSubarray} = spvTheory * diagonalMatrix ^ (iSubarray - 1) * covTxCoherent * pinv(diagonalMatrix) ^ (iSubarray - 1) * pinv(spvTheory) + varNoise * eye(length(posRxSensor));
    covRxSum = covRxSum + spvTheory * diagonalMatrix ^ (iSubarray - 1) * covTxCoherent * pinv(diagonalMatrix) ^ (iSubarray - 1) * pinv(spvTheory) + varNoise * eye(length(posRxSensor));
end
covRxCoherent = covRxSum / nSubarrays;

