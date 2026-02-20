# 07 — Rotation, Crop-Embed, and Brute-Force Image Registration (corr2 Grid Search)

This module implements a deterministic classical image registration baseline using exhaustive grid search over translation and rotation parameters.

A synthetic target image is generated via rotation and localized masking, after which alignment parameters are recovered by maximizing the Pearson correlation coefficient (`corr2`) across a discrete transformation space.

The implementation prioritizes transparency, reproducibility, and explicit parameter control.

---

## Objective

To demonstrate a brute-force registration strategy that:

- Synthesizes a controlled geometric transformation
- Recovers transformation parameters via similarity maximization
- Exposes the computational trade-offs of exhaustive search

This serves as an interpretable baseline prior to optimized or feature-based registration methods.

---

## Processing Pipeline

1. **Rotation (crop mode)**  
   The input image is rotated by −45° using `"crop"` to preserve fixed spatial dimensions.

2. **Centered Patch Extraction (50×50)**  
   A small region is extracted from the rotated image.

3. **Mask Embedding**  
   The cropped patch is reinserted into a black canvas of the original size, creating a sparse target image.

4. **Brute-Force Registration (Grid Search)**  
   The original image is transformed over a discrete search space:

   - Translation: `tx, ty ∈ [-10, 10]` pixels  
   - Rotation: `θ ∈ [0°, 360°]`  
   - Step size: 1 pixel / 1 degree  

   Similarity is computed using:
   ```matlab
   corr2(transformed_image, target_image)
   ```

The parameter set yielding the maximum correlation is selected.

5. **Result Export + Visualization**  
The best parameters and blended alignment visualization are exported.

---

## Directory Structure

```bash
07_rotation_crop_registration/
├── main.m
├── input/
│   └── peppers.png
├── output/
│   ├── 01_original.png
│   ├── 02_rotated_crop.png
│   ├── 03_target_masked.png
│   ├── 04_best_params.txt
│   └── 05_blend.png
└── README.md
```

---

## How to run
1.	Place the input image at:
```matlab
input/peppers.png
```
3.	In MATLAB, set the working directory to this folder and run:
```matlab
main
```
Outputs are written to output/.


---

## Design Characteristics
- Deterministic search (no randomness)
- Fully explicit parameter space
- Fixed image dimensions via "crop" rotation
- Export-first workflow for traceability
- Grid search implemented transparently (no hidden optimization)

---

## Computational Characteristics

The search complexity is:

O(Tx × Ty × R)

Where:
	- Tx = 21 translation steps in x
	-	Ty = 21 translation steps in y
	-	R  = 361 rotation steps

This results in ~159,000 transformation evaluations.

The method is intentionally exhaustive and not optimized for speed.

---

## Limitations
- Sensitive to search range selection
- Computationally expensive for larger parameter spaces
- Uses global correlation (not robust to local intensity changes)
- Not invariant to scale

This module is intended as a conceptual baseline rather than a production registration system.

--- 

Requirements
- MATLAB
- Image Processing Toolbox
  (imrotate, imcrop, imtranslate, imshowpair, corr2)
