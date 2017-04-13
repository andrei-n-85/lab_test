#include <usrp_standard.h>
#include <stdio.h>
#include <usrp_prims.h>
#include "libusrpTest.h"
#include <db_base.h>
#include <vector>
#include <usrp_bytesex.h>
#include <fcntl.h>
#include <errno.h>
#include <pthread.h>
using namespace std;


void *transferTX(void *dummy);

usrp_standard_rx_sptr usrp;
usrp_standard_tx_sptr usrpTX;

db_base_sptr subdev;
db_base_sptr subdevTX;
vector <vector <db_base_sptr> > subdevs;

int BUFSIZE,BUFSIZETX;						// buffer size
int N,NTX;						// N = BUFSIZE/sizeof (double);
short *buf;						// RX Buffer
short *bufTX;						// TX Buffer
int npipe,npipeTX;
FILE *npipeFileh,*npipeFilehTX;
FILE *readFileh,*readFilehTX;						// pipe handle
					
unsigned int bufferSize;					// Length of the allocated buffer in Bytes
int bytesPerSample;					// Bytes per sample from the USRP (1..2)
int channelCount;					// Number of channels that were read from the USRP.

pthread_t transferThread;					// RX thread
pthread_t transferThreadTX;					// TX thread
bool isReceiving=false;
bool isTransmitting=false;

int rxInitialized(void) {
	if (usrp==0)
		return 0;
	else
		return 1;
}
int txInitialized(void) {
	if (usrpTX==0)
		return 0;
	else
		return 1;
}


///////////////////////////////////////////////////////
//
//	USRP RX INITIALIZATION
//
///////////////////////////////////////////////////////
int usrpInitRX(void) {

// Initialize RX USRP
usrp = usrp_standard_rx::make(
		0,	//which_board,
		32,	//decim_rate,
		1,	//nchan,
		-1,	//mux,
		0,	//mode,
		0,	//fusb_block_size,
		0	//fusb_nblocks,
	);

if (usrp==0) {
fprintf(stderr,"no usrp found\n");
return 0;
}


// Create named PIPE /tmp/USRPPIPE
int lvc;
lvc = mkfifo("/tmp/USRPPIPE",0666);

if ((lvc == -1) && (errno != EEXIST)) {
fprintf(stderr,"couldn't create named pipe\n");
return 0;
}


//usrp->set_verbose(true);
return 1;
}

///////////////////////////////////////////////////////
//
//	TRANSFER INITIALIZATION
//
///////////////////////////////////////////////////////
int initTransfer(void) {

// Open PIPE
npipeFileh = fopen("/tmp/USRPPIPE","w+");
if (npipeFileh)
    npipe = fileno (npipeFileh);
int dum[1]={1};
write(npipe,dum,1);

readFileh = fopen("/tmp/USRPPIPE","r+");

// Init Buffer
BUFSIZE = usrp->block_size();
N = BUFSIZE/sizeof (short); //double
buf = new short [N];

return 1;
}


///////////////////////////////////////////////////////
//
//	DAUGHTERBOARD INITIALIZATION
//
///////////////////////////////////////////////////////
int dbInit(int side, int index,int antenna) {

// Set sample width, if different from the default (2 Bytes)
/*if (sampleWidth == 1) {
	usrp->usrp->set_format(usrp->usrp->make_format(8, 8));
	// TODO: set_usb_datarate(), so that uO gets displayed the correct number of times.
}
*/

fprintf(stderr,"bytes per sample: %i\n",usrp->format_width(usrp->format()) / 8);

// get subdevs
subdevs = usrp->db();


// HACK select subdev from subdevs
int sideIndex = side;
int subdevIndex  = index;


// Check
if (sideIndex >= subdevs.size() || subdevIndex >= subdevs[sideIndex].size()) {
	fprintf(stderr,"No subdev on side %i and index %i \n max is: %i and %i",sideIndex,subdevIndex,subdevs.size(),subdevs[sideIndex].size());
	return 0;
}


// Select Subdev
subdev = subdevs[sideIndex][subdevIndex];
fprintf(stderr,"Subdevice name is %s\n", subdev->name().c_str());
fprintf(stderr,"Subdevice freq range: (%g, %g)\n", 
	 subdev->freq_min(), subdev->freq_max());

subdev->select_rx_antenna(antenna);

int channelNum = 0;


// Tune to
/*int frequency = l;
usrp_tune_result tuneResult;
if (!usrp->tune(channelNum, subdev, frequency, &tuneResult)) {
	fprintf(stderr,"failed to tune\n");
	return 0;
}*/

// Set Gain
//subdev->set_gain(0);



/* Calculate and set MUX */
int mux = 0;
int muxForThisSubdev = usrp->determine_rx_mux_value(usrp_subdev_spec(sideIndex, subdevIndex));


muxForThisSubdev = (muxForThisSubdev & 0xff);
mux |= (muxForThisSubdev << 8 * channelNum);
fprintf(stderr,"calculated MUX: %X\n",mux);

// Adjust MUX: Are we are operating on real samples?
if ((mux & 0xf0) == 0xf0) {
	fprintf(stderr,"operating on real samples!\n");
	// Set the rest of the Q-Inputs of the mux to constant zero (f) as well.
	for (channelNum=1; channelNum < 4; channelNum++) {
		mux |= (0xf0 << 8 * channelNum);
	}
}
if (!usrp->set_mux(mux)) {
	fprintf(stderr,"failed to set mux\n");	
	return 0;
}


return 1;
}



