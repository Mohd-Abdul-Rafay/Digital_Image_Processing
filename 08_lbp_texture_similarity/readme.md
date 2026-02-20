# 08 — Texture Similarity via Local Binary Patterns (LBP) + Euclidean Distance

This module benchmarks **classical texture similarity** using **Local Binary Pattern (LBP)** descriptors and **Euclidean distance**. A reference texture patch (from `bricks.jpg`) is compared against multiple candidate patches (original + rotated variants) under a controlled, reproducible pipeline.

**Goal:** a transparent baseline for texture matching that is easy to audit, rerun, and version-control.

---

## What this module does

1. Loads four texture images:
   - `bricks.jpg`
   - `bricksRotated.jpg`
   - `carpet.jpg`
   - `rice.png`
2. Converts inputs to **grayscale** (LBP operates on intensity patterns).
3. Crops a fixed **128×128** patch (`[x=0, y=0, w=128, h=128]`) from each image.
4. Creates an augmented set by rotating each image by **−45°** (`crop` mode) and cropping again.
5. Extracts **LBP feature vectors** for each patch.
6. Computes **Euclidean distance** between the reference and each candidate:
   - **Lower distance ⇒ more similar texture**
7. Exports a ranked table and artifacts to `output/`.

---

## Outputs (export-first)

All outputs are written deterministically to `output/`:

- `01_patches_montage.png` — montage of all patches used (reference included)
- `02_results.txt` — best match + full ranking (human-readable)
- `03_lbp_similarity_ranking.csv` — full ranking (spreadsheet-friendly)

---

## Directory structure

```bash
08_lbp_texture_similarity/
├── main.m
├── input/
│   ├── bricks.jpg
│   ├── bricksRotated.jpg
│   ├── carpet.jpg
│   └── rice.png
├── output/
│   ├── 01_patches_montage.png
│   ├── 02_results.txt
│   └── 03_lbp_similarity_ranking.csv
├── notes.html
└── README.md
```

---

## Notes (recommended)
For deeper explanations and interactive learning for this module, open:

- `notes.html` (interactive, browser-based)

---

## How to run
1.	Place the input files in:
```matlab
08_lbp_texture_similarity/input/
```
2.	In MATLAB, set the working directory to this folder and run:
```matlab
main
```

---

## Parameters (explicit by design)

These are the only values you typically tune first:
- Crop rectangle: [0, 0, 128, 128]
- Rotation for augmentation: −45° (imrotate(...,"crop"))
- LBP extraction:
	- extractLBPFeatures(..., 'Interpolation','Linear')
- Similarity metric:
	- Euclidean distance between LBP feature vectors (norm(…,2))

---

## Interpretation
- LBP captures local intensity micro-patterns strongly correlated with texture.
- Euclidean distance provides a simple, interpretable similarity measure.
- This is a classical baseline, not a learned retrieval system.

---

## Requirements
- MATLAB
- Image Processing Toolbox (imread, imcrop, imrotate, montage)
- Computer Vision Toolbox (extractLBPFeatures)
