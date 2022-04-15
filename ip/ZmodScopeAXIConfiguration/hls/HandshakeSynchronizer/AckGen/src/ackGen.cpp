/********************************************************************************
 *  File: ackGen.cpp
 *  Author: Nita Eduard
 *  Date: 28 March 2022
 *
 *  Description:
 *	The purpose of the Handshake Acknowledge Generator is to be used
 *  along side the Handshake Request Generator to synchronize multiple signals
 *  across two clock domains.
 *  
 *	This core generates the outloadData signal used to load the data into the
 *  receiving clock domain and the outAck signal used to send a handshake acknowledge.
 *  
 *	The data is not loaded into the receiving clock domain 
 *	until it is valid and the receiving logic acknowledges that it should be loaded
 *  by asserting the inLoad signal.
 ********************************************************************************/

#include <ap_int.h>

typedef enum {
	Wait,
	Ready
} STATE;

/********************************************************************************
 * inLoad 		- load data request signal
 * inReq		- handshake request signal
 * outAck		- handshake acknowledge signal
 * outValid		- valid data signal
 * outLoadData	- signal used to load data into receiving clock domain
 ********************************************************************************/
void ack_gen(
		ap_uint<1> inLoad,
		ap_uint<1> inReq,
		ap_uint<1>& outAck,
		ap_uint<1>& outValid,
		ap_uint<1>& outLoadData
		) {
	#pragma HLS interface ap_ctrl_none port=return
	#pragma HLS interface ap_none port=inLoad
	#pragma HLS interface ap_none port=inReq
	#pragma HLS interface ap_none port=outAck
	#pragma HLS interface ap_none port=outValid
	#pragma HLS interface ap_none port=outLoadData

	ap_uint<1> dataValid;
	ap_uint<1> valid;
	ap_uint<1> req;

	static ap_uint<1> reqD[3];
	#pragma HLS ARRAY_PARTITION variable=reqD type=complete
	static ap_uint<1> ackD;
	static STATE currentState = Wait;

	valid = (currentState == Ready);
	req = reqD[2] ^ reqD[1];

	switch(currentState) {
		case Wait:
			if(req) {
				currentState = Ready;
			}
			break;
		case Ready:
			if(inLoad) {
				currentState = Wait;
			}
			break;
		default:
			currentState = Wait;
			break;
	}

	outValid = valid;
	dataValid = inLoad & valid;
	outAck = ackD;
	reqD[2] = reqD[1];
	reqD[1] = reqD[0];
	reqD[0] = inReq;
	ackD = dataValid ^ ackD;
	outLoadData = dataValid;
}
