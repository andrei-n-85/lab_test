%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /physical_layer/dab_diffmod.m                                           %
%                                                                         %
% Requires: - transmission_frame_mapped (matrix)                          %
%           - no_log_frames                                               %
%           - TFPR                                                        %
%                                                                         %
% Returns:  - transmssion_frame_mapped (matrix)                           %
%-------------------------------------------------------------------------%
% This code performs differential modulation for DAB in Transmission      %
% Mode 1. Input is the TFPR symbol (TFPR), the number of logical frames   %
% that are contained in the transmission frame matrix. The input matrix   %
% transmission_frame_matrix was already QPSK-mapped and frequency         %
% interleaved. Its number of rows corresponds to the number of            %
% transmission frames with 115200 values for each row.                    %
% The output matrix contains 76(number of OFDM symbols per transmisssion  %
% frame) * no_log_frames/4 (number of transmission frames) rows with 2048 %
% DQPSK modulated values.                                                 %
%-------------------------------------------------------------------------%
% DIFFERENTIAL MODULATION FOR TRANSMISSION MODE 1 ONLY.                   %
%-------------------------------------------------------------------------%
% MASTER THESIS: CHRISTOPHER TSCHISCHKA                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function transmission_frame_dqpsk = dab_diffmod(transmission_frame, no_log_frames, TFPR)


    %% Preallocate matrix with TFPR symbols and zeros (left and right)
    TFPR = [zeros(256,1); TFPR.'; zeros(256,1)];
    transmission_frame_dqpsk = repmat(TFPR,1,no_log_frames/4*76);

    
    %% Perform differential modulation
    for i = 1 : no_log_frames/4
        for j = 2 : 76
            transmission_frame_dqpsk(257:1792,j+(i-1)*76) = transmission_frame_dqpsk(257:1792,j-1+(i-1)*76) .* transmission_frame(1+(j-2)*1536:(j-1)*1536,i);
        end
    end


    
    %% Shift right hand side by one and insert a 'zero-comlumn'
    for i = 1793 : -1 : 1025
        transmission_frame_dqpsk(i,:) = transmission_frame_dqpsk(i-1,:);
    end        
    transmission_frame_dqpsk(1025,:) = zeros(1,76*no_log_frames/4); 
transmission_frame_dqpsk = transmission_frame_dqpsk.';
    
end

% 
%  %% Preallocate matrix with TFPR symbols and zeros (left and right)
%     TFPR = [zeros(1,256) TFPR zeros(1,256)];
%     transmission_frame_dqpsk = repmat(TFPR,no_log_frames/4*76,1);
% 
%     
%     %% Perform differential modulation
%     for i = 1 : no_log_frames/4
%         for j = 2 : 76
%             transmission_frame_dqpsk(j+(i-1)*76,257:1792) = transmission_frame_dqpsk(j-1+(i-1)*76,257:1792) .* transmission_frame(i,1+(j-2)*1536:(j-1)*1536);
%         end
%     end
% 
%     
%     %% Shift right hand side by one and insert a 'zero-comlumn'
%     for i = 1793 : -1 : 1025
%         transmission_frame_dqpsk(:,i) = transmission_frame_dqpsk(:,i-1);
%     end        
%     transmission_frame_dqpsk(:,1025) = zeros(76*no_log_frames/4,1); 