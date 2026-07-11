function [G] = rgb2gray(RGB)
    //    Convert RGB images to gray images
    //    
    //    Syntax
    //      G = rgb2gray(RGB)
    //    
    //    Parameters
    //      RGB : A RGB image (hypermat), the dimension of RGB should be M x N x 3 .
    //      G : Output image, a gray image which dimension is M x N and has the same data type as RGB .
    //    
    //    Description
    //      rgb2gry convert RGB images to gray scale images using G = 0.299*R + 0.587*G + 0.114*B. 
   
    dims = size(RGB);
    typeofrgb = typeof(RGB(1));

    //check whether RGB is a MxNx3 hypermat
    if (size(dims,2)== 3) then
        if (dims(3)<>3) then
            mprintf("%s\n","Input image is not a RGB image, output remained the same as input.");
            G = RGB;
        end
        G = int_rgb2gray(RGB)
//        //convert the image to double image first
//        RGB = im2double(RGB);
//
//        //convert to gray scale
//        G =  0.299*RGB(:,:,1) + 0.587*RGB(:,:,2) + 0.114*RGB(:,:,3);
//
//        select typeofrgb
//        case 'uint8' then
//            G = im2uint8(G);
//        case 'int8' then
//            G = im2int8(G);
//        case 'uint16' then
//            G = im2uint16(G);
//        case 'int16' then
//            G = im2int16(G);
//        case 'int32' then
//            G = im2int32(G);
//        case 'constant' then
//            G = im2double(G);
//        else
//            error("Data type " + imtype + " is not supported.");
//        end //end select

    else //if not size(dims,'2') == 3
            mprintf("%s\n","Input image is not a RGB image, output remained the same as input.");
            G = RGB;
    end
endfunction
