base = get_absolute_file_path("phantom_test.sce");
exec(base + "phantom.sci", -1);

//--------------------------------------------------
// TEST 1 : Default Phantom
//--------------------------------------------------
disp("TEST 1 : Default Phantom");

[head,E] = phantom();

disp("Image Size:");
disp(size(head));

disp("Image Sum:");
disp(sum(head));

disp("Mean Intensity:");
disp(mean(head));

disp("Output:");
disp(E);

mprintf("\n");

//--------------------------------------------------
// TEST 2 : Small Image (N = 8)
//--------------------------------------------------
disp("TEST 2 : Small Image (N = 8)");

head = phantom(8);

disp("Image Size:");
disp(size(head));

disp("Image Sum:");
disp(sum(head));

disp("Output:");
disp(head);

mprintf("\n");

//--------------------------------------------------
// TEST 3 : 90 Degree Rotation
//--------------------------------------------------
disp("TEST 3 : 90 Degree Rotation");

E = [
1 0.55 0.20 0 0 90
];

[head,ell] = phantom(E,128);

disp("Image Size:");
disp(size(head));

disp("Image Sum:");
disp(sum(head));

disp("Center Pixel:");
disp(head(64,64));

disp("Non-zero Pixels:");
disp(length(find(head)));

mprintf("\n");

//--------------------------------------------------
// TEST 4 : Shepp-Logan Phantom
//--------------------------------------------------
disp("TEST 4 : Shepp-Logan Phantom");

[head,E] = phantom("shepp-logan");

disp("Image Size:");
disp(size(head));

disp("Minimum Intensity:");
disp(min(head));

disp("Maximum Intensity:");
disp(max(head));

disp("Output:");
disp(E);

mprintf("\n");

//--------------------------------------------------
// TEST 5 : Negative Intensity Ellipse
//--------------------------------------------------
disp("TEST 5 : Negative Intensity Ellipse");

E = [
-0.8 0.40 0.30 0 0 0
];

[head,ell] = phantom(E,128);

disp("Image Size:");
disp(size(head));

disp("Minimum Intensity:");
disp(min(head));

disp("Maximum Intensity:");
disp(max(head));

disp("Image Sum:");
disp(sum(head));

mprintf("\n");

//--------------------------------------------------
// TEST 6 : Ellipse Partially Outside Image
//--------------------------------------------------
disp("TEST 6 : Ellipse Partially Outside Image");

E = [
1 0.40 0.30 0.80 0 0
];

[head,ell] = phantom(E,128);

disp("Image Size:");
disp(size(head));

disp("Image Sum:");
disp(sum(head));

disp("Non-zero Pixels:");
disp(length(find(head)));

mprintf("\n");

//--------------------------------------------------
// TEST 7 : Rotated and Shifted Ellipses
//--------------------------------------------------
disp("TEST 7 : Rotated and Shifted Ellipses");

E = [
 1.0   0.35 0.15 -0.30  0.20  30
-0.5   0.20 0.10  0.30 -0.20 -45
];

[head,ell] = phantom(E,256);

disp("Image Size:");
disp(size(head));

disp("Image Sum:");
disp(sum(head));

disp("Center Pixel:");
disp(head(128,128));

mprintf("\n");

//--------------------------------------------------
// TEST 8 : Overlapping Ellipses
//--------------------------------------------------
disp("TEST 8 : Overlapping Ellipses");

E = [
1.0 0.40 0.40 0 0 0
0.7 0.40 0.40 0 0 0
];

[head,ell] = phantom(E,101);

disp("Image Size:");
disp(size(head));

disp("Maximum Intensity:");
disp(max(head));

disp("Non-zero Pixels:");
disp(length(find(head)));

disp("Image Sum:");
disp(sum(head));

mprintf("\n");

//--------------------------------------------------
// TEST 9 : Ellipses Completely Outside Image
//--------------------------------------------------
disp("TEST 9 : Ellipses Completely Outside Image");

E = [
1.0 0.20 0.20 3 3 0
];

[head,ell] = phantom(E,128);

disp("Image Size:");
disp(size(head));

disp("Image Sum:");
disp(sum(head));

disp("Non-zero Pixels:");
disp(length(find(head)));

mprintf("\n");

//--------------------------------------------------
// TEST 10 : Invalid Inputs
//--------------------------------------------------
disp("TEST 10 : Invalid Inputs");

//--------------------------------------------------
disp("Case 1 : Invalid Model");

disp("Status:");
try
    phantom("brain");
    disp("PASS");
catch
    disp("ERROR");
    disp(lasterror());
end

mprintf("\n");

//--------------------------------------------------
disp("Case 2 : Invalid Ellipse Matrix");

disp("Status:");
try
    phantom(rand(4,5));
    disp("PASS");
catch
    disp("ERROR");
    disp(lasterror());
end

mprintf("\n");

//--------------------------------------------------
disp("Case 3 : Invalid Numeric Input");

disp("Status:");
try
    phantom(64.5);
    disp("PASS");
catch
    disp("ERROR");
    disp(lasterror());
end

mprintf("\n");

//--------------------------------------------------
disp("Case 4 : Invalid Second Argument");

disp("Status:");
try
    phantom("shepp-logan","abc");
    disp("PASS");
catch
    disp("ERROR");
    disp(lasterror());
end

mprintf("\n");

//--------------------------------------------------
disp("Case 5 : Too Many Inputs");

disp("Status:");
try
    phantom(64,64,64);
    disp("PASS");
catch
    disp("ERROR");
    disp(lasterror());
end

mprintf("\n");
