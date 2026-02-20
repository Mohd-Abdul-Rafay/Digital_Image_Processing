%% 02 — Color Spaces & Contrast Enhancement (Histogram Equalization + Stretching)
% Reproducible DIP module:
% 1) RGB → Grayscale + Histogram Equalization (histeq)
% 2) Contrast stretching in HSV-V channel (imadjust)
% 3) Channel visualizations: RGB, HSV, YIQ (NTSC)
% 4) Simple color mask: keep only "red-like" pixels

clear; clc; close all;

%% Paths
inDir  = fullfile(pwd, "input");
outDir = fullfile(pwd, "output");
if ~exist(outDir, "dir"); mkdir(outDir); end

imgPath = fullfile(inDir, "onion.png");
assert(exist(imgPath, "file") == 2, "Missing input image: %s", imgPath);

%% Read
imgRGB = imread(imgPath);

%% 1) Grayscale + Histogram Equalization
imgGray = rgb2gray(imgRGB);
imgEq   = histeq(imgGray);

fig = figure("Name","RGB vs Grayscale","Color","w");
montage({imgRGB, imgGray}, "BorderSize", 20, "BackgroundColor", "w", "Size", [1 2]);
exportgraphics(fig, fullfile(outDir, "01_rgb_vs_grayscale.png"), "Resolution", 200);

fig = figure("Name","Histogram Equalization (Grayscale)","Color","w");
montage({imgGray, imgEq}, "BorderSize", 20, "BackgroundColor", "w", "Size", [1 2]);
exportgraphics(fig, fullfile(outDir, "02_grayscale_vs_histeq.png"), "Resolution", 200);

%% 2) Contrast Stretching (HSV Value Channel)
imgStretch = contrastStretchHSV(imgRGB);

fig = figure("Name","Equalization vs Stretching","Color","w");
montage({imgRGB, imgEq, imgStretch}, "BorderSize", 20, "BackgroundColor", "w", "Size", [1 3]);
exportgraphics(fig, fullfile(outDir, "03_input_eq_stretch.png"), "Resolution", 200);

%% 3) Channel Visualizations (RGB / HSV / YIQ)
[R,G,B] = imsplit(imgRGB);
fig = figure("Name","RGB Channels","Color","w");
montage({R,G,B}, "BorderSize", 20, "BackgroundColor", "w", "Size", [1 3]);
exportgraphics(fig, fullfile(outDir, "04_rgb_channels.png"), "Resolution", 200);

imgHSV = rgb2hsv(imgRGB);
[H,S,V] = imsplit(imgHSV);
fig = figure("Name","HSV Channels","Color","w");
montage({H,S,V}, "BorderSize", 20, "BackgroundColor", "w", "Size", [1 3]);
exportgraphics(fig, fullfile(outDir, "05_hsv_channels.png"), "Resolution", 200);

imgYIQ = rgb2ntsc(imgRGB); % NTSC (YIQ-like)
[Y,I,Q] = imsplit(imgYIQ);
fig = figure("Name","YIQ Channels (NTSC)","Color","w");
montage({Y,I,Q}, "BorderSize", 20, "BackgroundColor", "w", "Size", [1 3]);
exportgraphics(fig, fullfile(outDir, "06_yiq_channels.png"), "Resolution", 200);

%% 4) Keep Red Pixels (Simple Threshold Mask)
% Note: Uses a conservative mask in RGB space for demonstration.
imgRedOnly = keepRedPixels(imgRGB);

fig = figure("Name","Keep Red Pixels Only","Color","w");
imshow(imgRedOnly);
title("Red-like pixels preserved; others set to black");
exportgraphics(fig, fullfile(outDir, "07_red_only_mask.png"), "Resolution", 200);

disp("Done. Outputs saved to: " + outDir);

%% ===== Local Functions =====

function outRGB = contrastStretchHSV(inRGB)
% Contrast stretch via HSV Value channel.
% Preserves hue/saturation while expanding intensity range.

    hsvImg = rgb2hsv(inRGB);
    [h,s,v] = imsplit(hsvImg);

    v2 = imadjust(v);                 % contrast stretch (default saturation)
    hsv2 = cat(3, h, s, v2);
    outRGB = hsv2rgb(hsv2);
end

function outRGB = keepRedPixels(inRGB)
% Keep red-like pixels; set everything else to black.
% Simple thresholding for demonstration (not illumination-invariant).

    [R,G,B] = imsplit(inRGB);

    % Thresholds (tuned for "onion.png"-like examples).
    rMin = 110;
    gMax = 110;
    bMax = 110;

    mask = (R >= rMin) & (G < gMax) & (B < bMax);

    R(~mask) = 0;
    G(~mask) = 0;
    B(~mask) = 0;

    outRGB = cat(3, R, G, B);
end
