function [im2] = im2uint8(im)
    //    Convert image to 8-bit unsigned integers
    //    
    //    Syntax
    //      im2 = im2uint8(im)
    //    
    //    Parameters
    //      im : An matrix/image, which can be ANY image supported by IPCV.
    //      im2 : Output image, an 8-bit unsigned integer matrix.
    //    
    //    Description
    //      im2uint8 convert intensity or RGB images to 8-bit unsigned integers. 
    //      If the input is of class uint8, the output image is identical to it. 
    //      Otherwise, im2uint8 rescales or offsets the data, and returns the equivalent image of class uint8.
 
    imtype = typeof(im(1));

    select imtype
    case 'boolean' then
        im2 = uint8(im*255);
    case 'uint8' then
        im2 = im;
    case 'int8' then
        im2 = uint8(im)+128;
    case 'uint16' then
        im2 = uint8(round(double(im)*(2^8-1)/(2^16-1)));
    case 'int16' then
        im2 = uint8(round((double(im) + 2^15)*(2^8-1)/(2^16-1)));
    case 'int32' then
        im2 = uint8(round((double(im)+2^31) * (2^8-1)/(2^32-1)));
    case 'constant' then
        im(im>1.0) = 1.0;
        im(im<0.0) = 0.0;
        im2 = uint8(round(im * 255));
    else
        error("Data type is not supported.");
    end
endfunction
