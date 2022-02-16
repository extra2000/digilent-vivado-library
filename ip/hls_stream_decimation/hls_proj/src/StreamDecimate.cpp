//-------------------------------------------------------------------------------
//--
//-- File: StreamDecimate.cpp
//-- Author: Nita Eduard
//-- Date: 2 February 2022
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
//-- This core has been written in order to perform decimation
//-- on a 32-bit data signal sent over AXI4-Stream.
//-- The decimation factor N (used to keep only every Nth sample)
//-- and the packet length (used to generate a TLAST signal)
//-- can be configured using an AXI-Lite interface.
//--
//-------------------------------------------------------------------------------
#include <hls_stream.h>
#include <ap_axi_sdata.h>
typedef ap_axiu<32,0,0,0> interface_t;
typedef hls::stream<interface_t> stream_t;

void StreamDecimate(ap_uint<32>& axil,
		stream_t& axisStreamIn, stream_t& axisStreamOut) {
	#pragma HLS INTERFACE s_axilite port=axil
	#pragma HLS INTERFACE s_axilite port=return
	#pragma HLS INTERFACE axis register_mode=both port=axisStreamIn
	#pragma HLS INTERFACE axis register_mode=both port=axisStreamOut

	static ap_uint<32> regSamplesDropped = 1;
	static ap_uint<32> regPacketCount = 0;

	if(axil.range(0, 0)) {
		regSamplesDropped = 1;
		regPacketCount = 0;
	} else {
		ap_axiu<32,0,0,0> axisData = axisStreamIn.read();

		if(regSamplesDropped < axil.range(31, 16)) {
			regSamplesDropped++;
		}
		else {
			regPacketCount++;
			regSamplesDropped = 1;

			if(regPacketCount >= axil.range(15, 1) && axil.range(15, 1) != 0) {
				regPacketCount = 0;
				axisData.last = true;
			}else{
				axisData.last = false;
			}
			axisStreamOut.write(axisData);
		}
	}
}
