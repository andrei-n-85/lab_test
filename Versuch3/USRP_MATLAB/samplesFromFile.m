function ret = samplesFromFile(length,handle)


A = fread(handle,length*2,'single');

ret  = complex(A(1:2:end-1),A(2:2:end));

