%
% Offline DAB Receiver
% Praktikum Drahtlose Nachrichtentechnik
% Version 09.04.2013
%
% Christoph Hausl
% Onurcan Iscan
%
% This Matlab script is an offline DAB Receiver. It reads the DAB samples
% from a file and decodes the Fast Information Channel. 
%
% Certain parts of the decoder are missing. During the laboratory, missing
% parts will be built by the students each week. 
%
% The missing parts are stored in separate .m files. Only edit those .m
% files to complete the receiver.
%
% In this document, you may only edit the very first section where you can
% change the following parameters:
%
% -Name of the .bin file to read the DAB samples
% -Sampling freuqency
% -Number of frames to decode
% -Demapping method
%
%

clear;
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters (Edit only this part of the .m file!!!)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Parameters.num_dab_frames = 5; % number of loaded DAB Frames

Parameters.sampling_freq = 2048000; % in Hz
%Parameters.sampling_freq = 2000000;

% this is the name of the file with the received samples
Parameters.file_name = 'offline_TX_v5_1_2048000Hz.bin';
%Parameters.file_name = 'test_samples_v1_2000000.bin';
%Parameters.file_name = 'test_samples_v2_2000000.bin';

Parameters.demapping_method = 'hard';  % 'hard' or 'soft'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize required information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath USRP_MATLAB;
addpath additional_files_rx

% Constant Values

Constants.freqTable = mode1_freqTable; % load frequency interleaver table

Constants.trellis = poly2trellis(7,[133,171,145,133]); % Trellis for convolutional decoder

Constants.PRSN = PrsnFicGenerator; % PRSN - Pseudo Random Sequence for Energy Dispersal

Constants.zPRS = phaseRefGen;

Constants.L = 196608*Parameters.sampling_freq/2048000; % DAB Frame Length of 96 ms

Constants.L_orginal = 196608; % number of samples with sampling frequency 2048kHz

Constants.CPL = 504; % CP Length

Constants.SL  = 2048;% Symbol Length

Constants.Tnull = 2656; % length of NULL-Symbol in samples

Constants.PuncPat = PuncPatGen;

Constants.Tg = 246e-6; % Guard Interval in s

Constants.DF = 1000; % Subcarrierspacing in Hz

CodeBits.FIC = []; % code bits of Fast Information Channel (initialization)

CodeBits.MSC = []; % code bits of Main Service Channel (initialization)

qpsk_symbols_deint = zeros(1,1536); %deinterleaved qpsk symbols (initialization)

estimated_parameters = NaN(Parameters.num_dab_frames,4);

Parameters.bufferHRead = fopen(Parameters.file_name ,'r'); % open the file containing the samples

figure_parameters = createGui(); % generate the GUI


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Read the samples from the file and start 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
oneFrame = samplesFromFile(Constants.L,Parameters.bufferHRead); % read one frame

oneFrame = oneFrame.'; % change row to line vector (convention in this program: time domain = line vector; frequency domain = row vector)

oneFrame_res = resample(oneFrame,2048000,Parameters.sampling_freq); %resampling from 2000 to 2048 kHz (% oneFrame_res2 = interp1(oneFrame,0:(2000/2048):192000); faster method)

fprintf('\n***********************Start**********************\n');
disp([Parameters.file_name ' loaded...']);
disp(['Sampling rate : ' num2str(Parameters.sampling_freq) 'Hz']);

% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%
%% Appointment 3: Coarse Frame Synchronization
% Edit the function 'coarse_Frame_Synchronization()'
%
% Input 1: one_Frame_res - Line vector of 196608 samples; One DAB-frame in the time-domain
% Input 2: Tnull - length of the Null symbol
%
% Output: coarseFrameOffset - estimates the index of oneFrame_res where the NULL-Symbol starts
%
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
coarseFrameOffset = coarse_Frame_Synchronization(oneFrame_res,Constants.Tnull);

% Print the results to the screen
fprintf('\nCoarse Frame Synchronization: Time-Offset %d Samples = %3.3fms \n',coarseFrameOffset,coarseFrameOffset/2048);

offset = floor(coarseFrameOffset * Parameters.sampling_freq/2048000);
subplot(1,2,1); plot(0:196607,abs(oneFrame_res)); hold on; plot(coarseFrameOffset,mean(abs(oneFrame_res)),'ro','MarkerSize',12); xlabel('time [samples]'); ylabel('Absolute Value of recieved signal |r(t)|'); title('   The red dot depicts the estimated start of the NULL-symbol');

% remove the samples at the beginning, which we do not require anymore
dummy = samplesFromFile(floor(Constants.Tnull*Parameters.sampling_freq/2048000)+offset,Parameters.bufferHRead); % these samples are not used; the next loaded frame should be synchronized (starting with the PRS (Reference Symbol))
clear dummy offset;

