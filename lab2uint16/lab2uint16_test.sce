base = get_absolute_file_path("lab2uint16_test.sce");
exec(base + "../lab2uint8/lab2cls.sci", -1);
exec(base + "lab2uint16.sci", -1);

// ==================================================
// Test 1: Typical L*a*b* Image
// ==================================================
disp("Test 1: Typical L*a*b* Image");

lab = cat(3, ...
          [50 75; 25 100], ...
          [0 20; -20 40], ...
          [0 -30; 30 60]);

out = lab2uint16(lab);

disp("Output type:");
disp(typeof(out));
disp("Output:");
disp(out);
mprintf("\n");

// ==================================================
// Test 2: Minimum Valid Values (uint8 Input)
// ==================================================
disp("Test 2: Minimum Valid Values (uint8 Input)");

lab = uint8(cat(3, ...
                zeros(2,2), ...
                zeros(2,2), ...
                zeros(2,2)));

out = lab2uint16(lab);

disp(out);
mprintf("\n");

// ==================================================
// Test 3: Maximum Valid Values (uint16 Input)
// ==================================================
disp("Test 3: Maximum Valid Values (uint16 Input)");

lab = uint16(cat(3, ...
                 65280*ones(2,2), ...
                 65280*ones(2,2), ...
                 65280*ones(2,2)));

out = lab2uint16(lab);

disp(out);
mprintf("\n");

// ==================================================
// Test 4: Single Pixel
// ==================================================
disp("Test 4: Single Pixel");

lab = cat(3, 50, 0, 0);

out = lab2uint16(lab);

disp(out);
mprintf("\n");

// ==================================================
// Test 5: uint8 Input
// ==================================================
disp("Test 5: uint8 Input");

lab = uint8(cat(3, ...
                [0 128; 255 64], ...
                [128 128; 128 128], ...
                [128 128; 128 128]));

out = lab2uint16(lab);

disp("Output type:");
disp(typeof(out));
disp(out);
mprintf("\n");

// ==================================================
// Test 6: uint16 Input
// ==================================================
disp("Test 6: uint16 Input");

lab = uint16(cat(3, ...
                 [0 1000; 30000 65280], ...
                 [0 1000; 30000 65280], ...
                 [0 1000; 30000 65280]));

out = lab2uint16(lab);

disp("Output type:");
disp(typeof(out));
disp(out);
mprintf("\n");

// ==================================================
// Test 7: Out-of-Range Values
// ==================================================
disp("Test 7: Out-of-Range Values");

lab = cat(3, ...
          [-20 120; 200 -50], ...
          [-200 200; -150 150], ...
          [-200 200; -150 150]);

out = lab2uint16(lab);

disp(out);
mprintf("\n");

// ==================================================
// Test 8: NaN Values
// ==================================================
disp("Test 8: NaN Values");

lab = cat(3, ...
          [%nan 50], ...
          [0 0], ...
          [0 0]);

out = lab2uint16(lab);

disp(out);
mprintf("\n");

// ==================================================
// Test 9: Invalid 2-D Input (Should Error)
// ==================================================
disp("Test 9: Invalid 2-D Input");

try
    lab = [1 2; 3 4];
    out = lab2uint16(lab);
    disp(out);
catch
    disp(lasterror());
end

mprintf("\n");


// ==================================================
// Test 10: int16 Input (Should Error)
// ==================================================
disp("Test 10: int16 Input");

try
    lab = int16(cat(3, ...
                    [0 50], ...
                    [0 0], ...
                    [0 0]));

    out = lab2uint16(lab);
    disp(out);
catch
    disp(lasterror());
end

mprintf("\n");
