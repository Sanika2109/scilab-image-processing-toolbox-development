cd(get_absolute_file_path("bwarea_test.sce"));
exec("bwarea.sci",-1);
ImgTest = imread("grayscale_img.jpg");

//--------------------------------------------------
// Test 1: Empty image (class: double)
//--------------------------------------------------
BW = zeros(5,5);
disp("Test 1: Empty Image (double)");

disp("Input Type:");
disp(typeof(BW));

disp("Input:");
disp(BW);

bw = (BW <> 0);
disp("Converted logical bw:");
disp(bw);

area = bwarea(BW);

figure();
subplot(1,2,1);
imshow(BW);
title("Input");
subplot(1,2,2);
imshow(bw);
title("Logical bw");

disp("Sum of foreground pixels:");
disp(sum(bw(:)));
disp("Estimated Area:");
disp(area);
mprintf("\n");


//--------------------------------------------------
// Test 2: Single pixel (class: uint8)
//--------------------------------------------------
BW = uint8(zeros(5,5));
BW(3,3) = 1;
disp("Test 2: Single Pixel Object (uint8)");

disp("Input Type:");
disp(typeof(BW));

disp("Input:");
disp(BW);

bw = (BW <> 0);
disp("Converted logical bw:");
disp(bw);

area = bwarea(BW);

figure();
subplot(1,2,1);
imshow(BW);
title("Input");
subplot(1,2,2);
imshow(bw);
title("Logical bw");

disp("Sum of foreground pixels:");
disp(sum(bw(:)));
disp("Estimated Area:");
disp(area);
mprintf("\n");


//--------------------------------------------------
// Test 3: Full image (class: boolean)
//--------------------------------------------------
BW = ones(5,5) <> 0;
disp("Test 3: Full Image (boolean)");

disp("Input Type:");
disp(typeof(BW));

disp("Input:");
disp(BW);

if typeof(BW) <> "boolean" then
    bw = (BW <> 0);
else
    bw = BW;
end
disp("Converted logical bw:");
disp(bw);

area = bwarea(BW);

figure();
subplot(1,2,1);
imshow(BW);
title("Input");
subplot(1,2,2);
imshow(bw);
title("Logical bw");

disp("Sum of foreground pixels:");
disp(sum(bw(:)));
disp("Estimated Area:");
disp(area);
mprintf("\n");


//--------------------------------------------------
// Test 4: Adjacent pixels (class: int8)
//--------------------------------------------------
BW = int8(zeros(5,5));
BW(3,3) = 2;
BW(3,4) = 5;
disp("Test 4: Adjacent Pixels (int8)");

disp("Input Type:");
disp(typeof(BW));

disp("Input:");
disp(BW);

bw = (BW <> 0);
disp("Converted logical bw:");
disp(bw);

area = bwarea(BW);

figure();
subplot(1,2,1);
imshow(BW);
title("Input");
subplot(1,2,2);
imshow(bw);
title("Logical bw");

disp("Sum of foreground pixels:");
disp(sum(bw(:)));
disp("Estimated Area:");
disp(area);
mprintf("\n");


//--------------------------------------------------
// Test 5: Diagonal pixels (class: uint16)
//--------------------------------------------------
BW = uint16(zeros(5,5));
BW(2,2) = 10;
BW(3,3) = 7;
disp("Test 5: Diagonal Pixels (uint16)");

disp("Input Type:");
disp(typeof(BW));

disp("Input:");
disp(BW);

bw = (BW <> 0);
disp("Converted logical bw:");
disp(bw);

area = bwarea(BW);

figure();
subplot(1,2,1);
imshow(BW);
title("Input");
subplot(1,2,2);
imshow(bw);
title("Logical bw");

disp("Sum of foreground pixels:");
disp(sum(bw(:)));
disp("Estimated Area:");
disp(area);
mprintf("\n");


//--------------------------------------------------
// Test 6: Horizontal line (class: int16)
//--------------------------------------------------
BW = int16(zeros(7,7));
BW(4,2:6) = 3;
disp("Test 6: Horizontal Line (int16)");

disp("Input Type:");
disp(typeof(BW));

disp("Input:");
disp(BW);

bw = (BW <> 0);
disp("Converted logical bw:");
disp(bw);

area = bwarea(BW);

figure();
subplot(1,2,1);
imshow(BW);
title("Input");
subplot(1,2,2);
imshow(bw);
title("Logical bw");

disp("Sum of foreground pixels:");
disp(sum(bw(:)));
disp("Estimated Area:");
disp(area);
mprintf("\n");


//--------------------------------------------------
// Test 7: Vertical line (class: uint32)
//--------------------------------------------------
BW = uint32(zeros(7,7));
BW(2:6,4) = 1;
disp("Test 7: Vertical Line (uint32)");

