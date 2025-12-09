% Part 1 - Convert Image to Grayscale
f = im2double(imread('ISIC_0011366.jpg'));  
grayscale = rgb2gray(f);
figure; imshow(grayscale,[]); title('1. Original Grayscale Image');

% Part 2a - Gaussian Low Pass Smoothing
smooth = imgaussfilt(grayscale, 2);     
figure; imshow(smooth,[]); title('2. Smoothed Image');

% Part 2b - Adaptive Histogram Equalization
equalization = adapthisteq(smooth);             
figure; imshow(equalization,[]); title('3. Adaptive Histogram Equalization');
figure; imhist(equalization); title('Histogram of Enhanced Image');

% Part 3 - Global Thresholding - Otsu's Method
T = graythresh(equalization);               
darker_region = ~imbinarize(equalization, T);        
figure; imshow(darker_region); title('4. Dark Region');

% Part 4 - Mathematical Morphology 
bw = bwareaopen(darker_region, 50);       
bw = imopen(bw,  strel('disk', 3));
bw = imclose(bw, strel('disk', 5));
bw = imfill(bw, 'holes');
figure; imshow(bw); title('5. Image After Morphology');

% Part 5 - Main Lesion
[L, num] = bwlabel(bw);          
mainL = regionprops(L, 'Area');
[~, idxMax] = max([mainL.Area]);
final_lesion = (L == idxMax);
figure; imshow(final_lesion); title('6. Final Lesion');

figure; imshow(f,[]); hold on;
visboundaries(final_lesion);
title('7. Detected Lesion Boundary');
hold off;