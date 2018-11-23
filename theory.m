clear; close;
posRxSensor=[-2 0 0; -1 0 0; 0 0 0; 1 0 0; 2 0 0];
dirTx = [30 0; 35 0; 90 0];
dirDesired = [90 0];
%% Array pattern plot
% only determined by array; best direction is 90 Azimuth
patternOriginal = pattern(posRxSensor);
% max gain at target direction
plot2d3d(patternOriginal, 0: 180, 0, 'Gain in dB', 'Initial pattern');
hold on;
%% Source position vector
% gain of elements on all directions
spvTheory = spv(posRxSensor, dirTx);
%% Covariance matrix: theory
% normalised equal power sources -> unit diagonal; uncorrelated -> others
% entries zero; size determined by number of transmitters
covTx = eye(length(dirTx));
% additive uncorrelated isotropic noise, SNR = 40 dB
varNoise = 1e-4;
% covariance matrix of transmitted signal
% diagonal -> signal power; others -> covariance of signals
covRx = spvTheory * covTx * spvTheory' + varNoise * eye(length(posRxSensor));
%% Covariance matrix: practice
load('xAudio'); load('xImage');
signalAudio = X_au;
signalImage = X_im;
% % % soundsc(real(signalAudio(2, :)), 11025);
% % % displayimage(signalImage(2, :),image_size, 201, 'The received signal at the 2nd antenna');
covAudio = signalAudio * signalAudio' / length(signalAudio(1, :));
covImage = signalImage * signalImage' / length(signalImage(1, :));
% source information is actually unknown
dirTx = [];
covTx = [];
spvTheory = [];
varNoise = [];
%% Detection: eigendecomposition
% theoretical value
eigTheory = eig(covRx);
% practical value
eigAudio = eig(covAudio);
eigImage = eig(covImage);
%% Estimation: conventional approach
% manifold vector of the desired source
spvDesired = spv(posRxSensor, [90, 0]);
% optimum weight by Wiener-Hopf solution
gain = 1;
weightOptimum = gain * covRx \ spvDesired;
patternOptimum = pattern(posRxSensor, weightOptimum);
plot2d3d(patternOptimum, 0: 180, 0, 'Gain in dB', 'Optimum pattern by W-H Algorithm');
hold on;
%% Estimation: superresolution approach
doa = music(posRxSensor, covRx);
[patternSuperRes] = superres(posRxSensor, dirDesired, doa);
plot2d3d(patternSuperRes, 0: 180, 0, 'Gain in dB', 'Superresolution pattern by MUSIC Algorithm');
legend('Original', 'Optimum', 'Superres');
