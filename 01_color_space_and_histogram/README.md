# 01 — Color Space Modeling & Intensity Distribution Transformation

This module explores how image representation changes across color spaces and how pixel intensity distributions can be systematically manipulated.

The implementation examines:

- RGB channel isolation and structural intensity variation
- RGB → HSV transformation and perceptual channel separation
- Spatial interpolation effects via 2× scaling and controlled center cropping
- Grayscale projection and empirical histogram estimation
- Histogram matching as distribution alignment using cumulative intensity remapping

Rather than treating these as isolated operations, this module frames them as representation primitives that underlie classical computer vision pipelines.

---

## Execution
```bash
01_color_space_and_histogram/
├── main.m
├── input/
│   └── image.png
└── output/
```

---


## Run:

```matlab
main
```
All generated visualizations are exported automatically to output/.

---

Focus: Foundational representation mechanics and intensity distribution modeling in classical vision systems.
