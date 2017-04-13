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
% Add the remainders and complement:
Workaround_FCS = not(mod(cw1(end-16+1:end) + cw2(end-16+1:end),2))';
% The result matches the FCS of X.25 standard test sequence
%isequal(FCS,Workaround_FCS)
if isequal(FIBs(241:256),Workaround_FCS)
    ret = 1;
    %disp('CRC Check o.k.')
else
    ret = 0;
    %disp('CRC wrong')
end