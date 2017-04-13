% This function performs differential demodulation
%
% Input 1: ofdm_symbol_f - 1536 DQPSK-symbols
% Input 2: ofdm_symbol_f_previous - 1536 DQPSK-symbols of previous OFDM-symbol
% Output:  qpsk_symbols - Row vector of 1536 QPSK-Symbols
%

function qpsk_symbols = differential_demodulation(ofdm_symbol_f,ofdm_symbol_f_previous,coarseFreqOffset,Constants)

% a) differential demodulation
qpsk_symbols_with_phase_offset = zeros(1,1536); % --> Remove this line and implement here!

% b) correction of the phase offset
qpsk_symbols = zeros(1,1536); % --> Remove this line and implement here!



