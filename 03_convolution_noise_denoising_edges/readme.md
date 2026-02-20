# 03 — Convolution, Noise Modeling, Denoising, and Edge Extraction

This module evaluates spatial filtering behavior under controlled noise injection.
It compares convolution-based intensity transformations, statistical denoising strategies, and edge stability after restoration.

The objective is to analyze how different noise models and smoothing operators influence structural preservation and downstream edge detection.

---

## Scope

The pipeline includes:
- Custom spatial convolution applied to the HSV Value channel
- Salt & Pepper noise modeling with median restoration
- Gaussian noise modeling with:
- Gaussian smoothing (imgaussfilt)
- Average filtering via custom convolution (conv2)
- Canny edge extraction on denoised outputs

All visualizations are exported deterministically to the output/ directory.

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
- Double-precision convolution for numerical stability
- Controlled intensity clipping and normalization
- Explicit comparison of linear vs nonlinear denoising
- Edge sensitivity analysis under restoration
