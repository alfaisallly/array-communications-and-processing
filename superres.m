function [patternSuperRes] = superres(posRxSensor, dirDesired, doa)
%MUSIC Summary of this function goes here
%   Detailed explanation goes here
% patternSuperRes = [];
mainlobe = [];
isLog = true;
azimuthAngle = 0: 180;
elevationAngle = 0;
% % obtain target angle by maximum gain direction
% spvDoa = spv(posRxSensor, doa, mainlobe);
dirInterf = setdiff(doa, dirDesired, 'rows');
spvInterf = spv(posRxSensor, dirInterf, mainlobe);
spvDesired = spv(posRxSensor, dirDesired, mainlobe);
spvAllDir = spv(posRxSensor, [azimuthAngle', elevationAngle * ones(size(azimuthAngle'))], mainlobe);
% weight by superresolution based on doa
weight = fpoc(spvInterf) * spvDesired;
patternSuperRes = abs(weight' * spvAllDir);

if isLog == true
    patternSuperRes = 10 * log10(patternSuperRes);
end

end

