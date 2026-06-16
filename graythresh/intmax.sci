function Imax = intmax(varargin)

    rhs = argn(2);

    // Default: int32
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
        error("intmax: Wrong number of input arguments.");
    end

    select cl

    case "int8" then
        Imax = 127;

    case "int16" then
        Imax = 32767;

    case "int32" then
        Imax = 2147483647;

    case "int64" then
        Imax = 9223372036854775807;

    case "uint8" then
        Imax = 255;

    case "uint16" then
        Imax = 65535;

    case "uint32" then
        Imax = 4294967295;

    case "uint64" then
        Imax = 18446744073709551615;

    else
        error(msprintf("intmax: invalid integer type", cl));

    end

endfunction
