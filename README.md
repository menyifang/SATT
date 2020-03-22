# SATT
The implementation of the paper "Structure-aware Texture Transfer for Arbitrary Images"

It is provided for educational/research purpose only. Please cite the related paper if you found the software useful for your work.


## Conventional Online Texture Transfer (COTT)
This also a Matlab imlementation of the paper "A Common Framework for Interactive Texture Transfer", CVPR 2018.

### Startup external codes: 
Run the function startup.m.

### Texture transfer:
Run the function demo.m
use the main function texture_transfer in demo.m with the parameter configuration.

#### Example: 
[targetStylizedFinal,optS] = texture_transfer(sty, src, trg, imgpath, optS);   

### External codes:

   1. Flann: for fast approximate nearest neighbor searching.
   
      http://www.cs.ubc.ca/research/flann/

   2. mirt2D_mexinterp: for fast 2D linear interpolation.
   
      http://www.mathworks.com/matlabcentral/fileexchange/24183-2d-interpolation/content/mirt2D_mexinterp/mirt2D_mexinterp.m

   3. cpd: for coherent point drift.
   
      http://www.bme.ogi.edu/~myron/matlab/cpd/

   4. Saliency: for content-aware saliency detection.
   
      https://cgm.technion.ac.il/Computer-Graphics-Multimedia/Software/Saliency/Saliency.html

   5. tpsWarp: for thin-plane spline warping.
   
      https://ww2.mathworks.cn/matlabcentral/fileexchange/24315-warping-using-thin-plate-splines

### Acknowledgments
Our code is inspired by [Text-Effects-Transfer] (https://github.com/williamyang1991/Text-Effects-Transfer/).

   
## Neural Fast Texture Transfer (NFTT)


### Requirements
* python 2.7 
* pytorch >= 0.4.1
* opencv-python
* skimage
* numpy
* scipy
* pandas

### Getting Started

* Clone this repo:

```
git clone https://github.com/menyifang/SATT.git
cd SATT/SATT-NFTT
```

* Data preparation

The structure of the data folder is recommanded as the provided sub-folders inside `imgs` folder. 

The dataset structure is recommended as:
```
+--imgs
|   +--example
|       +--train
|           +--paired_source_img
|       +--test
|           +--sem1
|           +--sem2
...
```

* Structure guiding

-extract saliency map for the source image with the tool in 'SATT/COTT/saliencyExtraction.m' and put the result in 'imgs/example/sal_train', then convert the saliency map into color image as the source attention map.

-propagate structure with a [CNN geometric matcher](https://github.com/ignacio-rocco/cnngeometric_pytorch) and put the attention maps in 'imgs/example/att_train', 'imgs/example/att_test', w.r.t images in 'train' and 'test'. 

* Training

Download pre-trained vgg models use commands in 'scripts/download_vgg_models.sh', put vgg_conv.pth under './models' folder


You can train a model using commands like

```
bash ./scripts/train.sh
```
Some hyper parameters can be modified in the script (train.sh, test.sh) and others are provided in options folder.
To see more intermediate results, check out './checkpoints/example/web/images'.

* Testing

You can test a model using commands like

```
bash ./scripts/test.sh
```
Check the results in 'results/example'. 


### Acknowledgments
Our code is inspired by [non-stationary_texture_syn](https://github.com/jessemelpolio/non-stationary_texture_syn).



