## 04 — Frequency-Domain Filtering and Spatial Equivalence Analysis

This module investigates low-pass filtering in both the frequency domain (via Fourier transform) and the spatial domain (via Gaussian convolution), and evaluates their structural equivalence.

The objective is to demonstrate how frequency-domain Gaussian filtering corresponds to spatial-domain Gaussian smoothing, and to quantify reconstruction differences.

---

## Scope

The pipeline includes:
- 2D Fast Fourier Transform (FFT) with magnitude and phase visualization
- Gaussian Low-Pass Filter (LPF) constructed directly in frequency space
- Image reconstruction via inverse FFT
- Spatial Gaussian smoothing using imgaussfilt
- Absolute difference analysis between frequency and spatial results

All outputs are exported deterministically to the output/ directory.

---

## Technical Overview

1) Fourier Decomposition

  The grayscale image is transformed using:
  ```bash
  F = fftshift(fft2(image))
  ```
  Magnitude and phase components are visualized independently to isolate structural and phase information.

  Magnitude is log-scaled for numerical stability and visibility.

2) Frequency-Domain Gaussian Low-Pass Filtering

  A Gaussian filter centered at the DC component is constructed:

  H(u,v) = e^{-\frac{u^2 + v^2}{2\sigma^2}}

  This preserves low-frequency components (global structure) while attenuating high-frequency components (edges, noise).

  The filtered spectrum is reconstructed using:
  ```bash
  ifft2(ifftshift(F .* H))
  ```

3) Spatial-Domain Gaussian Filtering

  A Gaussian filter is applied directly in the spatial domain using:
  ```bash
  imgaussfilt(image, sigma)
  ```
  This serves as the spatial-domain equivalent of the frequency-domain Gaussian LPF.

4) Structural Difference Analysis

  The absolute pixel-wise difference between:
  - Frequency-domain reconstruction
  - Spatial-domain smoothing

is computed to evaluate equivalence and numerical deviations.

---

## Directory Structure
```bash
04_frequency_domain_filtering/
├── main.m
├── input/
│   └── onion.png
├── output/
│   ├── 01_fft_magnitude_phase.png
│   ├── 02_reconstruction_freq_lpf.png
│   ├── 03_reconstruction_spatial_lpf.png
│   ├── 04_abs_difference.png
│   ├── freq_lpf.png
│   ├── spatial_lpf.png
│   └── abs_diff.png
└── README.md
```

---

Execution

From MATLAB:
```bash
main
```
All visualizations and reconstructed outputs are saved automatically to output/.

---

## Design Emphasis
- Explicit separation of magnitude and phase components
- Controlled Gaussian LPF modeling in frequency space
- Direct comparison with spatial-domain Gaussian smoothing
- Quantitative reconstruction difference evaluation
- Deterministic export pipeline

---

## Conceptual Insight

This module reinforces a fundamental signal processing principle:

- Gaussian filtering in the spatial domain corresponds to Gaussian attenuation in the frequency domain.

The absolute difference analysis highlights numerical and boundary-condition discrepancies between implementations.
