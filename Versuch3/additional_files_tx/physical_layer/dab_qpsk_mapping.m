%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /physical_layer/mapping.m                                               %
%                                                                         %
% Requires: - transmission_frame_interleaved (matrix)                     %
%                                                                         %
% Returns:  - transmssion_frame_mapped (matrix)                           %
%-------------------------------------------------------------------------%
% This code performs frequency interleaving for DAB in Transmission Mode  %
% 1. The input vector is a frequency permutation vector with a length of  %
% 1536 values necessary to perform frequency interleaving and a           %
% transmission frame matrix consisting of a juxtaposition  of the FIC and %
% the MSC. Its number of rows corresponds to the number of transmission   %
% frames having 230400 binary values when performing frequency            %
% interleaving before QPSK modulation (requires less computational time)  %
% and 115200 values when performing frequency interleaving after QPSK     %
% modulation (official DAB standard). The resulting transmission signal   %
% reamins the same for both ways.                                         %
% The frequency interleavied output matrix has the same dimensions as the %
% input matrix.                                                           %
%-------------------------------------------------------------------------%
% QPSK MAPPING FOR TRANSMISSION MODE 1 ONLY.                              %
%-------------------------------------------------------------------------%
% MASTER THESIS: CHRISTOPHER TSCHISCHKA                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function transmission_frame_mapped = dab_qpsk_mapping(transmission_frame_interleaved)


    %% Converting representation from unipolar to bipolar (0-->1, 1-->-1)
    converted = (ones - transmission_frame_interleaved * 2);

    
    %% Mapping
    %Preallocation of output
    transmission_frame_mapped = zeros(size(transmission_frame_interleaved,1),size(transmission_frame_interleaved,2)/2);
    
    % Performing QPSK-mapping
    for i = 1 : 75    
        transmission_frame_mapped(:,(i-1)*1536+1:i*1536) = converted(:,3072*(i-1)+1:3072*(i-1)+1536) + 1i*converted(:,3072*(i-1)+1536+1:i*3072);
    end
    
    
    %% Multiply with square root of 0.5 to normalize values
    transmission_frame_mapped = transmission_frame_mapped *0.7071067811865476219424364; % sqrt(0.5);

  
end