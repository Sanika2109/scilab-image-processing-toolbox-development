base = get_absolute_file_path("graythresh_test.sce");
exec(base + "../rgb2gray/rgb2gray.sci", -1);
exec(base + "../im2double/im2double.sci", -1);
exec(base + "../isa/isa.sci", -1);
exec(base + "../im2uint16/im2uint16.sci", -1);
exec(base + "../im2uint8/im2uint8.sci", -1);
exec(base + "../intmax/intmax.sci", -1);
exec(base + "graythresh.sci", -1);

//--------------------------------------------------
// Test 1 : Otsu + goodness metric on bimodal uint8 image
//--------------------------------------------------
disp("TEST 1 : OTSU - Bimodal Image");

img = uint8([zeros(50,50) 255*ones(50,50)]);

[level, goodness] = graythresh(img);

disp("Level: ", level);
disp("Goodness metric: ",goodness);

//--------------------------------------------------
// Test 2 : Mean algorithm
//--------------------------------------------------
disp("TEST 2 : Mean");

img = uint8([
    grand(100,1,"uin",20,80);
    grand(100,1,"uin",180,240)
]);

out = graythresh(img, "mean");

disp(out);

//--------------------------------------------------
// Test 3 : Intermeans
//--------------------------------------------------
disp("TEST 3 : Intermeans");

img = uint8([
    grand(100,1,"uin",20,70);
    grand(100,1,"uin",180,230)
]);

out = graythresh(img, "intermeans");

disp(out);

//--------------------------------------------------
// Test 4 : Intermodes
//--------------------------------------------------
disp("TEST 4 : Intermodes");

img = uint8([
    10 + grand(100,1,"uin",0,5);
    245 + grand(100,1,"uin",0,5)
]);

out = graythresh(img, "intermodes");

disp(out);

//--------------------------------------------------
// Test 5 : Maximum Entropy
//--------------------------------------------------
disp("TEST 5 : MaxEntropy");

img = uint8([
    30 + grand(100,1,"uin",0,20);
    200 + grand(100,1,"uin",0,20)
]);

out = graythresh(img, "maxentropy");

disp(out);

//--------------------------------------------------
// Test 6 : Max Likelihood
//--------------------------------------------------
disp("TEST 6 : MaxLikelihood");

img = uint8([ ...
    40 + grand(100,1,"uin",0,20);
    200 + grand(100,1,"uin",0,20)]);

out = graythresh(img, "maxlikelihood");

disp(out);

//--------------------------------------------------
// Test 7 : Minimum
//--------------------------------------------------
disp("TEST 7 : Minimum");

img = uint8([ ...
    50 + grand(100,1,"uin",0,10);
    220 + grand(100,1,"uin",0,10)]);

out = graythresh(img, "minimum");

disp(out);

//--------------------------------------------------
// Test 8 : MinError
//--------------------------------------------------
disp("TEST 8 : MinError");

img = uint8([ ...
    30 + grand(100,1,"uin",0,15);
    210 + grand(100,1,"uin",0,15)]);

out = graythresh(img, "minerror");

disp(out);

//--------------------------------------------------
// Test 9 : Moments
//--------------------------------------------------
disp("TEST 9 : Moments");

img = uint8(grand(128,128,"uin",0,255));

out = graythresh(img, "moments");

disp(out);

//--------------------------------------------------
// Test 10 : Concavity
//--------------------------------------------------
disp("TEST 10 : Concavity");

img = uint8([
    20 + grand(120,1,"uin",0,25);
    120 + grand(120,1,"uin",0,40);
    220 + grand(120,1,"uin",0,15)
]);

out = graythresh(img, "concavity");

disp(out);

//--------------------------------------------------
// Test 11 : Percentile default p=0.5
//--------------------------------------------------
disp("TEST 11 : Percentile");

img = uint8([
    grand(150,1,"uin",10,80);
    grand(150,1,"uin",180,240)
]);

out = graythresh(img, "percentile", 0.5);

disp(out);

//--------------------------------------------------
// Test 12 : Percentile p=0.25
//--------------------------------------------------
disp("TEST 12 : Percentile p=0.25");

img = uint8([
    grand(200,1,"uin",10,60);
    grand(100,1,"uin",180,240)
]);

out = graythresh(img, "percentile", 0.25);

disp(out);

//--------------------------------------------------
// Test 13 : Percentile p = 0.75
//--------------------------------------------------
disp("TEST 13 : Percentile p=0.75");

img = uint8([
    grand(300,1,"uin",10,80);
    grand(100,1,"uin",180,240)
]);

out = graythresh(img, "percentile", 0.75);

disp(out);
//--------------------------------------------------
// Test 14 : Histogram input
//--------------------------------------------------
disp("TEST 14 : Histogram Input");

histogram = [10 20 50 100 50 20 10];

out = graythresh(histogram, "otsu");

disp(out);

//--------------------------------------------------
// Test 15 : Single-bin histogram
//--------------------------------------------------
disp("TEST 15 : Single Bin Histogram");

histogram = 100;

out = graythresh(histogram, "otsu");

disp(out);

//--------------------------------------------------
// Test 16 : RGB image
//--------------------------------------------------
disp("TEST 16 : RGB Image");

rgb(:,:,1) = uint8([255*ones(50,25)  50*ones(50,25)]);
rgb(:,:,2) = uint8([100*ones(50,25) 200*ones(50,25)]);
rgb(:,:,3) = uint8([0*ones(50,25)   150*ones(50,25)]);

out = graythresh(rgb, "otsu");

disp(out);

//--------------------------------------------------
// Test 17 : uint16 image
//--------------------------------------------------
disp("TEST 17 : uint16 Image");

img = uint16([zeros(50,50) 65535*ones(50,50)]);

out = graythresh(img);

disp(out);


//--------------------------------------------------
// Test 18 : Random double image
//--------------------------------------------------
disp("TEST 18 : Double Image");

img = rand(100,100);

out = graythresh(img);

disp(out);

