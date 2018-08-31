function [filter_bank,filter_bank_hat] = Coupled_filter_learning(Image_rec, Image_hat,lambda,epsilon)
% [filter_bank,filter_bank_hat] = Coupled_filter_learning(Image_rec, Image_hat,D,D_hat,lambda,epsilon)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Learning orthogonal filter bank  from input
% input:
%   data		-	data is a matrix with p predictors and n obervations
%   lambda		-	parameter for thresholding
%   (optional)
%   opts:
%		A		-	initialization for A, whose atoms are orthogonal with each other.
%   	nIter	-	number of Iteration for learning, default value (=50)
% 
% output:
%   filter_bank	-	output of data-driven filter bank
%
%Reference: Jian-feng Cai, H. Ji, Z. Shen and Guibo Ye,  
%Data-driven tight frame construction and image denoising ,
%Applied and Computational Harmonic Analysis, 37 (1), 89-105, Jul. 2014
%
%Author: Chenlong Bao, Yuhui Quan, Sibin Huang, and Hui Ji
%
%Last Revision: 25-May-2014
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% epsilon=0.5*epsilon;
patchSize 	= 8; 										% patch size
stepSize  	= 1;                       					% overlap step of data   
%  trainnum=10000;
A 		= (1/patchSize)*ones(patchSize^2,1);		% pre-input filters  (must be orthogonal)
%% Checking the correctness of pre-defined filter subset A 
if ~isempty(A)
	r = size(A, 2);
	temp = wthresh(A'*A - eye(r),'h',1e-14);
	if sum(temp(:)) > 0 
		error('The input A does not meet the requirement!');
	end
end
%% Generate collection of image patches
Data1  		= im2colstep(Image_rec, [patchSize, patchSize], [stepSize, stepSize]);
Data2  		= im2colstep(Image_hat, [patchSize, patchSize], [stepSize, stepSize]);
rperm 		= randperm(size(Data1, 2));
% data	= Data1(:, rperm(1:trainnum));
% data_hat= Data2(:, rperm(1:trainnum));
 data	= Data1;
 data_hat= Data2;
%% whether A is empty 
flag_A = isempty(A);
%% Input and initialization 
data = double(data);   	  % input data
p    = size(data, 1);     % dimension of data
if ~flag_A
	A = double(A);		  
	tmpMat = (eye(p) - A*A')*data;  
    tmpMathat = (eye(p) - A*A')*data_hat;       
end
%  if ~D
D = DctInit(sqrt(p)); 
if ~flag_A
	r = size(A, 2);
	rperm = randperm(p);
	D = D(:,rperm(1:p-r));
end
D = double(D);			 % input dictionary D
D_hat=D;
%  else
%   	r = size(A, 2);
% 	rperm = randperm(p);
% 	D = D(:,rperm(1:p-r));
%     D_hat = D_hat(:,rperm(1:p-r));
%  end
%% Learning loop
iter = 0;
nIter=5;
ita=1;
while iter < nIter
    % Soft thresholding for solving L-0 minimization
    temp=(D'*data+lambda*D_hat'*data_hat)./(1+lambda);
    tmpCoef = wthresh(temp, 'h', epsilon);
% 	tmpCoef = wthresh(D'*data, 'h', lambda);
    % SVD for solving dictionary update
    if ~flag_A
		[U, S, V] = svd(tmpMat*tmpCoef'+ita*D_hat,0);
	else
		[U, S, V] = svd(data*tmpCoef',0);
    end
     D = U*V';
%      D=0.8*D+0.2*D_hat;
  	if ~flag_A
		[U, S, V] = svd(tmpMathat*tmpCoef'+ita*D,0);
	else
		[U, S, V] = svd(tmpMathatt*tmpCoef',0);
    end
    D_hat = U*V';     
%      D_hat=0.2*D+0.8*D_hat;
    % next loop
    iter = iter + 1;
end

%% Output
filter_bank = [A, D];      %Dictionary
filter_bank_hat= [A, D_hat];


