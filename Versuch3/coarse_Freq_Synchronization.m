% This function performs the coarse frequency synchronization. 
%
% input: 
%           recPRSSymbol: Received Phase reference symbol
%           zPRS:  
% output:  
%           coarseFreqOffset: 
%
% 


function coarseFreqOffset = coarse_Freq_Synchronization(recPRSSymbol,zPRS,fig_handle)

% c) calculate the correlation metric for k = -127:127

S_rob = zeros(255,1);  % --> Remove this line and implement here!

relevant_S_rob = ones(1,17); % --> Remove this line and implement here!

% plot the relevant part of the metric
if (gcf ~= fig_handle)
    figure(fig_handle);
end
index_wo_CFO = 128;  % This index is correct if there is no coarse frequency shift
max_coarse_freq_shift = 8; % this is the maximal assumed coarse frequency shift in kHz

subplot('Position',[0.70 0.68 0.25 0.28]);
hold off;
plot(-2*max_coarse_freq_shift:2*max_coarse_freq_shift,abs(S_rob(index_wo_CFO-2*max_coarse_freq_shift:index_wo_CFO+2*max_coarse_freq_shift))); 
hold on; plot([-max_coarse_freq_shift -max_coarse_freq_shift],[0 max(abs(relevant_S_rob))/2],'--r'); plot([max_coarse_freq_shift max_coarse_freq_shift],[0 max(abs(relevant_S_rob))/2],'--r'); xlabel('Subcarrier Shift'); ylabel({'Correlation between received and';'ideal reference symbol in frequency domain'}); title('Coarse Frequency Synchronization');

% f) find the maximum
coarseFreqOffset = 0; % --> Remove this line and implement here!

