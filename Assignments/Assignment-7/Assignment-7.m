img1 = imread("peppers.png");
figure;
imshow(img1)
title("Original input image")

img2 = imrotate(img1,-45,"crop");
figure;
imshow(img2)
title("Rotated image")

desired_width = 50;
desired_height = 50;
center_x = size(img2,2) / 2;
center_y = size(img2,1) / 2;
x = center_x - desired_width / 2;
y = center_y - desired_height / 2;
image = imcrop(img2, [x, y, desired_width-1, desired_height-1]);
% Create a black image of the same size as img2
img3 = zeros(size(img2), 'like', img2);

% Paste the cropped region of img3 onto the black image
img3(y:y+desired_height-1, x:x+desired_width-1, :) = image;

% Display the final output (color image)
figure;
imshow(img3);
title("Cropped image")



image_registration = reg(img1,img3);
disp(image_registration)


figure;
imshowpair(img1,img3,"blend")
title("Blended image")


function position = reg(img1, img3)
    % Initialize variables
    position = struct('max_corr', 0, 'max_rotation', 0, 'max_translation', [0, 0]);
    correlated_matrix = [];
    max_translation_x_values = [];
    max_translation_y_values = [];
    max_rotation = [];
    
    % Convert img1 and img3 to grayscale if they are RGB images
    if size(img1, 3) == 3
        img1_gray = rgb2gray(img1);
    else
        img1_gray = img1;
    end
    
    if size(img3, 3) == 3
        img3_gray = rgb2gray(img3);
    else
        img3_gray = img3;
    end
    
    % Define translation and rotation parameters
    translation_step = 1;  % Set the translation step size
    rotation_step = 1;      % Set the rotation step size

    % Nested loops to explore all combinations of translation and rotation
    for translation_x = -10:translation_step:10
        for translation_y = -10:translation_step:10
            image1 = imtranslate(img1_gray, [translation_x, translation_y], 'FillValues', 0, 'OutputView', 'same');
            for rotation = 0:rotation_step:360
                image2 = imrotate(image1, rotation, 'bilinear', 'crop');
            
                % Compute correlation between image2 and img3_gray using corr2
                corre = corr2(image2, img3_gray);
                correlated_matrix = [correlated_matrix, corre];
                max_rotation = [max_rotation,rotation];
                max_translation_x_values = [max_translation_x_values, translation_x];
                max_translation_y_values = [max_translation_y_values, translation_y];
            end
        end
    end

    % Find the maximum correlation value and its position
    [max_corr, max_idx] = max(correlated_matrix);
    [max_translation_x] = max_translation_x_values(max_idx);
    [max_translation_y] = max_translation_y_values(max_idx);
    [max_rotation] = max_rotation(max_idx);


    
    % Store the results in the output structure
    position.max_corr = max_corr;
    position.max_rotation = max_rotation;
    position.max_translation = [max_translation_x, max_translation_y];
end


