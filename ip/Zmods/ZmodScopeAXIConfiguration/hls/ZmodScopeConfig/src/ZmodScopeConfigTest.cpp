#include <ap_int.h>
extern void ZmodScopeConfig(ap_uint<1> RstBusy, ap_uint<1> InitDoneADC,
		ap_uint<1> ConfigError, ap_uint<1> InitDoneRelay,
		ap_uint<1> DataOverflow,
		ap_uint<18>& Ch1HgMultCoefAxil, ap_uint<18>& Ch1LgMultCoefAxil,
		ap_uint<18>& Ch1HgAddCoefAxil, ap_uint<18>& Ch1LgAddCoefAxil,
		ap_uint<18>& Ch2HgMultCoefAxil, ap_uint<18>& Ch2LgMultCoefAxil,
		ap_uint<18>& Ch2HgAddCoefAxil, ap_uint<18>& Ch2LgAddCoefAxil,
		ap_uint<7>& ConfigAxil, ap_uint<5>& StatusAxil,
		ap_uint<18>& Ch1HgMultCoef, ap_uint<18>& Ch1LgMultCoef,
		ap_uint<18>& Ch1LgAddCoef, ap_uint<18>& Ch1HgAddCoef,
		ap_uint<18>& Ch2HgMultCoef, ap_uint<18>& Ch2LgMultCoef,
		ap_uint<18>& Ch2LgAddCoef, ap_uint<18>& Ch2HgAddCoef,
		ap_uint<1>& Ch1Gain, ap_uint<1>& Ch2Gain,
		ap_uint<1>& Ch1Coupling, ap_uint<1>& Ch2Coupling,
		ap_uint<1>& TestMode, ap_uint<1>& EnableAcquisition,
		ap_uint<1>& Reset);
int main() {
	bool failed = 0;
	// IP outputs
	ap_uint<18> Ch1HgMultCoef, Ch1LgMultCoef, Ch1HgAddCoef, Ch1LgAddCoef,
	Ch2HgMultCoef, Ch2LgMultCoef, Ch2HgAddCoef, Ch2LgAddCoef;
	ap_uint<1> Ch1Gain, Ch2Gain, Ch1Coupling, Ch2Coupling, TestMode, EnableAcquisition, Reset;

	// IP inputs
	ap_uint<1> dataOverflow = 1;
	ap_uint<1> rstBusy = 0;
	ap_uint<1> initDoneADC = 1;
	ap_uint<1> initDoneRelay = 0;
	ap_uint<1> configError = 1;

	// IP AXI-Lite interface
	ap_uint<18> coefficientAxil[8];
	ap_uint<7> configAxil = 0b0101010;
	ap_uint<5> statusAxil;
	for(int i = 0; i < 8; i++) {
		coefficientAxil[i] = i;
	}

	for(int i = 0; i < 5; i++) {
	ZmodScopeConfig(rstBusy, initDoneADC, configError, initDoneRelay, dataOverflow,
			coefficientAxil[0], coefficientAxil[1], coefficientAxil[2], coefficientAxil[3],
			coefficientAxil[4], coefficientAxil[5], coefficientAxil[6], coefficientAxil[7],
			configAxil, statusAxil,
			Ch1HgMultCoef, Ch1LgMultCoef, Ch1LgAddCoef, Ch1HgAddCoef,
			Ch2HgMultCoef, Ch2LgMultCoef, Ch2LgAddCoef, Ch2HgAddCoef,
			Ch1Gain, Ch2Gain, Ch1Coupling, Ch2Coupling, TestMode, EnableAcquisition, Reset);
	}
	if(rstBusy != statusAxil.range(0, 0)) {
		printf("rstBusy mismatch\n");
		failed = 1;
	}
	if(initDoneADC != statusAxil.range(1, 1)) {
		printf("initDoneADC mismatch\n");
		failed = 1;
	}
	if(configError != statusAxil.range(2, 2)) {
		printf("configError mismatch\n");
		failed = 1;
	}
	if(initDoneRelay != statusAxil.range(3, 3)) {
		printf("initDoneRelay mismatch\n");
		failed = 1;
	}
	if(dataOverflow != statusAxil.range(4, 4)) {
		printf("dataOverflow mismatch\n");
		failed = 1;
	}
	if(coefficientAxil[0] != Ch1HgMultCoef) {
		printf("Ch1HgMultCoef mismatch\n");
		failed = 1;
	}
	if(coefficientAxil[1] != Ch1LgMultCoef) {

		printf("Ch1LgMultCoef mismatch\n");
		failed = 1;
	}
	if(coefficientAxil[2] != Ch1HgAddCoef) {
		printf("Ch1HgAddCoef mismatch\n");
		failed = 1;
	}
	if(coefficientAxil[3] != Ch1LgAddCoef) {
		printf("Ch1LgAddCoef mismatch\n");
		failed = 1;
	}
	if(coefficientAxil[4] != Ch2HgMultCoef) {
		printf("Ch2HgMultCoef mismatch\n");
		failed = 1;
	}
	if(coefficientAxil[5] != Ch2LgMultCoef) {
		printf("Ch2LgMultCoef mismatch\n");
		failed = 1;
	}
	if(coefficientAxil[6] != Ch2HgAddCoef) {
		printf("Ch2HgAddCoef mismatch\n");
		failed = 1;
	}
	if(coefficientAxil[7] != Ch2LgAddCoef) {
		printf("Ch2LgAddCoef mismatch\n");
		failed = 1;
	}
	if(configAxil.range(0, 0) != Ch1Gain) {
		printf("Ch1Gain mismatch\n");
		failed = 1;
	}
	if(configAxil.range(1, 1) != Ch2Gain) {
		printf("Ch2Gain mismatch\n");
		failed = 1;
	}
	if(configAxil.range(2, 2) != Ch1Coupling) {
		printf("Ch1Coupling mismatch\n");
		failed = 1;
	}
	if(configAxil.range(3, 3) != Ch2Coupling) {
		printf("Ch2Coupling mismatch\n");
		failed = 1;
	}
	if(configAxil.range(4, 4) != TestMode) {
		printf("TestMode mismatch\n");
		failed = 1;
	}
	if(configAxil.range(5, 5) != EnableAcquisition) {
		printf("EnableAcquisition mismatch\n");
		failed = 1;
	}
	if(configAxil.range(6, 6) != Reset) {
		printf("Reset mismatch\n");
		failed = 1;
	}

	return failed;
}
