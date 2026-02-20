%% 08 — Texture Similarity via Local Binary Patterns (LBP) + Euclidean Distance
% Compares a reference crop (bricks, unrotated) against multiple texture patches
% using LBP feature vectors and Euclidean distance (lower = more similar).
%
% Requirements: Computer Vision Toolbox (extractLBPFeatures), Image Processing Toolbox

clear; close all; clc;

%% Paths (relative, repo-friendly)
inDir  = fullfile(pwd, "input");
outDir = fullfile(pwd, "output");
if ~exist(outDir, "dir"), mkdir(outDir); end

paths.bricks        = fullfile(inDir, "bricks.jpg");
paths.bricksRotated = fullfile(inDir, "bricksRotated.jpg");
paths.carpet        = fullfile(inDir, "carpet.jpg");
paths.rice          = fullfile(inDir, "rice.png");

assert(exist(paths.bricks,        "file")==2, "Missing: %s", paths.bricks);
assert(exist(paths.bricksRotated, "file")==2, "Missing: %s", paths.bricksRotated);
assert(exist(paths.carpet,        "file")==2, "Missing: %s", paths.carpet);
assert(exist(paths.rice,          "file")==2, "Missing: %s", paths.rice);

%% Load
bricks         = imread(paths.bricks);
bricksRotated  = imread(paths.bricksRotated);
carpet         = imread(paths.carpet);
rice           = imread(paths.rice);

%% Convert to grayscale (LBP expects 2D intensity)
bricksG        = toGray(bricks);
bricksRotG     = toGray(bricksRotated);
carpetG        = toGray(carpet);
riceG          = toGray(rice);

%% Patch spec
cropRect = [0, 0, 128, 128];   % [x y w h] in pixels
angleDeg = -45;               % rotation applied for augmented set

%% Build dataset: 8 patches (4 original crops + 4 rotated crops)
patches = cell(1, 8);
labels  = strings(1, 8);

patches{1} = imcrop(bricksG,   cropRect); labels(1) = "bricks (orig)";
patches{2} = imcrop(bricksRotG,cropRect); labels(2) = "bricksRotated (orig)";
patches{3} = imcrop(carpetG,   cropRect); labels(3) = "carpet (orig)";
patches{4} = imcrop(riceG,     cropRect); labels(4) = "rice (orig)";

patches{5} = imcrop(imrotate(bricksG,   angleDeg, "bilinear", "crop"), cropRect); labels(5) = "bricks (rot -45)";
patches{6} = imcrop(imrotate(bricksRotG,angleDeg, "bilinear", "crop"), cropRect); labels(6) = "bricksRotated (rot -45)";
patches{7} = imcrop(imrotate(carpetG,   angleDeg, "bilinear", "crop"), cropRect); labels(7) = "carpet (rot -45)";
patches{8} = imcrop(imrotate(riceG,     angleDeg, "bilinear", "crop"), cropRect); labels(8) = "rice (rot -45)";

% Sanity: ensure all crops are 129x129 due to rect w/h=128 (inclusive bounds), or consistent sizes
for k = 1:numel(patches)
    assert(~isempty(patches{k}), "Crop failed for index %d (%s). Check cropRect vs image size.", k, labels(k));
end

%% LBP settings (explicit for reproducibility)
lbpOpts = {"Interpolation","Linear"};

%% Compute similarity scores vs reference (patch 1)
ref = uint8(patches{1});
refFeat = extractLBPFeatures(ref, lbpOpts{:});

scores = zeros(1, numel(patches)-1);
cands  = labels(2:end);

for i = 2:numel(patches)
    feat = extractLBPFeatures(uint8(patches{i}), lbpOpts{:});
    scores(i-1) = norm(refFeat - feat, 2); % Euclidean distance
end

%% Rank + report
T = table(cands(:), scores(:), 'VariableNames', ["Candidate","LBP_EuclideanDistance"]);
T = sortrows(T, "LBP_EuclideanDistance", "ascend");

disp("LBP similarity ranking (lower distance = more similar):");
disp(T);

bestCand  = T.Candidate(1);
bestScore = T.LBP_EuclideanDistance(1);

%% Save outputs (deterministic)
% 1) Patch overview montage
patchImgs = cellfun(@(x) uint8(x), patches, "UniformOutput", false);
h1 = figure("Visible","off");
montage(patchImgs, "Size",[2,4], "BorderSize", 6, "BackgroundColor","w");
title("Patches used for LBP similarity (reference = bricks/orig)");
exportgraphics(h1, fullfile(outDir, "01_patches_montage.png"));
close(h1);

% 2) Results text
fid = fopen(fullfile(outDir, "02_results.txt"), "w");
fprintf(fid, "Reference: %s\n", labels(1));
fprintf(fid, "Best match: %s\n", bestCand);
fprintf(fid, "Best (lowest) LBP Euclidean distance: %.6f\n\n", bestScore);
fprintf(fid, "Full ranking:\n");
for r = 1:height(T)
    fprintf(fid, "%2d) %-28s  %.6f\n", r, T.Candidate(r), T.LBP_EuclideanDistance(r));
end
fclose(fid);

% 3) CSV for easy copy/paste into README
writetable(T, fullfile(outDir, "03_lbp_similarity_ranking.csv"));

disp("Saved outputs to: " + outDir);

%% ---------------- Local helpers ----------------
function g = toGray(im)
    if ndims(im) == 3
        g = rgb2gray(im);
    else
        g = im;
    end
end
