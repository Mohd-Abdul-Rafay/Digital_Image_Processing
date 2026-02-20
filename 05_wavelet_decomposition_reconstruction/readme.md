# 05 — Wavelet Decomposition, Detail Suppression, and Reconstruction (Haar DWT)

This module implements a reproducible multi-level 2D Haar wavelet pipeline for grayscale image decomposition, structural analysis, and controlled reconstruction.

The objective is to demonstrate how multi-resolution wavelet representations separate global structure from directional high-frequency content, and how manipulating detail subbands impacts reconstruction fidelity.

---

## Overview

The pipeline performs:

- 3-level 2D Haar Discrete Wavelet Transform (DWT)
- Hierarchical coefficient mosaic visualization
- Detail-only inverse reconstruction for edge-energy modeling
- Controlled attenuation of high-frequency subbands
- Full inverse reconstruction via multi-level IDWT
- Deterministic export of all results

All generated artifacts are automatically saved to the `output/` directory.

---

## Methodology

### 1) Multi-Level Haar Decomposition

A 3-level 2D Haar DWT is applied recursively.

At each level:

- `cA` — Approximation (low-frequency structure)
- `cH` — Horizontal detail
- `cV` — Vertical detail
- `cD` — Diagonal detail

The approximation subband (`cA`) is recursively decomposed across levels to construct a multi-resolution representation.

Haar is selected due to its orthogonality, compact support, and interpretability in foundational wavelet analysis.

---

### 2) Coefficient Mosaic Visualization

Wavelet coefficients are normalized for visualization using:

```matlab
wcodemat(...)
```
A hierarchical mosaic is constructed:
- Level 3 embedded inside Level 2
- Level 2 embedded inside Level 1

This produces a single structured coefficient map that exposes directional and scale-dependent information.

---

### 3) Detail-Only Edge Map Construction

To isolate high-frequency structural energy:
- Approximation subbands are zeroed
- Only detail subbands (H, V, D) are reconstructed using idwt2
- Detail reconstructions are accumulated across all levels
- A fixed threshold produces a binary edge map

This highlights multi-scale edge contributions encoded in the wavelet domain.

---

### 4) Detail Suppression and Reconstruction

To evaluate reconstruction sensitivity:
- All detail subbands (cH, cV, cD) are scaled by 0.5
- The image is reconstructed via inverse DWT
- Reconstruction differences reflect attenuation of high-frequency information

This models structured frequency-domain smoothing and illustrates how detail energy governs perceived sharpness.

---

## Directory Structure
```bash
05_wavelet_decomposition_reconstruction/
├── main.m
├── input/
│   └── peppers.png
├── output/
│   ├── 01_grayscale.png
│   ├── 02_dwt_coefficients_mosaic.png
│   ├── 03_edge_map_detail_energy.png
│   ├── 04_edge_map_thresholded.png
│   ├── 05_reconstructed_detail_suppressed.png
│   └── 06_original_vs_reconstructed.png
├── note.html
└── README.md
```

---

## Notes (recommended)
For deeper explanations and interactive learning for this module, open:

- `notes.html` (interactive, browser-based)

---

## Execution

From MATLAB:
```matlab
main
```
All outputs are written automatically to output/.

---

## Design Principles
- Deterministic, export-first workflow
- Explicit separation of approximation and detail components
- Multi-resolution structural modeling
- Controlled high-frequency attenuation experiment
- Size-consistent reconstruction comparison

---

## Requirements
- MATLAB
- Wavelet Toolbox (dwt2, idwt2, wcodemat)

---

## Core Insight

Wavelet decomposition separates an image into scale-aware structural components:
- Low-frequency approximation encodes global structure.
- High-frequency subbands encode localized directional detail.

Suppressing detail energy directly reduces edge sharpness, demonstrating how multi-resolution representations enable targeted frequency-domain manipulation.
