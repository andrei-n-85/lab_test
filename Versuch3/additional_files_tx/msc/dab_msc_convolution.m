%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% msc/dab_msc_convolution.m                                               %
%                                                                         %
% Requires: - disp_audio_frame_matrix (matrix)                            %
%           - tre (struct)                                                %
%                                                                         %
% Returns:  - conv_mother_matrix (matrix)                                 %
%                                                                         %
%-------------------------------------------------------------------------%
% This function performs convolutional coding for the MSC.                %
%                                                                         %
% INPUT:                                                                  %
% As input serves the dispersed audio frame matrix which number of        %
% rows corresponds to the number of logical frames with [bitrate *        %
% duration of logical frame] bits. Variable tre is a struct created by    %
% the MATLAB command  poly2trellis(7, [133 171 145 133])  for a           %
% convolutional coder with 7 registers and four outputs with the octal    %
% forms 133, 171, 145 and 133.                                            %
%                                                                         %
% OUTPUT:                                                                 %
% Output is the convolutional encoded mother matrix                       %
%                                                                         %
% DESCRIPTION:                                                            %
% First, six zero bits are appended to the input matrix in order to have  %
% terminating bits for the convolutional coder. After having preallocated %
% the output, convolutional encoding is performed.                        %
%-------------------------------------------------------------------------%
% MASTER THESIS: CHRISTOPHER TSCHISCHKA                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function conv_mother_matrix = dab_msc_convolution(disp_audio_frame_matrix, tre)


    % Append 6 zero-bits to the end as terminating bits
    conv_in = [disp_audio_frame_matrix, false(size(disp_audio_frame_matrix,1),6)];
    
    
    % Preallocate mother codeword matrix
    conv_mother_matrix = false(size(disp_audio_frame_matrix,1),4*size(disp_audio_frame_matrix,2)+4*6); 
    
    
    % Perform convolutional coding
    for i = 1 : size(disp_audio_frame_matrix,1)
        conv_mother_matrix(i,:) = convenc(conv_in(i,:), tre);                            
    end
    

end