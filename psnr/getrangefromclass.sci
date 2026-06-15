function r = getrangefromclass(img)

    if argn(2) <> 1 then
        error("getrangefromclass: IMG must be an image.");
    end

    cl = typeof(img); //equivalent of class

    if isinteger(img) then
        r = [intmin(cl) intmax(cl)];
    elseif or(cl == ["constant", "boolean"]) then
        r = [0 1];
    else
        error(msprintf("getrangefromclass: unrecognized image class", cl));
    end

    r = double(r);

endfunction

function isint = isinteger(x)
    isint = or(typeof(x) == ["int8","uint8","int16","uint16","int32","uint32","int64","uint64"]);
endfunction
