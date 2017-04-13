% This function performs the fine frame synchronization. 
%
% Input 1: recPRSSymbol_wo_CFO - Row vector of 1536 values; Received reference symbol in frequency domain without coarse frequency offset
% Input 2: zPRS - Row vector of 1536 values; transmitted reference symbol in frequency domain
%
% Output 1: fineFrameOffset - estimates the fine frame/time-offset in samples
% Output 2: H - estimated channel transfer function
% Output 3: h_time - estimated channel impulse response    

function [fineFrameOffset, H, h_time]= fine_Frame_Synchronization(recPRSSymbol_wo_CFO,zPRS,fig_handle)

% a) Calculate the Channel transfer function 'H'
H = ones(1536,1);  % --> Remove this line and implement here!

% b) Use 'H' to obtain the Channel impulse response 'h_time'
h_time = ones(1,1536); % --> Remove this line and implement here!


% plot the CIR
if (gcf ~= fig_handle)
    figure(fig_handle);
end
subplot('position',[0.375 0.25 0.25 0.28]);
plot((-length(h_time)/2 :length(h_time)/2-1)*1/1.536, (abs(h_time))); 
ylabel({'Absolute Value of channel impulse response |h(t)|';'calculated from reference symbol'}); 
xlabel('time in us'); title('Fine Frame Synchronization'); xlim([-600 600]);

% d) search for the maximum in channel impulse response
fineFrameOffset = 0; % --> Remove this line and implement here!
