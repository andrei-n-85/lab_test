function ret  = setTXGain(gain)


if ~libisloaded('libusrpmatlab')
    disp('usrp has to be initialized using initUSRPTX.m');
    ret = 0;
    return;
end
if ~calllib('libusrpmatlab','txInitialized')
    disp('usrp has to be initialized using initUSRPTX.m');
    ret = 0;
    return;
end

ret = 1;
calllib('libusrpmatlab','setGainTX',int32(gain));