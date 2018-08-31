function [ denoised ] = Idenoise(noisy,sigma_hat,width,height,denoiser)
%DENOISE takes a signal with additive white Guassian noisy and an estimate
%of the standard deviation of that noise and applies some denosier to
%produce a denoised version of the input signal
% Input:
%       noisy       : signal to be denoised
%       sigma_hat   : estimate of the standard deviation of the noise
%       width   : width of the noisy signal
%       height  : height of the noisy signal. height=1 for 1D signals
%       denoiser: string that determines which denosier to use. e.g.
%       denoiser='FFDNet'
%Output:
%       denoised   : the denoised signal.
%aditional case statements to this function and modify the calls to D-AMP

noisy=reshape(noisy,[width,height]);

switch denoiser
    case 'fast-BM3D'
        noisy=255*noisy;
        [NA, output]=BM3D(1,noisy,255*sigma_hat,'lc',0);       
    case 'FFDNet'
         output=FFDNet(noisy,sigma_hat);
    case 'Bishrink'
          temp=noisy*255;                    % bishrink denoise
          z=denoising_dtdwt(temp,1);
          output=z/255;
     case 'WNNM'       
           Par   = ParSet(sigma_hat*255);   
           output = WNNM_DeNoising(noisy*255,Par);                                %WNNM denoisng function   
           output =output/255;
     otherwise
        error('Unrecognized Denoiser')
end
    denoised=output;
end

