%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIC/dab_emptyFIB_creation.m                                             %
%                                                                         %
% Requires: - no requirements                                             %
% Returns:  - FIB                                                         %
%-------------------------------------------------------------------------%
% An empty FIB is created directly without calculations                   %
%-------------------------------------------------------------------------%
% MASTER THESIS: CHRISTOPHER TSCHISCHKA                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function FIB = dab_emptyFIB_creation

    FIB = false(1,256);
    FIB(1,1:8) = true;
    FIB(241:256) = [true false true false true false false false true false true false true false false false];

end