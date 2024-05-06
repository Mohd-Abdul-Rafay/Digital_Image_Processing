% Importing the original image
img1 = imread("cell.tif");
figure;
imshow(img1)
title("Original Grayscale Image")


% Extracting the edges using sobel operator by tuning the threshold
threshold = 0.026;
sobel_edges = edge(img1,"sobel",threshold);
figure;
imshow(sobel_edges);
title("Sobel Edges");



% Dilating the edges image using two different structuring elements
SE1 = strel("line",3,0);
SE2 = strel("line",3,90);
D1 = imdilate(sobel_edges,SE1);
D2 = imdilate(D1,SE2);
figure;
imshow(D2);
title("Dilated image with two different structuring elements")



% Filling the holes using the imfill function
fill = imfill(D2,"holes");
figure;
imshow(fill);
title("Holes filled using the imfill function")



% Smothening the holes filled image using the erosion operator
SE3 = strel("diamond",2);
smooth_image = imerode(fill,SE3);
figure;
imshow(smooth_image);
title("Smoothened Image using the erosion operator")
