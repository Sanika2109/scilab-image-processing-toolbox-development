function Imin = intmin(varargin)

    rhs = argn(2);

    if rhs == 0 then
        cl = "int32";

    elseif rhs == 1 then

        x = varargin(1);

        if typeof(x) == "string" then
            cl = x;
        else
            cl = typeof(x);
        end

    else
        error("intmin: Wrong number of input arguments.");
    end

    select cl

    case "int8" then
        Imin = -128;

    case "int16" then
        Imin = -32768;

    case "int32" then
        Imin = -2147483648;

    case "int64" then
        Imin = -9223372036854775808;

    case "uint8" then
        Imin = 0;

    case "uint16" then
        Imin = 0;

    case "uint32" then
        Imin = 0;

    case "uint64" then
        Imin = 0;

    else
        error(msprintf("intmin: invalid integer type", cl));

    end

endfunction
