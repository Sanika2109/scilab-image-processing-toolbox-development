base = get_absolute_file_path("stretchlim_test.sce");
exec(base + "../postpad/postpad.sci", -1);
exec(base + "stretchlim.sci", -1);

//--------------------------------------------------
// TEST 1 : Default tolerance on uint8 ramp
//--------------------------------------------------
disp("TEST 1 : uint8 ramp, default tolerance");

I = uint8(0:255);
disp("Input (top-left 5x5):");
disp(I(1:min(5,size(I,1)), 1:min(5,size(I,2))));
disp("Output: [Low High]");
disp(stretchlim(I));

//--------------------------------------------------
// TEST 2 : Scalar tolerance
//--------------------------------------------------
disp("TEST 2 : Scalar tolerance 0.05");

I = uint8(0:255);
disp("Input (top-left 5x5):");
disp(I(1:min(5,size(I,1)), 1:min(5,size(I,2))));
disp("Output: [Low High]");
disp(stretchlim(I));

//--------------------------------------------------
// TEST 3 : Custom tolerance on non-uniform image
//--------------------------------------------------
disp("TEST 3 : Custom tolerance [0.20 0.80]");

I = uint8([
     10 * ones(10,10), ...
    100 * ones(10,10), ...
    200 * ones(10,10), ...
    250 * ones(10,10)
]);
disp("Input (top-left 5x5):");
disp(I(1:min(5,size(I,1)), 1:min(5,size(I,2))));
disp("Output: [Low High]");
disp(stretchlim(I));

//--------------------------------------------------
// TEST 4 : Constant uint8 image
//--------------------------------------------------
disp("TEST 4 : Constant uint8 image");

I = uint8(100 * ones(20,20));
disp("Input (top-left 5x5):");
disp(I(1:min(5,size(I,1)), 1:min(5,size(I,2))));
disp(stretchlim(I));

//--------------------------------------------------
// TEST 5 : Double precision image with varying intensities
//--------------------------------------------------
disp("TEST 5 : Double precision image with varying intensities");

I = [
    0.10 * ones(10,10), ...
    0.40 * ones(10,10), ...
    0.70 * ones(10,10), ...
    0.95 * ones(10,10)
];

disp("Input (top-left 5x5):");
disp(I(1:5,1:5));
disp("Output: [Low High]");
disp(stretchlim(I));

//--------------------------------------------------
// TEST 6 : Skewed histogram image
//--------------------------------------------------
disp("TEST 6 : Skewed histogram image");

I = uint8([
     20 * ones(20,5), ...
     80 * ones(20,15), ...
    180 * ones(20,20), ...
    240 * ones(20,10)
]);
disp("Input (top-left 5x5):");
disp(I(1:min(5,size(I,1)), 1:min(5,size(I,2))));
disp(stretchlim(I));

//--------------------------------------------------
// TEST 7 : uint16 full-range image
//--------------------------------------------------
disp("TEST 7 : uint16 image");

I = matrix(uint16(0:65535),256,256);
disp("Input (top-left 5x5):");
disp(I(1:min(5,size(I,1)), 1:min(5,size(I,2))));
disp("Output: [Low High]");
disp(stretchlim(I));

//--------------------------------------------------
// TEST 8 : int16 image with varying intensity regions
//--------------------------------------------------
disp("TEST 8 : int16 image with varying intensity regions");

I = int16([
   -25000 * ones(20,5), ...
   -5000  * ones(20,15), ...
    5000  * ones(20,20), ...
    25000 * ones(20,10)
]);
disp("Input (top-left 5x5):");
disp(I(1:5,1:5));
disp("Output: [Low High]");
disp(stretchlim(I));

//-------------------------------------------------
// TEST 9 : RGB image with different channels
//--------------------------------------------------
disp("TEST 9 : RGB image");

I = zeros(16,16,3,"uint8");

I(:,:,1) = matrix(uint8(0:255),16,16);
I(:,:,2) = matrix(uint8(255:-1:0),16,16);
I(:,:,3) = uint8(128 * ones(16,16));

disp("Input (top-left 5x5 of each channel):");

disp("Red Channel:");
disp(I(1:5,1:5,1));

disp("Green Channel:");
disp(I(1:5,1:5,2));

disp("Blue Channel:");
disp(I(1:5,1:5,3));
disp("Output: [Low High]");
disp(stretchlim(I));

//--------------------------------------------------
// TEST 10 : Invalid tolerance
//--------------------------------------------------
disp("TEST 10 : Invalid tolerance");

try
    stretchlim(uint8(0:255), [0.8 0.2]);
catch
    disp(lasterror());
end
