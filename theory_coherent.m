clear; close;
posRxSensor=[-2 0 0; -1 0 0; 0 0 0; 1 0 0; 2 0 0];
azimuthAngle = 0: 180;
elevationAngle = 0;
dirTx = [30 0; 35 0; 90 0];
dirDesired = dirTx(3, :);
gainWh = 1;
% additive uncorrelated isotropic noise, SNR = 40 dB
varNoise = 1e-4;
%% Array pattern plot
% only determined by array; best direction is 90 Azimuth
patternOriginal = pattern(posRxSensor);
% max gain at target direction
plot2d3d(patternOriginal, azimuthAngle, elevationAngle, 'Gain in dB', 'Initial gain pattern');
hold on;
%% Source position vector
% gain of elements on all directions
spvTheory = spv(posRxSensor, dirTx);
%% Covariance matrix: theory
% normalised equal power sources -> unit diagonal; uncorrelated -> others
% entries zero; size determined by number of transmitters
covTxCoherent = eye(length(dirTx));
% two sources are fully correlated
covTxCoherent(2, :) = covTxCoherent(1, :);
% covariance matrix of transmitted signal
% diagonal -> signal power; others -> covariance of signals
covRx = spvTheory * covTxCoherent * spvTheory' + varNoise * eye(length(posRxSensor));
% source information is actually unknown
dirTx = [];
covTxCoherent = [];
spvTheory = [];
varNoise = [];
%% Estimation: conventional approach
% manifold vector of the desired source
spvDesired = spv(posRxSensor, dirDesired);
% optimum weight by Wiener-Hopf solution
weightWh = gainWh * covRx \ spvDesired;
patternWh = pattern(posRxSensor, weightWh);
plot2d3d(patternWh, azimuthAngle, elevationAngle, 'Gain in dB', 'Gain pattern by W-H beamformer');
hold on;
%% Estimation: superresolution approach
% estimate doa with MUSIC algorithm
doa = music(posRxSensor, covRx);
[patternSuperRes] = superres(posRxSensor, dirDesired, doa);
plot2d3d(patternSuperRes, azimuthAngle, elevationAngle, 'Gain in dB', 'Gain pattern by superresolution beamformer');
legend('Original', 'Wiener-Hopf', 'Superres','location','southeast');
