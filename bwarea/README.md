# bwarea
## Description
- The bwarea function computes the area of foreground objects in a binary image using pixel neighborhood weighting.
- The number of arguments passed must be equal to 1.
- The input must be a 2-D matrix (binary or non-binary; non-zero values are treated as foreground).
## Calling Sequence
`area = bwarea(BW)`
## Parameters
`BW` - A 2-D matrix. All non-zero values are treated as foreground (1) and zero values as background (0).
# Examples
## 1
      BW = zeros(5,5);
      area = bwarea(BW)
##
      0
## 2
      BW = zeros(5,5);
      BW(3,3) = 1;
      area = bwarea(BW)
##
      1
## 3
      BW = ones(5,5);
      area = bwarea(BW)
##
      25
## 4
      BW = zeros(5,5);
      BW(3,3) = 1;
      BW(3,4) = 1;
      area = bwarea(BW)
##
      2
## 5
      BW = zeros(5,5);
      BW(2,2) = 1;
      BW(3,3) = 1;
      area = bwarea(BW)
##
      2.25
## 6
      BW = zeros(7,7);
      BW(4,2:6) = 1;
      area = bwarea(BW)
##
      5
## 7
      BW = zeros(7,7);
      BW(2:6,4) = 1;
      area = bwarea(BW)
##
      5
## 8
      BW = zeros(8,8);
      BW(2,2) = 1;
      BW(2,3) = 1;
      BW(6,6) = 1;
      BW(7,6) = 1;
      area = bwarea(BW)
##
      4
## 9
      Img = imread("bright_img.jpg");
      BW = rgb2gray(Img);
      area = bwarea(BW)
##
      Depends on image content (grayscale images should be thresholded before calling bwarea)
## 10
      BW = zeros(10,10);
      BW(2,2) = 1;
      BW(4,7) = 1;
      BW(8,3) = 1;
      BW(9,9) = 1;
      area = bwarea(BW)
##
      4
## 11
      BW = [0 0 1 1 0 0;
            0 1 1 1 1 0;
            1 1 1 1 1 1;
            0 1 1 1 1 0;
            0 0 1 1 0 0];
      area = bwarea(BW)
##
      19
## 12
      BW = zeros(3,3,2);
      area = bwarea(BW)
##
      Error : Input image must be a 2D image.
## 13
      area = bwarea()
##
      Error : One input argument required.
## 14
      BW = zeros(5,5);
      area = bwarea(BW, 2)
##
      Error : Wrong number of input arguments.
