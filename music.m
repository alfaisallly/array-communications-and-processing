function [doa] = music(array, covRx)
mainlobe = [];
azimuth = 0: 180;
elevation = 0;
cost = zeros(length(azimuth), 1);
[nSourse, eigVectorSignal] = detection(covRx);
for iAzimuthAngle = azimuth
    spvComponent = spv(array, [iAzimuthAngle elevation], mainlobe);
    % why not noise eigen vector directly?
    cost(iAzimuthAngle + 1) = spvComponent' * fpoc(eigVectorSignal) * spvComponent;
end
[~, doaIndex] = mink(cost, nSourse);
doaAzimuth = doaIndex - 1;
doa = [doaAzimuth elevation * ones(size(doaAzimuth))];
doa = sortrows(doa, 1);
