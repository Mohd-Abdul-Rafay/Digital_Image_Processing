%% 06 — Morphology Pipeline for Cell Segmentation (Sobel → Dilate → Fill → Erode)
% Digital Image Processing (MATLAB)
%
% Pipeline:
% 1) Sobel edge detection with tuned threshold
% 2) Morphological dilation with orthogonal line structuring elements
% 3) Hole filling (imfill)
% 4) Morphological erosion for smoothing
%
% Outputs are exported deterministically to ./output/

clear; close all; clc;

%% -------- Paths (relative) --------
inDir  = fullfile(pwd, "input");
outDir = fullfile(pwd, "output");
if ~exist(outDir, "dir"), mkdir(outDir); end

imgPath = fullfile(inDir, "cell.tif");
assert(exist(imgPath, "file") == 2, "Missing input image: %s", imgPath);

%% -------- Load image (grayscale expected) --------
img = imread(imgPath);
if ndims(img) == 3
    img = rgb2gray(img); % safety in case input is RGB
end

% Save original
imwrite(img, fullfile(outDir, "01_original.png"));

%% -------- 1) Sobel edges (threshold tuned) --------
sobelThreshold = 0.026; % your tuned value
edges = edge(img, "sobel", sobelThreshold);
imwrite(edges, fullfile(outDir, "02_sobel_edges.png"));

%% -------- 2) Dilate with two line structuring elements --------
seH = strel("line", 3, 0);   % horizontal-ish
seV = strel("line", 3, 90);  % vertical-ish

d1 = imdilate(edges, seH);
d2 = imdilate(d1, seV);
imwrite(d2, fullfile(outDir, "03_dilated_edges.png"));

%% -------- 3) Fill holes --------
filled = imfill(d2, "holes");
imwrite(filled, fullfile(outDir, "04_filled.png"));

%% -------- 4) Erode for smoothing --------
seSmooth = strel("diamond", 2);
smoothMask = imerode(filled, seSmooth);
imwrite(smoothMask, fullfile(outDir, "05_smoothed_mask.png"));

%% -------- Optional: quick visual summary (single image export) --------
summary = montageGrid({
    img, edges, d2;
    filled, smoothMask, []
});
imwrite(summary, fullfile(outDir, "06_pipeline_summary.png"));

disp("Done. Outputs saved to: " + outDir);

%% ===================== Local helper =====================
function out = montageGrid(cellImgs)
% Creates a compact grid image from a 2D cell array of images.
% Empty slots can be [].
    [r, c] = size(cellImgs);

    % Find first non-empty to set target size
    first = [];
    for i = 1:r
        for j = 1:c
            if ~isempty(cellImgs{i,j})
                first = cellImgs{i,j};
                break;
            end
        end
        if ~isempty(first), break; end
    end

    if isempty(first)
        out = uint8([]);
        return;
    end

    if islogical(first), first = uint8(first) * 255; end
    if ~isa(first, "uint8"), first = im2uint8(mat2gray(first)); end
    targetH = size(first, 1);
    targetW = size(first, 2);

    gap = 10;
    canvasH = r * targetH + (r-1) * gap;
    canvasW = c * targetW + (c-1) * gap;

    out = uint8(255 * ones(canvasH, canvasW)); % white background

    for i = 1:r
        for j = 1:c
            tile = cellImgs{i,j};
            if isempty(tile), continue; end

            if islogical(tile), tile = uint8(tile) * 255; end
            if ~isa(tile, "uint8"), tile = im2uint8(mat2gray(tile)); end

            if size(tile,1) ~= targetH || size(tile,2) ~= targetW
                tile = imresize(tile, [targetH, targetW]);
            end

            y0 = (i-1) * (targetH + gap) + 1;
            x0 = (j-1) * (targetW + gap) + 1;
            out(y0:y0+targetH-1, x0:x0+targetW-1) = tile;
        end
    end
end
