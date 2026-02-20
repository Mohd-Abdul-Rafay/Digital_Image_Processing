## 02 — Color Spaces & Contrast Enhancement

This module implements controlled experiments in color space transformations and intensity redistribution.
It demonstrates how contrast manipulation and channel-wise decomposition affect image representation across perceptual and device-dependent domains.

The goal is reproducible visualization and quantitative intensity modeling.

---

## Objectives
1.	RGB → Grayscale projection
2.	Histogram Equalization (global contrast redistribution)
3.	Contrast Stretching via HSV Value channel
4.	Channel decomposition in:
    •	RGB
    •	HSV
    •	YIQ (NTSC)
5.	Color-based masking (red-channel isolation)

All outputs are automatically exported for reproducibility.

---

## Directory Structure
```bash
02_color_spaces_and_contrast/
├── main.m
├── input/
│   └── onion.png
├── output/
│   ├── 01_rgb_vs_grayscale.png
│   ├── 02_grayscale_vs_histeq.png
│   ├── 03_input_eq_stretch.png
│   ├── 04_rgb_channels.png
│   ├── 05_hsv_channels.png
│   ├── 06_yiq_channels.png
│   └── 07_red_only_mask.png
└── README.md
```

---

## Methodology

Histogram Equalization

Applied to grayscale projection using MATLAB’s histeq.
This redistributes pixel intensities to approximate a uniform histogram.

Contrast Stretching

Performed in HSV space by applying imadjust on the Value channel.
Hue and saturation are preserved while intensity dynamic range is expanded.

Color Masking

A simple threshold-based red-channel mask isolates red-dominant pixels while suppressing others.

---

## How to Run

From MATLAB, navigate to this folder and execute:
```bash
main
```
All results will be saved automatically inside the output/ directory.

---

## Notes
•	Designed for reproducibility and clean output exports.
•	Demonstrates contrast modeling in multiple color representations.
•	Suitable for foundational Digital Image Processing coursework and experimentation.
