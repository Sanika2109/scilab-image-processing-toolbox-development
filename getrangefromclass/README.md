# getrangefromclass
## Description
- The getrangefromclass function returns the valid intensity range associated with the datatype of an image.
- The number of arguments passed must be equal to 1.
- For integer image types, it returns the minimum and maximum representable values of the datatype; for boolean and floating-point (constant) images, it returns the normalized range [0, 1].
## Calling Sequence
`r = getrangefromclass(img)`
## Dependencies
The function depends on the following external files, which must be loaded before `getrangefromclass.sci`:

| File | Purpose |
|--------|---------|
| `intmin.sci` | Returns the minimum representable value for an integer datatype. |
| `intmax.sci` | Returns the maximum representable value for an integer datatype. |
## Parameters
`img` - An image or matrix. Supported datatypes: int8, uint8, int16, uint16, int32, uint32, int64, uint64, boolean, and constant (double).
# Examples
## 1
      I = uint8([1 2; 3 4]);
      r = getrangefromclass(I)
##
      0   255
## 2
      I = int8([1 -2; 3 -4]);
      r = getrangefromclass(I)
##
      -128   127
## 3
      I = uint16([1 2; 3 4]);
      r = getrangefromclass(I)
##
      0   65535
## 4
      I = int16([1 -2; 3 -4]);
      r = getrangefromclass(I)
##
      -32768   32767
## 5
      I = uint32([1 2; 3 4]);
      r = getrangefromclass(I)
##
      0   4294967295
## 6
      I = int32([1 -2; 3 -4]);
      r = getrangefromclass(I)
##
      -2147483648   2147483647
## 7
      I = uint64([1 2; 3 4]);
      r = getrangefromclass(I)
##
      0   18446744073709551615
## 8
      I = int64([1 -2; 3 -4]);
      r = getrangefromclass(I)
##
      -9223372036854775808   9223372036854775807
## 9
      I = rand(5,5);
      r = getrangefromclass(I)
##
      0   1
## 10
      I = [%t %f; %f %t];
      r = getrangefromclass(I)
##
      0   1
## 11
      I = imread("cameraman.jpeg");
      r = getrangefromclass(I)
##
      0   255
## 12
      I = [];
      r = getrangefromclass(I)
##
      Error : "getrangefromclass: IMG must be an image"
## 13
      r = getrangefromclass("hello")
##
      Error : "getrangefromclass: unrecognized image class"
## 14
      r = getrangefromclass(list(1,2,3))
##
      Error : "getrangefromclass: unrecognized image class"
## 15
      r = getrangefromclass()
##
      Error : "getrangefromclass: IMG must be an image"
