base = get_absolute_file_path("lab2double_test.sce");
exec(base + "../lab2cls/lab2cls.sci", -1);
exec(base + "lab2double.sci", -1);

// Load test image
DogImg = imread("dog.jpg");

// ==================================================
// Test 1: Real LAB Image
// ==================================================
disp("Test 1: Real LAB image from rgb2lab");

rgb = DogImg;
lab = rgb2lab(rgb);

out = lab2double(lab);

disp("Input type:"); disp(typeof(lab));
disp("Output type:"); disp(typeof(out));
disp("Output size:"); disp(size(out));

mprintf("\n");


// ==================================================
// Test 2: uint8 LAB minimum encoded values
// ==================================================
disp("Test 2: uint8 LAB minimum");

lab = uint8(zeros(2,2,3));

out = lab2double(lab);
disp(out);

mprintf("\n");


// ==================================================
// Test 3: uint8 LAB maximum encoded values
// ==================================================
disp("Test 3: uint8 LAB maximum");

lab = uint8(255 * ones(2,2,3));

out = lab2double(lab);
disp(out);

mprintf("\n");


// ==================================================
// Test 4: uint8 LAB typical encoded pattern
// ==================================================
disp("Test 4: uint8 LAB typical encoded values");

lab = uint8(cat(3, ...
                [0 128;255 64], ...
                [128 148;108 168], ...
                [128 98;158 188]));

out = lab2double(lab);
disp(out);

mprintf("\n");


// ==================================================
// Test 5: uint16 LAB input (scaled encoding)
// ==================================================
disp("Test 5: uint16 LAB input");

lab = uint16(cat(3, ...
                 [0 32640;65280 16320], ...
                 [32640 40000;20000 50000], ...
                 [32640 30000;45000 60000]));

out = lab2double(lab);
disp(out);

mprintf("\n");


// ==================================================
// Test 6: uint16 minimum
// ==================================================
disp("Test 6: uint16 minimum");

lab = uint16(zeros(2,2,3));

out = lab2double(lab);
disp(out);

mprintf("\n");


// ==================================================
// Test 7: uint16 maximum
// ==================================================
disp("Test 7: uint16 maximum");

lab = uint16(65280 * ones(2,2,3));

out = lab2double(lab);
disp(out);

mprintf("\n");


// ==================================================
// Test 8: double LAB pass-through (no conversion expected)
// ==================================================
disp("Test 8: double LAB pass-through");

lab = cat(3, ...
          [50 75;25 100], ...
          [0 20;-20 40], ...
          [0 -30;30 60]);

out = lab2double(lab);

disp(out);

mprintf("\n");


// ==================================================
// Test 9: Mx3 LAB colormap input
// ==================================================
disp("Test 9: Mx3 LAB colormap");

lab = [
    0    -128  -128;
    50      0     0;
    100    127   127
];

out = lab2double(lab);

disp(out);

mprintf("\n");


// ==================================================
// Test 10: Invalid input type (should error)
// ==================================================
disp("Test 10: Invalid input type (int16)")
try
    lab = int16(cat(3, ...
                    [0 50;10 20], ...
                    [0 0;0 0], ...
                    [0 0;0 0]));

    out = lab2double(lab);
    disp(out);
catch
    disp(lasterror());
end

mprintf("\n");
