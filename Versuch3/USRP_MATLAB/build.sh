rm libusrpmatlab.so
rm libusrpmatlab.so.1
rm libusrpmatlab.so.1.0

#g++ -fPIC -DPIC -Wall -c libusrpTest.c -o libusrpmatlab.o -lusrp
#g++ -shared -o libusrpmatlab.so.1.0 -WI,-soname,libusrpmatlab.so.1 libusrpmatlab.o -static -lusrp
#ln -s libusrpmatlab.so.1.0 libusrpmatlab.so.1
#ln -s libusrpmatlab.so.1 libusrpmatlab.so

#g++ -fPIC -DPIC -o libusrpmatlab.so libusrpTest.c -shared -lusrp
g++ -fPIC -O3 -o libusrpmatlab.so -I/usr/local/include/usrp libusrpTest.c -shared -lusrp -lpthread
sudo cp libusrpmatlab.so /usr/lib

g++ test.c -o testLib -lusrpmatlab
