%% 07 — Brute-Force Rigid Registration via Correlation (Rotation + Translation)
% Refined, reproducible, export-first version of your pipeline.
% Keeps your approach: (1) create a transformed/cropped target, (2) brute-force search
% over translations and rotations using corr2, (3) report best parameters + visualize.
%
% Notes:
% - Fixes your runtime break: x/y must be integer indices and ROI must be size-consistent.
% - Preallocates correlation vector for speed (no dynamic concatenation).
% - Adds deterministic outputs to ./output/ .
% - Keeps the same search ranges and corr2 scoring.

clear; close all; clc;

%% Paths
inDir  = fullfile(pwd, "input");
outDir = fullfile(pwd, "output");
if ~exist(outDir, "dir"), mkdir(outDir); end

imgPath = fullfile(inDir, "peppers.png");
assert(exist(imgPath,"file")==2, "Missing input image: %s", imgPath);

%% Load
img1 = imread(imgPath);
imwrite(img1, fullfile(outDir, "01_original.png"));

figure; imshow(img1); title("Original input image");

%% Create transformed target (rotate + center crop + paste into black canvas)
img2 = imrotate(img1, -45, "bilinear", "crop");
imwrite(img2, fullfile(outDir, "02_rotated_crop.png"));

figure; imshow(img2); title("Rotated image");

desired_width  = 50;
desired_height = 50;

% Center ROI (ensure integer pixel indices and in-bounds crop)
[H, W, ~] = size(img2);
center_x = floor(W/2);
center_y = floor(H/2);

x = center_x - floor(desired_width/2);
y = center_y - floor(desired_height/2);

% Clamp top-left so ROI is fully inside image
x = max(1, min(x, W - desired_width  + 1));
y = max(1, min(y, H - desired_height + 1));

roi = img2(y:y+desired_height-1, x:x+desired_width-1, :);

% Black canvas, paste ROI back at same location
img3 = zeros(size(img2), "like", img2);
img3(y:y+desired_height-1, x:x+desired_width-1, :) = roi;

imwrite(img3, fullfile(outDir, "03_target_masked.png"));

figure; imshow(img3); title("Cropped region pasted on black canvas");

%% Brute-force registration (your method) — correlation over translation + rotation
result = reg_bruteforce_corr2(img1, img3, -10:10, -10:10, 0:360, 1);
disp(result);

% Save result as text
fid = fopen(fullfile(outDir, "04_best_params.txt"), "w");
fprintf(fid, "max_corr: %.6f\n", result.max_corr);
fprintf(fid, "max_rotation: %d\n", result.max_rotation);
fprintf(fid, "max_translation: [%d, %d]\n", result.max_translation(1), result.max_translation(2));
fclose(fid);

%% Visualization: blend
figure; imshowpair(img1, img3, "blend"); title("Blended image (original vs target)");
frame = getframe(gcf);
imwrite(frame.cdata, fullfile(outDir, "05_blend.png"));

disp("Done. Outputs saved to: " + outDir);

%% ========================= Local Functions =========================
function position = reg_bruteforce_corr2(imgA, imgB, txRange, tyRange, rotRange, rotStep)
% Brute-force rigid search:
% - translate imgA by (tx,ty)
% - rotate by r degrees (crop)
% - score corr2 with imgB
% Returns best correlation + parameters.
%
% Keeps your corr2 objective and ranges, but fixes performance/robustness.

    % Output struct
    position = struct("max_corr", -inf, "max_rotation", 0, "max_translation", [0 0]);

    % Convert to grayscale (as you did)
    if size(imgA,3) == 3, A = rgb2gray(imgA); else, A = imgA; end
    if size(imgB,3) == 3, B = rgb2gray(imgB); else, B = imgB; end

    A = im2double(A);
    B = im2double(B);

    % Preallocate score storage (avoid dynamic array growth)
    nTx  = numel(txRange);
    nTy  = numel(tyRange);
    nRot = numel(rotRange(1):rotStep:rotRange(end));
    scores = -inf(nTx * nTy * nRot, 1);

    idx = 0;

    for i = 1:nTx
        tx = txRange(i);
        for j = 1:nTy
            ty = tyRange(j);

            % Translate (same behavior, deterministic fill)
            A_t = imtranslate(A, [tx, ty], "FillValues", 0, "OutputView", "same");

            k = 0;
            for r = rotRange(1):rotStep:rotRange(end)
                k = k + 1;
                idx = idx + 1;

                % Rotate (crop, bilinear) — your behavior
                A_tr = imrotate(A_t, r, "bilinear", "crop");

                % corr2 requires same size (they are)
                c = corr2(A_tr, B);
                scores(idx) = c;

                % Track best on the fly (no need to store everything, but we keep scores anyway)
                if c > position.max_corr
                    position.max_corr = c;
                    position.max_rotation = r;
                    position.max_translation = [tx, ty];
                end
            end
        end
    end

    % Optional: return also index if you want later
    % [~, bestIdx] = max(scores);
end
