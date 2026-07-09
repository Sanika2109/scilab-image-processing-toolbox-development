function [lab] = lab2cls(lab, out_cls)

  nd = ndims(lab);
  sz = size(lab);

  was_image = %f;
  is_3d = %f;
  
  if (nd == 2 & sz(2) == 3) then // colormap shape
    // Do nothing, it is already shaped.
  elseif (nd == 3 & sz(3) == 3) then // MxNx3 image
    was_image = %t;
    lab = matrix(lab, sz(1)*sz(2), 3);
  elseif (nd == 4 & sz(3) == 3) then // MxNx3xK image
    was_image = %t;
    is_3d = %t;
    lab = matrix(lab, [sz(1)*sz(2), 3, sz(4)]);
  else
    error("lab2: LAB must be Mx3, MxNx3, or MxNx3xK size");
  end

  in_cls = typeof(lab);
  if in_cls == "constant" then
      in_cls = "double";
  end
  
  if out_cls == "single" then
      out_cls = "double";
  end

  select out_cls
    case "double" then
      lab = double(lab);
      select in_cls
        case "uint8" then
          if is_3d then
            lab(:, 1, :) = lab(:, 1, :) * (100 / 255);
            lab(:, [2, 3], :) = lab(:, [2, 3], :) - 128;
          else
            lab(:, 1) = lab(:, 1) * (100 / 255);
            lab(:, [2, 3]) = lab(:, [2, 3]) - 128;
          end
        case "uint16" then
          if is_3d then
            lab(:, 1, :) = lab(:, 1, :) * (100 / 65280);
            lab(:, [2, 3], :) = lab(:, [2, 3], :) * (255 / 65280);
            lab(:, [2, 3], :) = lab(:, [2, 3], :) - 128;
          else
            lab(:, 1) = lab(:, 1) * (100 / 65280);
            lab(:, [2, 3]) = lab(:, [2, 3]) * (255 / 65280);
            lab(:, [2, 3]) = lab(:, [2, 3]) - 128;
          end
        case "double" then
          // Do nothing, we already casted to the other type.
        else
          error("lab2: invalid class for LAB");
      end

    case "uint8" then
      select in_cls
        case "double" then
          if is_3d then
            lab(:, 1, :) = lab(:, 1, :) * (255 / 100);
            lab(:, [2, 3], :) = lab(:, [2, 3], :) + 128;
          else
            lab(:, 1) = lab(:, 1) * (255 / 100);
            lab(:, [2, 3]) = lab(:, [2, 3]) + 128;
          end
          lab(isnan(lab)) = 255; 
          
          // Explicitly round and saturate before cast --
          lab = round(lab);
          lab(lab < 0) = 0;
          lab(lab > 255) = 255;
          lab = uint8(lab);
          
        case "uint16" then
          lab = double(lab) / 256; 
          
          // Explicitly round and saturate before cast --
          lab = round(lab);
          lab(lab < 0) = 0;
          lab(lab > 255) = 255;
          lab = uint8(lab);
          
        case "uint8" then
          // Do nothing.
        else
          error("lab2uint8: invalid class for LAB");
      end

    case "uint16" then
      select in_cls
        case "double" then
          if is_3d then
            lab(:, 1, :) = lab(:, 1, :) * (65280 / 100);
            lab(:, [2, 3], :) = lab(:, [2, 3], :) + 128;
            lab(:, [2, 3], :) = lab(:, [2, 3], :) * (65280 / 255);
          else
            lab(:, 1) = lab(:, 1) * (65280 / 100);
            lab(:, [2, 3]) = lab(:, [2, 3]) + 128;
            lab(:, [2, 3]) = lab(:, [2, 3]) * (65280 / 255);
          end
          lab(isnan(lab)) = 65535; 
          
          // Explicitly round and saturate before cast --
          lab = round(lab);
          lab(lab < 0) = 0;
          lab(lab > 65535) = 65535;
          lab = uint16(lab);
          
        case "uint8" then
          lab = uint16(lab) * 256;
        case "uint16" then
          // Do nothing.
        else
          error("lab2uint16: invalid class for LAB");
      end

    else
      error("lab2: non-supported conversion (internal error)");
  end

  if was_image then
    lab = matrix(lab, sz);
  end

endfunction
