function ret  = stopTX()


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
pause(1);
calllib('libusrpmatlab','stopTransferTX');