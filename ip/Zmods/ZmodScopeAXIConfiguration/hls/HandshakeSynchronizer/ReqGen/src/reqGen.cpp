/********************************************************************************
 *  File: reqGen.cpp
 *  Author: Nita Eduard
 *  Date: 28 March 2022
 *
 *  Description:
 *  The purpose of the Handshake Request Generator is to be used
 *  along side the Handshake Acknowledge Generator to synchronize multiple signals
 *  across two clock domains.
 *
 *  This core generates the outloadData signal used to load the data into the
 *  sending clock domain and the outReq signal used to send a handshake request.
 *
 *  The data is not loaded into the input clock domain until
 *  the Request Generator is ready and the sending logic decides to transmit data
 *  by asserting the inSend signal.
 ********************************************************************************/

#include <ap_int.h>

typedef enum {
	Ready,
	Busy
} STATE;

/********************************************************************************
 * inSend 		- s data request signal
 * inAck		- handshake acknowledge signal
 * outReq		- handshake request signal
 * outReady		- flag indicating that it is safe to change input data
 * outLoadData	- signal used to load data into sending clock domain
 ********************************************************************************/
void req_gen(
		ap_uint<1> inSend,
		ap_uint<1> inAck,
		ap_uint<1>& outReq,
		ap_uint<1>& outReady,
		ap_uint<1>& outLoadData
		) {
	#pragma HLS interface ap_ctrl_none port=return
	#pragma HLS interface ap_none port=inSend
	#pragma HLS interface ap_none port=inAck
	#pragma HLS interface ap_none port=outReq
	#pragma HLS interface ap_none port=outReady
	#pragma HLS interface ap_none port=outLoadData

	ap_uint<1> dataReady;
	ap_uint<1> ready;
	ap_uint<1> ack;

	static ap_uint<1> ackD[3];
	#pragma HLS ARRAY_PARTITION variable=ackD type=complete
	static ap_uint<1> reqD = 0;
	static STATE currentState = Ready;
	static ap_uint<8> dataReg = 0;
	ready = (currentState == Ready);
	ack = ackD[2] ^ ackD[1];

	switch(currentState) {
		case Ready:
			if(inSend) {
				currentState = Busy;
			}
			break;
		case Busy:
			if(ack) {
				currentState = Ready;
			}
			break;
		default:
			currentState = Ready;
			break;
	}

	outReady = ready;
	dataReady = inSend & ready;
	outReq = reqD;
	ackD[2] = ackD[1];
	ackD[1] = ackD[0];
	ackD[0] = inAck;
	outLoadData = dataReady;
	reqD = dataReady ^ reqD;
}
