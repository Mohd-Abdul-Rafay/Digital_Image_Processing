% Reading an image 'onion.png' and converting it to a grayscale image and displaying it into one figure
img = imread("onion.png");
grayscaleImage = rgb2gray(img);
montage({img,grayscaleImage},"BorderSize",30,"BackgroundColor","w","Size",[1,2])

% Equalize the histogram of the grayscale image using histeq
figure;
equalisedImage = histeq(grayscaleImage);

% Function call for histogram Stretching
stretchedImage = histogramStretching(img);

% Display the input image, the equalized image, and the histogram stretched image in one figure
figure;
montage({img,equalisedImage,stretchedImage},"BorderSize",30,"BackgroundColor","w","Size",[1,3])

% Display all channels of the color image ‘onion.png’ separately but in one figure
figure;
[RC,GC,BC] = imsplit(img);
montage({RC,GC,BC},"BorderSize",30,"BackgroundColor","w","Size",[1,3])

% Convert the color image  onion.png into HSV color space and display all channels separately in one figure
figure;
hsvImg = rgb2hsv(img);
[HC,SC,VC] = imsplit(hsvImg);
montage({HC,SC,VC},"BorderSize",30,"BackgroundColor","w","Size",[1,3])

% Convert the color image  onion.png  into YIQ color space and display all channels separately in one figure
figure;
yiqImg = rgb2ntsc(img);
[YC,IC,QC] = imsplit(yiqImg);
montage({YC,IC,QC},"BorderSize",30,"BackgroundColor","w","Size",[1,3])

% Write a function to change all the pixels that have a color other than red from the
% color image onion.png  to black and display the output image
redOnlyImage = keepRedPixels(img);

% Display the output for only red color image
figure;
imshow(redOnlyImage);
title('Image other than red pixels set to black');

% Function for histogram stretching
function stretchinghist = histogramStretching(inputColorImage)
    
    hsvInput = rgb2hsv(inputColorImage);
    [h,s,v] = imsplit(hsvInput);
    stretchedIntensity = imadjust(v);


    % Combine the stretched channel back into an RGB image
    stretchedhsv = cat(3, h, s, stretchedIntensity);
    stretchinghist = hsv2rgb(stretchedhsv);
    
end
function redPixelImage = keepRedPixels(inputImage)
    % Function to keep only the red pixels in a color image
    
    [R,G,B] = imsplit(inputImage);
    thresholdValue = 110;
   
    % Creating a mask for identifying the red color
    mask = R>=thresholdValue & G<thresholdValue & B<thresholdValue;
    
    % Converting other than red pixels to black
    R(~mask) = 0;
    G(~mask) = 0;
    B(~mask) = 0;

    % Combining all three channels of the resultant image
    redPixelImage = cat(3,R,G,B);

end

