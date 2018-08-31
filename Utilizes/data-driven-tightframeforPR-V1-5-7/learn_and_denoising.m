function im_out=learn_and_denoising(noisy_img,sigma)

% Parameter setting of image denoising
                       			% noise level
patchSize 	=8;% 16; 										% patch size
stepSize  	= 3;                       					% overlap step of data   
trainnum	= 10000;%40000		50000							% the number of samples selected for learning
lambda_1  	= 3.4 * sigma;            					% lambda for learning dictionary
lambda_2  	= 2.7 * sigma;  %2.7          					% lambda for denoising by learned dictionary
opts.nIter	= 30;										% number loop for constructing data-driven filter bank
opts.A 		= (1/patchSize)*ones(patchSize^2,1);		% pre-input filters  (must be orthogonal)


% Checking the correctness of pre-defined filter subset A 
A = opts.A;
if ~isempty(A)
	r = size(A, 2);
	temp = wthresh(A'*A - eye(r),'h',1e-14);
	if sum(temp(:)) > 0 
		error('The input A does not meet the requirement!');
	end
end


%% Generate collection of image patches
Data  		= im2colstep(noisy_img, [patchSize, patchSize], [stepSize, stepSize]);
rperm 		= randperm(size(Data, 2));
patchData 	= Data(:, rperm(1:trainnum));



%% Learning filter bank from image patches
learnt_dict  = filter_learning(patchData, lambda_1, opts);

%% Denoising image by using the tight frame derived from learned filter banks
im_out 		 = frame_denoising(noisy_img, learnt_dict, lambda_2);






