function B = padarray(A, padsize, padopt)

    // Check minimum number of input arguments
    if argn(2) < 2 then
        error("padarray requires at least 2 inputs.");
    end

    // Use zero padding as default if padding type is not provided
    if argn(2) == 2 then
        padopt = 0;
    end

    // Extract padding sizes
    m = padsize(1);
    n = padsize(2);

    // Get dimensions of input image/matrix
    [rows, cols] = size(A);

    // Handle constant numeric padding
    if type(padopt)==1 then

        // Create matrix filled with specified padding value
        B = ones(rows+2*m, cols+2*n) * padopt;

        // Place original image at center
        B(m+1:m+rows, n+1:n+cols) = A;

    else

        // Apply selected padding method
        select padopt

        case "replicate" then

            // Create output matrix and place image at center
            B = zeros(rows+2*m, cols+2*n);
            B(m+1:m+rows, n+1:n+cols) = A;

            // Replicate first row at top and last row at bottom
            B(1:m,n+1:n+cols) = ones(m,1)*A(1,:);
            B(rows+m+1:$,n+1:n+cols) = ones(m,1)*A($,:);

            // Replicate border columns
            B(:,1:n) = B(:,n+1)*ones(1,n);
            B(:,cols+n+1:$) = B(:,cols+n)*ones(1,n);

        case "circular" then

            B = zeros(rows+2*m, cols+2*n);
            B(m+1:m+rows,n+1:n+cols)=A;

            // Wrap bottom rows to top and top rows to bottom
            B(1:m,n+1:n+cols)=A($-m+1:$,:);
            B(rows+m+1:$,n+1:n+cols)=A(1:m,:);

            // Wrap columns from opposite sides
            B(:,1:n)=B(:,cols+1:cols+n);
            B(:,cols+n+1:$)=B(:,n+1:2*n);

       case "reflect" then

            B = zeros(rows+2*m, cols+2*n);
            B(m+1:m+rows, n+1:n+cols) = A;

            // Reflect image excluding border pixels
            B(1:m, n+1:n+cols) = A(m+1:-1:2,:);
            B(rows+m+1:$, n+1:n+cols) = A($-1:-1:$-m,:);

            // Reflect columns excluding borders
            B(:,1:n) = B(:,n+2:2*n+1);
            B(:,cols+n+1:$) = B(:,cols:-1:cols-n+1);

       case "symmetric" then

            B = zeros(rows+2*m, cols+2*n);
            B(m+1:m+rows, n+1:n+cols) = A;

            // Reflect image including border pixels
            B(1:m, n+1:n+cols) = A(m:-1:1,:);
            B(rows+m+1:$, n+1:n+cols) = A($:-1:$-m+1,:);

            // Reflect columns including borders
            B(:,1:n) = B(:,2*n:-1:n+1);
            B(:,cols+n+1:$) = B(:,cols+n:-1:cols+1);

        // Invalid padding option
        else
            error("Unsupported padding type");

        end

    end

endfunction
