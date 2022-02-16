#include "StreamDecimateTest.h"
#define SIZE(a) sizeof(a)/sizeof(a[0])
int main() {
	int test_failed = 0;

	stream_t stream_in;
	stream_t stream_out;
	ap_axiu<32, 0, 0, 0> payload;
	ap_axiu<32, 0, 0, 0> result;

	ap_uint<32> result_signal[5][100];
	ap_uint<32> result_tlast[5][5][100];
	ap_uint<32> reset;
	for(int i = 0; i < SIZE(input_decimation_factor); i++) {
		for(int j = 0; j < SIZE(input_packet_length); j++) {
			// Set AXI4-Lite Parameters
			ap_uint<32> index_result = 0;
			reset.range(0,0) = 1;
			reset.range(31, 16) = input_decimation_factor[i];
			reset.range(15, 1) = input_packet_length[j];
			StreamDecimate(reset, stream_in, stream_out);
			reset.range(0,0) = 0;
			for(int k = 0 ; k < SIZE(input_signal); k++) {
				// Send AXI4-Stream data
				payload.data = input_signal[k];
				stream_in.write(payload);
				StreamDecimate(reset, stream_in, stream_out);
				if(!stream_out.empty()) {
					result = stream_out.read();
					result_signal[i][index_result] = result.data;
					result_tlast[j][i][index_result] = result.last;
					index_result++;
				}
			}
		}
	}

	for(int i = 0; i < SIZE(input_decimation_factor); i++) {
		for(int j =0 ; j < SIZE(input_signal)/input_decimation_factor[i]; j++) {
			if(result_signal[i][j] != output_signal[i][j]) {
				printf("MISMATCH!\n");
				printf("Decimation factor: %d\n", input_decimation_factor[i].to_uint());
				printf("RESULT[%d][%d]: ACTUAL=%d EXPECTED=%d\n", i, j, result_signal[i][j].to_uint(), output_signal[i][j].to_uint());
				test_failed = 1;
			}
		}
	}

	for(int i = 0; i < SIZE(input_decimation_factor); i++) {
		for(int j = 0; j < SIZE(input_packet_length); j++) {
			for(int k =0 ; k < SIZE(input_signal)/input_decimation_factor[i]; k++) {
				if(result_tlast[j][i][k] != output_tlast[j][i][k]) {
					printf("MISMATCH!\n");
					printf("Packet length: %d, Decimation factor: %d\n", input_packet_length[j].to_uint(), input_decimation_factor[i].to_uint());
					printf("TLAST[%d][%d][%d]: ACTUAL=%d EXPECTED=%d\n", j, i, k, result_tlast[j][i][k].to_uint(), output_tlast[j][i][k].to_uint());
					test_failed = 1;
				}
			}
		}
	}

	return test_failed;
}
