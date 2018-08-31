function y = denoising_dwt(x)
% Local Adaptive Image Denoising Algorithm
% Usage :
%        y = denoising_dwt(x)
% INPUT :
%        x - a noisy image
% OUTPUT :
%        y - the corresponding denoised image

% Adjust windowsize and the corresponding filter自适应窗口大小和联合滤波器
windowsize  = 7;
windowfilt = ones(1,windowsize)/windowsize;

% Number of Stages
L = 6;

% symmetric extension
N = length(x);%信号的长度
N = N+2^L;
x = symextend(x,2^(L-1));

% forward transform
[af, sf] = farras;%返回两个滤波器，af为分析滤波器，sf为合成滤波器
W = dwt2D(x,L,af); 

% Noise variance estimation using robust median estimator..
tmp = W{1}{3};
Nsig = median(abs(tmp(:)))/0.6745;

for scale = 1:L-1
    for dir = 1:3
        
        % noisy coefficients 
        Y_coefficient = W{scale}{dir};
        
        % noisy parent        
        Y_parent = W{scale+1}{dir};
        
        % extent Y_parent to make the matrix size be equal to Y_coefficient         
        Y_parent = expand(Y_parent);
        
        % Signal variance estimation
        
        Wsig = conv2(windowfilt,windowfilt,(Y_coefficient).^2,'same');
        Ssig = sqrt(max(Wsig-Nsig.^2,eps));
        
        % Threshold value estimation 
        T = sqrt(3)*Nsig^2./Ssig;
        
        % Bivariate Shrinkage
        W{scale}{dir} = bishrink(Y_coefficient,Y_parent,T);
        
    end
end


% Inverse Transform
y = idwt2D(W,L,sf);

% Extract the image
y = y(2^(L-1)+1:2^(L-1)+512,2^(L-1)+1:2^(L-1)+512);