# bwarea

## Description
- The bwarea function computes the area of foreground objects in a binary image using pixel neighborhood weighting.
- The number of arguments passed must be equal to 1.
- The input must be a 2-D matrix (binary or non-binary; non-zero values are treated as foreground).

## Calling Sequence
`area = bwarea(BW)`

## Parameters
`BW` - A 2-D matrix. All non-zero values are treated as foreground (1) and zero values as background (0). Non-logical inputs are internally converted to a logical matrix (`bw = (BW <> 0)`) before the area is estimated.

# Examples

## 1
      BW = zeros(5,5);
      bw = (BW <> 0);
      disp(bw)
      area = bwarea(BW)
##
      F  F  F  F  F
      F  F  F  F  F
      F  F  F  F  F
      F  F  F  F  F
      F  F  F  F  F

      0

## 2
      BW = uint8(zeros(5,5));
      BW(3,3) = 1;
      bw = (BW <> 0);
      disp(bw)
      area = bwarea(BW)
##
      F  F  F  F  F
      F  F  F  F  F
      F  F  T  F  F
      F  F  F  F  F
      F  F  F  F  F

      1

## 3
      BW = ones(5,5) <> 0;
      bw = BW;
      disp(bw)
      area = bwarea(BW)
##
      T  T  T  T  T
      T  T  T  T  T
      T  T  T  T  T
      T  T  T  T  T
      T  T  T  T  T

      25

## 4
      BW = int8(zeros(5,5));
      BW(3,3) = 2;
      BW(3,4) = 5;
      bw = (BW <> 0);
      disp(bw)
      area = bwarea(BW)
##
      F  F  F  F  F
      F  F  F  F  F
      F  F  T  T  F
      F  F  F  F  F
      F  F  F  F  F

      2

## 5
      BW = uint16(zeros(5,5));
      BW(2,2) = 10;
      BW(3,3) = 7;
      bw = (BW <> 0);
      disp(bw)
      area = bwarea(BW)
##
      F  F  F  F  F
      F  T  F  F  F
      F  F  T  F  F
      F  F  F  F  F
      F  F  F  F  F

      2.25

## 6
      BW = int16(zeros(7,7));
      BW(4,2:6) = 3;
      bw = (BW <> 0);
      disp(bw)
      area = bwarea(BW)
##
      F  F  F  F  F  F  F
      F  F  F  F  F  F  F
      F  F  F  F  F  F  F
      F  T  T  T  T  T  F
      F  F  F  F  F  F  F
      F  F  F  F  F  F  F
      F  F  F  F  F  F  F

      5

## 7
      BW = uint32(zeros(7,7));
      BW(2:6,4) = 1;
      bw = (BW <> 0);
      disp(bw)
      area = bwarea(BW)
##
      F  F  F  F  F  F  F
      F  F  F  T  F  F  F
      F  F  F  T  F  F  F
      F  F  F  T  F  F  F
      F  F  F  T  F  F  F
      F  F  F  T  F  F  F
      F  F  F  F  F  F  F

      5

## 8
      BW = int32(zeros(8,8));
      BW(2,2) = 4;
      BW(2,3) = 8;
      BW(6,6) = 2;
      BW(7,6) = 9;
      bw = (BW <> 0);
      disp(bw)
      area = bwarea(BW)
##
      F  F  F  F  F  F  F  F
      F  T  T  F  F  F  F  F
      F  F  F  F  F  F  F  F
      F  F  F  F  F  F  F  F
      F  F  F  F  F  F  F  F
      F  F  F  F  F  T  F  F
      F  F  F  F  F  T  F  F
      F  F  F  F  F  F  F  F

      4

## 9
      Img = imread("grayscale_img.jpg");
      grayImg = rgb2gray(Img);
      BW = grayImg > 128;
      bw = BW;
      disp(bw(1:10,1:10))
      area = bwarea(BW)
##
      Values depend on the loaded image content.

      Depends on image content (grayscale images should be thresholded before calling bwarea)

## 10
      BW = zeros(10,10);
      BW(2,2) = 5;
      BW(4,7) = 1;
      BW(8,3) = 9;
      BW(9,9) = 2;
      bw = (BW <> 0);
      disp(bw)
      area = bwarea(BW)
##
      F  F  F  F  F  F  F  F  F  F
      F  T  F  F  F  F  F  F  F  F
      F  F  F  F  F  F  F  F  F  F
      F  F  F  F  F  F  T  F  F  F
      F  F  F  F  F  F  F  F  F  F
      F  F  F  F  F  F  F  F  F  F
      F  F  F  F  F  F  F  F  F  F
      F  F  T  F  F  F  F  F  F  F
      F  F  F  F  F  F  F  F  T  F
      F  F  F  F  F  F  F  F  F  F

      4

## 11
      BW = [0 0 1 1 0 0;
            0 1 1 1 1 0;
            1 1 1 1 1 1;
            0 1 1 1 1 0;
            0 0 1 1 0 0];
      bw = (BW <> 0);
      disp(bw)
      area = bwarea(BW)
##
      F  F  T  T  F  F
      F  T  T  T  T  F
      T  T  T  T  T  T
      F  T  T  T  T  F
      F  F  T  T  F  F

      19

## 12
      BW = uint8([0 0 1 1 0 0;
                  0 1 2 3 1 0;
                  1 1 1 1 1 1;
                  0 2 1 4 1 0;
                  0 0 1 1 0 0]);
      bw = (BW <> 0);
      disp(bw)
      area = bwarea(BW)
##
      F  F  T  T  F  F
      F  T  T  T  T  F
      T  T  T  T  T  T
      F  T  T  T  T  F
      F  F  T  T  F  F

      19

*Note:* `bwarea` treats any non-zero value as foreground, so the magnitude of the pixel values does not affect the result—only their positions. Examples 11 and 12 therefore produce the same estimated area because they have the same foreground shape.
