% 03 — Convolution, Noise Models, Denoising, and Edge Extraction
% Reproducible DIP module (exports all figures to ./output)

clear; close all; clc;

%% Paths
inDir  = fullfile(pwd, "input");
outDir = fullfile(pwd, "output");
if ~exist(outDir, "dir"); mkdir(outDir); end

imgPath = fullfile(inDir, "onion.png");
assert(exist(imgPath, "file") == 2, "Missing input image: %s", imgPath);

%% Load + grayscale
rgb = imread(imgPath);
gray = rgb2gray(rgb);

%% 1) Custom convolution on color image (HSV-V channel)
K = [-1  1  1; 
     -1 -1  1; 
     -1  1  1];

rgbConv = myConvHSVValue(rgb, K, "same");

h = figure("Name","01 Convolution (HSV-V)"); 
montage({rgb, rgbConv}, "BackgroundColor","w", "BorderSize",20, "Size",[1 2]);
title("Original vs Custom Convolution (applied on HSV Value channel)");
exportgraphics(h, fullfile(outDir, "01_original_vs_convolution.png"));

%% 2) Salt & pepper noise + median denoise
spNoisy = imnoise(gray, "salt & pepper");
spDenoised = medfilt2(spNoisy);

h = figure("Name","02 SaltPepper + Median");
montage({gray, spNoisy}, "BackgroundColor","w", "BorderSize",20, "Size",[1 2]);
title("Clean grayscale vs Salt & Pepper noisy");
exportgraphics(h, fullfile(outDir, "02_clean_vs_saltpepper.png"));

h = figure("Name","03 Median Denoise");
montage({gray, spDenoised}, "BackgroundColor","w", "BorderSize",20, "Size",[1 2]);
title("Clean grayscale vs Median denoised");
exportgraphics(h, fullfile(outDir, "03_clean_vs_median_denoised.png"));

%% 3) Gaussian noise + Gaussian denoise + average-filter denoise via custom conv
gaussNoisy = imnoise(gray, "gaussian", 0, 0.01);
gaussDenoised = imgaussfilt(gaussNoisy, 2);

avgK = fspecial("average", [3 3]);
avgDenoised = myConvGray(gaussNoisy, avgK, "same");

h = figure("Name","04 Gaussian + Gaussian Filter");
montage({gaussNoisy, gaussDenoised}, "BackgroundColor","w", "BorderSize",20, "Size",[1 2]);
title("Gaussian noisy vs imgaussfilt denoised");
exportgraphics(h, fullfile(outDir, "04_gaussian_noisy_vs_gauss_denoised.png"));

h = figure("Name","05 Gaussian Filter vs Avg Conv");
montage({gaussDenoised, avgDenoised}, "BackgroundColor","w", "BorderSize",20, "Size",[1 2]);
title("imgaussfilt denoise vs average-filter denoise (custom conv)");
exportgraphics(h, fullfile(outDir, "05_gauss_denoised_vs_avgconv_denoised.png"));

%% 4) Edge extraction (Canny)
edgesSP  = edge(spDenoised, "canny");
edgesAVG = edge(avgDenoised, "canny");

h = figure("Name","06 Edge Maps");
montage({edgesSP, edgesAVG}, "BackgroundColor","w", "BorderSize",20, "Size",[1 2]);
title("Canny edges: Median-denoised S&P vs AvgConv-denoised Gaussian");
exportgraphics(h, fullfile(outDir, "06_edges_comparison.png"));

disp("Done. Outputs saved to ./output/");

%% ---------------- Local functions ----------------

function outRGB = myConvHSVValue(inRGB, kernel, shape)
% Apply conv2 to HSV Value channel only, then reconstruct RGB.
% - Uses double precision for safety
% - Clips output to [0,1] for valid HSV value channel

    hsv = rgb2hsv(inRGB);
    h = hsv(:,:,1); s = hsv(:,:,2); v = hsv(:,:,3);

    v2 = conv2(double(v), double(kernel), shape);

    % Normalize to [0,1] conservatively (avoid blow-up)
    v2 = rescale(v2, 0, 1);

    hsv2 = cat(3, h, s, v2);
    outRGB = hsv2rgb(hsv2);
end

function outGray = myConvGray(inGray, kernel, shape)
% Convolution for grayscale images with proper casting + clipping.

    x = conv2(double(inGray), double(kernel), shape);

    % clip to displayable range
    x = max(min(x, 255), 0);
    outGray = uint8(x);
end
