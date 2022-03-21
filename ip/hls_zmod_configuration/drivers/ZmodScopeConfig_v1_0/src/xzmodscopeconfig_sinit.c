// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2021.1 (64-bit)
// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#include "xparameters.h"
#include "xzmodscopeconfig.h"

extern XZmodscopeconfig_Config XZmodscopeconfig_ConfigTable[];

XZmodscopeconfig_Config *XZmodscopeconfig_LookupConfig(u16 DeviceId) {
	XZmodscopeconfig_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XZMODSCOPECONFIG_NUM_INSTANCES; Index++) {
		if (XZmodscopeconfig_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XZmodscopeconfig_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XZmodscopeconfig_Initialize(XZmodscopeconfig *InstancePtr, u16 DeviceId) {
	XZmodscopeconfig_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XZmodscopeconfig_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XZmodscopeconfig_CfgInitialize(InstancePtr, ConfigPtr);
}

#endif

