function ret = tuneUSRPTX(frequency)


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

calllib('libusrpmatlab','setFreqTX',int32(frequency));
ret = 1;