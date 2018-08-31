function [im_out,learnt_dict]=DDTF_denoising(noisy_img,W0,epsilon)

% Parameter setting of image denoising
                       			% noise level
patchSize 	=8;% 16; 				            		% patch size
stepSize  	= 8;                       					% overlap step of data   
% trainnum	= 10000;%40000		50000							% the number of samples selected for learning

% lambda_1  	=  epsilon;            		     	% lambda for learning dictionary
% lambda_2  	=  epsilon;  %2.7          	    		% lambda for denoising by learned dictionary
% opts.nIter	= 1;										% number loop for constructing data-driven filter bank
% opts.A 		= (1/patchSize)*ones(patchSize^2,1);		% pre-input filters  (must be orthogonal)


% Checking the correctness of pre-defined filter subset A 
% A = opts.A;
% if ~isempty(A)
% 	r = size(A, 2);
% 	temp = wthresh(A'*A - eye(r),'h',1e-14);
% 	if sum(temp(:)) > 0 
% 		error('The input A does not meet the requirement!');
% 	end
% end

%% Generate collection of image patches
Data  		= im2colstep(noisy_img, [patchSize, patchSize], [stepSize, stepSize]);

% rperm 		= randperm(size(Data, 2));
patchData 	= Data;%(:, rperm(1:trainnum))
% [~,de]=sort(var(Data),'descend');
% % xtrain=blocks(:,de(1:N2));   
% patchData=Data(:,de(1:trainnum)); 
%patchData 	= Data;
%% Learning filter bank from image patches
learnt_dict  = DDTF_filter_learning(patchData, epsilon, W0);
%% Denoising image by using the tight frame derived from learned filter banks
im_out 		 = frame_denoising(noisy_img, learnt_dict, epsilon);
