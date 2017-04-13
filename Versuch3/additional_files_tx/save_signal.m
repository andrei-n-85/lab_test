function save_signal(TF,filename_perfix,Sampling_Frequency)

sig = resample(TF,Sampling_Frequency,2048000);  % resampling from 2048000Hz to 2000000Hz

scale =  350000;
resampled = int16( scale*sig );

% Reshape vector to I Q I Q I... format
resampled_re = real(resampled);
resampled_im = imag(resampled);
trans_out = [(resampled_re(:))'; (resampled_im(:))'];
trans_out =  trans_out(:).';

filename = [filename_perfix '_' num2str(Sampling_Frequency) 'Hz.bin'];
%% Save resampled data to file
if exist(filename);
unix(['rm ' filename]);
end

fid = fopen(filename,'a');
state = fwrite(fid,trans_out,'single');
fclose(fid);
if state
disp([filename ' has been saved! ' ]);
end