function [head, ellipses] = phantom(varargin)

    rhs = argn(2);

    if rhs > 2 then
        error("phantom: Invalid call to phantom.");
    end

    // Defaults
    ellipses = mod_shepp_logan();
    n = 256;

    if rhs <> 0 then

        // First input argument
        in = varargin(1);

        // Check if input is a string
        if typeof(in) == "string" then

            select convstr(in, "l")

            case "shepp-logan" then
                ellipses = shepp_logan();

            case "modified shepp-logan" then
                ellipses = mod_shepp_logan();

            else
                error(msprintf("phantom: unknown MODEL `%s''", in));

            end

        // Check if input is an ellipse matrix
        elseif isnumeric(in) & ndims(in) == 2 & size(in,2) == 6 then

            ellipses = in;

        // Check if input is N
        elseif chk_n(in) then

            n = in;

            // If N is the first argument, we can't have more
            if rhs > 1 then
                error("phantom: Invalid call to phantom.");
            end

        else

            error("phantom: first argument must either be MODEL, E, or N");

        end

        // If there is a second input argument, must be N
        if rhs > 1 then

            if chk_n(varargin(2)) then

                n = varargin(2);

            else

                error("phantom: N must be numeric scalar");

            end

        end

    end

    // Initialize blank image
    head = zeros(n, n);

    // Create the pixel grid
    xvals = -1 : 2/(n-1) : 1;

    xgrid = repmat(xvals, n, 1);

    for i = 1:size(ellipses, 1)

        I   = ellipses(i,1);
        a2  = ellipses(i,2)^2;
        b2  = ellipses(i,3)^2;
        x0  = ellipses(i,4);
        y0  = ellipses(i,5);
        phi = ellipses(i,6) * %pi / 180;  
        
        // Create the offset x and y values for the grid
        x = xgrid - x0;
        y = flipdim(xgrid', 1) - y0;

        cos_p = cos(phi);
        sin_p = sin(phi);

        // Find the pixels within the ellipse
        locs = find(((x .* cos_p + y .* sin_p).^2) ./ a2 ...
            + ((y .* cos_p - x .* sin_p).^2) ./ b2 <= 1);

        // Add the ellipse intensity to those pixels
        if ~isempty(locs) then
            head(locs) = head(locs) + I;
        end

    end

endfunction


function ellipses = shepp_logan()
    ellipses = [ 1     0.69    0.92     0      0         0
                -0.98  0.6624  0.874    0     -0.0184    0
                -0.02  0.11    0.31     0.22   0       -18
                -0.02  0.16    0.41    -0.22   0        18
                 0.01  0.21    0.25     0      0.35      0
                 0.01  0.046   0.046    0      0.1       0
                 0.01  0.046   0.046    0     -0.1       0
                 0.01  0.046   0.023   -0.08  -0.605     0
                 0.01  0.023   0.023    0     -0.606     0
                 0.01  0.023   0.046    0.06  -0.605     0];
endfunction


function ellipses = mod_shepp_logan()
    ellipses = [ 1.0   0.69    0.92     0.0    0.0       0
                -0.8   0.6624  0.874    0.0   -0.0184    0
                -0.2   0.11    0.31     0.22   0.0     -18
                -0.2   0.16    0.41    -0.22   0.0      18
                 0.1   0.21    0.25     0.0    0.35      0
                 0.1   0.046   0.046    0.0    0.1       0
                 0.1   0.046   0.046    0.0   -0.1       0
                 0.1   0.046   0.023   -0.08  -0.605     0
                 0.1   0.023   0.023    0.0   -0.606     0
                 0.1   0.023   0.046    0.06  -0.605     0];
endfunction


// Helper functions
function tf = isnumeric(x)

    tf = or(typeof(x) == [ ...
        "constant", ...
        "int8",  "uint8", ...
        "int16", "uint16", ...
        "int32", "uint32", ...
        "int64", "uint64", ...
        "sparse"]);

endfunction

function tf = chk_n(x)

    tf = isnumeric(x) & isscalar(x) & ceil(x) == x;

endfunction
