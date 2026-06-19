base = get_absolute_file_path("lab2uint8_test.sce");
exec(base + "../lab2cls/lab2cls.sci", -1);
exec(base + "lab2uint8.sci", -1);

// ==================================================
// Test 1: Typical L*a*b* image
// ==================================================
disp("Test 1: Typical L*a*b* Image");
lab = cat(3, ...
          [50 75; 25 100], ...
          [0 20; -20 40], ...
          [0 -30; 30 60]);
disp("Input type:", typeof(lab));
out = lab2uint8(lab);
disp("Output type:", typeof(out));
disp("Output:");
disp(out);
mprintf("\n");


// ==================================================
// Test 2: Minimum valid L*a*b* values (uint8 Input)
// ==================================================
disp("Test 2: Minimum Valid L*a*b* Values (uint8 Input)");
lab = cat(3, ...
          uint8(zeros(2,2)), ...
          uint8(zeros(2,2)), ...
          uint8(zeros(2,2)));
disp("Input type:", typeof(lab));
out = lab2uint8(lab);
disp("Output type:", typeof(out));
disp("Output:");
disp(out);
mprintf("\n");


// ==================================================
// Test 3: Maximum valid L*a*b* values (uint16 Input)
// ==================================================
disp("Test 3: Maximum Valid L*a*b* Values (int16 Input)");
lab = cat(3, ...
          uint16(65280*ones(2,2)), ...
          uint16(65280*ones(2,2)), ...
          uint16(65280*ones(2,2)));
disp("Input type:", typeof(lab));
out = lab2uint8(lab);
disp("Output type:", typeof(out));
disp("Output:");
disp(out);
mprintf("\n");


// ==================================================
// Test 4: Floating-point values
// ==================================================
disp("Test 4: Floating Point Values");
lab = cat(3, ...
          [10.5 20.2; 30.8 40.1], ...
          [1.5 -2.3; 5.7 -8.9], ...
          [15.4 -12.7; 25.8 -30.6]);
disp("Input type:", typeof(lab));
out = lab2uint8(lab);
disp("Output type:", typeof(out));
disp("Output:");
disp(out);
mprintf("\n");


// ==================================================
// Test 5: uint8 Encoded L*a*b* Input
// ==================================================
disp("Test 5: uint8 Encoded L*a*b* Input");

lab = cat(3, ...
          uint8([0 50; 75 100]), ...
          uint8([0 128; 178 255]), ...
          uint8([0 128; 178 255]));
disp("Input type:", typeof(lab));
out = lab2uint8(lab);
disp("Output type:", typeof(out));
disp("Output:");
disp(out);
mprintf("\n");


// ==================================================
// Test 6: Single pixel L*a*b* value (uint16 Input)
// ==================================================
disp("Test 6: Single Pixel L*a*b* Value (uint16 Input)");
lab = cat(3, ...
          uint16(32640), ...
          uint16(32768), ...
          uint16(32768));
disp("Input type:", typeof(lab));
out = lab2uint8(lab);
disp("Output type:", typeof(out));
disp("Output:");
disp(out);
mprintf("\n");


// ==================================================
// Test 7: 3-D image with multiple pixels
// ==================================================
disp("Test 7: 3-D L*a*b* Image");
lab = rand(4,4,3);
lab(:,:,1) = lab(:,:,1) * 100;
lab(:,:,2) = lab(:,:,2) * 255 - 128;
lab(:,:,3) = lab(:,:,3) * 255 - 128;
disp("Input type:", typeof(lab));
out = lab2uint8(lab);
disp("Output type:", typeof(out));
disp("Output:");
disp(out);
mprintf("\n");


// ==================================================
// Test 8: Out-of-Range L*a*b* Values (uint16 Input)
// ==================================================
disp("Test 8: Out-of-Range L*a*b* Values (uint16 Input)");
lab = cat(3, ...
          uint16([0 32768; 49152 65535]), ...
          uint16([0 15234; 33425 61767]), ...
          uint16([0 54678; 42252 65535]));
disp("Input type:", typeof(lab));
out = lab2uint8(lab);
disp("Output type:", typeof(out));
disp("Output:");
disp(out);
mprintf("\n");


// ==================================================
// Test 9: Empty Input (should error)
// ==================================================
disp("Test 9: Empty Input");

try
    lab = [];
    out = lab2uint8(lab);
    disp("Output type:", typeof(out));
    disp("Output:", out);
catch
    disp(lasterror());
end

mprintf("\n");


// ==================================================
// Test 10: Invalid 2-D uint8 Input (Should Error)
// ==================================================
disp("Test 10: Invalid 2-D uint8 Input (Should Error)");
try
    lab = uint8([50 60; 70 80]);
    out = lab2uint8(lab);
    disp("Output type:", typeof(out));
    disp("Output:", out);
catch
    disp(lasterror());
end
mprintf("\n");
