%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /additional_files/get_length_cu.m                                       %
%                                                                         %
% Requires: - protlvl (scalar)                                            %
%           - bitrate (scalar)                                            %
%           - audio_bit_rates(vector)                                     %
%           - table7_length (matrix)                                      %
%                                                                         %
% Returns: - length_cu (scalar)                                           %
%                                                                         %
%-------------------------------------------------------------------------%
% This function calculates the length of a sub-channel in number of CU.   %
% Therefore, the protection level and the audio biut rate are required.   %
% Furthermore, a vector containing all allowed bit rates in DAB and table %
% 7 of the DAB standard, which is stored in table7_length, is needed.     %
%-------------------------------------------------------------------------%
% MASTER THESIS: CHRISTOPHER TSCHISCHKA                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function length_cu = get_length_cu(prot_lvl, bitrate, audio_bit_rates, table7_length)
 
    % Calculate length in CU
    bitrate_index = audio_bit_rates==bitrate;
    length_cu = bitrate_index * table7_length;
    length_cu = length_cu(prot_lvl);
    
end