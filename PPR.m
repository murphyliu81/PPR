function [Iout]=PPR(Y,phi,phit,x,denoiser,L)
%% This algorithm exploits the PPR framework
%%%% Only the iteartion times need to be specified.
%% Coded diffraction imaging from one coded diffraction pattern at Gaussion noise case
%% a demo code for "PPR: Plug-and-Play Regularization Model for Solving Nonlinear Imaging Inverse Problems"
%%%%%%%%%%%%%%last modified by shibaoshun 2018 Aug 20th
%%%%%%%%%% Input:  Y    measurements
%%%%%%%%%%        phi   linear sampling operator A 
%%%%%%%%%%        phit  linear sampling operator A^{H}
%%%%%%%%%%        x     random initial guess
%%%%%%%%%%        denoiser     select a denoiser
%%%%%%%%%%        diffraction number   L
%% Initial
    maxiteration=30;
    f = @(Yhat) sum(abs((Yhat(:)-Y(:))).^2); 
    gradf= @(x,Yhat) 4*real(phit(phi(x).*(Yhat-Y))); % define the gradient of the data fidelity function
   if L<1
      C=3; 
   else
      C=2;
   end
    xold=x;
    lambda=1.5;
    x_hat=x;
%%  initial tight frame
   load learnt_dict.mat
   W=learnt_dict;
   [width,height]=size(x);
 %%
 for i=1:1:maxiteration    
%% parameter evaluation    
    sigma_hat=mad(x);                        %evaluate the input noise standard deviation
    epsilon=C*sigma_hat;  
%% filtering step
    x_hat = Idenoise(x,sigma_hat,width,height,denoiser);        
%% sparse coding step   
    r=(x+lambda*x_hat)./(1+lambda);
    Image_rec=frame_reconstruction(r,W,epsilon);  
%%  image updating step 
    x=proj_CPR(Image_rec,2,f,gradf,phi);  %     projection  
%% stop while the residual is a small value 
    Residual= norm(x_hat-xold)/norm(x_hat);
    if  Residual<1e-4
    break;
    end
    xold = x_hat;  
    i
 end
Iout=x_hat;
