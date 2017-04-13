%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% additional_files/crcX25.m                                               %
%                                                                         %
% Requires: - FIBs                                                        %
% Returns: - ret (CRC value of the FIBs)                                  %
%-------------------------------------------------------------------------%
% This function returns the CRC value necessary for the CRC field of      %
% the FIBs in the FIC.                                                    %
%                                                                         %
% Code originally from David May                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function ret = crcX25(FIBs)

global cw1
global h
Input = FIBs(1:240)';
k = length(Input);

% Remainder of step 1)
if isempty(cw1)
    h = crc.generator;
    cw1 = generate(h,[ones(16, 1); zeros(k-16,1)]);
end
% Remainder of step 2)
cw2 = generate(h,Input);
% % Add the remainders and complement:
ret = not(mod(cw1(end-16+1:end) + cw2(end-16+1:end),2))';