function [patternSuperres, weight] = superres(array, dirTarget, doa)
mainlobe = [];
azimuth = 0: 180;
elevation = 0;
isLog = true;
dirInterf = setdiff(doa, dirTarget, 'rows');
spvInterf = spv(array, dirInterf, mainlobe);
spvTarget = spv(array, dirTarget, mainlobe);
spvAll = spv(array, [azimuth', elevation * ones(size(azimuth'))], mainlobe);
% weight by superresolution based on doa
weight = fpoc(spvInterf) * spvTarget;
patternSuperres = abs(weight' * spvAll);
if isLog == true
    patternSuperres = 10 * log10(patternSuperres);
end
end

