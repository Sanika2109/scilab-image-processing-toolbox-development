base = get_absolute_file_path("lab2double_test.sce");
exec(base + "../lab2uint8/lab2cls.sci", -1);
exec(base + "lab2double.sci", -1);

// ==================================================
// Test 1: Typical uint8 LAB Image
// ==================================================
disp("Test 1: Typical uint8 LAB Image");

lab = uint8(cat(3, ...
                [0 128; 255 64], ...
                [128 148; 108 168], ...
                [128 98; 158 188]));

out = lab2double(lab);

disp("Output type:");
disp(typeof(out));
disp("Output:");
disp(out);
mprintf("\n");

// ==================================================
// Test 2: Minimum uint8 Values
// ==================================================
disp("Test 2: Minimum uint8 Values");

lab = uint8(zeros(2,2,3));

out = lab2double(lab);

disp(out);
mprintf("\n");

// ==================================================
// Test 3: Maximum uint8 Values
// ==================================================
disp("Test 3: Maximum uint8 Values");

lab = uint8(255 * ones(2,2,3));

out = lab2double(lab);

disp(out);
mprintf("\n");

// ==================================================
// Test 4: Typical uint16 LAB Image
// ==================================================
disp("Test 4: Typical uint16 LAB Image");

lab = uint16(cat(3, ...
                 [0 32640; 65280 16320], ...
                 [32640 40000; 20000 50000], ...
                 [32640 30000; 45000 60000]));

out = lab2double(lab);

disp("Output type:");
disp(typeof(out));
disp(out);
mprintf("\n");

// ==================================================
// Test 5: Minimum uint16 Values
// ==================================================
disp("Test 5: Minimum uint16 Values");

lab = uint16(zeros(2,2,3));

out = lab2double(lab);

disp(out);
mprintf("\n");

// ==================================================
// Test 6: Maximum uint16 Values
// ==================================================
disp("Test 6: Maximum uint16 Values");

lab = uint16(65280 * ones(2,2,3));

out = lab2double(lab);

disp(out);
mprintf("\n");

// ==================================================
// Test 7: Double Input (Pass-through)
// ==================================================
disp("Test 7: Double Input");

lab = cat(3, ...
          [50 75; 25 100], ...
          [0 20; -20 40], ...
          [0 -30; 30 60]);

out = lab2double(lab);

disp("Output type:");
disp(typeof(out));
disp(out);
mprintf("\n");

// ==================================================
// Test 8: Single Pixel
// ==================================================
disp("Test 8: Single Pixel");

lab = uint8(cat(3, 128, 128, 128));

out = lab2double(lab);

disp(out);
mprintf("\n");

// ==================================================
// Test 9: Mx3 Colormap
// ==================================================
disp("Test 9: Mx3 Colormap");

lab = uint8([...
    0   128 128;
    128 128 128;
    255 255 255]);

out = lab2double(lab);

disp(out);
mprintf("\n");

// ==================================================
// Test 10: Invalid 2-D Input (Should Error)
// ==================================================
disp("Test 10: Invalid 2-D Input");

try
    lab = uint8([1 2; 3 4]);
    out = lab2double(lab);
    disp(out);
catch
    disp(lasterror());
end

mprintf("\n");

// ==================================================
// Test 11: int16 Input (Should Error)
// ==================================================
disp("Test 11: int16 Input");

try
    lab = int16(cat(3, ...
                    [0 50], ...
                    [0 0], ...
                    [0 0]));

    out = lab2double(lab);
    disp(out);
catch
    disp(lasterror());
end

mprintf("\n");
