%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% msc/dab_msc_creation.m                                                  %
%                                                                         %
% Requires: - PRBS (vector)                                               %
%           - no_of_serv (scalar)                                         %
%           - no_log_frames (scalar)                                      %
%           - subch_vars (struct)                                         %
%                                                                         %
% Returns:  - MSC (matrix)                                                %
%                                                                         %
%-------------------------------------------------------------------------%
% This function multiplexes the encoded logical frames to the MSC         %
%                                                                         %
% INPUT:                                                                  %
% Input is struct subch_vars containing all encoded logical frames of     %
% each service with as many rows as there are logical frames, the PRSBS   %
% vector, the number of services, the number of logical frame, the start  %
% address and the length of every service in numbers of CU. The PRBS is a %
% 511 values long pseudo random binary sequence of the poynomial          %
% P(x) = x^9 + x^5 + 1 of a feedback shift register (see DAB standard).   %
%                                                                         %
% OUTPUT:                                                                 %
% Output is the multiplexed MSC with as many rows as there are            %
% tranmission frames with each row containing 221,184 values.             %
%                                                                         %
% DESCRIPTION:                                                            %
% First, the PRBS is repeated until it has the same length as one CIF.    %
% Then the MSC is preallocated with 4 CIFs in each row and (number of     %
% logical frames / 4) number of rows which corresponds to the number of   %
% transmission frames.                                                    %
%-------------------------------------------------------------------------%
% MSC MULTIPLEXING FOR TRANSMISSION MODE 1 ONLY                           %
%-------------------------------------------------------------------------%
% MASTER THESIS: CHRISTOPHER TSCHISCHKA                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function MSC = dab_msc_multiplex(PRBS, no_of_serv, no_log_frames, subch_vars)


    % Generate PRBS-CIF
    CIF = repmat(PRBS,1,ceil(55296/length(PRBS)));
    CIF = CIF(1:55296);


    % Preallocate MSC with the PBRS
    MSC = repmat(CIF, no_log_frames/4, 4);


    % Put services into the MSC
    for g = 1 : no_log_frames/4
        for h = 1 : 4
            for i = 1 : no_of_serv
                MSC(g, (1+subch_vars(i).start_addr_cu_dec*64+55296*(h-1) : (subch_vars(i).start_addr_cu_dec+subch_vars(i).length_cu)*64+55296*(h-1))) =  subch_vars(no_of_serv).interleaved_matrix(1+(h-1)+4*(g-1),:);
            end
        end
    end

    
end