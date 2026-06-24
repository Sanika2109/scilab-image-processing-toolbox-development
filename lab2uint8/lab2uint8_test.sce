base = get_absolute_file_path("lab2uint8_test.sce");
exec(base + "../lab2cls/lab2cls.sci", -1);
exec(base + "lab2uint8.sci", -1);

// Load test image
DogImg = imread("dog.jpg");

// ==================================================
// Test 1: Real LAB Image 
// ==================================================
disp("Test 1: Real LAB Image from rgb2lab");

rgb = DogImg;
lab = rgb2lab(rgb);

out = lab2uint8(lab);

disp("Input type:"); disp(typeof(lab));
disp("Output type:"); disp(typeof(out));
disp("Output size:"); disp(size(out));

mprintf("\n");


// ==================================================
// Test 2: Minimum valid double LAB
// ==================================================
disp("Test 2: Minimum LAB (double)");

lab = cat(3, ...
          zeros(2,2), ...
          -128*ones(2,2), ...
          -128*ones(2,2));

out = lab2uint8(lab);
disp(out);

mprintf("\n");


// ==================================================
// Test 3: Maximum valid double LAB
// ==================================================
disp("Test 3: Maximum LAB (double)");

lab = cat(3, ...
          100*ones(2,2), ...
          127*ones(2,2), ...
          127*ones(2,2));

out = lab2uint8(lab);
disp(out);

mprintf("\n");


// ==================================================
// Test 4: Typical LAB values (double)
// ==================================================
disp("Test 4: Typical LAB (double)");

lab = cat(3, ...
          [50 75;25 100], ...
          [0 20;-20 40], ...
          [0 -30;30 60]);

out = lab2uint8(lab);
disp(out);

mprintf("\n");


// ==================================================
// Test 5: NaN handling
// ==================================================
disp("Test 5: NaN Handling");

lab = cat(3, ...
          [%nan 50;25 100], ...
          [0 20;%nan 40], ...
          [0 -30;30 %nan]);

out = lab2uint8(lab);
disp(out);

mprintf("\n");


// ==================================================
// Test 6: Clipping (out-of-range double)
// ==================================================
disp("Test 6: Clipping behavior");

lab = cat(3, ...
          [-20 50;120 200], ...
          [-200 0;100 300], ...
          [-300 0;100 400]);

out = lab2uint8(lab);
disp(out);

mprintf("\n");


// ==================================================
// Test 7: uint8 encoded LAB input
// ==================================================
disp("Test 7: uint8 LAB input");

lab = cat(3, ...
          uint8([0 128;200 255]), ...
          uint8([0 128;200 255]), ...
          uint8([0 128;200 255]));

out = lab2uint8(lab);
disp(out);

mprintf("\n");


// ==================================================
// Test 8: uint16 encoded LAB input
// ==================================================
disp("Test 8: uint16 LAB input");

lab = cat(3, ...
          uint16([0 32768;49152 65280]), ...
          uint16([0 32768;49152 65280]), ...
          uint16([0 32768;49152 65280]));

out = lab2uint8(lab);
disp(out);

mprintf("\n");


// ==================================================
// Test 9: Empty input (error case)
// ==================================================
disp("Test 9: Empty input");

try
    lab = [];
    out = lab2uint8(lab);
    disp(out);
catch
    disp(lasterror());
end

mprintf("\n");


// ==================================================
// Test 10: Invalid dimensions (error case)
// ==================================================
disp("Test 10: Invalid dimensions");

try
    lab = uint8([50 60;70 80]); // invalid 2-D input
    out = lab2uint8(lab);
    disp(out);
catch
    disp(lasterror());
end

mprintf("\n");