fineFrameOffset = 0; % Initial Value for the fineFrameOffset

% Prepare the screen
fprintf('\n#Frame\t Fine Freq. [Hz] \t Coarse Freq.  \t Fine Frame.\n--------------------------------------------------------------------------------------------\n');

% Now, the coarse time synchronization is over and we can start with the
% next frames

% Begin with the frame loop
for frameNumber= 1 : Parameters.num_dab_frames   % for loop over the frames
    
    %% update the parameters vector
    estimated_parameters(frameNumber,1) = frameNumber;    
    
    %% according to the fineFrameOffset, read the samples from the file. Note that for
    % the very first frame, fineFrameOffset = 0
    if fineFrameOffset >= 0
        dummy = samplesFromFile(fineFrameOffset,Parameters.bufferHRead);
        oneFrame = samplesFromFile(Constants.L,Parameters.bufferHRead); 
        clear dummy;
    else
        oneFrame = [oneFrame(end+1+fineFrameOffset:end).'; samplesFromFile(Constants.L+fineFrameOffset,Parameters.bufferHRead)]; % read samples from file with negative time offset
    end
    
    %% change row to line vector (convention in this program: time domain = line vector; frequency domain = row vector)
    oneFrame = oneFrame.';
    
    %% resample the frame to 2048000Hz
    oneFrame_res_wFFO = resample(oneFrame,2048000,Parameters.sampling_freq); %resampling to 2048 kHz

    %% check, whether there are enuogh samples to process. If not, break
    if (length(oneFrame_res_wFFO) < Constants.L_orginal)
        break
    end    
    
    %% plot the frame
    figure(figure_parameters.fig_handle);
    subplot('Position',[0.05 0.68 0.25 0.28]);
    plot(0:196607,abs(oneFrame_res_wFFO)); hold on; xlabel('time [samples]'); ylabel('Absolute Value of received signal |r(t)|'); title(['DAB-Frame ',num2str(frameNumber),' in Time Domain']);    plot([0 2551],[mean(abs(oneFrame_res_wFFO)) mean(abs(oneFrame_res_wFFO))],'-r','LineWidth',2);     plot([0 0],[0 1.5*max(abs(oneFrame_res_wFFO))],'-r','LineWidth',1);     plot([2551 2551],[0 1.5*max(abs(oneFrame_res_wFFO))],'-r','LineWidth',1);     text(max(abs(oneFrame_res_wFFO))/2,mean(abs(oneFrame_res_wFFO)),' \leftarrow Reference Sym.','FontSize',12,'Color','red');
    hold off;
    
    %% Extract the reference symbol in time domain (could be improved by taking fine frame synchronization into account)
    refsym_t = oneFrame_res_wFFO(1 : Constants.CPL+Constants.SL); 
    
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    %
    %% Appointment 3: Fine Frequency Synchronization
    % Edit the function 'fine_Frequency_Synchronization()'
    %
    % Input : refsym_t - Row vector of 2552 samples; Reference symbol in time domain
    %
    % Output: fineFreqOffset - Fine Frequency offset in Hz
    %
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    fineFreqOffset = fine_Frequency_Synchronization(refsym_t,Constants,figure_parameters.fig_handle);
    
    %% print the results to the screen and update the GUI
    fprintf(' %i \t %4.4f',frameNumber,fineFreqOffset);
    estimated_parameters(frameNumber,2) = fineFreqOffset;
    set(figure_parameters.mTextBox,'String',num2str(estimated_parameters(1:frameNumber,:)));
    set(figure_parameters.mTextBox,'Value',frameNumber);
    
    %% Correction of fine frequency offset
    oneFrame_res = oneFrame_res_wFFO .* exp(-1i*2*pi* fineFreqOffset * (0:1/(2048*10^3):(length(oneFrame_res_wFFO)-1)/(2048*10^3)));
    
    
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    %
    %% Appointment 3: Coarse Frequency Synchronization
    % Edit the function 'coarse_Freq_Synchronization()'
    %
    % Input 1: oneFrame_res - Row vector; Samples in time domain after correction of fine frequency offset. The first 2552 samples belong to the reference symbol
    % Input 2: zPRS - Row vector of 1536 values; Reference Symbol without disturbance (Sample rate 1536 kHz) (empty DC component is not included)
    %
    % Output: coarseFreqOffset - Coarse Frequency offset in number of subcarriers
    %
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    start = Constants.CPL+1;
    stop = Constants.CPL+1+Constants.SL-1;
    
    % FFT of received Reference Symbol
    recPRSSymbol = fftshift(fft(oneFrame_res(start:stop))); 
    clear start stop;
        
    % change line to row vector
    recPRSSymbol = recPRSSymbol.'; 
    
    coarseFreqOffset = coarse_Freq_Synchronization(recPRSSymbol,Constants.zPRS,figure_parameters.fig_handle);
    
    %% print the results to the screen and update the GUI
    fprintf('\t\t %d',coarseFreqOffset);
    estimated_parameters(frameNumber,3) = coarseFreqOffset;
    set(figure_parameters.mTextBox,'String',num2str(estimated_parameters(1:frameNumber,:)));
    
    %% Correct Coarse Frequency Offset in Frequency Domain for Reference Symbol
    start1 = 257+coarseFreqOffset;
    stop1 = start1+767;
    
    start2 = stop1+1+1;
    stop2  = start2+767;
    
    recPRSSymbol_wo_CFO = [recPRSSymbol(start1 : stop1); recPRSSymbol(start2 : stop2)]; % Received Reference Symbol without Coarse Frequency Offset

    %% Update the GUI
    figure(figure_parameters.fig_handle);
    subplot('Position',[0.05 0.25 0.25 0.28]);
    hold off;plot( (-1023:1024),abs(recPRSSymbol)); hold on; plot([start1-1024 start1-1024],[0 max(abs(recPRSSymbol))],'--r'); plot([stop2-1024 stop2-1024],[0 max(abs(recPRSSymbol))],'--r'); xlabel('Frequency [kHz] = Subcarrier'); ylabel('|z^{(RS)}_k|'); title({'Oversampled Reference Symbol in Frequency Domain:';'The red lines show the region chosen';'after the coarse Frequency Synch.'});
    clear start1 stop1 start2 stop2
   
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    %
    %% Appointment 3: Fine Frame Synchronization
    % Edit the function 'fine_Frame_Synchronization()'
    %
    % Input 1: recPRSSymbol_wo_CFO - Row vector of 1536 values; Received reference symbol in frequency domain without coarse frequency offset
    % Input 2: zPRS - Row vector of 1536 values; transmitted reference symbol in frequency domain
    %
    % Output 1: fineFrameOffset - estimates the fine frame/time-offset in samples
    % Output 2: H - estimated channel transfer function
    % Output 3: h_time - estimated channel impulse response    
    %
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    [fineFrameOffset, H, h_time]= fine_Frame_Synchronization(recPRSSymbol_wo_CFO,Constants.zPRS,figure_parameters.fig_handle);

    %% print the results to the screen and update the GUI
    fprintf('\t\t %d\n',fineFrameOffset);
    estimated_parameters(frameNumber,4) = fineFrameOffset;
    set(figure_parameters.mTextBox,'String',num2str(estimated_parameters(1:frameNumber,:)));
    
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    %
    %% Appointment 4: Estimation of the signal and noise power
    % Edit the function 'estimate_SNR()'
    %
    % Input 1: oneFrame_res - samples of one frame and the Null-Symbol
    % Input 2: Tnull - Length of the Null-Symbol
    % Output : SNR_before_demodulation_dB - Signal-to-Noise ratio in dB
    %
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    [SNR_before_demodulation_dB] = estimate_SNR(oneFrame_res,Constants.Tnull);
    
    %% assign the reference symbol as 'previous ofdm symbol' to be used
    % during the differential decoding
    ofdm_symbol_f_previous = recPRSSymbol_wo_CFO; 
    
    %% Equalization (optional)
    % ofdm_symbol_f_previous = recPRSSymbol_wo_CFO./H;
    
    % Now, the synchronisation of this frame is completed. 
    % Begin with the OFDM Symbol loop
    for symbolNumber=1:75 %% symbolNumber describes the number of the OFDM-symbol
        
        %% extract the current OFDM symbol with cyclic prefix in time domain (with frequency offset)
        start = symbolNumber*(Constants.CPL+Constants.SL) + 1;
        stop = symbolNumber*(Constants.CPL+Constants.SL)+ Constants.CPL + Constants.SL;
        ofdm_symbol_t = oneFrame_res(start : stop); 
        clear start stop;
        
        % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        %
        %% Appointment 4: OFDM Demodulation
        % Edit the function 'OFDM_demodulation()'
        %
        % Input 1: ofdm_symbol_t - Line vector of 2552 samples; One OFDM-symbol in the time-domain including the cyclic prefix
        % Input 2: coarseFreqOffset -  Estimated coarse frequency offset in kHz
        % Output: ofdm_symbol_f - Row vector of 1536 samples; 1536 DQPSK-symbols = One OFDM-symbol in frequency-domain without coarse frequency shift, without oversampling and without DC
        %
        % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        ofdm_symbol_f = OFDM_demodulation(ofdm_symbol_t,coarseFreqOffset,Constants);
        
        
        %% update the gui
        if symbolNumber == 1
            figure(figure_parameters.fig_handle);
            subplot('Position',[0.70 0.25 0.25 0.28]);
            hold off; plot(ofdm_symbol_f/mean(abs(ofdm_symbol_f)),'.b');  hold on; title({'DQPSK-Symbols (Blue: before differential';'demodulation; Red: after diff. demod.)'}); xlabel('Real Part (Inphase)'); ylabel('Imaginary Part (Quadrature)');  xlim([-4 4]); ylim([-3 3]);
        end
        if symbolNumber == 2
            subplot('Position',[0.70 0.25 0.25 0.28]);
            plot(ofdm_symbol_f/mean(abs(ofdm_symbol_f)),'.b');  hold on; title({'DQPSK-Symbols (Blue: before differential';'demodulation; Red: after diff. demod.)'}); xlabel('Real Part (Inphase)'); ylabel('Imaginary Part (Quadrature)');  xlim([-4 4]); ylim([-3 3]);
        end
        
        
        % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        %
        %% Appointment 4: Differential  Demodulation
        % Edit the function 'differential_demodulation()'
        %
        % Input 1: ofdm_symbol_f - 1536 DQPSK-symbols
        % Input 2: ofdm_symbol_f_previous - 1536 DQPSK-symbols of previous OFDM-symbol
        % Output:  qpsk_symbols - Row vector of 1536 QPSK-Symbols
        %
        % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        qpsk_symbols = differential_demodulation(ofdm_symbol_f,ofdm_symbol_f_previous,coarseFreqOffset,Constants);

        %% update the gui
        if symbolNumber == 2
            figure(figure_parameters.fig_handle);
            subplot('Position',[0.70 0.25 0.25 0.28]);
            hold on; plot(qpsk_symbols/mean(abs(qpsk_symbols)),'.r');xlim([-4 4]); ylim([-3 3]);
            xlabel('Real Part (Inphase)'); ylabel('Imaginary Part (Quadrature)');
        end
        
        %% store symbol for differential demodulation of next symbol
        ofdm_symbol_f_previous = ofdm_symbol_f; 
        
        
        % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        %
        %% Appointment 4: Estimation of the SNR after differentiel modulation
        % Edit the function 'estimate_SNR_blind()'
        %
        % Input 1: qpsk_symbols - noisy qpsk symbols
        % Output : SNR_dB_after_diff_demod - Signal-to-Noise ratio in dB
        %
        % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        [SNR_dB_after_diff_demod] = estimate_SNR_blind(qpsk_symbols);
        
        

        %% Frequency Deinterleaving
        qpsk_symbols_deint(Constants.freqTable) = qpsk_symbols;
        
        % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        %
        %% Appointment 4: QPSK Demapper
        % Edit the function 'demapper()'
        %
        % Input 1: qpsk_symbols_deint - deinterleaved qpsk symbols
        % Input 3: SNR in dB
        % Input 2: demapping_method: 'hard' or 'soft'
        % Output:  demapped_output - Row vector of 3072 values
        %
        % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        SNR = SNR_before_demodulation_dB + 10*log10(2048/1536) - 3;
        demapped_output = demapper(qpsk_symbols_deint,SNR,Parameters.demapping_method);
        
        %% extract the FIC and MSC bits
        if symbolNumber <= 3
            CodeBits.FIC = [CodeBits.FIC demapped_output]; % store all code bits of Fast Information Channel (FIC); (9216 code bits per DAB-frame)
        else
            CodeBits.MSC = [CodeBits.MSC demapped_output]; % store all code bits of Main Service Channel (MSC); (221184 code bits per DAB-frame)
        end
        
    end % END of OFDM-Symbol loop
    drawnow;
    
end % END of DAB-Frame loop

% Now, all the OFDM symbols of each frame is demodulated
% Begin with decoding

% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%
%% Appointment 5: Channel Decoding of Fast Information Channel
% Edit the function 'channel_decoding()'
%
% Input 1: CodeBits.FIC - line-vector with 9216*n codebits of the fast information channel (FIC); 9216 codebits per DAB-Frame; n is the number of DAB-Frames
% Input 2: Constants
% Input 3: demapping method: 'hard' or 'soft'
% Output:  FIBs  - Matrix with 12*n rows and 256 columns; Each row contains one fast information block (FIB) with 256 information bits
%
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FIBs = channel_decoding(CodeBits.FIC,Constants,Parameters.demapping_method);

%% Interpret FIC Information
[chan_names, FIBerrorRate] = FIBSink(FIBs); % FIC Parser interprets information bits of FIC


%% update the GUI
set(figure_parameters.mListbox2,'String',chan_names);
set(figure_parameters.mListbox4,'String',['FIB Error Rate = ' num2str(FIBerrorRate)]);


% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%
%% Appointment 6: Decoding of the Fast Information Blocks
% Edit the function 'decode_FIBs()'
%
% Input : FIBs -
%
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
decode_FIBs(FIBs);


%% close the file
fclose(Parameters.bufferHRead);
