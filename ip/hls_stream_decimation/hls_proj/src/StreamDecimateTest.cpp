#include <hls_stream.h>
#include <ap_axi_sdata.h>
typedef ap_axiu<32,0,0,0> interface_t;
typedef hls::stream<interface_t> stream_t;
void StreamDecimate(ap_uint<32>& axilDecimationFactor, ap_uint<32>& axilPacketLength,
		stream_t& axisStreamIn, stream_t& axisStreamOut);
int main() {
	stream_t stream_in;
	stream_t stream_out;
	ap_axiu<32,0,0,0> payload;
	ap_uint<32> decimation_factor = 5;
	ap_uint<32> packet_length = 16;
	for(long i =0 ;i < 1000; i++) {
		payload.data = i;
		stream_in.write(payload);
		StreamDecimate(decimation_factor, packet_length, stream_in, stream_out);
		printf("[%i]:%d\n", i, stream_out.read().data.to_int());

	}
}
