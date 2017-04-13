% This function performs the fine frequency synchronization. 
%
% input: 
%           refsym_t:  Row vector of 2552 samples; Reference symbol in time domain
%           Constants: Constant values 
% output:  
%           fineFreqOffset: Fine Frequency offset in Hz
%
% 

function fineFreqOffset = fine_Frequency_Synchronization(refsym_t,Constants,fig_handle)
% a) Phasedifference between the k. and the k+2048. sample (k=indices of
% the cyclic prefix)

phase_difference = ones(1,504); % --> Remove this line and implement here!

% Plot the angle difference
if (gcf ~= fig_handle)
    figure(fig_handle);
end
subplot('Position',[0.375 0.68 0.25 0.28]);
hold off;plot(1:Constants.CPL,mod((phase_difference*360/(2*pi))+360,360),'bo'); ylabel({'Phase Shift between Sample in Cyclic Prefix and';'corresponding sample at end of OFDM symbol'}); xlabel('Sample'); title('Fine Frequency Synchronization');


% b) phasedifference of the whole cyclic prefix
fineFreqOffset = 0; % --> Remove this line and implement here!


