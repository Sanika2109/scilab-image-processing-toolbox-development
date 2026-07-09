base = get_absolute_file_path("lab2single_test.sce");
exec(base + "../lab2cls/lab2cls.sci", -1);
exec(base + "lab2single.sci", -1);

// Load test image
DogImg = imread("dog.jpg");

// ==================================================
// Test 1: Real LAB Image 
// ==================================================
disp("Test 1: Real LAB image from rgb2lab");

rgb = DogImg;
lab = rgb2lab(rgb);

out = lab2single(lab);

disp("Input type:"); disp(typeof(lab));
disp("Output type:"); disp(typeof(out));
disp("Output size:"); disp(size(out));

mprintf("\n");


// ==================================================
// Test 2: uint8 LAB colormap (Mx3)
// ==================================================
disp("Test 2: uint8 LAB Colormap");

lab = uint8([
    255 128 128;
    0   128 128
]);

out = lab2single(lab);

disp(out);

mprintf("\n");


// ==================================================
// Test 3: uint16 LAB colormap (Mx3)
// ==================================================
disp("Test 3: uint16 LAB Colormap");

lab = uint16([
    65280 32768 32768;
    0     32768 32768
]);

out = lab2single(lab);

disp(out);

mprintf("\n");


// ==================================================
// Test 4: double LAB colormap (Mx3)
// ==================================================
disp("Test 4: double LAB Colormap");

lab = [
    50 10 -10;
    75 20  30
];

out = lab2single(lab);

disp(out);

mprintf("\n");


// ==================================================
// Test 5: uint8 MxNx3 LAB image
// ==================================================
disp("Test 5: uint8 LAB Image");

lab = cat(3, ...
          uint8([0 128;255 64]), ...
          uint8([128 138;148 158]), ...
          uint8([128 118;168 108]));

out = lab2single(lab);

disp(out);

mprintf("\n");


// ==================================================
// Test 6: uint16 MxNx3 LAB image
// ==================================================
disp("Test 6: uint16 LAB Image");

lab = cat(3, ...
          uint16([0 32640;65280 16320]), ...
          uint16([32640 40000;20000 50000]), ...
          uint16([32640 30000;45000 60000]));

out = lab2single(lab);

disp(out);

mprintf("\n");


// ==================================================
// Test 7: 4D LAB image (batch processing)
// ==================================================
disp("Test 7: 4D LAB Image");

lab = rand(2,2,3,2);
lab(:,:,1,:) = lab(:,:,1,:) * 100;
lab(:,:,2,:) = lab(:,:,2,:) * 255 - 128;
lab(:,:,3,:) = lab(:,:,3,:) * 255 - 128;

out = lab2single(lab);

disp("Input size:");
disp(size(lab));
disp("Output size:");
disp(size(out));

mprintf("\n");


// ==================================================
// Test 8: Invalid dimensions (error)
// ==================================================
disp("Test 8: Invalid dimensions");

try
    lab = rand(3,4); // invalid (not Mx3 or MxNx3)
    out = lab2single(lab);
catch
    disp(lasterror());
end

mprintf("\n");


// ==================================================
// Test 9: Invalid type (error)
// ==================================================
disp("Test 9: Invalid input type");

try
    lab2single("hello");
catch
    disp(lasterror());
end

mprintf("\n");


// ==================================================
// Test 10: NaN and Inf Handling
// ==================================================
disp("Test 10: NaN and Inf Handling");

lab = cat(3, ...
          [%nan 50; %inf -50], ...
          [0 -%inf; %nan 40], ...
          [0 30; -30 %inf]);

out = lab2single(lab);

disp("Input:");
disp(lab);

disp("Output:");
disp(out);

mprintf("\n");
