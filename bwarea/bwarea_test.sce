cd(get_absolute_file_path("bwarea_test.sce"));
exec("bwarea.sci",-1);
ImgTest = imread("grayscale_img.jpg");

//--------------------------------------------------
// Test 1: Empty image
//--------------------------------------------------
BW = zeros(5,5);
disp("Test 1: Empty Image");

area = bwarea(BW);

figure();
imshow(BW);

disp("BW:");
disp(BW);
disp("Sum of pixels:");
disp(sum(BW(:)));  
disp("Area:");
disp(area);
mprintf("\n");


//--------------------------------------------------
// Test 2: Single pixel
//--------------------------------------------------
BW = zeros(5,5);
BW(3,3)=1;

disp("Test 2: Single Pixel Object");

area = bwarea(BW);

figure();
imshow(BW);

disp("BW:");
disp(BW);
disp("Sum of pixels:");
disp(sum(BW(:)));  
disp("Area:");
disp(area);
mprintf("\n");


//--------------------------------------------------
// Test 3: Full image
//--------------------------------------------------
BW = ones(5,5);

disp("Test 3: Full Image");

area = bwarea(BW);

figure();
imshow(BW);

disp("BW:");
disp(BW);
disp("Sum of pixels:");
disp(sum(BW(:)));  
disp("Area:");
disp(area);
mprintf("\n");


//--------------------------------------------------
// Test 4: Adjacent pixels
//--------------------------------------------------
BW=zeros(5,5);
BW(3,3)=1;
BW(3,4)=1;

disp("Test 4: Adjacent Pixels");

area=bwarea(BW);

figure();
imshow(BW);

disp("BW:");
disp(BW);
disp("Sum of pixels:");
disp(sum(BW(:)));  
disp("Area:");
disp(area);
mprintf("\n");


//--------------------------------------------------
// Test 5: Diagonal pixels
//--------------------------------------------------
BW=zeros(5,5);
BW(2,2)=1;
BW(3,3)=1;

disp("Test 5: Diagonal Pixels");

area=bwarea(BW);

figure();
imshow(BW);

disp("BW:");
disp(BW);
disp("Sum of pixels:");
disp(sum(BW(:)));  
disp("Area:");
disp(area);
mprintf("\n");


//--------------------------------------------------
// Test 6: Horizontal line
//--------------------------------------------------
BW=zeros(7,7);
BW(4,2:6)=1;

disp("Test 6: Horizontal Line");

area=bwarea(BW);

figure();
imshow(BW);

disp("BW:");
disp(BW);
disp("Sum of pixels:");
disp(sum(BW(:)));  
disp("Area:");
disp(area);
mprintf("\n");


//--------------------------------------------------
// Test 7: Vertical line
//--------------------------------------------------
BW=zeros(7,7);
BW(2:6,4)=1;

disp("Test 7: Vertical Line");

area=bwarea(BW);

figure();
imshow(BW);

disp("BW:");
disp(BW);
disp("Sum of pixels:");
disp(sum(BW(:)));  
disp("Area:");
disp(area);
mprintf("\n");


//--------------------------------------------------
// Test 8: Multiple objects
//--------------------------------------------------
BW=zeros(8,8);
BW(2,2)=1;
BW(2,3)=1;
BW(6,6)=1;
BW(7,6)=1;

disp("Test 8: Multiple Objects");

area=bwarea(BW);

figure();
imshow(BW);

disp("BW:");
disp(BW);
disp("Sum of pixels:");
disp(sum(BW(:)));  
disp("Area:");
disp(area);
mprintf("\n");


//--------------------------------------------------
// Test 9: Thresholded image 
//--------------------------------------------------
Img = ImgTest;

disp("Test 9: Thresholded Binary Image");

if ndims(Img) == 3
    grayImg = rgb2gray(Img);
else
    grayImg = Img;
end

BW = grayImg > 128;

area = bwarea(BW);

figure();
subplot(1,2,1);
imshow(Img);
title("Original");

subplot(1,2,2);
imshow(BW);
title("Binary");

disp("BW (cropped view):");
disp(BW(1:10, 1:10));
disp("Sum of pixels:");
disp(sum(BW(:)));  
disp("Area:");
disp(area);
mprintf("\n");


//--------------------------------------------------
// Test 10: Noise pixels
//--------------------------------------------------
BW=zeros(10,10);
BW(2,2)=1;
BW(4,7)=1;
BW(8,3)=1;
BW(9,9)=1;

disp("Test 10: Sparse Noise");

area=bwarea(BW);

figure();
imshow(BW);

disp("BW:");
disp(BW);
disp("Sum of pixels:");
disp(sum(BW(:)));  
disp("Area:");
disp(area);
mprintf("\n");


//--------------------------------------------------
// Test 11: Complex shape
//--------------------------------------------------
BW=[0 0 1 1 0 0;
    0 1 1 1 1 0;
    1 1 1 1 1 1;
    0 1 1 1 1 0;
    0 0 1 1 0 0];

disp("Test 11: Complex Shape");

area=bwarea(BW);

figure();
imshow(BW);

disp("BW:");
disp(BW);
disp("Sum of pixels:");
disp(sum(BW(:)));  
disp("Area:");
disp(area);
mprintf("\n");
