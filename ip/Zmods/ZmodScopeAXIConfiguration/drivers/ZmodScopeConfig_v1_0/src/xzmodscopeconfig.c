// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2021.1 (64-bit)
// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// ==============================================================
/***************************** Include Files *********************************/
#include "xzmodscopeconfig.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XZmodscopeconfig_CfgInitialize(XZmodscopeconfig *InstancePtr, XZmodscopeconfig_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XZmodscopeconfig_Start(XZmodscopeconfig *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XZmodscopeconfig_ReadReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_AP_CTRL) & 0x80;
    XZmodscopeconfig_WriteReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XZmodscopeconfig_IsDone(XZmodscopeconfig *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XZmodscopeconfig_ReadReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XZmodscopeconfig_IsIdle(XZmodscopeconfig *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XZmodscopeconfig_ReadReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XZmodscopeconfig_IsReady(XZmodscopeconfig *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XZmodscopeconfig_ReadReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XZmodscopeconfig_EnableAutoRestart(XZmodscopeconfig *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XZmodscopeconfig_WriteReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XZmodscopeconfig_DisableAutoRestart(XZmodscopeconfig *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XZmodscopeconfig_WriteReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_AP_CTRL, 0);
}

void XZmodscopeconfig_Set_Ch1HgMultCoefAxil(XZmodscopeconfig *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XZmodscopeconfig_WriteReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_CH1HGMULTCOEFAXIL_DATA, Data);
}

u32 XZmodscopeconfig_Get_Ch1HgMultCoefAxil(XZmodscopeconfig *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XZmodscopeconfig_ReadReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_CH1HGMULTCOEFAXIL_DATA);
    return Data;
}

void XZmodscopeconfig_Set_Ch1LgMultCoefAxil(XZmodscopeconfig *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XZmodscopeconfig_WriteReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_CH1LGMULTCOEFAXIL_DATA, Data);
}

u32 XZmodscopeconfig_Get_Ch1LgMultCoefAxil(XZmodscopeconfig *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XZmodscopeconfig_ReadReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_CH1LGMULTCOEFAXIL_DATA);
    return Data;
}

void XZmodscopeconfig_Set_Ch1HgAddCoefAxil(XZmodscopeconfig *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XZmodscopeconfig_WriteReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_CH1HGADDCOEFAXIL_DATA, Data);
}

u32 XZmodscopeconfig_Get_Ch1HgAddCoefAxil(XZmodscopeconfig *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XZmodscopeconfig_ReadReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_CH1HGADDCOEFAXIL_DATA);
    return Data;
}

void XZmodscopeconfig_Set_Ch1LgAddCoefAxil(XZmodscopeconfig *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XZmodscopeconfig_WriteReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_CH1LGADDCOEFAXIL_DATA, Data);
}

u32 XZmodscopeconfig_Get_Ch1LgAddCoefAxil(XZmodscopeconfig *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XZmodscopeconfig_ReadReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_CH1LGADDCOEFAXIL_DATA);
    return Data;
}

void XZmodscopeconfig_Set_Ch2HgMultCoefAxil(XZmodscopeconfig *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XZmodscopeconfig_WriteReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_CH2HGMULTCOEFAXIL_DATA, Data);
}

u32 XZmodscopeconfig_Get_Ch2HgMultCoefAxil(XZmodscopeconfig *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XZmodscopeconfig_ReadReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_CH2HGMULTCOEFAXIL_DATA);
    return Data;
}

void XZmodscopeconfig_Set_Ch2LgMultCoefAxil(XZmodscopeconfig *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XZmodscopeconfig_WriteReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_CH2LGMULTCOEFAXIL_DATA, Data);
}

u32 XZmodscopeconfig_Get_Ch2LgMultCoefAxil(XZmodscopeconfig *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XZmodscopeconfig_ReadReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_CH2LGMULTCOEFAXIL_DATA);
    return Data;
}

void XZmodscopeconfig_Set_Ch2HgAddCoefAxil(XZmodscopeconfig *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XZmodscopeconfig_WriteReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_CH2HGADDCOEFAXIL_DATA, Data);
}

u32 XZmodscopeconfig_Get_Ch2HgAddCoefAxil(XZmodscopeconfig *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XZmodscopeconfig_ReadReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_CH2HGADDCOEFAXIL_DATA);
    return Data;
}

void XZmodscopeconfig_Set_Ch2LgAddCoefAxil(XZmodscopeconfig *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XZmodscopeconfig_WriteReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_CH2LGADDCOEFAXIL_DATA, Data);
}

u32 XZmodscopeconfig_Get_Ch2LgAddCoefAxil(XZmodscopeconfig *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XZmodscopeconfig_ReadReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_CH2LGADDCOEFAXIL_DATA);
    return Data;
}

void XZmodscopeconfig_Set_RelayConfigAxil(XZmodscopeconfig *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XZmodscopeconfig_WriteReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_RELAYCONFIGAXIL_DATA, Data);
}

u32 XZmodscopeconfig_Get_RelayConfigAxil(XZmodscopeconfig *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XZmodscopeconfig_ReadReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_RELAYCONFIGAXIL_DATA);
    return Data;
}

u32 XZmodscopeconfig_Get_StatusAxil(XZmodscopeconfig *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XZmodscopeconfig_ReadReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_STATUSAXIL_DATA);
    return Data;
}

void XZmodscopeconfig_InterruptGlobalEnable(XZmodscopeconfig *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XZmodscopeconfig_WriteReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_GIE, 1);
}

void XZmodscopeconfig_InterruptGlobalDisable(XZmodscopeconfig *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XZmodscopeconfig_WriteReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_GIE, 0);
}

void XZmodscopeconfig_InterruptEnable(XZmodscopeconfig *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XZmodscopeconfig_ReadReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_IER);
    XZmodscopeconfig_WriteReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_IER, Register | Mask);
}

void XZmodscopeconfig_InterruptDisable(XZmodscopeconfig *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XZmodscopeconfig_ReadReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_IER);
    XZmodscopeconfig_WriteReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_IER, Register & (~Mask));
}

void XZmodscopeconfig_InterruptClear(XZmodscopeconfig *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XZmodscopeconfig_WriteReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_ISR, Mask);
}

u32 XZmodscopeconfig_InterruptGetEnabled(XZmodscopeconfig *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XZmodscopeconfig_ReadReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_IER);
}

u32 XZmodscopeconfig_InterruptGetStatus(XZmodscopeconfig *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XZmodscopeconfig_ReadReg(InstancePtr->Control_BaseAddress, XZMODSCOPECONFIG_CONTROL_ADDR_ISR);
}

