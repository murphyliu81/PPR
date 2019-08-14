
# [PPR: Plug-and-Play Regularization Model for Solving Nonlinear Imaging Inverse Problems]
Authors： Baoshun Shi, Qiusheng Lian,  Xiaoyu Fan

This package is a demo code for the aforementioned paper. This paper is published in the journal “Signal Processing” (https://www.sciencedirect.com/science/article/pii/S016516841930132X?via%3Dihub). If you use this code, please contact me  or  cite this paper. The email address is  shibaoshun@ysu.edu.cn.

Shi Baoshun, Lian Qiusheng, Fan Xiaoyu. PPR: Plug-and-play regularization model for solving nonlinear imaging inverse problems. Signal Processing, 2019，162(9)：83-96. 


# Requirements and Dependencies
- MATLAB R2017a
- [Cuda](https://developer.nvidia.com/cuda-toolkit-archive)-8.0 & [cuDNN](https://developer.nvidia.com/cudnn) v-6.1
- [MatConvNet](http://www.vlfeat.org/matconvnet/)

Run the following m function to test the model.
-Demo_PPR


#Note
-1. If you use the FFDnet denoiser, you must add the correct path of the MatConvNet toolbox into the demo code. MatConvNet must be compiled before it can be used.

-2. Since the noise is random, the PSNR may be perturbed. This phenomenon is reasonable for non-convex problems.

