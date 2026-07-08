function lab = lab2cls(lab, out_cls)

    nd = ndims(lab);
    sz = size(lab);

    was_image = %f;

    // Mx3 colormap
    if nd == 2 & sz(2) == 3 then

    // MxNx3 image
    elseif nd == 3 & sz(3) == 3 then
        was_image = %t;
        lab = matrix(lab, sz(1)*sz(2), 3);

    // MxNx3xK image stack
    elseif nd == 4 & sz(3) == 3 then
        was_image = %t;
        lab = matrix(lab, [sz(1)*sz(2), 3, sz(4)]);

    else
        error(msprintf("lab2%s: LAB must be Mx3, MxNx3, or MxNx3xK size", out_cls));
    end

    in_cls = class(lab);

    select out_cls

    // =====================================================
    // Convert to double
    // =====================================================

    case "double" then

        lab = double(lab);

        select in_cls

        case "uint8" then

            // Rescale L*, a*, and b* channels
            lab(:,1,:) = lab(:,1,:) * (100 / 255);
            lab(:,2:3,:) = lab(:,2:3,:) - 128;

        case "uint16" then

            lab(:,1,:) = lab(:,1,:) * (100 / 65280);
            lab(:,2:3,:) = lab(:,2:3,:) * (255 / 65280);
            lab(:,2:3,:) = lab(:,2:3,:) - 128;

        case "double" then

            // Already double

        otherwise

            error(msprintf("lab2%s: invalid class %s for LAB", out_cls, in_cls));
        end

    case "single" then

        // Scilab does not support native single-precision arrays.
        // Processing is performed using double precision.

        lab = double(lab);

        select in_cls

        case "uint8" then

            lab(:,1,:) = lab(:,1,:) * (100 / 255);
            lab(:,2:3,:) = lab(:,2:3,:) - 128;

        case "uint16" then

            lab(:,1,:) = lab(:,1,:) * (100 / 65280);
            lab(:,2:3,:) = lab(:,2:3,:) * (255 / 65280);
            lab(:,2:3,:) = lab(:,2:3,:) - 128;

        case "double" then

            // Already double

        otherwise

            error(msprintf("lab2%s: invalid class %s for LAB", out_cls, in_cls));

        end

    // =====================================================
    // Convert to uint8
    // =====================================================
    case "uint8" then

        select in_cls

        case "double" then

            lab(:,1,:) = lab(:,1,:) * (255 / 100);
            lab(:,2:3,:) = lab(:,2:3,:) + 128;

            // Clip values to the valid uint8 range before conversion
            idx = isnan(lab);
            lab(idx) = 255;

            lab(lab < 0) = 0;
            lab(lab > 255) = 255;

            lab = uint8(round(lab));

        case "uint16" then

            // Reduce precision from 16-bit to 8-bit
            lab = uint8(double(lab) / 256);

        case "uint8" then

            // Already uint8

        otherwise

            error(msprintf("lab2uint8: invalid class for LAB", in_cls));

        end

    // =====================================================
    // Convert to uint16
    // =====================================================
    case "uint16" then

        select in_cls

        case "double" then

            lab(:,1,:) = lab(:,1,:) * (65280 / 100);

            lab(:,2:3,:) = lab(:,2:3,:) + 128;
            lab(:,2:3,:) = lab(:,2:3,:) * (65280 / 255);

            // Clip values to the valid uint16 range before conversion
            idx = isnan(lab);
            lab(idx) = 65535;

            lab(lab < 0) = 0;
            lab(lab > 65535) = 65535;

            lab = uint16(round(lab));

        case "uint8" then

            // Expand 8-bit values to 16-bit
            lab = uint16(lab) * 256;

        case "uint16" then

            // Already uint16

        otherwise

            error(msprintf("lab2uint16: invalid class for LAB", in_cls));

        end

    // =====================================================
    // Unsupported output class
    // =====================================================
    otherwise

        error(msprintf("lab2%s: non-supported conversion (internal error)", out_cls));

    end

    // Restore the original image dimensions
    if was_image then
        lab = matrix(lab, sz);
    end

endfunction

// Helper function to determine the data class
function cls = class(x)

    t = typeof(x);

    if t == "constant" then
        cls = "double";
    elseif t == "uint8" then
        cls = "uint8";
    elseif t == "uint16" then
        cls = "uint16";
    else
        cls = t;
    end

endfunction
