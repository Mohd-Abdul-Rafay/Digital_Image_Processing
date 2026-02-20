## 02 — Color Spaces & Contrast Enhancement

Controlled experiments in color space transformations and intensity redistribution.

This module evaluates how contrast manipulation and channel-wise decomposition influence image representation across RGB, HSV, and YIQ domains. The implementation emphasizes reproducibility, structured output export, and clear isolation of transformation effects.

---

## Scope

This experiment includes:
1.	RGB → Grayscale projection
2.	Global Histogram Equalization (histeq)
3.	Contrast Stretching in HSV Value channel (imadjust)
4.	Channel decomposition
	•	RGB
	•	HSV
	•	YIQ (NTSC transform)
5.	Red-channel dominant masking (threshold-based segmentation)

All outputs are programmatically generated and saved to ensure deterministic reproducibility.

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

### Histogram Equalization:

Grayscale projection is equalized using histeq, approximating a uniform intensity distribution to enhance global contrast.

### HSV-Based Contrast Stretching:

Intensity expansion is performed exclusively on the HSV Value channel using imadjust, preserving chromatic components (Hue, Saturation) while increasing dynamic range.

### Channel Decomposition:

Independent visualization of RGB, HSV, and YIQ channels isolates representation differences between device-dependent and perceptual color spaces.

### Color Masking:

A deterministic threshold-based red dominance mask suppresses non-red pixels, demonstrating simple channel-based segmentation.

---

## Execution

From MATLAB:
```bash
main
```
All outputs are exported automatically to the output/ directory.

---

## Design Principles
•	Deterministic outputs
•	Clean separation of transformations
•	Explicit domain modeling (RGB vs HSV vs YIQ)
•	Reproducible export pipeline
