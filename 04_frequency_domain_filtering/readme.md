## 04 — Frequency-Domain Filtering and Spatial Equivalence

This module analyzes Gaussian low-pass filtering in both the frequency domain and the spatial domain, and evaluates their structural equivalence.

It demonstrates how Fourier-domain attenuation corresponds to spatial Gaussian smoothing, and quantifies reconstruction discrepancies introduced by implementation differences and boundary conditions.

---

## Scope

The pipeline performs:
	•	2D FFT with magnitude and phase visualization
	•	Gaussian Low-Pass Filter (LPF) constructed in frequency space
	•	Reconstruction via inverse FFT
	•	Spatial Gaussian filtering using imgaussfilt
	•	Absolute difference analysis between domain implementations

All outputs are exported deterministically to output/.

---

## Technical Overview

### 1) Fourier Decomposition

The grayscale image is transformed using:
  ```bash
  F = fftshift(fft2(image))
  ```
Magnitude and phase are visualized independently to separate:
- Magnitude (energy distribution across frequencies)
- Phase (structure / alignment information)

Magnitude is log-scaled for visibility.

### 2) Frequency-Domain Gaussian Low-Pass Filtering

A Gaussian LPF centered at the DC component is defined as:

[
H(u,v) = e^{-\frac{u^2 + v^2}{2\sigma^2}}
]

This preserves low-frequency structure while attenuating high-frequency detail.
Reconstruction is performed using:
```bash
img_freq = ifft2(ifftshift(F .* H));
```

### 3) Spatial-Domain Gaussian Filtering

A Gaussian filter is applied directly in the spatial domain:
```bash
img_spatial = imgaussfilt(image, sigma);
```
This serves as the spatial equivalent of the frequency-domain Gaussian LPF.

### 4) Structural Difference Analysis

The absolute pixel-wise difference between:
- frequency-domain reconstruction, and
- spatial-domain smoothing

is computed to quantify equivalence and implementation differences:
```bash
abs_diff = abs(double(img_spatial) - double(img_freq));
```

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
- Explicit magnitude/phase inspection (diagnostic clarity)
- Gaussian LPF modeled directly in frequency space (controlled attenuation)
- Spatial-domain equivalent using imgaussfilt (baseline comparison)
- Quantitative reconstruction difference map (equivalence validation)
- Deterministic output exports for clean versioning

---

## Conceptual Insight

Gaussian smoothing in the spatial domain corresponds to Gaussian attenuation in the frequency domain.
Any residual difference primarily reflects boundary handling, numeric precision, and implementation details across domains.
