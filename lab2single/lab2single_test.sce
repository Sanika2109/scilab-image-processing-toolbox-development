base = get_absolute_file_path("lab2single_test.sce");
exec(base + "../lab2cls/lab2cls.sci", -1);
exec(base + "lab2single.sci", -1);

//Test 1: uint8 LAB Colormap
disp("Test 1: uint8 LAB Colormap");

lab = uint8([255 128 128;
             0   128 128]);

out = lab2single(lab);

disp("Output type:");
disp(typeof(out));

disp("Output:");
disp(out);

//Test 2: uint16 LAB Colormap
disp("Test 2: uint16 LAB Colormap");

lab = uint16([65280 32768 32768;
                  0 32768 32768]);

out = lab2single(lab);

disp("Output:");
disp(out);

//Test 3: Double Input
disp("Test 3: Double Input");

lab = [50 10 -10;
       75 20  30];

out = lab2single(lab);

disp("Output:");
disp(out);

//Test 4: MxNx3 Image
disp("Test 4: MxNx3 Image");

lab = cat(3,...
          [0 50;100 25],...
          [0 10;20 30],...
          [0 -10;40 -20]);

out = lab2single(lab);

disp(size(out));
disp(out);

//Test 5: uint8 Image
disp("Test 5: uint8 Image");

lab = cat(3,...
          uint8([0 255;128 64]),...
          uint8([128 255;0 128]),...
          uint8([128 0;255 128]));

out = lab2single(lab);

disp("Output:");
disp(out);

//Test 6: 4-D LAB Image
disp("Test 6: 4-D LAB Image");

lab = rand(2,2,3,2);

out = lab2single(lab);

disp("Input size:");
disp(size(lab));

disp("Output size:");
disp(size(out));

//Test 7: Invalid Dimensions
disp("Test 7: Invalid Dimensions");

try
    lab = rand(3,3);
    lab2single(lab);
catch
    disp(lasterror());
end

//Test 8: Invalid Class
disp("Test 8: Invalid Class");

try
    lab2single("hello");
catch
    disp(lasterror());
end

//Test 9: Output Type
disp("Test 9: Output Type");

lab = uint8([255 128 128]);

out = lab2single(lab);

disp(typeof(out));
