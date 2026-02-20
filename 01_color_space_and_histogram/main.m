% =========================================================================
% 01 — Color Space + Histogram Processing (DIP)
% - RGB & HSV channel visualization
% - Resize (2x) + center crop back to original size
% - Grayscale conversion + histogram
% - Histogram matching (input gray matched to reference gray distribution)
%
% Input:
%   input/image.png
% Output:
%   output/*.png
% =========================================================================

clear; clc; close all;

%% Paths
inDir  = fullfile("input");
outDir = fullfile("output");
if ~exist(outDir, "dir"); mkdir(outDir); end

imgPath = fullfile(inDir, "image.png");
assert(exist(imgPath, "file") == 2, "Missing input image: %s", imgPath);

%% Read image
img = imread(imgPath);
assert(size(img,3) == 3, "Expected an RGB image.");

imwrite(img, fullfile(outDir, "01_original.png"));

%% RGB channels
[RC, GC, BC] = imsplit(img);
fig = figure("Visible","off");
montage({RC, GC, BC}, "BackgroundColor","w", "BorderSize", 20, "Size", [1 3]);
title("RGB Channels (R | G | B)");
exportgraphics(fig, fullfile(outDir, "02_rgb_channels.png"));
close(fig);

%% HSV channels
hsvImg = rgb2hsv(img);
[HC, SC, VC] = imsplit(hsvImg);

fig = figure("Visible","off");
montage({HC, SC, VC}, "BackgroundColor","w", "BorderSize", 20, "Size", [1 3]);
title("HSV Channels (H | S | V)");
exportgraphics(fig, fullfile(outDir, "03_hsv_channels.png"));
close(fig);

%% Resize 2x and center crop back to original size
scaleFactor = 2;
enlargedImage = imresize(img, scaleFactor);

origH = size(img,1);
origW = size(img,2);

startX = floor((size(enlargedImage,2) - origW)/2) + 1;
startY = floor((size(enlargedImage,1) - origH)/2) + 1;
cropRect = [startX, startY, origW-1, origH-1];

croppedImage = imcrop(enlargedImage, cropRect);

imwrite(enlargedImage, fullfile(outDir, "04_enlarged_2x.png"));
imwrite(croppedImage,  fullfile(outDir, "05_center_cropped.png"));

fig = figure("Visible","off");
montage({enlargedImage, croppedImage}, "BackgroundColor","w", "BorderSize", 20, "Size", [1 2]);
title("Resized (2x) vs Center-Cropped to Original Size");
exportgraphics(fig, fullfile(outDir, "06_resize_crop_comparison.png"));
close(fig);

%% Grayscale + histogram
grayImg = rgb2gray(img);
imwrite(grayImg, fullfile(outDir, "07_grayscale.png"));

fig = figure("Visible","off");
imshow(grayImg);
title("Grayscale Image");
exportgraphics(fig, fullfile(outDir, "08_grayscale_view.png"));
close(fig);

fig = figure("Visible","off");
imhist(grayImg);
title("Histogram of Grayscale Image");
exportgraphics(fig, fullfile(outDir, "09_grayscale_histogram.png"));
close(fig);

%% Histogram matching (same-image reference, per your original code)
matchedImg = histogramMatching(grayImg, img);
imwrite(matchedImg, fullfile(outDir, "10_histogram_matched.png"));

fig = figure("Visible","off");
montage({grayImg, matchedImg}, "BackgroundColor","w", "BorderSize", 20, "Size", [1 2]);
title("Before vs Histogram Matched");
exportgraphics(fig, fullfile(outDir, "11_histogram_matching_comparison.png"));
close(fig);

disp("Done. Outputs saved to: " + outDir);

%% ----------------------- Local Function -----------------------
function matchingImage = histogramMatching(inputImage, referenceImage)
    % Convert to grayscale if needed
    if size(referenceImage,3) == 3
        referenceImage = rgb2gray(referenceImage);
    end
    if size(inputImage,3) == 3
        inputImage = rgb2gray(inputImage);
    end

    % Ensure uint8 for consistent histogram behavior
    if ~isa(inputImage, "uint8");     inputImage = im2uint8(inputImage); end
    if ~isa(referenceImage, "uint8"); referenceImage = im2uint8(referenceImage); end

    % Match histogram
    targetHist = imhist(referenceImage);
    matchingImage = histeq(inputImage, targetHist);
end