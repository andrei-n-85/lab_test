clear;
addpath additional_files_tx
addpath additional_files_tx/msc
addpath additional_files_tx/fic
addpath additional_files_tx/physical_layer


% Parameters 

number_of_frames = 15; % number of frames to generate (Note that each frame requires about 2MB of space)

channel.SNR_dB = 4; % SNR in dB

channel.Delay = [10e-3 ]; % Delay of each path in s

channel.Path_Gain = [1 ]; % Path gain 

channel.Doppler_Frequency = [3800 ]; % Doppler Freq. in Hz

Sampling_Frequency = 2048000;   % Sampling Frequency in Hz

filename_prefix = 'offline_TX_v5_1';


% Generate n DAB Frames
TF = generate_DAB_signal(number_of_frames);

% Perform channel effects
received_samples = perform_channel(TF,channel);

% Save file
save_signal(received_samples,filename_prefix,Sampling_Frequency);

