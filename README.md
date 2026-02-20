# Digital Image Processing — Classical Vision Systems (MATLAB)

This repository implements a structured collection of classical computer vision pipelines using MATLAB.  
The focus is on deterministic image transformations, multi-resolution analysis, morphology, registration, texture modeling, and feature-based similarity — implemented with explicit parameter control and reproducible export-first design.

This is not a collection of isolated scripts.  
It is a modular, systemized exploration of foundational image processing mechanics.

---

## Repository Philosophy

- Deterministic pipelines (no hidden randomness)
- Export-first execution (all artifacts saved)
- Explicit parameterization
- Clear separation of processing stages
- Transparent baselines before optimization
- No black-box abstractions

Each module isolates a specific representation principle in classical vision systems.

---

## Modules

### 01 — Color Space Modeling & Histogram Transformations
RGB / HSV decomposition, grayscale projection, histogram equalization, and distribution remapping.

### 02 — Color Spaces & Contrast Enhancement
Channel-wise modeling across RGB, HSV, YIQ with contrast stretching and masking.

### 03 — Convolution, Noise Modeling & Edge Extraction
Custom convolution, salt-and-pepper noise, Gaussian smoothing, Canny edges.

### 04 — Frequency-Domain Filtering
Fourier decomposition, Gaussian low-pass filtering, spatial-frequency equivalence analysis.

### 05 — Wavelet Decomposition & Reconstruction (Haar DWT)
Multi-level wavelet analysis, detail suppression, reconstruction sensitivity.

### 06 — Morphology-Based Cell Segmentation
Sobel edge detection, dilation, hole filling, erosion-based smoothing.

### 07 — Brute-Force Image Registration
Rotation + translation grid search using correlation maximization.

### 08 — Texture Similarity via Local Binary Patterns (LBP)
Texture modeling and similarity ranking using handcrafted descriptors.

---

## Design Characteristics

- Classical CV focus (no deep learning)
- Multi-representation analysis (spatial, frequency, wavelet)
- Morphological reasoning
- Feature-based similarity
- Explicit complexity trade-offs (e.g., brute-force search)

---

## Intended Audience

- Students strengthening foundational CV understanding
- Engineers reviewing classical baselines
- Researchers needing interpretable preprocessing systems
- Anyone bridging classical vision to modern ML

---

## Requirements

- MATLAB
- Image Processing Toolbox
- Computer Vision Toolbox (for LBP module)
- Wavelet Toolbox (for DWT module)

---

## Why This Repository Exists

Modern computer vision is dominated by deep learning.  
However, understanding classical image representation, frequency decomposition, morphology, and feature descriptors remains essential for:

- Debugging learned systems
- Designing preprocessing pipelines
- Interpreting model behavior
- Building hybrid classical-ML systems

This repository serves as a structured reference for those foundational principles.

---

## Notes

- Each module contains its own README.
- All scripts assume execution from their respective folder.
- Outputs are written to local `output/` directories.

---

## License

For educational and research use.