disp("Input Type:");
disp(typeof(BW));

disp("Input:");
disp(BW);

bw = (BW <> 0);
disp("Converted logical bw:");
disp(bw);

area = bwarea(BW);

figure();
subplot(1,2,1);
imshow(BW);
title("Input");
subplot(1,2,2);
imshow(bw);
title("Logical bw");

disp("Sum of foreground pixels:");
disp(sum(bw(:)));
disp("Estimated Area:");
disp(area);
mprintf("\n");


//--------------------------------------------------
// Test 8: Multiple objects (class: int32)
//--------------------------------------------------
BW = int32(zeros(8,8));
BW(2,2) = 4;
BW(2,3) = 8;
BW(6,6) = 2;
BW(7,6) = 9;
disp("Test 8: Multiple Objects (int32)");

disp("Input Type:");
disp(typeof(BW));

disp("Input:");
disp(BW);

bw = (BW <> 0);
disp("Converted logical bw:");
disp(bw);

area = bwarea(BW);

figure();
subplot(1,2,1);
imshow(BW);
title("Input");
subplot(1,2,2);
imshow(bw);
title("Logical bw");

disp("Sum of foreground pixels:");
disp(sum(bw(:)));
disp("Estimated Area:");
disp(area);
mprintf("\n");


//--------------------------------------------------
// Test 9: Thresholded real image (class: boolean, large -> cropped)
//--------------------------------------------------
Img = ImgTest;
grayImg = rgb2gray(Img);
BW = grayImg > 128;
disp("Test 9: Thresholded Binary Image (boolean)");

disp("Input Type:");
disp(typeof(BW));

disp("Input (cropped view, 10x10):");
disp(BW(1:10, 1:10));

if typeof(BW) <> "boolean" then
    bw = (BW <> 0);
else
    bw = BW;
end
disp("Converted logical bw (cropped view, 10x10):");
disp(bw(1:10, 1:10));

area = bwarea(BW);

figure();
subplot(1,2,1);
imshow(Img);
title("Original");
subplot(1,2,2);
imshow(bw);
title("Logical bw");

disp("Sum of foreground pixels:");
disp(sum(bw(:)));
disp("Estimated Area:");
disp(area);
mprintf("\n");


//--------------------------------------------------
// Test 10: Sparse noise (class: double)
//--------------------------------------------------
BW = zeros(10,10);
BW(2,2) = 5;
BW(4,7) = 1;
BW(8,3) = 9;
BW(9,9) = 2;
disp("Test 10: Sparse Noise (double)");

disp("Input Type:");
disp(typeof(BW));

disp("Input:");
disp(BW);

bw = (BW <> 0);
disp("Converted logical bw:");
disp(bw);

area = bwarea(BW);

figure();
subplot(1,2,1);
imshow(BW);
title("Input");
subplot(1,2,2);
imshow(bw);
title("Logical bw");

disp("Sum of foreground pixels:");
disp(sum(bw(:)));
disp("Estimated Area:");
disp(area);
mprintf("\n");


//--------------------------------------------------
// Test 11: Complex shape (class: double)
//--------------------------------------------------
BW = [0 0 1 1 0 0;
      0 1 1 1 1 0;
      1 1 1 1 1 1;
      0 1 1 1 1 0;
      0 0 1 1 0 0];
disp("Test 11: Complex Shape (double)");

disp("Input Type:");
disp(typeof(BW));

disp("Input:");
disp(BW);

bw = (BW <> 0);
disp("Converted logical bw:");
disp(bw);

area = bwarea(BW);

figure();
subplot(1,2,1);
imshow(BW);
title("Input");
subplot(1,2,2);
imshow(bw);
title("Logical bw");

disp("Sum of foreground pixels:");
disp(sum(bw(:)));
disp("Estimated Area:");
disp(area);
mprintf("\n");


//--------------------------------------------------
// Test 12: Complex shape, arbitrary non-zero values (class: uint8)
//--------------------------------------------------
BW = uint8([0 0 1 1 0 0;
            0 1 2 3 1 0;
            1 1 1 1 1 1;
            0 2 1 4 1 0;
            0 0 1 1 0 0]);
disp("Test 12: Complex Shape, Arbitrary Values (uint8)");

disp("Input Type:");
disp(typeof(BW));

disp("Input:");
disp(BW);

bw = (BW <> 0);
disp("Converted logical bw:");
disp(bw);

area = bwarea(BW);

figure();
subplot(1,2,1);
imshow(BW);
title("Input");
subplot(1,2,2);
imshow(bw);
title("Logical bw");

disp("Sum of foreground pixels:");
disp(sum(bw(:)));
disp("Estimated Area:");
disp(area);
mprintf("\n");
