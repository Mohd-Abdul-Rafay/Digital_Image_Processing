# 03 — Convolution, Noise Models, Denoising, and Edge Extraction

This module implements a reproducible Digital Image Processing pipeline that compares:
- **Custom convolution** (applied on the HSV **Value** channel for color images)
- **Noise injection** (salt & pepper, Gaussian)
- **Denoising** (median, Gaussian smoothing, average filter via custom convolution)
- **Edge extraction** (Canny) after denoising

All figures are exported automatically to `output/` for clean versioning and review.

---

## What This Produces

### A) Convolution on Color (HSV Value Channel)
A custom 3×3 kernel is applied to the **V channel** only, then reconstructed back to RGB.

### B) Salt & Pepper Noise + Median Denoising
Noise is added to the grayscale image, then removed using `medfilt2`.

### C) Gaussian Noise + Two Denoising Methods
Gaussian noise is removed using:
1) `imgaussfilt` (σ = 2)  
2) Average filtering via a custom convolution (`conv2`)

### D) Edge Extraction
Canny edges are computed on:
- Median-denoised salt & pepper result
- Average-filter denoised Gaussian result

---

## Directory Structure

```bash
03_convolution_noise_denoising_edges/
├── main.m
├── input/
│   └── onion.png
├── output/
│   ├── 01_original_vs_convolution.png
│   ├── 02_clean_vs_saltpepper.png
│   ├── 03_clean_vs_median_denoised.png
│   ├── 04_gaussian_noisy_vs_gauss_denoised.png
│   ├── 05_gauss_denoised_vs_avgconv_denoised.png
│   └── 06_edges_comparison.png
└── README.md
```

---


## Run:

```matlab
main
```
All generated visualizations are automatically saved to the output/ directory.

---

## Design Emphasis
- Computation uses double precision internally to avoid numeric artifacts.
- Output intensity ranges are clipped/rescaled to valid display ranges before export.
- The HSV-V approach isolates intensity filtering while preserving hue/saturation.
