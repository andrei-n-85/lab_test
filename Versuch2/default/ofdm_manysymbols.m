% Many OFDM symbols; Variable OFDM Parameters


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SENDER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L = 100; % Number of OFDM symbols
N = 2; % Number of subcarriers (without DC); N hast to be larger than 1
T_u = 3; % Symbol duration without Guardinterval in samples (1. DAB-TM: T_u = 1e-3 s = 2048 samples); 1/T_u is equal to subcarrierspacing; T_u has to be larger than N
CP_duration = 0; % Duration of Cyclic Prefix in samples; CP_duration has to be smaller than T_u
% The total used bandwidth is given by N/T_u; The throughput is given by 2*N/(T_u+CP_duration) in bits/sample



% Generate random bits
bits_to_map = randi(2,2*N*L,1)-1;

s_TP = [];
for ii = 0 : L-1
    % Modulation: 4-QAM
    h = modem.qammod('M',4,'InputType','bit'); % Initialization
    z = modulate(h,bits_to_map(ii*2*N+1:ii*2*N+2*N));
    
    if ii == floor(L/2)
        scatterplot(z); title('QAM-Symbols at Sender'); xlabel('Real Part (Inphase)'); ylabel('Imaginary Part (Quadrature)');
    end
    
    % OFDM-Modulation
    num_zeros1 = floor((T_u - N)/2); % Zeros for oversampling
    num_zeros2 = ceil((T_u - N)/2 - 1); % Zeros for oversampling
    
    
    z_input = [zeros(num_zeros1,1); z(1:length(z)/2); 0; z(length(z)/2+1:length(z)); zeros(num_zeros2,1)]; % include zeros for oversampling; include 0 at DC (Gleichanteil)
    ofdm_symbol_wo_cp = ifft(ifftshift(z_input)); % Ofdm Symbol without Cyclic Prefix
    ofdm_symbol_wo_cp = ofdm_symbol_wo_cp.';
    ofdm_symbol = [ofdm_symbol_wo_cp((end-CP_duration+1):end) ofdm_symbol_wo_cp]; %add cyclic prefix
    
    
    s_TP = [s_TP ofdm_symbol];
end
s_TP = s_TP/sqrt(mean(abs(s_TP).^2)); %scale signal to average power of 1
figure; plot(abs(s_TP)); title('Absolute Value of Transmitted signal'); xlabel('Time (samples)'); ylabel('Absolute value');
ofdm_symbol_length = length(ofdm_symbol);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Channel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Path 1
a_1 = 1; % attenuation of path 1
tau_1 = 0; % delay of path 1 (number of samples)

% Path 2
a_2 = 0; % attenuation of path 2
tau_2 = 200; % delay of path 2 (number of samples) % tau_2 has to be larger or equal than tau_1

% Noise
noise_var = 0.000001;
noise = sqrt(noise_var/2)*(randn(1,length(s_TP)+tau_2) + 1i*randn(1,length(s_TP)+tau_2));


s_TP_delayed1 = [zeros(1,tau_1) s_TP zeros(1,tau_2-tau_1)];
s_TP_delayed2 = [zeros(1,tau_2) s_TP];
r_TP = a_1 * s_TP_delayed1 + a_2 * s_TP_delayed2 + noise;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Receiver
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

r_bits_to_map = [];
for ii = 0 : L-1
    r_TP_onesymbol = r_TP(ii*ofdm_symbol_length+1 : ii*ofdm_symbol_length+ofdm_symbol_length);
    
    
    % remove Cyclic Prefix
    r_ofdm_symbol_start = CP_duration + 1;
    r_ofdm_symbol_stop = CP_duration + T_u;
    r_ofdm_symbol_wo_cp = r_TP_onesymbol(r_ofdm_symbol_start : r_ofdm_symbol_stop);
    
    
    % OFDM-Demodulation
    r_z_input = fftshift(fft(r_ofdm_symbol_wo_cp));
    r_z_input = r_z_input.';
    start1 = num_zeros1 + 1;
    stop1 = num_zeros1 + N/2;
    start2 = num_zeros1 + N/2 + 1 + 1;
    stop2 = num_zeros1 + N + 1;
    
    %Multipath Compensation
    fi = [-T_u/2 : T_u/2-1]'/T_u; % fi = i/T_u
    r_z_input2 = r_z_input ./ (a_1*exp(-1i * 2 * pi * tau_1 * fi) + a_2*exp(-1i * 2 * pi * tau_2 * fi));
    
    % remove oversampling and DC
    r_z = [r_z_input2(start1:stop1); r_z_input2(start2:stop2)];
    if ii == floor(L/2)
        scatterplot(r_z); title('QAM-Symbols at Receiver'); xlabel('Real Part (Inphase)'); ylabel('Imaginary Part (Quadrature)'); xlim([-100 100]); ylim([-100 100]);
    end
    
    % Demodulation: 4-QAM
    h = modem.qamdemod('M',4,'OutputType','bit'); % Initialization
    r_bits_to_map_onesymbol = demodulate(h,r_z);
    r_bits_to_map = [r_bits_to_map; r_bits_to_map_onesymbol];
end


disp('**************************************');
disp('number of total bits');
disp(length(bits_to_map));
disp('number of bit errors');
disp(sum(abs(r_bits_to_map - bits_to_map)));
disp('Signal-to-Noise Ratio in dB');
SNR = mean(abs(a_1 * s_TP_delayed1 + a_2 * s_TP_delayed2).^2)/mean(abs(noise).^2);
disp(10*log10(SNR));








