%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /additional_files/PRBS_generation.m                                     %
%                                                                         %
% Requires: - no requirements                                             %
%                                                                         %
% Returns: - PRBS (vector)                                                %
%                                                                         %
%-------------------------------------------------------------------------%
% This function creates the pseudo-random binary sequence which is needed %
% for energy dispersal and for the pre-allocation of the CIFs of the MSC  %
% the preceeding ch_in) and the channel_parameters which are stored in a  %
% according to the DAB standard defined by the ETSI.                      %
%-------------------------------------------------------------------------%
% MASTER THESIS: CHRISTOPHER TSCHISCHKA                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function PRBS = PRBS_generation

    PRBS = false(1,511);
    register = ones(1,9);
    for i = 1:511                                                          % Length of period of M-Sequence (generator polynom is primitiv) = Maximum length of period = 
        PRBS(i) = xor(register(5),register(9));                            % Modulo-2 addition
        for j=9 : -1: 2                                                    % Update registers for next run
            register(j) = register(j-1);                                   % Update last 8 registers
        end
        
        register(1) = PRBS(i);                                             % Update first register
    end
