function [covRxCoherent, subarray, covRxSub] = spatial_smooth(posRxSensor, dirTx, covTxCoherent, varNoise)
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
temp1 = zeros(length(posRxSensor));
temp2 = zeros(length(posRxSensor));
for iSubarray = 1: nSubarrays
    subarray{iSubarray} = posRxSensor(iSubarray: (iSubarray + sizeSubarray - 1), :);
%     posSubarray = posRxSensor(iSubarray: (iSubarray + sizeSubarray - 1), :);
    spvTheory = spv(subarray{iSubarray}, dirTx);
    covRxSub{iSubarray} = spvTheory * covTxCoherent * spvTheory';
    
%     covRxSum = covRxSum + covRxSub{iSubarray};
end
temp1(1:4, 1:4) = covRxSub{1};
temp2(2:5, 2:5) = covRxSub{2};
covRxCoherent = (temp1+temp2) / nSubarrays + varNoise * eye(5);

