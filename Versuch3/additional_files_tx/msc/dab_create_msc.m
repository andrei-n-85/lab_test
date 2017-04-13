%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% msc/dab_create_msc.m                                                    %
%                                                                         %
% Requires: - fixed_vars (struct)                                         %
%           - FICinfo (struct)                                            %
%           - subch_vars (struct)                                         %
%                                                                         %
% Returns:  - MSC (matrix)                                                %
%           - subch_vars (struct)                                         %
%                                                                         %
%-------------------------------------------------------------------------%
% This function creates the Mains Service Channel.                        %
%                                                                         %
% INPUT:                                                                  %
% Input is the struct fixed_vars containing all variables for DAB, the    %
% struct FICinfo containing information about the Fast Information Channel%
% which is not explicitly related to only one of the services and the     %
% struct subc_vars which contains individual information for each         %
% sub-channel.                                                            %
%                                                                         %
% OUTPUT:                                                                 %
% Output is the MSC and the struct subch_vars, which was updated in this  %
% function.                                                               %
%                                                                         %
% DSCRIPTION                                                              %
% For each service, a certain number of bits comprising a certain number  %
% of logical frames is read from a file. This bit-vector for each logical %
% frame is first reshaped into a matrix with logical frames stored        % 
% column-wise. The matrix is then energy dispersed, convolutional         %
% encoded, punctured and time interleaved. After having done this         %
% procedure for every service, the encoded data is stored in four CIFs    %
% representing the MSC.                                                   %
%                                                                         %
%-------------------------------------------------------------------------%
% DUE TO LAST SECTION, MSC CREATION FOR TRANSMISSION MODE 1 ONLY          %
%-------------------------------------------------------------------------%
% MASTER THESIS: CHRISTOPHER TSCHISCHKA                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [MSC subch_vars] = dab_create_msc(fixed_vars, FICinfo, subch_vars)

    % Create data for each sub-channel
    for subch_no = 1 : FICinfo.no_of_serv    
        
        
        % Get input for MSC
        [audio_frame_vector subch_vars] = dab_msc_getinput(FICinfo.no_log_frames, subch_vars, subch_vars(subch_no).bits_for_LFs, subch_no);
               
        
        % Reshape audio vector to audio matrix
        audio_frame_matrix = reshape(audio_frame_vector, subch_vars(subch_no).bits_for_LF, length(audio_frame_vector)/subch_vars(subch_no).bits_for_LF);
        audio_frame_matrix = audio_frame_matrix.';
        
        
        % Energy Dispersal
        disp_audio_frame_matrix = dab_msc_dispersal(audio_frame_matrix, fixed_vars.PRBS);
        clearvars audio_frame_matrix


        % Convolutional coding
        convoluted_mother_matrix = dab_msc_convolution(disp_audio_frame_matrix, fixed_vars.tre);
        clearvars disp_audio_frame_matrix

        
        % Unequal Error Protection 
        [convoluted_matrix, subch_vars(subch_no).table7] = dab_uep(convoluted_mother_matrix, subch_vars(subch_no).bitrate, subch_vars(subch_no).protlvl, fixed_vars);
         clearvars convoluted_mother_matrix   


        % Time Interleaving
        [subch_vars(subch_no).interleaved_matrix subch_vars(subch_no).conv_pre] = dab_msc_tinterleave(convoluted_matrix.', subch_vars(subch_no).conv_pre);
        clearvars convoluted_matrix

        
    end

    
    % Multiplex CIFs to form the MSC
    MSC = dab_msc_multiplex(fixed_vars.PRBS, FICinfo.no_of_serv, FICinfo.no_log_frames, subch_vars);

    
end