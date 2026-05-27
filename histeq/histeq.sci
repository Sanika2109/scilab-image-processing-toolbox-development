function equi_hist = histeq(I, L)

   // Set default intensity levels to 256 for 8-bit images
   if argn(2) < 2 then
       L = 256;
   end

   // Convert input image to uint8 format
   I = uint8(I);

   // Convert RGB image to grayscale
   grayscale_img = rgb2gray(I);

   // Convert image to double for calculations
   img = double(grayscale_img);

   // Get image dimensions
   [row,col] = size(img);

   // Total number of pixels
   pixel_val = row * col;

   // Scale pixel values to range [0, L−1]
   img = round(img*(L - 1)/255);

   // Initialize histogram array
   hist = zeros(1, L); 

   // Compute histogram frequency of pixel intensities
   for i = 1:row
     for j = 1:col
       pixel = img(i,j);
       hist(pixel + 1) = hist(pixel + 1) + 1;
     end
   end  

   // Compute cumulative histogram (CDF)
   cumm_hist = cumsum(hist);

   // Normalize cumulative values to range [0,1]
   cumm_norm = cumm_hist/pixel_val;

   // Generate new intensity mapping values
   new_intensity = round((L - 1) * cumm_norm);

   // Initialize output image
   output = img;

   // Replace old intensities with new equalized values
   for i = 1:row
     for j = 1:col
       pixel = img(i,j);
       output(i,j) = new_intensity(pixel + 1);
     end
   end  

   // Rescale output to 8-bit range [0,255]
   output = uint8(output*255/(L-1));

   // Return equalized image
   equi_hist = output;

endfunction
