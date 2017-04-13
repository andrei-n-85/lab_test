% This function performs the demapping of the qpsk symbols
%
% Input 1: qpsk_symbols_deint - deinterleaved qpsk symbols
% Input 2: SNR in dB
% Input 3: demapping method: 'hard' or 'soft'
% Output:  demapped_output - Row vector of 3072 values

function demapped_output = demapper(qpsk_symbols_deint,SNR_dB,demapping_method)

if strcmp(demapping_method,'hard')   % if hard demapping is used
    
    demapped_output = ones(1,3072);  % --> Remove this line and implement here!
    
       
elseif strcmp(demapping_method,'soft') % if soft demapping is used
    
    demapped_output = ones(1,3072);  % --> Remove this line and implement here!
        
else
    error('not valid demapping method!')
end