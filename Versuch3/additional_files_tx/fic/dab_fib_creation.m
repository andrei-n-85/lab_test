%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIC/dab_fib_creation.m                                                  %
%                                                                         %
% Requires: - fixed_vars (struct)                                         %
%           - FICinfo (struct)                                            %
%           - subch_vars (struct)                                         %
%                                                                         %
% Returns:  - FIC (matrix)                                                %
%-------------------------------------------------------------------------%
% This function creates 12 Fast Information Blocks (FIBs). There are 4    %
% functions creating 4 FIBs each necessary for Transmission Mode 1.       %
% All FIGs are distribute by following scheme:                            %
%  - FIG00 is present in FIB 1, 4, 7 and 10                               %
%  - FIG01 is present in FIB 2, 3, 4, 5, and 7                            %
%  - FIG02 is present in FIB 11 and 12                                    %
%  - FIG10 is present in FIB 1                                            %
%  - FIG11 is present in FIB 2, 3, 4, 5, 6, 7, 8, 9, 10                   %
%                                                                         %
% If the number of services is smaller than 9, some FIBs may be empty and %
% are replaced by an empty FIB.                                           %
% Each FIC contains all data necessary for the whole ensemble             %
%-------------------------------------------------------------------------%
% FIB CREATION FOR TRANSMISSION MODE 1 ONLY                               %
% ONLY FOR A MAXIMUM OF 9 SUB CHANNELS OR SERVICES                        %
%-------------------------------------------------------------------------%
% MASTER THESIS: CHRISTOPHER TSCHISCHKA                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function FIBs = dab_fib_creation(FICinfo, subch_vars)
    
    
    %% Create FIBs containing data
    FIBs1 = dab_fibs1_creation(FICinfo, subch_vars);               
    FIBs2 = dab_fibs2_creation(FICinfo, subch_vars);                
    FIBs3 = dab_fibs3_creation(FICinfo, subch_vars);                
    FIBs4 = dab_fibs4_creation(FICinfo, subch_vars);                
    
    
    %% Store all 12 FIBs in a matrix with 12 rows
    FIBs_temp = [FIBs1; FIBs2; FIBs3; FIBs4];
              
    
    %% Create all FICs necessary for all transmission frames
    FIBs = repmat(FIBs_temp,FICinfo.no_log_frames/4,1);
    
    
    %% Reshape the FICs for Energy Dispersal and Convolutional Coding
    FIBs = FIBs.';
    FIBs = FIBs(:);
    FIBs = reshape(FIBs,768, FICinfo.no_log_frames);
    FIBs = FIBs.';
    

end