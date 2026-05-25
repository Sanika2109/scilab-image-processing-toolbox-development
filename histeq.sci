function equi_hist = histeq(I, L)
   if argn(2) < 2 then
       L = 256; //If user doesn't provide any level value, default level is set to 256 (8 bit image)
   end
   I = uint8(I);
   grayscale_img = rgb2gray(I);
   img = double(grayscale_img);
   [row,col] = size(img);
   pixel_val = row * col;
   img = round(img*(L - 1)/255);
   hist = zeros(1, L); 
   for i = 1:row
     for j = 1:col
       pixel = img(i,j);
       hist(pixel + 1) = hist(pixel + 1) + 1; //calculation of histogram
     end
   end  

   cumm_hist = cumsum(hist); //computation of cummulative histogram
   cumm_norm = cumm_hist/pixel_val; //normalization of cummulative values
   new_intensity = round((L - 1) * cumm_norm); //computation of new intensity value
   output = img;
   for i = 1:row
     for j = 1:col
       pixel = img(i,j);
       output(i,j) = new_intensity(pixel + 1); //remapping intensity values
     end
   end  
   output = uint8(output*255/(L-1));
   equi_hist = output;
endfunction
