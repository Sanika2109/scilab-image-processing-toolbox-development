function padding = padarray(A, padsize, padopt)

    // Check minimum number of input arguments
    if argn(2) < 2 then
        error("padarray: at least 2 input arguments required.");
    end

    // Validate padding size
    if size(padsize, "*") <> 2 then
        error("padarray: padsize must be [rows cols].");
    end

    if or(padsize < 0) then
        error("padarray: padsize values must be non-negative.");
    end

    // Default padding is zero padding
    if argn(2) < 3 then
        padopt = 0;
    end

    // Extract padding dimensions
    m = int(padsize(1));
    n = int(padsize(2));

    // Get input matrix dimensions
    [rows, cols] = size(A);

    // Constant-value padding
    if type(padopt) == 1 then

        // Create output matrix filled with padding value
        padding = ones(rows + 2*m, cols + 2*n) * padopt;

        // Place original matrix at center
        padding(m+1:m+rows, n+1:n+cols) = A;
        return;

    end

    // Padding using predefined boundary modes
    select convstr(padopt, "l")
    case "zeros" then

        // Pad with zeros
        padding = zeros(rows + 2*m, cols + 2*n);
        padding(m+1:m+rows, n+1:n+cols) = A;
        
    case "replicate" then

        // Extend border pixels outward
        padding = zeros(rows + 2*m, cols + 2*n);

        // Insert original matrix
        padding(m+1:m+rows, n+1:n+cols) = A;

        // Replicate first and last rows
        padding(1:m, n+1:n+cols) = ones(m,1) * A(1,:);
        padding(rows+m+1:$, n+1:n+cols) = ones(m,1) * A($,:);

        // Replicate first and last columns
        padding(:,1:n) = padding(:,n+1) * ones(1,n);
        padding(:,cols+n+1:$) = padding(:,cols+n) * ones(1,n);

    case "circular" then

        // Circular padding requires padding size not larger than image dimensions
        if m > rows | n > cols then
            error("padarray: circular padding size must not exceed image dimensions.");
        end

        padding = zeros(rows + 2*m, cols + 2*n);

        // Insert original matrix
        padding(m+1:m+rows, n+1:n+cols) = A;

        // Wrap bottom rows to top
        padding(1:m, n+1:n+cols) = A(rows-m+1:rows,:);

        // Wrap top rows to bottom
        padding(rows+m+1:$, n+1:n+cols) = A(1:m,:);

        // Wrap right columns to left
        padding(:,1:n) = padding(:,cols+1:cols+n);

        // Wrap left columns to right
        padding(:,cols+n+1:$) = padding(:,n+1:2*n);

    case "reflect" then

        // Reflection excludes border pixels
        if m >= rows | n >= cols then
            error("padarray: reflect padding size must be smaller than image dimensions.");
        end

        padding = zeros(rows + 2*m, cols + 2*n);

        // Insert original matrix
        padding(m+1:m+rows, n+1:n+cols) = A;

        // Reflect rows excluding edge rows
        padding(1:m, n+1:n+cols) = A(m+1:-1:2,:);
        padding(rows+m+1:$, n+1:n+cols) = A($-1:-1:$-m,:);

        // Reflect columns excluding edge columns
        padding(:,1:n) = padding(:,2*n+1:-1:n+2);
        padding(:,cols+n+1:$) = padding(:,cols+n-1:-1:cols);

    case "symmetric" then

        // Symmetric reflection includes border pixels
        if m > rows | n > cols then
            error("padarray: symmetric padding size must not exceed image dimensions.");
        end

        padding = zeros(rows + 2*m, cols + 2*n);

        // Insert original matrix
        padding(m+1:m+rows, n+1:n+cols) = A;

        // Mirror rows including edge rows
        padding(1:m, n+1:n+cols) = A(m:-1:1,:);
        padding(rows+m+1:$, n+1:n+cols) = A($:-1:$-m+1,:);

        // Mirror columns including edge columns
        padding(:,1:n) = padding(:,2*n:-1:n+1);
        padding(:,cols+n+1:$) = padding(:,cols+n:-1:cols+1);

    else
        error("padarray: unsupported padding type.");
    end
endfunction
