% Importing the image and converting the RGB image into the grayscale image
colorImage = imread("onion.png"); 
img1 = rgb2gray(colorImage);

% Filter for convolution
filter = [-1,1,1;-1,-1,1;-1,1,1];

% Convoluted image
ConvImage = myConv(colorImage,filter,'same');
figure;
montage({colorImage,ConvImage},"BackgroundColor",'w','BorderSize',30,Size=[1,2])
title("Original color image and Convoluted image")

% Copying grayscale image in img2 and applying salt and pepper noise
img2 = imnoise(img1,"salt & pepper");
figure;
montage({img1,img2},"BackgroundColor",'w','BorderSize',30,Size=[1,2])
title("Original grayscale image and the noisy salt and pepper image")

%Remove salt and pepper noise using function medfilt2 and display the clean (img1)
%and denoised image side by side 
denoised_img2 = medfilt2(img2);
figure;
subplot(1,2,1);
imshow(img1)
title("Clean image (img1)")
subplot(1,2,2);
imshow(denoised_img2)
title("Denoised image")

% Create a copy of the clean grayscale image, denoted with ‘img3’, in the memory and
% add Gaussian noise using imnoise. Remove Gaussian noise using imgaussfilt and save
% the result in ‘img4’
img3 = imnoise(img1,"gaussian",0,0.01);
img4 = imgaussfilt(img3,2);
figure;
montage({img3,img4},'BackgroundColor','w','BorderSize',30,Size=[1,2])
title("Gaussian noised image and denoised image by gaussian filter")

% Apply ‘myConv’ using an average filter to remove noise from ‘img3’ and save the
% result image in ‘img5’. Display img4 and img5 side by side
average_filter = fspecial("average",[3,3]);
img5 = myConv(img3,average_filter,'same');
figure;
montage({img4,img5},"BackgroundColor","w","BorderSize",30,Size=[1,2])
title("Noised removed using the imgaussfilt and myConv (average filter)")

% Extract edges from img2 and img5 and display the results side by side.
denoised_img2_edges = edge(denoised_img2,"canny");
img5_edges = edge(img5,"canny");
figure;
montage({img2_edges,img5_edges},"BackgroundColor","w","BorderSize",30,Size=[1,2])
title("Extracted edges from img2 and img5")

% Function for convolution
%%
function result = myConv(inputImage,kernel,padding)
    if size(inputImage,3) == 3
        inputImage = rgb2hsv(inputImage);
        [h,s,v] = imsplit(inputImage);
        temp = conv2(v, kernel, padding);
        concate = cat(3,h,s,temp);
        result = hsv2rgb(concate);
    else
        result = conv2(inputImage, kernel, padding);
        result = uint8(result);
    end
end
