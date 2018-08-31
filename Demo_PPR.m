function Demo_PPR()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Coded diffraction imaging from single obervation or undersampled data at Gaussion noise case
%% demo code for "PPR: Plug-and-Play Regularization Model for Solving Nonlinear Imaging Inverse Problems"
%%%%%%%%%%%%%%last modified by shibaoshun 2018 Aug 20th
%% add path
clear ;
close all;
CurrPath = cd;
addpath(genpath(CurrPath));
%% add the matconvenet path
addpath('D:\×ÀÃæ\PPR\matconvnet-1.0-beta25\matlab') % Pay attention! to run FFDNet denoiser you sholud add the correct path of the metconvnet 
addpath('D:\×ÀÃæ\PPR\matconvnet-1.0-beta25\matlab\mex')
%% function defination
type ='cdp'; 
data.cdptype       ='quatary';
gamma=0;                      %0 for gaussian noise
outliers=0;
savefile           =        []; % filename to save instance data
%% select an image
Imagenumber=1;
 switch Imagenumber
 case 1
 ori_image='Lena512.png';
 case 2
 ori_image='barbara.png';
 case 3
 ori_image='hill.png';
 case 4
 ori_image='boat.png';
 case 5
 ori_image='couple.png';
 case 6
 ori_image='fingerprint.png';
 case 7
 ori_image='acinarcell.png';
 case 8
 ori_image='chromaffincell.png';  
 end
rng('default');
disp(['Loading image ',ori_image]);
disp(' ');
Imin=double(imread(ori_image))/255;
SNR_num=[5 10 15 20 25];
%% innitial guess
load initialguess.mat    % the same initialguess for each case, one can also exploit the random one
data.numM=1;             % one diffraction pattern
for j=1:1:5
SNR=SNR_num(j)           % level of noise (added to measurements)
[Y,F,~,~,~] = instanceGenerator(Imin,type,data,savefile,SNR,gamma,outliers);
phi = @(I) F(I,0); 
phit = @(I) F(I,1);  
%% %%%%%%%%%%%%%%%%%%%%%<<<<PPR_denoiser>>>%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('calling the function PPR_denoiser.....\n');
t=clock;
Image=PPR(Y,phi,phit,x,'fast-BM3D',data.numM); %FFDNet
time(j)=etime(clock,t)
PSNR(j)=psnr(Image,Imin)
[FSIM(j), ~] = FeatureSIM(Imin, Image)% compute FSIM
end
%% show the result
fprintf(1,'PSNR = %f \n', PSNR);
fprintf(1,'FSIM = %f \n', FSIM);
fprintf(1,'Time = %f \n', time);
