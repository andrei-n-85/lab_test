function ret = writeTXBuffer(data)

bPtr = libpointer('int16Ptr',zeros(1,length(data)*2));

bPtr.Value(1:2:end-1) = int16(real(data));
bPtr.Value(2:2:end)   = int16(imag(data));


ret = calllib('libusrpmatlab','writeTXBuffer',int32(length(data)*4),bPtr);
