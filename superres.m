function [patternSuperRes] = superres(posRxSensor, dirDesired, doa)
%MUSIC Summary of this function goes here
%   Detailed explanation goes here
patternSuperRes = [];
mainlobe = [];
isLog = true;
elevationAngle = 0;
azimuthAngle = 0: 180;

dirInterf = setdiff(doa, dirDesired, 'rows');
spvInterf = spv(posRxSensor, dirInterf, mainlobe);
spvDesired = spv(posRxSensor, dirDesired, mainlobe);
spvAllDir = spv(posRxSensor, [azimuthAngle', elevationAngle * ones(size(azimuthAngle'))], mainlobe);
weight = fpoc(spvInterf) * spvDesired;
patternSuperRes = [patternSuperRes; abs(weight' * spvAllDir)];

if isLog == true
    patternSuperRes = 10 * log10(patternSuperRes);
end

end

