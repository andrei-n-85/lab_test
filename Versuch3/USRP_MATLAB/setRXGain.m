function ret  = setRXGain(gain)


if ~libisloaded('libusrpmatlab')
    disp('usrp has to be initialized using initUSRPRX.m');
    ret = 0;
    return;
end
if ~calllib('libusrpmatlab','rxInitialized')
    disp('usrp has to be initialized using initUSRPRX.m');
    ret = 0;
    return;
end

ret = 1;
calllib('libusrpmatlab','setGain',int32(gain));