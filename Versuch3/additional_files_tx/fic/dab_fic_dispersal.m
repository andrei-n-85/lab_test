%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIC/dab_fic_dispersal.m                                                 %
%                                                                         %
% Requires: - FIC (matrix)                                                %
%           - PRBS (vector)                                               %
%                                                                         %
% Returns:  - FIC_disp (matrix)                                           %
%-------------------------------------------------------------------------%
% This function performs the energy dispersal for the FIC. The input PRBS %
% is a 511 values long pseudo random binary sequence of the poynomial     %
% P(x) = x^9 + x^5 + 1 of a feedback shift register (see DAB standard).   %
% For the input FIC, each row has to contain 3 FIBs with 256 bits each    %
% --> 768 bits per row.                                                   %
% The number of rows has to be a multiple of 4 for Transmission Mode 1,   %
% any integer number for Transmission Mode 2 and a multiple of 2 for      %
% transmission mode 4.                                                    %
% The output is the energy dispersed FIB matrix with the same dimensions  %
% as the input FIC                                                        %
%-------------------------------------------------------------------------%
% TRANSMISSION MODE 3 CANNOT BE DISPEARSED WITH THIS FUNCTION             %
%-------------------------------------------------------------------------%
% MASTER THESIS: CHRISTOPHER TSCHISCHKA                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function FIC_disp = dab_fic_dispersal(FIC, PRBS)


    %% Create PRBS with length for the FIB matrix
    PRBS_FIC = repmat(PRBS,1,2);
    PRBS_FIC = PRBS_FIC(1,1:768);

    
    %% Energy dispersal for the FIB matrix 
    % Preallocation of matrix
    FIC_disp = false(size(FIC,1),size(FIC,2));
    
    % Performing energy dispersal
    for i = 1 : size(FIC,1); 
        FIC_disp(i,:) = xor(PRBS_FIC, FIC(i,:));
    end

    
end