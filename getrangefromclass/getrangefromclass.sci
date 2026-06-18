function r = getrangefromclass(img)

    if argn(2) <> 1 then
        error("getrangefromclass: IMG must be an image.");
    elseif (~isimage(img))
        error ("getrangefromclass: IMG must be an image");  
    end

    cl = typeof(img); //Scilab equivalent of class 

    if isinteger(img) then
        r = [intmin(cl) intmax(cl)];

    // Octave class names "double" and "logical" correspond to
    // typeof() values "constant" and "boolean" in Scilab.
    // Scilab doesn't have a "single" datatype
    // strcmp() causes a size-mismatch error for scalar-to-vector string comparisons in Scilab.
    // Therefore, element-wise comparison with or() is used instead.
    elseif or(cl == ["constant" "boolean"]) then
        r = [0 1];
    else
        error(msprintf("getrangefromclass: unrecognized image class ", cl));
    end

    r = double(r);

endfunction

//Helper functions

// isinteger
function isint = isinteger(x)
    isint = or(typeof(x) == ["int8","uint8","int16","uint16","int32","uint32","int64","uint64"]);
endfunction

//isimage
function tf = isimage(img)

    tf = %f;

    t = typeof(img);

    validTypes = ["constant", ...
                  "uint8", "uint16", "uint32", "uint64", ...
                  "int8", "int16", "int32", "int64", ...
                  "boolean"];

    if ~or(t == validTypes) then
        return;
    end

    sz = size(img);

    if length(sz) == 2 & min(sz) > 0 then
        tf = %t;

    elseif length(sz) == 3 & min(sz) > 0 then
        if sz(3) == 3 | sz(3) == 4 then
            tf = %t;
        end
    end

endfunction