///////////////////////////////////////////////////////
//
//	SET FREQUENCY
//
///////////////////////////////////////////////////////
int setFreq(double freq)
{
usrp_tune_result tuneResult;
if (!usrp->tune(0, subdev, freq, &tuneResult)) {
	fprintf(stderr,"failed to tune\n");
	return 0;
}
//if (!usrp->set_rx_freq(0,freq))
//fprintf(stderr,"tuning failed");

return 1;
}
///////////////////////////////////////////////////////
//
//	SET GAIN
//
///////////////////////////////////////////////////////
int setGain(int gain)
{

if (!subdev->set_gain(gain))
fprintf(stderr,"set gain failed");

return 1;
}
///////////////////////////////////////////////////////
//
//	SET DECIMATION
//
///////////////////////////////////////////////////////
int setDecim(int dec) {
if (dec>7 && dec<257) {
	usrp->set_decim_rate((unsigned int)dec);	
	return 1;
}
else 
	return 0;
}
///////////////////////////////////////////////////////
//
//	TRANSFER DATA
//
///////////////////////////////////////////////////////
void *transfer(void *dummy)
{

  bool overrun;
for (;;) {
  unsigned int	ret = usrp->read (buf, /*sizeof (buf)*/ BUFSIZE, &overrun);
    if (ret != BUFSIZE){
      fprintf (stderr, "test_input: error, ret = %d\n", ret);
    }

    if (overrun){
      fprintf (stderr,"rx_overrun\n");
    }

for (unsigned int i = 0; i < /* sizeof (buf) / sizeof (short)*/ N; i++)
	buf[i] = usrp_to_host_short (buf[i]);
//write to stdout
    //write(1,buf,BUFSIZE);

// write to pipe
    write(npipe,buf,BUFSIZE);
}
}

///////////////////////////////////////////////////////
//
//	START TRANSFER THREAD
//
///////////////////////////////////////////////////////
int startTransfer(void)

{
if (isReceiving)
	return 0;


if (!usrp->start())
	fprintf(stderr,"starting failed");

pthread_create(&transferThread,NULL,transfer,NULL);
isReceiving = true;
return 1;

}

///////////////////////////////////////////////////////
//
//	STOP TRANSFER THREAD
//
///////////////////////////////////////////////////////
int stopTransfer(void)
{
if (!isReceiving)
	return 0;


if (!usrp->stop())
	fprintf(stderr,"stoping failed");

pthread_cancel(transferThread);

isReceiving = false;

return 1;
}

///////////////////////////////////////////////////////
//
//	READ BUFFER
//
///////////////////////////////////////////////////////
int readBuffer(int bytes,int shift,short * buffer)
{
	int ret;
	if (shift>0)
	{
		short *dummy[shift];
		ret = fread(buffer,1,bytes,readFileh);
		ret = fread(dummy,1,shift,readFileh);
	}
	else
		ret = fread(buffer,1,(bytes+shift),readFileh);
	return ret;
}
///////////////////////////////////////////////////////
//
//	DESTROY USRP
//
///////////////////////////////////////////////////////
int destroyUSRP(void) {
//	close(npipe);
//	fclose(readFileh);
}













/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
//
//			TX
/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////
//
//	INIT USRP TX
//
///////////////////////////////////////////////////////
int usrpInitTX(void) {

// Initialize RX USRP
usrpTX = usrp_standard_tx::make(
		0,	//which_board,
		32*2,	//interp_rate,
		1,	//nchan,
		-1,	//mux,
		0,	//fusb_block_size,
		0	//fusb_nblocks,
	);

if (usrpTX==0) {
fprintf(stderr,"no usrp found\n");
return 0;
}


// Create named PIPE /tmp/USRPPIPETX
int lvc;
lvc = mkfifo("/tmp/USRPPIPETX",0666);

if ((lvc == -1) && (errno != EEXIST)) {
	fprintf(stderr,"couldn't create named pipe\n");
return 0;
}
return 1;
}

