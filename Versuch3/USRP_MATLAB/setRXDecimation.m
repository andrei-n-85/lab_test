function ret  = setRXDecimation(decimation)


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

if (decimation < 8 || decimation > 256)
    ret = 0;
    disp('error: decimation has to be between [8 256]')
    return;
end
if mod(decimation,2)
    ret = 0;
    disp('error: decimation has to be even')
    return;
end

ret = 1;
calllib('libusrpmatlab','setDecim',int32(decimation));