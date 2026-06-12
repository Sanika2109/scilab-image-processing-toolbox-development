base = get_absolute_file_path("lab2uint8_test.sce");
exec(base + "../lab2uint8/lab2cls.sci", -1);
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
// Test 2: Minimum valid L*a*b* values
// ==================================================
disp("Test 2: Minimum Valid Values");
lab = cat(3, zeros(2,2), -128*ones(2,2), -128*ones(2,2));
disp("Input type:", typeof(lab));
out = lab2uint8(lab);
disp("Output:");
disp(out);
mprintf("\n");


// ==================================================
// Test 3: Maximum valid L*a*b* values
// ==================================================
disp("Test 3: Maximum Valid Values");
lab = cat(3, 100*ones(2,2), 127*ones(2,2), 127*ones(2,2));
disp("Input type:", typeof(lab));
out = lab2uint8(lab);
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
disp("Output:");
disp(out);
mprintf("\n");


// ==================================================
// Test 5: Integer input
// ==================================================
disp("Test 5: Integer Input");
lab = cat(3, ...
          [0 50; 75 100], ...
          [-128 0; 50 127], ...
          [-128 0; 50 127]);
disp("Input type:", typeof(lab));
out = lab2uint8(lab);
disp("Output:");
disp(out);
mprintf("\n");


// ==================================================
// Test 6: Single pixel L*a*b* value
// ==================================================
disp("Test 6: Single Pixel");
lab = cat(3, 50, 0, 0);
disp("Input type:", typeof(lab));
out = lab2uint8(lab);
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
disp("Output size:");
disp(size(out));
mprintf("\n");


// ==================================================
// Test 8: Values outside nominal range
// ==================================================
disp("Test 8: Out-of-Range Values");
lab = cat(3, ...
          [-10 120; 150 -20], ...
          [-200 200; -150 150], ...
          [-250 250; -180 180]);
disp("Input type:", typeof(lab));
out = lab2uint8(lab);
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
    disp(out);
catch
    disp(lasterror());
end

mprintf("\n");


// ==================================================
// Test 10: Invalid 2-D input (should error)
// ==================================================
disp("Test 10: Invalid 2-D Input");
try
    lab = [50 60; 70 80];
    out = lab2uint8(lab);
    disp(out);
catch
    disp(lasterror());
end
mprintf("\n");
