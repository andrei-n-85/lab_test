function ret = readRXBuffer(numSamples)

bPtr = libpointer('int16Ptr',zeros(1,numSamples*2));


calllib('libusrpmatlab','readBuffer',int32(numSamples*4),int32(0),bPtr);


ret = complex(single(bPtr.Value(1:2:end-1)),single(bPtr.Value(2:2:end)));
