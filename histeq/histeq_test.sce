cd(get_absolute_file_path("histeq_test.sce"));
exec("histeq.sci",-1);

// Test 1: Bright image
A = imread("C:\Users\Sanika\Downloads\bright_cimg.jpg");
disp("Test 1: Bright Image");
B = histeq(A);
figure();
subplot(1,2,1);
imshow(A);
title("Original");
subplot(1,2,2);
imshow(B);
title("Equalized");
mprintf("\n");


// Test 2: Dark image
A = imread("C:\Users\Sanika\Downloads\dark_cimage.jpeg");
disp("Test 2: Dark Image");
B = histeq(A);
figure();
subplot(1,2,1);
imshow(A);
title("Original");
subplot(1,2,2);
imshow(B);
title("Equalized");
mprintf("\n");


// Test 3: Low contrast image
A = imread("C:\Users\Sanika\Downloads\lc_cimage.jpeg");
disp("Test 3: Low Contrast Image");
B = histeq(A);
figure();
subplot(1,2,1);
imshow(A);
title("Original");
subplot(1,2,2);
imshow(B);
title("Equalized");
mprintf("\n");


// Test 4: Too few bins
A = imread("C:\Users\Sanika\Downloads\dog.jpg");
disp("Test 4: Too Few Bins (4 bins)");
B = histeq(A,4);
figure();
subplot(1,2,1);
imshow(A);
title("Original");
subplot(1,2,2);
imshow(B);
title("4 bins");
mprintf("\n");


// Test 5: Too many bins
A = imread("C:\Users\Sanika\Downloads\dog.jpg");
disp("Test 5: Too Many Bins (512 bins)");
B = histeq(A,512);
figure();
subplot(1,2,1);
imshow(A);
title("Original");
subplot(1,2,2);
imshow(B);
title("512 bins");
mprintf("\n");


// Test 6: Adequate bins
A = imread("C:\Users\Sanika\Downloads\dog.jpg");
disp("Test 6: Adequate Number of Bins (128 bins)");
B = histeq(A,128);
figure();
subplot(1,2,1);
imshow(A);
title("Original");
subplot(1,2,2);
imshow(B);
title("256 bins");
mprintf("\n");
