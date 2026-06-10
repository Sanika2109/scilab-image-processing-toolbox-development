function r = getrangefromclass(img)

    // Validate number of input arguments
    if argn(2) <> 1 then
        error("getrangefromclass: IMG must be an image.");
    end

    cl = typeof(img); // Scilab data type for 'class'

    // Return full range for integer image classes
    if isinteger(img) then
        r = [intmin(cl) intmax(cl)];

    // Floating-point ("constant") and boolean images are assumed in [0,1]
    elseif or(cl == ["constant", "boolean"]) then
        r = [0 1];

    else
        error(msprintf("getrangefromclass: unrecognized image class", cl));
    end

    // Ensure output is returned as double
    r = double(r);

endfunction

//Helper function
//isinteger function
function isint = isinteger(x)

    // Check whether input belongs to any supported integer class
    isint = or(typeof(x) == ["int8","uint8","int16","uint16","int32","uint32","int64","uint64"]);

endfunction
