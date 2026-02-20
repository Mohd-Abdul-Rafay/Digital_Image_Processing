%% 05 — Wavelet Decomposition, Detail-Energy Edge Map, and Detail Suppression (Haar)
% Author: Abdul Rafay Mohd
% Summary:
%   1) Load peppers.png -> grayscale
%   2) 3-level Haar DWT (approx + detail subbands)
%   3) Visualize coefficient mosaic (A/H/V/D across levels)
%   4) Build "edge map" by accumulating IDWT(detail-only) across levels, then threshold
%   5) Suppress detail bands (H/V/D *= 0.5) and reconstruct via multi-level IDWT
%
% Notes:
%   - Core algorithm is unchanged; this refactor adds structure, validation, and exports.
%   - Requires Wavelet Toolbox (dwt2, idwt2, wcodemat).

clear; close all; clc;

%% -------------------- Paths (relative, repo-friendly) --------------------
inDir  = fullfile(pwd, "input");
outDir = fullfile(pwd, "output");
if ~exist(outDir, "dir"), mkdir(outDir); end

imgPath = fullfile(inDir, "peppers.png");
assert(exist(imgPath, "file") == 2, "Missing input image: %s", imgPath);

%% -------------------- Load + Grayscale --------------------
imgRGB = imread(imgPath);
imgGray = rgb2gray(imgRGB);
imwrite(imgGray, fullfile(outDir, "01_grayscale.png"));

%% -------------------- Decompose (3-level Haar DWT) --------------------
levels = 3;
decomposed_coefficients = WaveLetDec(imgGray, levels);

%% -------------------- Coefficient Mosaic Visualization --------------------
A1img = wcodemat(decomposed_coefficients{1}{1}, 255, "mat", 1);
H1img = wcodemat(decomposed_coefficients{1}{2}, 255, "mat", 1);
V1img = wcodemat(decomposed_coefficients{1}{3}, 255, "mat", 1);
D1img = wcodemat(decomposed_coefficients{1}{4}, 255, "mat", 1);

A2img = wcodemat(decomposed_coefficients{2}{1}, 255, "mat", 1);
H2img = wcodemat(decomposed_coefficients{2}{2}, 255, "mat", 1);
V2img = wcodemat(decomposed_coefficients{2}{3}, 255, "mat", 1);
D2img = wcodemat(decomposed_coefficients{2}{4}, 255, "mat", 1);

A3img = wcodemat(decomposed_coefficients{3}{1}, 255, "mat", 1);
H3img = wcodemat(decomposed_coefficients{3}{2}, 255, "mat", 1);
V3img = wcodemat(decomposed_coefficients{3}{3}, 255, "mat", 1);
D3img = wcodemat(decomposed_coefficients{3}{4}, 255, "mat", 1);

level3 = [A3img, H3img; V3img, D3img];
level2 = [imresize(level3, size(A2img)), H2img; V2img, D2img];
decomposed_image = [imresize(level2, size(A1img)), H1img; V1img, D1img];

figure("Name","DWT Coefficient Mosaic"); imshow(decomposed_image, []);
title("Image decomposition coefficients");
imwrite(uint8(decomposed_image), fullfile(outDir, "02_dwt_coefficients_mosaic.png"));

%% -------------------- Edge Map (detail-only IDWT accumulation) --------------------
edge_map = zeros(size(decomposed_coefficients{1}{1}));  % unchanged intent

for i = 1:numel(decomposed_coefficients)
    [rows_A, cols_A] = size(decomposed_coefficients{1}{1});
    resized_horizontal = imresize(decomposed_coefficients{i}{2}, [rows_A, cols_A]);
    resized_vertical   = imresize(decomposed_coefficients{i}{3}, [rows_A, cols_A]);
    resized_diagonal   = imresize(decomposed_coefficients{i}{4}, [rows_A, cols_A]);

    reconstructed_image = idwt2(zeros(size(edge_map)), ...
                                resized_horizontal, resized_vertical, resized_diagonal, ...
                                "haar");

    edge_map = edge_map + imresize(reconstructed_image, size(edge_map));
end

threshold = 7;                 % unchanged
edge_binary = edge_map > threshold;

figure("Name","Wavelet Detail Edge Map"); imshow(edge_binary);
title("Edge map (thresholded detail accumulation)");
imwrite(mat2gray(edge_map), fullfile(outDir, "03_edge_map_detail_energy.png"));
imwrite(edge_binary,        fullfile(outDir, "04_edge_map_thresholded.png"));

%% -------------------- Detail Suppression (H/V/D *= 0.5) --------------------
for i = 1:numel(decomposed_coefficients)
    for j = 2:4
        decomposed_coefficients{i}{j} = decomposed_coefficients{i}{j} * 0.5; % unchanged
    end
end

Reconstructed_image = iWaveLetRec(decomposed_coefficients);

% Keep your output behavior (uint8), but make it safe for negatives/overflow.
Reconstructed_image = uint8(min(max(Reconstructed_image, 0), 255));
imwrite(Reconstructed_image, fullfile(outDir, "05_reconstructed_detail_suppressed.png"));

%% -------------------- Compare (export + display) --------------------
figure("Name","Original vs Reconstructed");
montage({imgGray, Reconstructed_image}, "BackgroundColor", "w", "BorderSize", 20, "Size", [1,2]);
title("Original Image and the Reconstructed Image");

cmp = comparisonTile(imgGray, Reconstructed_image);
imwrite(cmp, fullfile(outDir, "06_original_vs_reconstructed.png"));

disp("Done. Outputs saved to: " + outDir);

%% ===================== Local Functions (your work, organized) =====================

function waveCoeff = WaveLetDec(img, level)
    waveCoeff = cell(level, 1);

    [cA, cH, cV, cD] = dwt2(img, "haar");
    waveCoeff{1} = {cA, cH, cV, cD};

    for i = 2:level
        [cA, cH, cV, cD] = dwt2(waveCoeff{i-1}{1}, "haar");
        waveCoeff{i} = {cA, cH, cV, cD};
    end
end

function imgR = iWaveLetRec(img)
    % NOTE: Kept your logic (starts from img{1}{1}, then walks forward).
    imgR = img{1}{1};

    for i = 2:numel(img)
        [rows_A, cols_A] = size(imgR);
        resized_horizontal = imresize(img{i}{2}, [rows_A, cols_A]);
        resized_vertical   = imresize(img{i}{3}, [rows_A, cols_A]);
        resized_diagonal   = imresize(img{i}{4}, [rows_A, cols_A]);

        imgR = idwt2(imgR * 1.3, resized_horizontal, resized_vertical, resized_diagonal, "haar");
    end
end

function out = comparisonTile(a, b)
    a = uint8(a); 
    b = uint8(b);

    Ha = size(a,1); Wa = size(a,2);
    Hb = size(b,1); Wb = size(b,2);

    H = max(Ha, Hb);
    W = max(Wa, Wb);

    A = uint8(255 * ones(H, W));
    B = uint8(255 * ones(H, W));

    A(1:Ha, 1:Wa) = a;
    B(1:Hb, 1:Wb) = b;

    gap = uint8(255 * ones(H, 24));
    out = [A, gap, B];
end
