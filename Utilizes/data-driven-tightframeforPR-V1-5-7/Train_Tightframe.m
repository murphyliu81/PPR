function Train_Tightframe()

clear all;
close all;
% Parameter setting of image denoising
                       			% noise level
patchSize 	=8;% 16; 										% patch size
stepSize  	= 1;                       					% overlap step of data   
trainnum	= 100000;%40000		50000							% the number of samples selected for learning
lambda_1  	= 3.4 * 0.04;            					% lambda for learning dictionary
opts.nIter	= 30;										% number loop for constructing data-driven filter bank
opts.A 		= (1/patchSize)*ones(patchSize^2,1);		% pre-input filters  (must be orthogonal)
%% Generate collection of image patches
Image1 	= double(imread('Lena512.png')); 				% read image   
Image2 	= double(imread('barbara.png')); 				% read image   
Image3 	= double(imread('montage.png')); 				% read image   
Image4 	= double(imread('man.png')); 				    % read image   
Image5 	= double(imread('house.png')); 			    	% read image   
Image6 	= double(imread('hill.png')); 				    % read image   
Image7 	= double(imread('fingerprint.png')); 			% read image   
Image8 	= double(imread('couple.png')); 				% read image   
Image9 	= double(imread('boat.png')); 				    % read image   
Data1 	= im2colstep(Image1, [patchSize, patchSize], [stepSize, stepSize]);
Data2 	= im2colstep(Image2, [patchSize, patchSize], [stepSize, stepSize]);
Data3 	= im2colstep(Image3, [patchSize, patchSize], [stepSize, stepSize]);
Data4 	= im2colstep(Image4, [patchSize, patchSize], [stepSize, stepSize]);
Data5 	= im2colstep(Image5, [patchSize, patchSize], [stepSize, stepSize]);
Data6 	= im2colstep(Image6, [patchSize, patchSize], [stepSize, stepSize]);
Data7 	= im2colstep(Image7, [patchSize, patchSize], [stepSize, stepSize]);
Data8 	= im2colstep(Image8, [patchSize, patchSize], [stepSize, stepSize]);
Data9 	= im2colstep(Image9, [patchSize, patchSize], [stepSize, stepSize]);
Data=[Data1 Data2 Data3 Data4 Data5 Data6 Data7 Data8 Data9]./255;
rperm 		= randperm(size(Data, 2));
patchData 	= Data(:, rperm(1:trainnum));

% Checking the correctness of pre-defined filter subset A 
A = opts.A;
if ~isempty(A)
	r = size(A, 2);
	temp = wthresh(A'*A - eye(r),'h',1e-14);
	if sum(temp(:)) > 0 
		error('The input A does not meet the requirement!');
	end
end

%% Learning filter bank from image patches
learnt_dict  = filter_learning(patchData, lambda_1, opts);
showdict(learnt_dict,[8,8],8,8);
save('learnt_dict','learnt_dict')