///////////////////////////////////////////////////////
//
//	INIT DB TX
//
///////////////////////////////////////////////////////
int initdbTX(int side,int index, int duplex) {

usrp_subdev_spec spec(side,index);
subdevTX = usrpTX->selected_subdev(spec);
fprintf(stderr,"Subdevice name is %s\n", subdevTX->name().c_str());
fprintf(stderr,"Subdevice freq range: (%g, %g)\n",subdevTX->freq_min(), subdevTX->freq_max());

unsigned int mux = usrpTX->determine_tx_mux_value(spec);
fprintf(stderr,"mux: %#08x\n",  mux);
usrpTX->set_mux(mux);
if (duplex==1)
	subdevTX->set_auto_tr(true);
else if(duplex==0)
	subdevTX->set_enable(true);
}

///////////////////////////////////////////////////////
//
//	SET TX GAIN
//
///////////////////////////////////////////////////////
int setGainTX(int gain) {
	subdevTX->set_gain(gain);
}


//float input_rate = usrpTX->dac_rate() / usrpTX->interp_rate();
//fprintf(stderr,"baseband rate: %g\n",  input_rate);



///////////////////////////////////////////////////////
//
//	SET TX FREQUENCY
//
///////////////////////////////////////////////////////
int setFreqTX(int f) {
usrp_tune_result r;
float rf_freq = f;//(subdev->freq_min() + subdev->freq_max()) * 0.5;
double target_freq = rf_freq;
bool ok = usrpTX->tune(0, subdevTX, target_freq, &r);

fprintf(stderr,"target_freq:     %f\n", target_freq);
fprintf(stderr,"ok:              %s\n", ok ? "true" : "false");
fprintf(stderr,"r.baseband_freq: %f\n", r.baseband_freq);
fprintf(stderr,"r.dxc_freq:      %f\n", r.dxc_freq);
fprintf(stderr,"r.residual_freq: %f\n", r.residual_freq);
fprintf(stderr,"r.inverted:      %d\n", r.inverted);
}
///////////////////////////////////////////////////////
//
//	SET TX INTERPOLATION
//
///////////////////////////////////////////////////////
int setInterpTX(unsigned int interp) {
usrpTX->set_interp_rate(interp);
}

///////////////////////////////////////////////////////
//
//	TX TRANSFER INITIALIZATION
//
///////////////////////////////////////////////////////
int initTransferTX(void) {

// Open PIPE

readFilehTX = fopen("/tmp/USRPPIPETX","r+");
fprintf(stderr,"%i\n",readFilehTX);

/*npipeFilehTX = fopen("/tmp/USRPPIPETX","w+");
fprintf(stderr,"%i\n",npipeFilehTX);
if (npipeFileh)
    npipeTX = fileno (npipeFileh);

*/
npipeTX  =open("/tmp/USRPPIPETX",O_RDWR);
int dum[1]={1};
write(npipe,dum,1);



// Init Buffer
BUFSIZETX = usrpTX->block_size();
NTX = BUFSIZETX/sizeof (short); //double
bufTX = new short [NTX];

return 1;
}
///////////////////////////////////////////////////////
//
//	START TRANSFER TX THREAD
//
///////////////////////////////////////////////////////
int startTransferTX(void)

{
if (isTransmitting)
	return 0;


if (!usrpTX->start())
	fprintf(stderr,"starting TX failed");

pthread_create(&transferThreadTX,NULL,transferTX,NULL);
isTransmitting = true;
return 1;

}

///////////////////////////////////////////////////////
//
//	STOP TRANSFER TX THREAD
//
///////////////////////////////////////////////////////
int stopTransferTX(void)
{
if (!isTransmitting)
	return 0;


if (!usrpTX->stop())
	fprintf(stderr,"stoping failed");

pthread_cancel(transferThreadTX);

isTransmitting = false;

return 1;
}
///////////////////////////////////////////////////////
//
//	TRANSFER TX DATA
//
///////////////////////////////////////////////////////
void *transferTX(void *dummy)
{

bool underrun;

for (;;) {

  fread(bufTX,2,NTX,readFilehTX);
  
  for (int i=0;i<NTX;i++)
	bufTX[i] = host_to_usrp_short((short)bufTX[i]);

  unsigned int ret = usrpTX->write(bufTX, /*sizeof (buf)*/ BUFSIZETX, &underrun);

    if (ret != BUFSIZETX){
      fprintf (stderr, "test_input: error, ret = %d\n", ret);
    }

    if (underrun){
      fprintf (stderr,"tx_underrun\n");
    }

  usrpTX->wait_for_completion ();
}


}

///////////////////////////////////////////////////////
//
//	WRITE TX BUFFER
//
///////////////////////////////////////////////////////
int writeTXBuffer(int bytes,short * buffer)
{
	int ret;
		ret = write(npipeTX,buffer,bytes);
	return ret;
}
