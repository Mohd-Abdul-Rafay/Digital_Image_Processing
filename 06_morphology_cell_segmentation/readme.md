# 06 — Morphology-Based Cell Segmentation (Sobel → Dilate → Fill → Erode)

This module implements a deterministic, classical morphology-based segmentation pipeline for microscopy-style grayscale imagery.

The system converts edge evidence into a clean binary cell mask using a minimal and interpretable sequence of operations. Every intermediate stage is exported to disk to ensure reproducibility, traceability, and reviewability.

---

## Motivation

Prior to modern deep learning approaches, microscopy segmentation pipelines relied on:

- Gradient-based edge extraction  
- Morphological connectivity repair  
- Region filling for contour completion  
- Controlled smoothing for mask regularization  

This implementation demonstrates that structured pipeline in a transparent and auditable manner.

---

## Processing Pipeline

### 1) Sobel Edge Detection (Threshold Controlled)
Extracts gradient boundaries using a tuned threshold to explicitly control edge sensitivity.

### 2) Morphological Dilation (Orthogonal Line Structuring Elements)
Two line structuring elements (0° and 90°) are applied sequentially to:
- Bridge small discontinuities
- Strengthen weak boundary responses
- Improve contour connectivity

### 3) Hole Filling (`imfill`)
Closed contours are converted into solid binary regions.

### 4) Morphological Erosion (Diamond Structuring Element)
Applies structural smoothing to:
- Reduce jagged boundaries
- Suppress small artifacts
- Stabilize the final segmentation mask

---

## Exported Artifacts

All outputs are deterministically written to `output/`:

- `01_original.png` — Input grayscale image  
- `02_sobel_edges.png` — Sobel edge map  
- `03_dilated_edges.png` — Connectivity-enhanced edges  
- `04_filled.png` — Region-filled mask  
- `05_smoothed_mask.png` — Final segmentation mask  
- `06_pipeline_summary.png` — Consolidated visual summary  

Each stage is saved independently for diagnostic inspection.

---

## Repository Structure

```bash
06_morphology_cell_segmentation/
├── main.m
├── input/
│   └── cell.tif
├── output/
│   ├── 01_original.png
│   ├── 02_sobel_edges.png
│   ├── 03_dilated_edges.png
│   ├── 04_filled.png
│   ├── 05_smoothed_mask.png
│   └── 06_pipeline_summary.png
├── notes.html   
└── README.md
```

---

## Notes (recommended)
For deeper explanations and interactive learning for this module, open:

- `notes.html` (interactive, browser-based)

---

## How to run
1.	Place your image here:
```bash
06_morphology_cell_segmentation/input/cell.tif
```
2.	From MATLAB, set your working directory to this folder and run:

```matlab
main
```
Outputs will be written to 06_morphology_cell_segmentation/output/.


---

## Parameters (explicit by design)

These are intentionally surfaced in code so results remain interpretable and tunable:
- Sobel threshold: 0.026
- Dilation SEs: strel("line", 3, 0) and strel("line", 3, 90)
- Erosion SE: strel("diamond", 2)

If you swap datasets or imaging conditions, these are the only values you typically adjust first.

---

## Reproducibility Characteristics
- Fully deterministic given identical inputs and parameters
- All intermediate states exported for debugging and analysis
- No hidden preprocessing or implicit normalization
- Designed as an interpretable segmentation baseline

---

## Requirements
- MATLAB
- Image Processing Toolbox (edge, strel, imdilate, imfill, imerode)
