% Load the image ‘peppers.png’
img = imread("peppers.png");

% Convert it into a grayscale image, denoted with img1
img1 = rgb2gray(img);

% Decompose img1 using WaveLetDec function using 3 levels
decomposed_coefficients = WaveLetDec(img1,3);

% Display the wavelet coefficients for each level
A1img = wcodemat(decomposed_coefficients{1}{1},255,'mat',1);
H1img = wcodemat(decomposed_coefficients{1}{2},255,'mat',1);
V1img = wcodemat(decomposed_coefficients{1}{3},255,'mat',1);
D1img = wcodemat(decomposed_coefficients{1}{4},255,'mat',1);

A2img = wcodemat(decomposed_coefficients{2}{1},255,'mat',1);
H2img = wcodemat(decomposed_coefficients{2}{2},255,'mat',1);
V2img = wcodemat(decomposed_coefficients{2}{3},255,'mat',1);
D2img = wcodemat(decomposed_coefficients{2}{4},255,'mat',1);
 
A3img = wcodemat(decomposed_coefficients{3}{1},255,'mat',1);
H3img = wcodemat(decomposed_coefficients{3}{2},255,'mat',1);
V3img = wcodemat(decomposed_coefficients{3}{3},255,'mat',1);
D3img = wcodemat(decomposed_coefficients{3}{4},255,'mat',1);

level3 = [A3img,H3img;V3img,D3img];
level2 = [imresize(level3,size(A2img)),H2img;V2img,D2img];
decomposed_image = [imresize(level2,size(A1img)),H1img;V1img,D1img];
imshow(decomposed_image,[])
title("Image decomposition coefficients")

% Initialize the edge map with zeros for approximation coefficients
edge_map = zeros(size(decomposed_coefficients{1}{1}));
% Iterate over each level of decomposition
for i = 1:numel(decomposed_coefficients)
    % Resize detail subbands to match the size of the approximation subband
    [rows_A, cols_A] = size(decomposed_coefficients{1}{1});
    resized_horizontal = imresize(decomposed_coefficients{i}{2}, [rows_A, cols_A]);
    resized_vertical = imresize(decomposed_coefficients{i}{3}, [rows_A, cols_A]);
    resized_diagonal = imresize(decomposed_coefficients{i}{4}, [rows_A, cols_A]);

    % Compute the inverse discrete wavelet transform (IDWT) using only the detail subbands
    reconstructed_image = idwt2(zeros(size(edge_map)), resized_horizontal, resized_vertical, resized_diagonal, 'haar');

    % Add the reconstructed detail subbands to the edge map
    edge_map = edge_map + imresize(reconstructed_image,size(edge_map));
end
threshold = 7;
edge_map = edge_map > threshold;

% Reduce the coefficient magnitude of the detail subbands by half and reconstruct the image. 
for i = 1:numel(decomposed_coefficients)
    for j = 2:4 %Skips the approximation subband
        % We can achieve this by scaling the frequency component by 0.5
        decomposed_coefficients{i}{j} = decomposed_coefficients{i}{j} * 0.5;
    end
end
Reconstructed_image = iWaveLetRec(decomposed_coefficients);
Reconstructed_image = uint8(Reconstructed_image);

% Display the input image with the reconstructed image side by side.
figure;
montage({img1,Reconstructed_image},"BackgroundColor","w","BorderSize",20,"Size",[1,2])
title("Original Image and the Reconstructed Image")


function waveCoeff = WaveLetDec(img, level)

    % Initialize a cell array to store wavelet coefficients
    waveCoeff = cell(level, 1);

    % Apply the DWT on the image for the first level
    [cA, cH, cV, cD] = dwt2(img, 'haar');
    waveCoeff{1} = {cA, cH, cV, cD}; % Store coefficients for first level

    % Iterate over remaining levels
    for i = 2:level
        % Apply DWT to the previous level approximation
        [cA, cH, cV, cD] = dwt2(waveCoeff{i-1}{1}, 'haar'); 
        % Store the coefficients of the current level
        waveCoeff{i} = {cA, cH, cV, cD};
    end
end



function imgR = iWaveLetRec(img)
    % Initialize the reconstructed image with the approximation subband of the highest level
    imgR = img{1}{1};

    % Iterate over the wavelet coefficient levels
    for i = 2:numel(img)
        % Resize details subband to match the dimensions of the current approximation subband
        [rows_A, cols_A] = size(imgR);
        resized_horizontal = imresize(img{i}{2}, [rows_A, cols_A]);
        resized_vertical = imresize(img{i}{3}, [rows_A, cols_A]);
        resized_diagonal = imresize(img{i}{4}, [rows_A, cols_A]);

        % Update the reconstructed image with the approximation subband
        imgR = idwt2(imgR*1.3, resized_horizontal, resized_vertical, resized_diagonal, 'haar');
    end
end

