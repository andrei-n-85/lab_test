% This function performs the coarse frame synchronization. 
%
% input: 
%           oneFrame_res: a row vector containing the samples
%           Tnull:  length of the Null-Symbol in terms of samples
% output:  
%           coarseFrameOffset: an integer that shows the start of the
%           Null symbol
%
% 

function coarseFrameOffset = coarse_Framesynchronization(oneFrame_res,Tnull)

% a) calculate the energy S[n] of the samples for all indices (window length =
% Tnull). Hint: Use the function 'conv'.

S = zeros(size(oneFrame_res)); % --> Remove this line and implement here!

% plot the absolute value of S[n]
figure('Name','Coarse Frame Synchronization','Position',[1 450 900 450]);
subplot(1,2,2); plot(0:length(S)-1,S); 
xlabel('time [samples]'); 
ylabel('Moving Sum');

% b) find the minimum
coarseFrameOffset = 1; % --> Remove this line and implement here!
