clear; close;
rxArrayPos=[-2 0 0; -1 0 0; 0 0 0; 1 0 0; 2 0 0];
txDir = [30, 0; 35, 0; 90, 0];
%% Array pattern plot
% only determined by array; best direction is 90 Azimuth
patternOriginal = pattern(rxArrayPos);
% max gain at target direction
plot2d3d(patternOriginal, 0: 180, 0, 'Gain in dB', 'Initial  pattern');
hold on;
%% Source position vector
% gain of elements on all directions
manifold = spv(rxArrayPos, txDir);
%% Covariance matrix: theory
% normalised equal power sources -> unit diagonal; uncorrelated -> others
% entries zero; size determined by number of transmitters
covTx = eye(length(txDir));
% additive uncorrelated isotropic noise, SNR = 20 dB
varNoise = 1e-1;
% covariance matrix of transmitted signal
% diagonal -> signal power; others -> covariance of signals
covRx = manifold * covTx * manifold' + varNoise * eye(length(rxArrayPos));
%% Covariance matrix: practice
load('xAudio'); load('xImage');
audioReal = X_au;
audioImag = X_im;
% % % % % % soundsc(real(xAudioReal(2, :)), 11025);
% % % % % % displayimage(xAudioImag(2, :),image_size, 201, 'The received signal at the 2nd antenna');
covAudioReal = audioReal * audioReal' / length(audioReal(1, :));
covAudioImag = audioImag * audioImag' / length(audioImag(1, :));
% source information is actually unknown
txDir = [];
covTx = [];
manifold = [];
varNoise = [];
%% Detection approach: eigendecomposition
% theoretical value
eigTransmitted = eig(covRx);
% practical value
eigAudioReal = eig(covAudioReal);
eigAudioImag = eig(covAudioImag);
%% Estimation
% manifold vector of the desired source
manifoldDesired = spv(rxArrayPos, [35, 0]);
% optimum weight by Wiener-Hopf solution
gain = 1;
weightOptimum = gain * covRx \ manifoldDesired;
patternOptimum = pattern(rxArrayPos, weightOptimum);
plot2d3d(patternOptimum, 0: 180, 0, 'Gain in dB', 'Optimum  pattern by W-H Algorithm');
legend('Original', 'Optimum');
