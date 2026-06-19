function lab = lab2cls(lab, out_cls)

    nd = ndims(lab);
    sz = size(lab);

    was_image = %f;

    // colormap shape (Mx3)
    if nd == 2 & sz(2) == 3 then

    // MxNx3 image
    elseif nd == 3 & sz(3) == 3 then
        was_image = %t;
       
// Octave compatibility:
// reshape (lab, [sz(1)*sz(2) 3]) is implemented with matrix(lab, sz(1)*sz(2), 3).
// Both use column-major storage, so element ordering is preserved.
        lab = matrix(lab, sz(1)*sz(2), 3);

    // MxNx3xK image
    elseif nd == 4 & sz(3) == 3 then
        was_image = %t;

// Octave compatibility:
// reshape (lab, [sz(1)*sz(2) 3 sz(4)]) is implemented using matrix(lab, [sz(1)*sz(2), 3, sz(4)]).
// Column-major ordering matches Octave reshape behavior.

        lab = matrix(lab, [sz(1)*sz(2), 3, sz(4)]);

    else
        error(msprintf("lab2%s: LAB must be Mx3, MxNx3, or MxNx3xK size", out_cls));
    end

    in_cls = class(lab);

    select out_cls

    // =====================================================
    // double / single output
    // =====================================================
    
// Octave compatibility:
// Octave handles "double" and "single" in a shared code path.
// Scilab separates them because select/case does not support
// Octave's grouped case syntax.

    case "double" then

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

            // already double

        otherwise

            error(msprintf("lab2%s: invalid class %s for LAB", out_cls, in_cls));
        end

    case "single" then

// Octave compatibility:
// Scilab has no native single-precision image class handling
// equivalent to Octave's cast(...,"single").
// Values are converted to double and processed identically.
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

            lab = double(lab);

        otherwise

            error(msprintf("lab2%s: invalid class %s for LAB", out_cls, in_cls));

        end

    // =====================================================
    // uint8 output
    // =====================================================
    case "uint8" then

        select in_cls

        case "double" then

          lab(:,1,:) = lab(:,1,:) * (255 / 100);
          lab(:,2:3,:) = lab(:,2:3,:) + 128;
          
// Octave compatibility:
// Octave uint8() performs saturation when converting from double.
// Explicit clipping is added here before uint8 conversion to ensure
// identical behavior across Scilab versions.

          idx = isnan(lab);
          lab(idx) = 255;

          lab(lab < 0) = 0;
          lab(lab > 255) = 255;

          lab = uint8(round(lab));

    case "uint16" then
        
// Octave compatibility:
// Octave performs division followed by uint8 conversion.
// Explicit double conversion avoids integer arithmetic differences
// between Octave and Scilab.
            lab = uint8(double(lab) / 256);

        case "uint8" then

            // Do nothing.

        otherwise

            error(msprintf("lab2uint8: invalid class for LAB", in_cls));

        end

    // =====================================================
    // uint16 output
    // =====================================================
    case "uint16" then

        select in_cls

        case "double" then

            lab(:,1,:) = lab(:,1,:) * (65280 / 100);

            lab(:,2:3,:) = lab(:,2:3,:) + 128;
            lab(:,2:3,:) = lab(:,2:3,:) * (65280 / 255);
            
// Octave compatibility:
// Explicit clipping and rounding are performed before uint16
// conversion to reproduce Octave saturation behavior reliably.

            idx = isnan(lab);
            lab(idx) = 65535;

            lab(lab < 0) = 0;
            lab(lab > 65535) = 65535;

            lab = uint16(round(lab));
            
        case "uint8" then

            lab = uint16(lab) * 256;

        case "uint16" then

            // Do nothing.

        otherwise

            error(msprintf("lab2uint16: invalid class for LAB", in_cls));

        end

    // =====================================================
    // unsupported output class
    // =====================================================
    otherwise

        error(msprintf("lab2%s: non-supported conversion (internal error)", out_cls));

    end

    // Restore original image shape
    if was_image then
// Octave compatibility:
// matrix(lab,sz) is used as the equivalent of reshape(lab,sz).
// Element ordering remains identical due to column-major storage.
        lab = matrix(lab, sz); 
    end

endfunction

//Helper function

// Octave compatibility helper:
// Provides an Octave-like class() function.
// Scilab numeric arrays are mapped to "double" and image integer
// classes are preserved. The Octave "single" class is not
// distinguished because this implementation represents single
// precision data using double precision values.

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
