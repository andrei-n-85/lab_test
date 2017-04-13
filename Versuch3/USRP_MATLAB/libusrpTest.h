#ifdef __cplusplus
extern "C" {
#endif


int usrpInitRX(void);
int usrpInitTX(void);
int rxInitialized(void);
int txInitialized(void);
int setFreq(double freq);
int setFreqTX(int f);
int setGain(int gain);
int setGainTX(int gain);
int setDecim(int dec);
int setInterpTX(unsigned int interp);
int startTransfer(void);
int startTransferTX(void);
int stopTransfer(void);
int stopTransferTX(void);
int dbInit(int side, int index, int antenna);
int initdbTX(int side,int index, int duplex);
int initTransfer(void);
int initTransferTX(void);
int readBuffer(int bytes,int shift,short * buffer);
int writeTXBuffer(int bytes,short * buffer);
int destroyUSRP(void);
#ifdef __cplusplus
}
#endif
