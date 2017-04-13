%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIC/dab_create_fic.m                                                    %
%                                                                         %
% Requires: - fixed_vars (struct)                                         %
%           - FICinfo (struct)                                            %
%           - subch_vars (struct)                                         %
%                                                                         %
% Returns:  - FIC (matrix)                                                %
%-------------------------------------------------------------------------%
% This function is responsible for the creation of the Fast Information   %
% Channel (FIC). The last step is to arrange the elements of the FIC such %
% that they can be processed further on. The input structs are created    %
% either by entering values via the graphical user interface or by        %
% entering the values by hand                                             %
%-------------------------------------------------------------------------%
% DUE TO LAST SECTION, FIC CREATION FOR TRANSMISSION MODE 1 ONLY          %
%-------------------------------------------------------------------------%
% MASTER THESIS: CHRISTOPHER TSCHISCHKA                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function FIC = dab_create_fic(fixed_vars, FICinfo, subch_vars)

        
        % FIC creation
        FIC_raw = dab_fib_creation(FICinfo, subch_vars);
        
        
        % FIC dispersal
        FIC_disp = dab_fic_dispersal(FIC_raw, fixed_vars.PRBS);
        
        
        % FIC convolutional coding
        FIC_conv = dab_fic_convolution(FIC_disp, fixed_vars.tre, fixed_vars.punct_vectors, fixed_vars.punct_tail);

        
        % Reshape FIC such that one row comprises one FIC of TM 1
        FIC = FIC_conv.';
        FIC = FIC(:);
        FIC = reshape(FIC,2304*4,FICinfo.no_log_frames/4);
        FIC = FIC.';
        

end
