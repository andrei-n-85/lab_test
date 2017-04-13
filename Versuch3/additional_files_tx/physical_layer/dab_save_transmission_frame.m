%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /physical_layer/dab_save_transmission_frame.m                           %
%                                                                         %
% Requires: - TF (matrix)                                                 %
%           - fid (file ID)                                               %
%                                                                         %
% Returns:                                                                %
%-------------------------------------------------------------------------%
% This function is used to store the created data in an binary file.      %
% First the result has to be resampled, as the USRP1 works with a         %
% frequency of 2000 kHz but values were created for a DAB system with     %
% 2048 kHz.                                                               %
% To create the output for GRC, the values are scaled by the value 30000  %
% in order to create values between -32,768 (-2^15) and 32,768 (+2^15) as %
% a short values comprises 16 bits (65,536). Thus the value may not be    %
% above these numbers. Furthermore, the output is stored as IQ-pair       %
% (Inphase - Quadrature) which is required as input for the USRP1 with    %
% short values. The result is then stored in the file given by the        %
% variable fid.                                                           %
%-------------------------------------------------------------------------%
% MASTER THESIS: CHRISTOPHER TSCHISCHKA                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function dab_save_transmission_frame(TF, fid)

    if (0)
    % Resampling
    %resampled = resample(TF,4000,2048,1);
    resampled = resample(TF,2000,2048,1);
    
    
    %% Creating output values for GRC
    % Scaling
    max_re = max(max(abs(real(resampled(1:100:end,1:10:end)))));
    max_im = max(max(abs(imag(resampled(1:100:end,1:10:end)))));
    scale =  25000 / max(max_re,max_im);
    resampled = resampled * scale;
    
    % Reshape vector to I Q I Q I... format
    resampled_re = real(resampled);
    resampled_im = imag(resampled);
    trans_out = [(resampled_re(:))'; (resampled_im(:))'];
    trans_out =  trans_out(:).';
   

    %% Save resampled data to file
    %fwrite(fid,trans_out,'short');
    fwrite(fid,trans_out,'single');
    
    else
    % Resampling
    %resampled = resample(TF,4000,2048,1);
    %resampled = resample(TF(:),2000,2048);
    resampled = TF(:);
    tau = 250;
    resampled = resampled + [zeros(tau,1); 0.0*resampled(1:end-tau)];
    
    %% Creating output values for GRC
    % Scaling
    max_re = max(max(abs(real(resampled(1:100:end,1:10:end)))));
    max_im = max(max(abs(imag(resampled(1:100:end,1:10:end)))));
    scale =  25000 / max(max_re,max_im);
    resampled = int16([0.1*ones(10000,1); resampled] * scale);

    % Reshape vector to I Q I Q I... format
    resampled_re = real(resampled);
    resampled_im = imag(resampled);
    trans_out = [(resampled_re(:))'; (resampled_im(:))'];
    trans_out =  trans_out(:).';
   

    %% Save resampled data to file
    %fwrite(fid,trans_out,'short');
    fwrite(fid,trans_out,'single');
    end        
        
   
    
% % For interpolation with factor 2:
% resampled = (resample(TF,2*192000,196608));
