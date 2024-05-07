%Reading and displaying an image from the database
img = imread("image.png");
imshow(img)
title("Original Image")

%Splitting the image into its color channels and displaying each channel of the original image in a separate figure (window)
[RC,GC,BC] = imsplit(img);
montage({RC,GC,BC},"BackgroundColor","w","BorderSize",30,Size=[1,3])
title("Seperate RGB Channels in one figure")

%Convert the color image into HSV image and Splitting the image into its color channels
hsvImg = rgb2hsv(img);
imshow(hsvImg)
title("HSV Image")
[HC,SC,VC] = imsplit(hsvImg);

%Displaying each channel of converted hsv image in a separate figure

montage({HC,SC,VC},"BorderSize",30,"BackgroundColor","w",Size=[1,3])
title("Seperate HSV Channels in one figure")

%Enlarging the image two times using the function imresize and croping the enlarged image to its original size using the function imcrop by giving the rectangular coordinates including width and height
enlargedImage = imresize(img,2);
targetSize = [size(img,1)-1,size(img,2)-1];
croppedImage = imcrop(enlargedImage,[75,75,targetSize]);
montage({enlargedImage,croppedImage},"BorderSize",30,"BackgroundColor","w",Size=[1,2])
title("Enlarged and Cropped images in one figure")

%Convert the color image into grayscale image
grayscaleimg = rgb2gray(img);
figure;
imshow(grayscaleimg)
title("Grayscale Image")

%Generating the histogram of the grayscale image
figure;
imhist(grayscaleimg)
title('Histogram of Grayscale Image')

%Using the Histogram Matching function defined below
matchedImage = histogramMatching(grayscaleimg, img);

%Saving the resulting image after the histogram matching into an image file

imwrite(matchedImage, 'matched_image.png');
montage({grayscaleimg,matchedImage},"BorderSize",30,"BackgroundColor","w",Size=[1,2])

%Function to achieve histogram matching


function matchingImage = histogramMatching(inputImage, referenceImage)
     % Check if the images are color or grayscale
      if size(referenceImage,3) == 3
          referenceImage = rgb2gray(referenceImage);
      end
      if size(inputImage,3) == 3
          inputImage = rgb2gray(inputImage);
      end
     % Histogram matching
      matchingImage = histeq(inputImage, imhist(referenceImage));
end
