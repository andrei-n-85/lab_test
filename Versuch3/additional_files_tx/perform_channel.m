function out = perform_channel(TF,channel)

Ts = 1/2048000;

signal_len = length(TF);

max_delay = ceil(max(channel.Delay)/Ts)+1;
min_delay = ceil(min(channel.Delay)/Ts)+1;

out = zeros( length(TF) + max_delay , 1);

number_of_paths = length(channel.Delay);

for t=1:number_of_paths
   tau      = floor((channel.Delay(t))/Ts); 
   gain     = channel.Path_Gain(t);
   delta_f  = channel.Doppler_Frequency(t);
   
   ind = (tau+1):(tau+signal_len);

   out(ind) = out(ind) + sqrt(gain)*TF.*exp(1i*2*pi*(1:length(TF))'*Ts*delta_f); 

end

out(1:min_delay) = sqrt(1.8e-4)*randn(1,min_delay) + 1i*sqrt(1.8e-4)*randn(1,min_delay);
%% Add Noise


 Sig_Pow = mean(abs(out).^2);
 Noise_Pow = Sig_Pow/(10^(channel.SNR_dB/10));
 
 noise = sqrt(Noise_Pow/2)*randn(size(out)) + 1i*sqrt(Noise_Pow/2)*randn(size(out));
 
 out = out + noise;
 