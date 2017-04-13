function ret  = stopRX()


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
pause(1);
calllib('libusrpmatlab','stopTransfer');