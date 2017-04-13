%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIC/dab_freq_interleave.m                                               %
%                                                                         %
% Requires: - transmission_frame_raw (matrix)                             %
%           - freq_perm (vector)                                          %
%                                                                         %
% Returns:  - transmission_frame_interleaved (matrix)                     %
%-------------------------------------------------------------------------%
% This code performs frequency interleaving for DAB in Transmission Mode  %
% 1 with 1536 sub-carriers. The input vector is a frequency permutation   %
% vector with a length of1536 values necessary to perform frequency       %
% interleaving and a transmission frame matrix consisting of a            %
% juxtaposition of the FIC and the MSC. Its number of rows corresponds to %
% the number of transmission frames having 230400 binary values when      %
% performing frequency interleaving before QPSK modulation (requires less %
% computational time) or 115200 values when performing frequency          %
% interleaving after QPSK modulation (official DAB standard). The         %
% resulting transmission signal is the same for both ways.                %
% The frequency interleavied output matrix has the same dimensions as the %
% input matrix.                                                           %
%-------------------------------------------------------------------------%
% FREQUENCY INTERLEAVING FOR TRANSMISSION MODE 1 ONLY                     %
%-------------------------------------------------------------------------%
% MASTER THESIS: CHRISTOPHER TSCHISCHKA                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function transmission_frame_interleaved = dab_freq_interleave(transmission_frame_raw, freq_perm)


    % Preallocation of output matrix
    transmission_frame_interleaved = false(size(transmission_frame_raw,1),size(transmission_frame_raw,2));
       
    % Performing Frequency Interleaving for 1536 subcarriers
    for i = 1 : 1536
        transmission_frame_interleaved(:,freq_perm(i):1536:end) = transmission_frame_raw(:,i:1536:end);
    end
   
    
 end