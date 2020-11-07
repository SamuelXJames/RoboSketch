%% generate_path.m
%
% INPUT: 
%   file: The filepath to the image that the robot should traverse 
%   refine: A float used to control feature refinement. Suggested values are
%           between (1-10] but can be a large as necessary. Larger values 
%           mean less refinement or that more details will be present.   
%   visibility: Whether to display the image after each process. Should be
%               set to 'on' or 'off' or ommited which defaults to 'off'
% OUTPUT: 
%   img: A binary image of the path that the robot traverses 
%   figures - The code will display a figure with the original image/path 
%             and a figure of the image after each path (if visibiliy is
%             on)
%   
%
% 
% Look at Page 127 in book for the control dynamics


function img = generate_path(filepath,refine,visibility)
    close all
    img = imread(filepath);

    % If visibility is not defined assume off
    if exist('visibility','var') == 0
        visibility = 'off';
    end
    
    if exist('refine','var') == 0
        refine = 3;
    end

    % Pad Images in case the edges are too close to the border
    pad_size = [50,50]; 
    img = padarray(img,pad_size,255);
    orig_img = img;

    % Orginal image with padding
    figa = figure(1);
    subplot(3,3,1);
    imshow(img);
    title('Original Image')

    % Convert to Grayscale
    img = rgb2gray(img);
    subplot(3,3,2);
    imshow(img);
    title('Grayscale');

    % Gaussian Filter noise in image
    subplot(3,3,3);
    img = imgaussfilt(img);
    imshow(img);
    title('Filterd Image');

    % Otsu Thresh Images - descimintates background from foreground 
    thresh =  graythresh(img);
    timg = imbinarize(img,thresh);

    % Inner Contour Detection (Canny Method) 
    icimg = edge(timg,'Canny');
    subplot(3,3,4);
    imshow(icimg);
    title('Inner Contours');
    % 

    % Outer Contour Detection (Canny Method) 
    ocimg = edge(img,'Canny');
    subplot(3,3,5);
    imshow(ocimg);
    title('Outer Contours');

    % Combined Image
    img = ocimg + icimg;
    subplot(3,3,6);
    imshow(img);
    title('Combined Image');

    % Median Filter
    img = medfilt2(img,[2,2]);
    subplot(3,3,7);
    imshow(img);
    title('Median Filter');

    % Contour Thinning (Stentiford Algorithm is too slow)
    img = bwskel(imbinarize(img));
    figure(figa);
    subplot(3,3,8);
    imshow(img);
    title('Contour Thinning');

    % Remove noise and regions that are too small
    img = bwareaopen(img,floor(size(img,1)/refine));
    figb = figure;
    imshowpair(orig_img,img,'montage');
    title(sprintf('Original Image and Generated Path'));
    figure(figa);
    subplot(3,3,9);
    imshow(img);
    title('Remove Small Regions');
    sgtitle('Image to Path Steps');
    set(figa,'visible',visibility);
end