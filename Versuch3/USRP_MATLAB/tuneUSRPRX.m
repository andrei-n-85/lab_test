function ret = tuneUSRPRX(frequency)


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

calllib('libusrpmatlab','setFreq',int32(frequency));
ret = 1;