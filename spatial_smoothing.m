function [covCoherentRx, subarray] = spatial_smoothing(array, directions, covCoherentTx, varNoise)
% number of subarrays equals number of coherent signals
nSubarrays = length(covCoherentTx) - rank(covCoherentTx) + 1;
sizeSubarray = length(array) - nSubarrays + 1;
subarray = cell(nSubarrays, 1);
spvSubarray = cell(nSubarrays, 1);
covSum = 0;
for iSubarray = 1: nSubarrays
    subarray{iSubarray} = array(iSubarray: (iSubarray + sizeSubarray - 1), :);
    spvSubarray{iSubarray} = spv(subarray{iSubarray}, directions);
    covSum = covSum + spvSubarray{iSubarray} * covCoherentTx * spvSubarray{iSubarray}';
end
covCoherentRx = covSum / nSubarrays + varNoise * eye(sizeSubarray);
