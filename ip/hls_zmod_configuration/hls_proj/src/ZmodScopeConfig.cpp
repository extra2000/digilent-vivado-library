//-------------------------------------------------------------------------------
//--
//-- File: ZmodScopeConfig.cpp
//-- Author: Nita Eduard
//-- Date: 16 March 2022
//--
//-------------------------------------------------------------------------------
//-- MIT License
//
//-- Copyright (c) 2022 Digilent
//
//-- Permission is hereby granted, free of charge, to any person obtaining a copy
//-- of this software and associated documentation files (the "Software"), to deal
//-- in the Software without restriction, including without limitation the rights
//-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//-- copies of the Software, and to permit persons to whom the Software is
//-- furnished to do so, subject to the following conditions:
//
//-- The above copyright notice and this permission notice shall be included in all
//-- copies or substantial portions of the Software.
//
//-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//-- SOFTWARE.
//--
//-------------------------------------------------------------------------------
//--
//-- Purpose:
//-- This core has been written in order to configure the Zmod Scope's
//-- calibration coefficients, High/Low gain, AC/DC coupling and inspect the
//-- Zmod Scope's status flags using an AXI-Lite interface.
//--
//-------------------------------------------------------------------------------
#include <ap_int.h>
void ZmodScopeConfig(ap_uint<1> RstBusy, ap_uint<1> InitDoneADC,
		ap_uint<1> ConfigError, ap_uint<1> InitDoneRelay,
		ap_uint<1> DataOverflow,
		ap_uint<18>& Ch1HgMultCoefAxil, ap_uint<18>& Ch1LgMultCoefAxil,
		ap_uint<18>& Ch1HgAddCoefAxil, ap_uint<18>& Ch1LgAddCoefAxil,
		ap_uint<18>& Ch2HgMultCoefAxil, ap_uint<18>& Ch2LgMultCoefAxil,
		ap_uint<18>& Ch2HgAddCoefAxil, ap_uint<18>& Ch2LgAddCoefAxil,
		ap_uint<4>& RelayConfigAxil, ap_uint<5>& StatusAxil,
		ap_uint<18>& Ch1HgMultCoef, ap_uint<18>& Ch1LgMultCoef,
		ap_uint<18>& Ch1LgAddCoef, ap_uint<18>& Ch1HgAddCoef,
		ap_uint<18>& Ch2HgMultCoef, ap_uint<18>& Ch2LgMultCoef,
		ap_uint<18>& Ch2LgAddCoef, ap_uint<18>& Ch2HgAddCoef,
		ap_uint<1>& Ch1Gain, ap_uint<1>& Ch2Gain,
		ap_uint<1>& Ch1Coupling, ap_uint<1>& Ch2Coupling) {
	#pragma HLS INTERFACE s_axilite port=return
	// AXI4-Lite registers
	// Channel 1 coefficients
	#pragma HLS INTERFACE s_axilite port=Ch1HgMultCoefAxil
	#pragma HLS INTERFACE s_axilite port=Ch1LgMultCoefAxil
	#pragma HLS INTERFACE s_axilite port=Ch1HgAddCoefAxil
	#pragma HLS INTERFACE s_axilite port=Ch1LgAddCoefAxil
	// Channel 2 coefficients
	#pragma HLS INTERFACE s_axilite port=Ch2HgMultCoefAxil
	#pragma HLS INTERFACE s_axilite port=Ch2LgMultCoefAxil
	#pragma HLS INTERFACE s_axilite port=Ch2HgAddCoefAxil
	#pragma HLS INTERFACE s_axilite port=Ch2LgAddCoefAxil
	// Relay Configuration
	#pragma HLS INTERFACE s_axilite port=RelayConfigAxil
	// Status bits
	// Since StatusAxil is written to, it will be implemented as ap_vld,
	// which will then register map the data AND valid signal (due to s_axilite).
	// Declared as ap_none as well, so it doesn't generate an extra valid signal
	#pragma HLS INTERFACE s_axilite port=StatusAxil
	#pragma HLS INTERFACE ap_none port=StatusAxil

	// Channel 1 coefficients
	#pragma HLS INTERFACE ap_none port=Ch1HgMultCoef register
	#pragma HLS INTERFACE ap_none port=Ch1LgMultCoef register
	#pragma HLS INTERFACE ap_none port=Ch1HgAddCoef register
	#pragma HLS INTERFACE ap_none port=Ch1LgAddCoef register
	// Channel 2 coefficients
	#pragma HLS INTERFACE ap_none port=Ch2HgMultCoef register
	#pragma HLS INTERFACE ap_none port=Ch2LgMultCoef register
	#pragma HLS INTERFACE ap_none port=Ch2HgAddCoef register
	#pragma HLS INTERFACE ap_none port=Ch2LgAddCoef register
	// Channel 1 gain
	#pragma HLS INTERFACE ap_none port=Ch1Gain register
	// Channel 2 gain
	#pragma HLS INTERFACE ap_none port=Ch2Gain register
	// Channel 1 coupling
	#pragma HLS INTERFACE ap_none port=Ch1Coupling register
	// Channel 2 coupling
	#pragma HLS INTERFACE ap_none port=Ch2Coupling register
	// Status bits
	#pragma HLS INTERFACE ap_none port=RstBusy
	#pragma HLS INTERFACE ap_none port=InitDoneADC
	#pragma HLS INTERFACE ap_none port=ConfigError
	#pragma HLS INTERFACE ap_none port=InitDoneRelay
	#pragma HLS INTERFACE ap_none port=DataOverflow

	Ch1HgMultCoef = Ch1HgMultCoefAxil.range(17, 0);
	Ch1LgMultCoef = Ch1LgMultCoefAxil.range(17, 0);
	Ch1HgAddCoef = Ch1HgAddCoefAxil.range(17, 0);
	Ch1LgAddCoef = Ch1LgAddCoefAxil.range(17, 0);

	Ch2HgMultCoef = Ch2HgMultCoefAxil.range(17, 0);
	Ch2LgMultCoef = Ch2LgMultCoefAxil.range(17, 0);
	Ch2HgAddCoef = Ch2HgAddCoefAxil.range(17, 0);
	Ch2LgAddCoef = Ch2LgAddCoefAxil.range(17, 0);

	Ch1Gain = RelayConfigAxil.range(0, 0);
	Ch2Gain = RelayConfigAxil.range(1, 1);
	Ch1Coupling = RelayConfigAxil.range(2, 2);
	Ch2Coupling = RelayConfigAxil.range(3, 3);

	StatusAxil.range(0, 0) = RstBusy;
	StatusAxil.range(1, 1) = InitDoneADC;
	StatusAxil.range(2, 2) = ConfigError;
	StatusAxil.range(3, 3) = InitDoneRelay;
	StatusAxil.range(4, 4) = DataOverflow;
}
