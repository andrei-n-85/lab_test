% This function performs OFDM demodulation and the correction of the coarse
% frequency shift
%
% Input 1: ofdm_symbol_t - Line vector of 2552 samples; One OFDM-symbol in the time-domain including the cyclic prefix
% Input 2: coarseFreqOffset -  Estimated coarse frequency offset in kHz
% Output: ofdm_symbol_f - Row vector of 1536 samples; 1536 DQPSK-symbols = One OFDM-symbol in frequency-domain without coarse frequency shift, without oversampling and without DC
%

function ofdm_symbol_f = OFDM_demodulation(ofdm_symbol_t,coarseFreqOffset,Constants)

% a) perform FFT
ofdm_symbol_f_os = zeros(2048,1);  % --> Remove this line and implement here!

% b) and c) Remove oversampling and DC by considering the coarse frequency shift
 ofdm_symbol_f = zeros(1536,1); % --> Remove this line and implement here!

