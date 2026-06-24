base = get_absolute_file_path("lab2uint16_test.sce");
exec(base + "../lab2cls/lab2cls.sci", -1);
exec(base + "lab2uint16.sci", -1);

// Load test image
DogImg = imread("dog.jpg");

// ==================================================
// Test 1: Real LAB Image 
// ==================================================
disp("Test 1: Real LAB Image from rgb2lab");

rgb = DogImg;
lab = rgb2lab(rgb);

out = lab2uint16(lab);

disp("Input type:"); disp(typeof(lab));
disp("Output type:"); disp(typeof(out));
disp("Output size:"); disp(size(out));

mprintf("\n");


// ==================================================
// Test 2: Double LAB minimum values
// ==================================================
disp("Test 2: Double LAB Minimum");

lab = cat(3, ...
          zeros(2,2), ...
          -128*ones(2,2), ...
          -128*ones(2,2));

out = lab2uint16(lab);
disp(out);

mprintf("\n");


// ==================================================
// Test 3: Double LAB maximum values
// ==================================================
disp("Test 3: Double LAB Maximum");

lab = cat(3, ...
          100*ones(2,2), ...
          127*ones(2,2), ...
          127*ones(2,2));

out = lab2uint16(lab);
disp(out);

mprintf("\n");


// ==================================================
// Test 4: Typical double LAB values
// ==================================================
disp("Test 4: Typical LAB values");

lab = cat(3, ...
          [50 75;25 100], ...
          [0 20;-20 40], ...
          [0 -30;30 60]);

out = lab2uint16(lab);
disp(out);

mprintf("\n");


// ==================================================
// Test 5: uint8 encoded LAB input
// ==================================================
disp("Test 5: uint8 LAB input");

lab = uint8(cat(3, ...
                [0 128;255 64], ...
                [128 128;128 128], ...
                [128 128;128 128]));

out = lab2uint16(lab);
disp(out);

mprintf("\n");


// ==================================================
// Test 6: uint16 encoded LAB input
// ==================================================
disp("Test 6: uint16 LAB input");

lab = uint16(cat(3, ...
                 [0 1000;30000 65280], ...
                 [0 1000;30000 65280], ...
                 [0 1000;30000 65280]));

out = lab2uint16(lab);
disp(out);

mprintf("\n");


// ==================================================
// Test 7: Clipping / Out-of-range double
// ==================================================
disp("Test 7: Clipping behavior");

lab = cat(3, ...
          [-20 120;200 -50], ...
          [-200 200;-150 150], ...
          [-200 200;-150 150]);

out = lab2uint16(lab);
disp(out);

mprintf("\n");


// ==================================================
// Test 8: NaN handling
// ==================================================
disp("Test 8: NaN Handling");

lab = cat(3, ...
          [%nan 50;25 100], ...
          [0 20;%nan 40], ...
          [0 -30;30 %nan]);

out = lab2uint16(lab);
disp(out);

mprintf("\n");


// ==================================================
// Test 9: Invalid 2-D input (error)
// ==================================================
disp("Test 9: Invalid 2-D Input");

try
    lab = [1 2;3 4];
    out = lab2uint16(lab);
catch
    disp(lasterror());
end

mprintf("\n");


// ==================================================
// Test 10: Invalid type (int16 should error)
// ==================================================
disp("Test 10: Invalid type (int16)");

try
    lab = int16(cat(3, ...
                    [0 50], ...
                    [0 0], ...
                    [0 0]));

    out = lab2uint16(lab);
catch
    disp(lasterror());
end

mprintf("\n");
