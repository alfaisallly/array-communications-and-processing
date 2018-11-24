clear; close;
posRxSensor=[-2 0 0; -1 0 0; 0 0 0; 1 0 0; 2 0 0];
azimuthAngle = 0: 180;
elevationAngle = 0;
% the index of desired user's angle among all doa
% to be determined by actual case
% eg. if target is 90 azimuth out of [30 35 90], the index is 3
audioTargetIndex = 3;
imageTargetIndex = 5;
%% Covariance matrix: practice
load('xAudio'); load('xImage');
signalAudio = X_au;
signalImage = X_im;
% % % soundsc(real(signalAudio(2, :)), 11025);
% % % displayimage(signalImage(2, :),image_size, 201, 'The received signal at the 2nd antenna');
covAudio = signalAudio * signalAudio' / length(signalAudio(1, :));
covImage = signalImage * signalImage' / length(signalImage(1, :));
doaAudio = music(posRxSensor, covAudio);
dirAudioDesired = doaAudio(audioTargetIndex, :);
[patternAudio] = superres(posRxSensor, dirAudioDesired, doaAudio);
plot2d3d(patternAudio, azimuthAngle, elevationAngle, 'Gain in dB', 'Gain pattern by superresolution beamformer');
hold on;
doaImage = music(posRxSensor, covImage);
dirImageDesired = doaImage(imageTargetIndex, :);
[patternImage] = superres(posRxSensor, dirImageDesired, doaImage);
plot2d3d(patternImage, azimuthAngle, elevationAngle, 'Gain in dB', 'Gain pattern by superresolution beamformer');
legend('Audio', 'Image','location','southeast');
