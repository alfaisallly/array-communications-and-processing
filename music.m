function [doa] = music(posRxSensor, covRx)
mainlobe = [];
elevationAngle = 0;
azimuthAngle = 0: 180;
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

