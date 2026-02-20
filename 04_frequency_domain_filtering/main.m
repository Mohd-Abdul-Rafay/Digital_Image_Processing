%% 04 — Fourier Analysis + Low-Pass Filtering (Frequency vs Spatial)
% Input:  input/onion.png
% Output: output/*.png
% Notes:
% - Uses FFT (shifted) to visualize magnitude/phase.
% - Applies a Gaussian LOW-PASS filter in frequency domain and reconstructs.
% - Compares with an equivalent Gaussian LOW-PASS spatial filter.
% - Exports all figures deterministically.

clear; close all; clc;

%% Paths
inDir  = fullfile(pwd, "input");
outDir = fullfile(pwd, "output");
if ~exist(outDir, "dir"), mkdir(outDir); end

imgPath = fullfile(inDir, "onion.png");
assert(exist(imgPath, "file") == 2, "Missing input image: %s", imgPath);

%% Load + grayscale
imgRGB = imread(imgPath);
imgG   = im2double(rgb2gray(imgRGB));   % work in double [0,1]

%% FFT (shifted)
F = fftshift(fft2(imgG));

mag = abs(F);
ph  = angle(F);

% Figure 1: Magnitude + Phase
fig1 = figure("Color","w");
subplot(1,2,1);
imagesc(log(1 + mag)); axis image off; colormap gray;
title("Magnitude (log scale)");

subplot(1,2,2);
imagesc(ph); axis image off; colormap gray;
title("Phase");

exportgraphics(fig1, fullfile(outDir, "01_fft_magnitude_phase.png"));

%% Frequency-domain LOW-PASS (Gaussian)
% Controls cutoff smoothness. Larger sigma => more low-pass (blurrier).
sigmaFreq = 20;

% Build Gaussian LPF in frequency domain (same size as image)
[M,N] = size(imgG);
[u,v] = meshgrid((-floor(N/2)):(ceil(N/2)-1), (-floor(M/2)):(ceil(M/2)-1));
D2 = u.^2 + v.^2;
H_lpf = exp(-(D2) / (2*sigmaFreq^2));  % Gaussian LPF centered at DC

F_lpf = F .* H_lpf;
imgFreqLP = real(ifft2(ifftshift(F_lpf)));  % reconstructed image

% Clamp to display range
imgFreqLP = min(max(imgFreqLP, 0), 1);

fig2 = figure("Color","w");
imshow(imgFreqLP, []);
title("Reconstruction from Frequency-Domain Gaussian LPF");
exportgraphics(fig2, fullfile(outDir, "02_reconstruction_freq_lpf.png"));

%% Spatial-domain LOW-PASS (Gaussian) to match the effect
sigmaSpatial = 2; % typical small sigma; tune if you want closer visual match
imgSpatialLP = imgaussfilt(imgG, sigmaSpatial, "FilterSize", 2*ceil(3*sigmaSpatial)+1, "Padding","replicate");

fig3 = figure("Color","w");
imshow(imgSpatialLP, []);
title("Spatial Gaussian LPF (imgaussfilt)");
exportgraphics(fig3, fullfile(outDir, "03_reconstruction_spatial_lpf.png"));

%% Absolute difference
diffImg = abs(imgSpatialLP - imgFreqLP);

fig4 = figure("Color","w");
imshow(diffImg, []);
title("Absolute Difference |Spatial LPF - Frequency LPF|");
exportgraphics(fig4, fullfile(outDir, "04_abs_difference.png"));

%% Optional: save the filtered images too
imwrite(imgFreqLP,    fullfile(outDir, "freq_lpf.png"));
imwrite(imgSpatialLP, fullfile(outDir, "spatial_lpf.png"));
imwrite(diffImg,      fullfile(outDir, "abs_diff.png"));

disp("Done. Outputs saved to output/.");
