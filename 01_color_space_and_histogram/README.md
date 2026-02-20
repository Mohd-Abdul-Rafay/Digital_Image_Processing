# 01 — Color Space Modeling & Intensity Distribution Transformation

This module investigates how image representations evolve across color domains and how pixel intensity distributions can be systematically reshaped.

The implementation treats common image operations not as isolated procedures, but as foundational representation primitives used throughout classical vision systems.

---

## Scope

This experiment includes:
- RGB channel isolation and structural intensity analysis
- RGB → HSV transformation for perceptual decomposition
- 2× spatial scaling with controlled center cropping (interpolation behavior)
- Grayscale luminance projection and empirical histogram estimation
- Histogram matching via cumulative distribution remapping

Each transformation is exported programmatically to ensure reproducibility.

---

## Execution
```bash
01_color_space_and_histogram/
├── main.m
├── input/
│   └── image.png
├── output/
│   ├── 01_original.png
│   ├── 02_rgb_channels.png
│   ├── 03_hsv_channels.png
│   ├── 04_enlarged_2x.png
│   ├── 05_center_cropped.png
│   ├── 06_resize_crop_comparison.png
│   ├── 07_grayscale.png
│   ├── 08_grayscale_view.png
│   ├── 09_grayscale_histogram.png
│   ├── 10_histogram_matched.png
│   └── 11_histogram_matching_comparison.png
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
- Explicit representation modeling
- Controlled intensity redistribution
- Spatial interpolation analysis
- Deterministic output generation
