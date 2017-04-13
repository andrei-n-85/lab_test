%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% msc/dab_msc_dispersal.m                                                 %
%                                                                         %
% Requires: - audio_frame_matrix (matrix)                                 %
%           - PRBS (vector)                                               %
%                                                                         %
% Returns:  - disp_audio_frame_matrix (matrix)                            %
%                                                                         %
%-------------------------------------------------------------------------%
% This function performs energy dispersal for the MSC.                    %
%                                                                         %
% INPUT:                                                                  %
% The inputs are the audio frame matrix with one logical frame in each    %
% row and a vector containing the Pseudo-Random-Binary-Sequence. The PRBS %
% is a 511 values long pseudo random binary sequence of the poynomial     %
% P(x) = x^9 + x^5 + 1 of a feedback shift register (see DAB standard).   %
%                                                                         %
% OUTPUT:                                                                 %
% The output is the dispersed audio frame matrix with as many number of   %
% rows as there are logical frames.                                       %
%                                                                         %
% DESCRIPTION:                                                            %
% First the PRBS is continued until it has the same length as the audio   %
% frame matrix. After preallocation of the output, energy dispersal is    %
% performed                                                               %
%                                                                         %
%-------------------------------------------------------------------------%
% MASTER THESIS: CHRISTOPHER TSCHISCHKA                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function disp_audio_frame_matrix = dab_msc_dispersal(audio_frame_matrix, PRBS)


    % Create pseudo random bit sequence with length of an audio frame
    PRBS_LF = repmat(PRBS, 1, ceil(size(audio_frame_matrix,2)/length(PRBS+1)));
    PRBS_LF = PRBS_LF(1:size(audio_frame_matrix, 2));

    
    % Preallocation of output 
    disp_audio_frame_matrix = false(size(audio_frame_matrix,1), size(audio_frame_matrix,2)); 
    
    
    % Perform energy dispersal
    for i = 1 : size(audio_frame_matrix, 1); 
        disp_audio_frame_matrix(i,:) = xor(PRBS_LF, audio_frame_matrix(i,:));
    end
    
    
end