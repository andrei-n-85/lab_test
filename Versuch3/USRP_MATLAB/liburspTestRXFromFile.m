%% Initialisierung

initUSRPRX(1,0,1); % Side A=0; SubDevIndex 0; Antenna 0=RX/TX;


% File handle
fileHWrite = fopen('bufferfile.bin','w+');
fileHRead  = fopen('bufferfile.bin','r+');


% Dezimierung
dec = 32;
Fs = 64000000/dec;
T = 1/Fs;
setRXDecimation(dec);

% RX Gain
setRXGain(0);


% Radio Frequency
tuneUSRPRX(222064000);



startRX;

L = 192000;                     % Size
t = (0:L-1)*T;                  % Time vector
NFFT = 2^nextpow2(L);           % Next power of 2 from length of L
f = Fs/2*linspace(-1,1,NFFT);

for i=0:100
    
% read from usrp
A = readRXBuffer(L);

% write to file
samplesToFile(A,fileHWrite);

% read from file
A = samplesFromFile(L,fileHRead);




subplot(2,1,1)
plot(t,real(A))
xlabel('time [s]')

Y = fft(A,NFFT)/L;
subplot(2,1,2)
plot(f,2*abs(fftshift(Y))) 
xlabel('Frequency [Hz]')
ylabel('|Y(f)|')

drawnow;

end

fclose(fileHWrite)
fclose(fileHRead)

stopRX;