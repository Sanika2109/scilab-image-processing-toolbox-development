base = get_absolute_file_path("getrangefromclass_test.sce");
exec(base + "../intmin/intmin.sci", -1);
exec(base + "../intmax/intmax.sci", -1);
exec(base + "getrangefromclass.sci", -1);

//Test Image
ImgTest = imread("cameraman.jpeg");

// ==================================================
// Test 1: uint8 image
// ==================================================
disp("Test 1: uint8 Image");
I = uint8([1 2; 3 4]);
disp("Input type:", typeof(I));
r = getrangefromclass(I);
disp("Output type:", typeof(r));
disp("Range:", r);
mprintf("\n");

// ==================================================
// Test 2: int8 image
// ==================================================
disp("Test 2: int8 Image");
I = int8([1 -2; 3 -4]);
disp("Input type:", typeof(I));
r = getrangefromclass(I);
disp("Output type:", typeof(r));
disp("Range:", r);
mprintf("\n");

// ==================================================
// Test 3: uint16 image
// ==================================================
disp("Test 3: uint16 Image");
I = uint16([1 2; 3 4]);
disp("Input type:", typeof(I));
r = getrangefromclass(I);
disp("Output type:", typeof(r));
disp("Range:", r);
mprintf("\n");

// ==================================================
// Test 4: int16 image
// ==================================================
disp("Test 4: int16 Image");
I = int16([1 -2; 3 -4]);
disp("Input type:", typeof(I));
r = getrangefromclass(I);
disp("Output type:", typeof(r));
disp("Range:", r);
mprintf("\n");

// ==================================================
// Test 5: uint32 image
// ==================================================
disp("Test 5: uint32 Image");
I = uint32([1 2; 3 4]);
disp("Input type:", typeof(I));
r = getrangefromclass(I);
disp("Output type:", typeof(r));
disp("Range:", r);
mprintf("\n");

// ==================================================
// Test 6: int32 image
// ==================================================
disp("Test 6: int32 Image");
I = int32([1 -2; 3 -4]);
disp("Input type:", typeof(I));
r = getrangefromclass(I);
disp("Output type:", typeof(r));
disp("Range:", r);
mprintf("\n");

// ==================================================
// Test 7: uint64 Image
// ==================================================
disp("Test 7: uint64 Image");
I = uint64([1 2; 3 4]);
disp("Input type:", typeof(I));
r = getrangefromclass(I);
disp("Output type:", typeof(r));
disp("Range:", r);
mprintf("\n");

// ==================================================
// Test 8: int64 Image
// ==================================================
disp("Test 8: int64 Image");
I = int64([1 -2; 3 -4]);
disp("Input type:", typeof(I));
r = getrangefromclass(I);
disp("Output type:", typeof(r));
disp("Range:", r);
mprintf("\n");

// ==================================================
// Test 9: Double image
// ==================================================
disp("Test 9: Double Image");
I = rand(5,5);
disp("Input type:", typeof(I));
r = getrangefromclass(I);
disp("Output type:", typeof(r));
disp("Range:", r);
mprintf("\n");

// ==================================================
// Test 10: Boolean image
// ==================================================
disp("Test 10: Boolean Image");
I = [%t %f; %f %t];
disp("Input type:", typeof(I));
r = getrangefromclass(I);
disp("Output type:", typeof(r));
disp("Range:", r);
mprintf("\n");

// ==================================================
// Test 11: Actual Grayscale Image
// ==================================================
disp("Test 11: Actual Grayscale Image");
I = ImgTest;
disp("Input type:", typeof(I));  
r = getrangefromclass(I);
disp("Output type:", typeof(r));
disp("Range:", r);
mprintf("\n");

// ==================================================
// Test 12: Empty Image (Error)
// ==================================================
disp("Test 12: Empty Image");
try
    getrangefromclass([]);
catch
    disp(lasterror());
end
mprintf("\n");

// ==================================================
// Test 13: String Input (Error)
// ==================================================
disp("Test 13: String Input");
try
    getrangefromclass("hello");
catch
    disp(lasterror());
end
mprintf("\n");

// ==================================================
// Test 14: List Input (Error)
// ==================================================
disp("Test 14: List Input");
try
    getrangefromclass(list(1,2,3));
catch
    disp(lasterror());
end
mprintf("\n");

// ==================================================
// Test 15: No Input (Error)
// ==================================================
disp("Test 15: No Input");
try
    getrangefromclass();
catch
    disp(lasterror());
end
mprintf("\n");
