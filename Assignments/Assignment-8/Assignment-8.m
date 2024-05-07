% Reading the input images
bricks = imread("bricks.jpg");
bricks_rotated = imread("bricksRotated.jpg");
carpet = imread("carpet.jpg");
rice = imread("rice.png");


% Crop the input images and store it in img1
img1(:,:,1) = imcrop(bricks,[0,0,128,128]);
img1(:,:,2) = imcrop(bricks_rotated,[0,0,128,128]);
img1(:,:,3) = imcrop(carpet,[0,0,128,128]);
img1(:,:,4) = imcrop(rice,[0,0,128,128]);

% Rotate the input images
rotated_bricks = imrotate(bricks, -45, "bilinear","crop");
rotated_bricks_rotated = imrotate(bricks_rotated, -45, "bilinear","crop");
rotated_carpet = imrotate(carpet, -45, "bilinear","crop");
rotated_rice = imrotate(rice, -45, "bilinear","crop");

% Crop the rotated input images and store it in img1
img1(:,:,5) = imcrop(rotated_bricks,[0,0,128,128]);
img1(:,:,6) = imcrop(rotated_bricks_rotated,[0,0,128,128]);
img1(:,:,7) = imcrop(rotated_carpet,[0,0,128,128]);
img1(:,:,8) = imcrop(rotated_rice,[0,0,128,128]);


% Initialize similarity scores list
sim_scores = [];
% Evaluate the similarity scores using the function sim=LBP2(imgA,imgB)
% This loop computes the similarity scores between the cropped_bricks before rotation
% and the rest of the images 
for i = 2:size(img1, 3)
    score = LBP2(img1(:,:,1),img1(:,:,i));
    sim_scores = [sim_scores, score];
end


% Find the most similar images to the cropped image of 'bricks.jpg' before rotation
disp("The similarity scores are: ")
disp(sim_scores);
[similar, idx] = min(sim_scores);
disp(['The highest similarity score is ', num2str(similar), ' at index ', num2str(idx)]);



function sim = LBP2(imgA, imgB)
    % Extract the Local Binary Patterns of the input images
    pattern1 = extractLBPFeatures(uint8(imgA), 'Interpolation', 'Linear');
    pattern2 = extractLBPFeatures(uint8(imgB), 'Interpolation', 'Linear');
    
    % Checks the similarity score of the input images by computing Euclidean distance of their respective LBP patterns
    % Here norm represents the Euclidean Distance
    sim = norm(pattern1 - pattern2);

end




