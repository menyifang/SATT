# SATT
The implementation of the paper "Structure-aware Texture Transfer for Arbitrary Images"

It is provided for educational/research purpose only. Please cite the related paper if you found the software useful for your work.


## Conventional Online Texture Transfer (COTT)
This also a Matlab imlementation of the paper "A Common Framework for Interactive Texture Transfer", CVPR 2018.

### Startup external codes: 
Run the function startup.m.

### Perform texture transfer:
Run the function demo.m with the parameter configuration.

#### Example: 
[targetStylizedFinal,optS] = texture_transfer(sty, src, trg, imgpath, optS);   

### External codes:

   1. Flann: for fast approximate nearest neighbor searching.
   
      http://www.cs.ubc.ca/research/flann/

   2. mirt2D_mexinterp: for fast 2D linear interpolation.
   
      http://www.mathworks.com/matlabcentral/fileexchange/24183-2d-interpolation/content/mirt2D_mexinterp/mirt2D_mexinterp.m


## Neural Fast Texture Transfer (NFTT)


