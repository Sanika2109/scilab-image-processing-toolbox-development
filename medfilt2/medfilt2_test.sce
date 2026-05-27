cd(get_absolute_file_path("medfilt2_test.sce"));
exec("medfilt2.sci",-1);

// Test 1: Salt-and-pepper noise image
A = imread("C:/Users/Sanika/Downloads/saltandpepper.jpg");
disp("Test 1: Salt-and-Pepper Noise Image");
A = double(A);
B = medfilt2(A,[3 3],"replicate");
figure();
subplot(1,2,1);
imshow(uint8(A));
title("Original");
subplot(1,2,2);
imshow(uint8(B));
title("Median Filtered");
mprintf("\n");

// Test 2: Large filter window
A = imread("C:/Users/Sanika/Downloads/saltandpepper.jpg");
disp("Test 2: Large Filter [5x5]");
A = double(A);
B = medfilt2(A,[5 5],"replicate");
figure();
subplot(1,2,1);
imshow(uint8(A));
title("Original");
subplot(1,2,2);
imshow(uint8(B));
title("5x5 Filter");
mprintf("\n");

// Test 3: Zero padding
A = imread("C:/Users/Sanika/Downloads/saltandpepper.jpg");
disp("Test 3: Zero Padding");
A = double(A);
B = medfilt2(A,[3 3],"zero");
figure();
subplot(1,2,1);
imshow(uint8(A));
title("Original");
subplot(1,2,2);
imshow(uint8(B));
title("Zero Padding");
mprintf("\n");

// Test 4: Replicate padding
A = imread("C:/Users/Sanika/Downloads/saltandpepper.jpg");
disp("Test 4: Replicate Padding");
A = double(A);
B = medfilt2(A,[3 3],"replicate");
figure();
subplot(1,2,1);
imshow(uint8(A));
title("Original");
subplot(1,2,2);
imshow(uint8(B));
title("Replicate Padding");
mprintf("\n");

// Test 5: Circular padding
A = imread("C:/Users/Sanika/Downloads/saltandpepper.jpg");
disp("Test 5: Circular Padding");
A = double(A);
B = medfilt2(A,[3 3],"circular");
figure();
subplot(1,2,1);
imshow(uint8(A));
title("Original");
subplot(1,2,2);
imshow(uint8(B));
title("Circular Padding");
mprintf("\n");

// Test 6: Single Pixel Image
A = uint8([150]);
disp("Test 6: Single Pixel Image");
A = double(A);
B = medfilt2(A,[3 3],"replicate");
disp("Original:");
disp(uint8(A));
disp("Filtered:");
disp(uint8(B));
mprintf("\n");

// Test 7: Small 2x2 Image
A = uint8([10 20;
           30 40]);
disp("Test 7: Small Image");
A = double(A);
B = medfilt2(A,[3 3],"replicate");
disp("Original:");
disp(uint8(A));
disp("Filtered:");
disp(uint8(B));
mprintf("\n");

// Test 8: Filter larger than image
A = uint8([10 20;
           30 40]);
disp("Test 8: Filter Larger Than Image");
A = double(A);
B = medfilt2(A,[5 5],"replicate");
disp("Original:");
disp(uint8(A));
disp("Filtered:");
disp(uint8(B));
mprintf("\n");

// Test 9: Uniform Image
A = uint8(ones(100,100)*128);
disp("Test 9: Uniform Image");
A = double(A);
B = medfilt2(A,[3 3],"replicate");
figure();
subplot(1,2,1);
imshow(uint8(A));
title("Original");
subplot(1,2,2);
imshow(uint8(B));
title("Filtered");
mprintf("\n");

// Test 10: Extreme Noise Pixel
A = uint8([10 20 30;
           40 255 50;
           60 70 80]);
disp("Test 10: Extreme Pixel Noise");
A = double(A);
B = medfilt2(A,[3 3],"replicate");
disp("Original:");
disp(uint8(A));
disp("Filtered:");
disp(uint8(B));
mprintf("\n");

// Test 11: Reflect padding
A = imread("C:/Users/Sanika/Downloads/saltandpepper.jpg");
disp("Test 11: Reflect Padding");
A = double(A);
B = medfilt2(A,[3 3],"reflect");
figure();
subplot(1,2,1);
imshow(uint8(A));
title("Original");
subplot(1,2,2);
imshow(uint8(B));
title("Reflect");
mprintf("\n");

// Test 12: Symmetric padding
A = imread("C:/Users/Sanika/Downloads/saltandpepper.jpg");
disp("Test 12: Symmetric Padding");
A = double(A);
B = medfilt2(A,[3 3],"symmetric");
figure();
subplot(1,2,1);
imshow(uint8(A));
title("Original");
subplot(1,2,2);
imshow(uint8(B));
title("Symmetric");
mprintf("\n");

// Test 13: Rectangular window [3x5]
A = imread("C:/Users/Sanika/Downloads/saltandpepper.jpg");
disp("Test 13: Rectangular Window [3x5]");
A = double(A);
B = medfilt2(A,[3 5],"replicate");
figure();
imshow(uint8(B));
title("3x5 Median");
mprintf("\n");

// Test 14: Rectangular window [5x7]
A = imread("C:/Users/Sanika/Downloads/saltandpepper.jpg");
disp("Test 14: Rectangular Window [5x7]");
A = double(A);
B = medfilt2(A,[5 7],"replicate");
figure();
imshow(uint8(B));
title("5x7 Median");
mprintf("\n");

// Test 15: Window same size as image
A = uint8([10 20 30;
           40 50 60;
           70 80 90]);
disp("Test 15: Window same as image size");
A = double(A);
B = medfilt2(A,[3 3],"replicate");
disp(uint8(B));
mprintf("\n");

// Test 16: Single row image
A = uint8([10 50 100 200 255]);
disp("Test 16: Single Row");
A = double(A);
B = medfilt2(A,[3 3],"replicate");
disp(uint8(B));
mprintf("\n");

// Test 17: Single column image
A = uint8([10;
           50;
           100;
           200;
           255]);
disp("Test 17: Single Column");
A = double(A);
B = medfilt2(A,[3 3],"replicate");
disp(uint8(B));
mprintf("\n");

// Test 18: Gradient image
A = uint8(repmat(1:100,100,1));
disp("Test 18: Gradient Image");
A = double(A);
B = medfilt2(A,[3 3],"replicate");
figure();
subplot(1,2,1);
imshow(uint8(A));
title("Gradient");
subplot(1,2,2);
imshow(uint8(B));
title("Filtered");
mprintf("\n");

// Test 19: Random noise image
A = uint8(rand(100,100)*255);
disp("Test 19: Random Noise");
A = double(A);
B = medfilt2(A,[3 3],"replicate");
figure();
subplot(1,2,1);
imshow(uint8(A));
title("Noise");
subplot(1,2,2);
imshow(uint8(B));
title("Filtered");
mprintf("\n");

// Test 20: Invalid padding option
disp("Test 20: Invalid Padding");
try
    A = double(uint8(rand(10,10)*255));
    B = medfilt2(A,[3 3],"abc");
catch
    disp(lasterror());
end
mprintf("\n");

// Test 21: Even window size
disp("Test 21: Even Window");
try
    A = double(uint8(rand(10,10)*255));
    B = medfilt2(A,[4 4],"replicate");
catch
    disp(lasterror());
end
mprintf("\n");

// Test 22: Empty image
disp("Test 22: Empty Image");
try
    A = [];
    B = medfilt2(A,[3 3],"replicate");
catch
    disp(lasterror());
end
