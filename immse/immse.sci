function mse = immse(x, y)

    // if (nargin != 2)
    if argn(2) <> 2 then
        error("immse: Wrong number of input arguments.");
    end

    // elseif (! size_equal (x, y))
    elseif or(size(x) <> size(y)) then
        error("immse: X and Y must be of same size");
    end

    // elseif (! strcmp (class (x), class (y)))
    if typeof(x) <> typeof(y) then
        error("immse: X and Y must have same class");
    end

    // if (isinteger (x))
    if isinteger(x) then
        x = double(x);
        y = double(y);
    end

    // err = x - y;
    err = x - y;

    // mse = sumsq (err(:)) / numel (err);
    mse = sumsq(matrix(err, -1, 1)) / numel(err);

endfunction

//Helper Functions
//isinteger function
function isint = isinteger(x)
    isint = or(typeof(x) == ["int8","uint8","int16","uint16","int32","uint32","int64","uint64"]);
endfunction

//sumsq function
function s = sumsq(x)
    s = sum(x(:).^2);
endfunction

//numel function
function n = numel(x)
    n = size(x, "*");
endfunction
