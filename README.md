
# [PPR: Plug-and-Play Regularization Model for Solving Nonlinear Imaging Inverse Problems]
Authors： Baoshun Shi, Qiusheng Lian,  Xiaoyu Fan

This package is a demo code for the aforementioned paper. This paper is submitted to the journal “Signal Processing”. If you use this code, please contact me. 
The email address is  shibaoshun@ysu.edu.cn.

# Requirements and Dependencies
- MATLAB R2017a
- [Cuda](https://developer.nvidia.com/cuda-toolkit-archive)-8.0 & [cuDNN](https://developer.nvidia.com/cudnn) v-6.1
- [MatConvNet](http://www.vlfeat.org/matconvnet/)

Run the following m function to test the model.
-Demo_PPR


#Note
-1. If you use the FFDnet denoiser, you must add the correct path of the MatConvNet toolbox into the demo code. MatConvNet must be compiled before it can be used.

-2. Since the noise is random, the PSNR may be perturbed. This phenomenon is reasonable for non-convex problems.

