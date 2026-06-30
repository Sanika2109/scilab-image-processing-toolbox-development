function low_high = stretchlim(img, tol)

    rhs = argn(2);

    if rhs < 2 then
        tol = [0.01 0.99];
    end

    if rhs < 1 | rhs > 2 then
        error("stretchlim: invalid number of arguments");
    end

    if ~isimage(img) then
        error("stretchlim: I or RGB must be an image");
    end

    // Preserve input type for normalization
    img_type = typeof(img);

    // Validate tolerance input
    if rhs > 1 then
        if ~isnumeric(tol) then
            error("stretchlim: TOL must be numeric");
        end

        if isscalar(tol) then

            if tol < 0 | tol > 0.5 then
                error("stretchlim: TOL must be in the [0 0.5] range");
            end

            tol = [tol 1-tol];

        elseif isvector(tol) then

            if numel(tol) <> 2 then
                error("stretchlim: TOL must be a 2 element vector");
            end

            if min(tol) < 0 | max(tol) > 1 then
                error("stretchlim: TOL must be in the [0 1] range");
            end

            if tol(1) > tol(2) then
                error("stretchlim: TOL(1) must not exceed TOL(2)");
            end

        else
            error("stretchlim: TOL must be a scalar or 2-element vector");
        end
    end

    // Reshape image so that each image plane becomes a column
    sz = postpad(size(img), max(3, ndims(img)), 1);
    plane_length = sz(1) * sz(2);
    img = matrix(img, [plane_length sz(3:$)]);

    // Compute percentile indices
    lo_idx = floor(tol(1) * plane_length) + 1;
    hi_idx = ceil(tol(2) * plane_length);

    // Clamp indices to valid range
    if lo_idx > plane_length then
        lo_idx = plane_length;
    end

    if hi_idx > plane_length then
        hi_idx = plane_length;
    end

    if lo_idx < 1 then
        lo_idx = 1;
    end

    if hi_idx < 1 then
        hi_idx = 1;
    end

    // Use min/max directly when full intensity range is requested
    if lo_idx == 1 & hi_idx == plane_length then

        low_high = [min(img, "r"); max(img, "r")];

    else

        // Sort each image plane independently
        sorted = zeros(size(img,1), size(img,2));

        for k = 1:size(img,2)
            sorted(:,k) = gsort(double(img(:,k)), "g", "i");
        end

        low_high = zeros(2, size(img,2));

        for k = 1:size(img,2)
            low_high(1,k) = sorted(lo_idx,k);
            low_high(2,k) = sorted(hi_idx,k);
        end

    end

    // Normalize limits to the [0,1] range
    select img_type

    case "boolean" then
        low_high = double(low_high);

    case "uint8" then
        low_high = double(low_high) / 255;

    case "uint16" then
        low_high = double(low_high) / 65535;

    case "int16" then
        low_high = (double(low_high) + 32768) / 65535;

    case "constant" then
        // Double images are already normalized

    else
        error("im2double: IMG is of unsupported class");

    end

    // Clamp floating-point values to [0,1]
    low_high(low_high < 0) = 0;
    low_high(low_high > 1) = 1;

    // Replace equal limits with [0;1] for constant-valued image planes
    equal_cols = (low_high(1,:) == low_high(2,:));

    if or(equal_cols) then
        low_high(:, equal_cols) = repmat([0;1], 1, sum(equal_cols));
    end

endfunction


// ----------------------------------------------------
// Helper Functions
// ----------------------------------------------------

function n = numel(x)
    n = size(x, "*");
endfunction


function tf = isnumeric(x)

    tf = or(typeof(x) == [ ...
        "constant", ...
        "int8",  "uint8", ...
        "int16", "uint16", ...
        "int32", "uint32", ...
        "int64", "uint64", ...
        "sparse"]);

endfunction


function tf = isimage(img)

    t = typeof(img);

    tf = or(t == [ ...
        "constant", ...
        "boolean", ...
        "uint8", ...
        "uint16", ...
        "int16"]);

    if tf then
        tf = min(size(img)) > 0;
    end

endfunction
