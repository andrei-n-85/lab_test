% One OFDM symbol; DAB-Transmission Mode 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SENDER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Generate random bits
bits_to_map = randi(2,3072,1)-1;


% Modulation: 4-QAM
h = modem.qammod('M',4,'InputType','bit'); % Initialization
%h = modem.dpskmod('M',4,'InputType','bit'); % Initialization
%h.inputtype = 'bit';
z = modulate(h,bits_to_map);
scatterplot(z); title('QAM-Symbols at Sender'); xlabel('Real Part (Inphase)'); ylabel('Imaginary Part (Quadrature)');

% OFDM-Modulation
CP_duration = 504; % Duration of Cyclic Prefix

z_input = [zeros(256,1); z(1:768); 0; z(769:1536); zeros(255,1)]; % include zeros for oversampling; include 0 at DC (Gleichanteil)
ofdm_symbol_wo_cp = ifft(ifftshift(z_input)); % Ofdm Symbol without Cyclic Prefix
ofdm_symbol_wo_cp = ofdm_symbol_wo_cp.';
ofdm_symbol = [ofdm_symbol_wo_cp((end-CP_duration+1):end) ofdm_symbol_wo_cp]; %add cyclic prefix

s_TP = ofdm_symbol; %/sqrt(mean(abs(ofdm_symbol).^2)); %scale signal to average power of 1
figure; plot(abs(s_TP)); title('Absolute Value of Transmitted signal'); xlabel('Time (samples)'); ylabel('Absolute value');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Channel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Path 1
a_1 = 1; % attenuation of path 1
tau_1 = 0; % delay of path 1 (number of samples)

% Path 2
a_2 = 0; % attenuation of path 2
tau_2 = 10; % delay of path 2 (number of samples) % tau_2 has to be larger or equal than tau_1

% Noise
noise_var = 0;
noise = sqrt(noise_var/2)*(randn(1,length(s_TP)+tau_2) + 1i*randn(1,length(s_TP)+tau_2));


s_TP_delayed1 = [zeros(1,tau_1) s_TP zeros(1,tau_2-tau_1)];
s_TP_delayed2 = [zeros(1,tau_2) s_TP];
r_TP = a_1 * s_TP_delayed1 + a_2 * s_TP_delayed2 + noise;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Receiver
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% remove Cyclic Prefix
r_ofdm_symbol_start = CP_duration + 1;
r_ofdm_symbol_stop = CP_duration + 2048;
r_ofdm_symbol_wo_cp = r_TP(r_ofdm_symbol_start : r_ofdm_symbol_stop);


% OFDM-Demodulation
r_z_input = fftshift(fft(r_ofdm_symbol_wo_cp));
r_z_input = r_z_input.';
start1 = 256+1;
stop1 = 256+768;
start2 = 256+768+1+1;
stop2 = 256+768+1+768;

%Multipath Compensation
fi = [-1024 : 1023]'/2048; % fi = i/T_u (Symbol period without Guardinterval T_u = 1e-3 s = 2048 samples)
r_z_input2 = r_z_input ./ (a_1*exp(-1i * 2 * pi * tau_1 * fi) + a_2*exp(-1i * 2 * pi * tau_2 * fi));

% remove oversampling and DC
r_z = [r_z_input2(start1:stop1); r_z_input2(start2:stop2)];
scatterplot(r_z); title('QAM-Symbols at Receiver'); xlabel('Real Part (Inphase)'); ylabel('Imaginary Part (Quadrature)');


% Demodulation: 4-QAM
h = modem.qamdemod('M',4,'OutputType','bit'); % Initialization
%h = modem.dpskdemod('M',4,'OutputType','bit'); % Initialization
r_bits_to_map = demodulate(h,r_z);


disp('**************************************');
disp('number of total bits');
disp(length(bits_to_map));
disp('number of bit errors');
disp(sum(abs(r_bits_to_map - bits_to_map)));
disp('Signal-to-Noise Ratio in dB');
SNR = mean(abs(s_TP).^2)/mean(abs(noise).^2);
disp(10*log10(SNR));








