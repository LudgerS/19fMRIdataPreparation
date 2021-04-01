%% analysis19F.m
%
% Example script for the analysis of fluorine-19 MRI data. Supplementary
% material to 
%   L. Starke, T. Niendorf & S. Waiczies
%   "Data preparation protocol for low signal-to-noise ratio fluorine-19 MRI"
%   in "Preclinical MRI of the Kidney", Springer Protocols (2021)
%
% The provided dataset is an example from Setup4 in
% Starke et al., "Performance of compressed sensing for fluorine?19 
% magnetic resonance imaging at low signal?to?noise ratio conditions", 
% Magnetic Resonance in Medicine (2019)
%
% Dataset variables:
% 'imageData' 19F image
% 'noiseData' pure noise scan (no excitation)
% 'nAverages' is the number of averages of 'imageData'
% Only a single average was acquired in the noise scan
% 'redHotMap' is a color map suited for 19F images
% 'nCoilElements' gives the number of receive elements in the used coil.
%
% ------------------------------------------------------ %
% Relies on https://github.com/LudgerS/MRInoiseBiasCorrection 
% Adjust 'addpath' arguments in this section before use.
% ------------------------------------------------------ %
%
% Written by Ludger Starke; Max Delbrück Center for Molecular Medicine in
% the Helmholtz Association, Berlin; 20-02-14
%
% License: GNU GPLv3 

clear, close all

addpath([pwd, filesep, 'subFunctions'])                                    % add subFunctions folder coming with the repository to the search path
addpath('C:\githubRepositories\MRInoiseBiasCorrection')                                    % add MRInoiseBiasCorrection tool to the search path

load('exampleData')


%% scaling adjustment

imageData = imageData/nAverages;                                           % rescales imageData to the scale of a single average; remove if your vendor uses a "true averaging" convention
noiseData = noiseData/1;                                                   % noiseData was already acquired with just 1 average


%% get noise level from image

cornerSize = 15;                                                           % specifies the size of the background region
backgroundMask = createBackgroundMask(size(imageData), cornerSize);        % creates a logical mask with quadratic "true" areas in all four corners

backgroundOverlay = simpleOverlay(imageData, backgroundMask);              % creates a simple overlay to visualize the background mask
imshow(backgroundOverlay, [], 'border', 'tight')

sigmaImage =  std(imageData(backgroundMask))/0.6551;                       % Noise standard deviation based on the background region. The factor
                                                                           % 0.6551 needs to be adjusted for data acquired with multiple 
                                                                           % receive elements (see Note 4 in the book chapter)

                                                                          
%% get noise level from noise scan

sigmaScan = std(noiseData(:))/0.6551/sqrt(nAverages);                      % Noise standard deviation computed from a noise scan. Division by 
                                                                           % sqrt(nAverages) computes the noise level change due to the different number
                                                                           % of averages in the noise and image data. See also the comment above.

sigma = sigmaScan;                                                         % for the rest of the example we use the noise scan estiamte


%% Noise bias correction and thresholding

correctedImage = correctNoiseBias(imageData, sigma, nCoilElements);        % uses the provided tool to correct the Rician noise bias

snrThreshold = 3.5;
thresholdedImage = correctedImage;
thresholdedImage(thresholdedImage < snrThreshold*sigma) = 0;               % simple thresholding at SNR = snrThreshold

featureMinVoxels = 3;                                                      % Specify the minimum number of voxels per feature
cleanedImage = removeIsolatedVoxels(thresholdedImage, featureMinVoxels);   % Remove isolated voxels using MATLAB's 'bwconncomp' function


figure
imshow([imageData, correctedImage, thresholdedImage, cleanedImage], [], 'border', 'tight')


%% overlay

resizeFactor = 3;                                                          % resizing the image before saving is helpful to improve image quality
                                                                           
overlayFileName = '19F_overlay.png';
fluorineOverlay(anatomyData, cleanedImage, redHotMap, resizeFactor, overlayFileName)

%% colorbar
% The arguments for the function are:
% colorMap, fileName, maximum of the corresponding image, axis label

plotFluorineColorBar(redHotMap, 'colorBar.png', max(cleanedImage(:))/sigma, 'Fluorine-19 SNR')




