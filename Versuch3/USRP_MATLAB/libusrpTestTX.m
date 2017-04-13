
initUSRPTX(1,0,0);
initUSRPRX(1,0,1);

interp = 256;
decim = 128;

setTXInterpolation(interp);
setRXDecimation(decim);

setTXGain(10);
setRXGain(10);


tuneUSRPTX(433000000);
tuneUSRPRX(89000000);

startTX;
startRX;

L = 81920;
for i=0:50
    A = readRXBuffer(L);
    writeTXBuffer(A./1);
end


stopTX;
stopRX;
