function [doa] = music(posRxSensor, covRx)
mainlobe = [];
azimuthAngle = 0: 180;
elevationAngle = 0;
[nSourse, eigVectorSignal] = detection(covRx);
subspaceCostFunc = zeros(length(azimuthAngle), 1);

for iAzimuthAngle = azimuthAngle
    spvComponent = spv(posRxSensor, [iAzimuthAngle elevationAngle], mainlobe);
    % why not noise eigen vector directly?
    subspaceCostFunc(iAzimuthAngle + 1) = spvComponent' * fpoc(eigVectorSignal) * spvComponent;
end
[~, doaIndex] = mink(subspaceCostFunc, nSourse);
doaAzimuth = doaIndex - 1;
doa = [doaAzimuth elevationAngle * ones(size(doaAzimuth))];
doa = sortrows(doa, 1);
