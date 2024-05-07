% Loading an image
img = imread("onion.png");
img1 = rgb2gray(img);

% Apply Fourier transform to img1 and the Fourier coefficient matrix is denoted with
%freq1
freq1 = fft2(img1);
freq1 = fftshift(freq1);

% Display both the magnitude and phase components of freq1
magnitude1 = abs(freq1);
phase1 = angle(freq1);
figure;
subplot(1, 2, 1);
imagesc(log(1 + magnitude1));
colormap gray;
title('Magnitude Component')
subplot(1, 2, 2);
imagesc(phase1);
colormap gray;
title('Phase Component')

% Remove the low-frequency components from freq1 and save the result into freq2
cutoff_threshold = 10;
gaussian_filter = fspecial("gaussian",size(img1),20);
gaussian_filter(gaussian_filter < cutoff_threshold) = 0;
high_pass_filter = 1 - gaussian_filter;
freq2 = freq1 .* high_pass_filter;
% Reconstruct an image (imgR) from freq2s
imgR = ifft2(ifftshift(freq2));

% Display the reconstructed image imgR
figure;
imagesc(abs(imgR)); 
colormap gray;
title("Reconstructed image (imgR) from freq2")

% Construct and apply a low-pass spatial filter to img1 to generate an image imgR2 that
% is similar to imgR
low_pass_filter = fspecial("gaussian",size(img1),2);
imgR2 = imfilter(img1,low_pass_filter,"replicate");
figure;
imshow(imgR2); 
title("Reconstructed low-pass spatial filtered image (imgR2)")

% Compute the pixel-to-pixel absolute difference between the spatial filtering result and
% imgR and display the difference image 
abs_difference = abs(double(imgR2)-double(imgR));
figure;
imshow(uint8(abs_difference))
title("Absolute difference between spatial filtering result and imgR")
