function [im2] = im2double(im)
    //    Convert image to double precision
    //
    //    Syntax
    //      im2 = im2double(im)
    //
    //    Parameters
    //      im : An matrix/image, which can be ANY image supported by IPCV.
    //      im2 : Output image, a double precision matrix.
    //
    //    Description
    //      im2double convert intensity or RGB images to double precision. 
    //      If the input is of class double, the output image is identical to it. 
    //      Otherwise, im2double rescales or offsets the data, and returns the equivalent image of class double.

    imtype = typeof(im);

    select imtype
    case 'boolean' then
        im2 = double(im);
    case 'uint8' then
        im2 = double(im) / 255.0;
    case 'int8' then
        im2 = (double(im) + 128) / 255.0;
    case 'uint16' then
        im2 = double(im) / (2^16-1);
    case 'int16' then
        im2 = (double(im) + 2^15) / (2^16-1);
    case 'uint32' then
        im2 = double(im) / (2^32-1);
    case 'int32' then
        im2 = (double(im) + 2^31) / (2^32-1);
    case 'constant' then
        im(im>1.0) = 1.0;
        im(im<0.0) = 0.0;
        im2 = im;
    else
        error("Data type is not supported.");
    end
endfunction
