// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2021.1 (64-bit)
// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef XZMODSCOPECONFIG_H
#define XZMODSCOPECONFIG_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "xzmodscopeconfig_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
#else
typedef struct {
    u16 DeviceId;
    u32 Control_BaseAddress;
} XZmodscopeconfig_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XZmodscopeconfig;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XZmodscopeconfig_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XZmodscopeconfig_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XZmodscopeconfig_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XZmodscopeconfig_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
int XZmodscopeconfig_Initialize(XZmodscopeconfig *InstancePtr, u16 DeviceId);
XZmodscopeconfig_Config* XZmodscopeconfig_LookupConfig(u16 DeviceId);
int XZmodscopeconfig_CfgInitialize(XZmodscopeconfig *InstancePtr, XZmodscopeconfig_Config *ConfigPtr);
#else
int XZmodscopeconfig_Initialize(XZmodscopeconfig *InstancePtr, const char* InstanceName);
int XZmodscopeconfig_Release(XZmodscopeconfig *InstancePtr);
#endif

void XZmodscopeconfig_Start(XZmodscopeconfig *InstancePtr);
u32 XZmodscopeconfig_IsDone(XZmodscopeconfig *InstancePtr);
u32 XZmodscopeconfig_IsIdle(XZmodscopeconfig *InstancePtr);
u32 XZmodscopeconfig_IsReady(XZmodscopeconfig *InstancePtr);
void XZmodscopeconfig_EnableAutoRestart(XZmodscopeconfig *InstancePtr);
void XZmodscopeconfig_DisableAutoRestart(XZmodscopeconfig *InstancePtr);

void XZmodscopeconfig_Set_Ch1HgMultCoefAxil(XZmodscopeconfig *InstancePtr, u32 Data);
u32 XZmodscopeconfig_Get_Ch1HgMultCoefAxil(XZmodscopeconfig *InstancePtr);
void XZmodscopeconfig_Set_Ch1LgMultCoefAxil(XZmodscopeconfig *InstancePtr, u32 Data);
u32 XZmodscopeconfig_Get_Ch1LgMultCoefAxil(XZmodscopeconfig *InstancePtr);
void XZmodscopeconfig_Set_Ch1HgAddCoefAxil(XZmodscopeconfig *InstancePtr, u32 Data);
u32 XZmodscopeconfig_Get_Ch1HgAddCoefAxil(XZmodscopeconfig *InstancePtr);
void XZmodscopeconfig_Set_Ch1LgAddCoefAxil(XZmodscopeconfig *InstancePtr, u32 Data);
u32 XZmodscopeconfig_Get_Ch1LgAddCoefAxil(XZmodscopeconfig *InstancePtr);
void XZmodscopeconfig_Set_Ch2HgMultCoefAxil(XZmodscopeconfig *InstancePtr, u32 Data);
u32 XZmodscopeconfig_Get_Ch2HgMultCoefAxil(XZmodscopeconfig *InstancePtr);
void XZmodscopeconfig_Set_Ch2LgMultCoefAxil(XZmodscopeconfig *InstancePtr, u32 Data);
u32 XZmodscopeconfig_Get_Ch2LgMultCoefAxil(XZmodscopeconfig *InstancePtr);
void XZmodscopeconfig_Set_Ch2HgAddCoefAxil(XZmodscopeconfig *InstancePtr, u32 Data);
u32 XZmodscopeconfig_Get_Ch2HgAddCoefAxil(XZmodscopeconfig *InstancePtr);
void XZmodscopeconfig_Set_Ch2LgAddCoefAxil(XZmodscopeconfig *InstancePtr, u32 Data);
u32 XZmodscopeconfig_Get_Ch2LgAddCoefAxil(XZmodscopeconfig *InstancePtr);
void XZmodscopeconfig_Set_RelayConfigAxil(XZmodscopeconfig *InstancePtr, u32 Data);
u32 XZmodscopeconfig_Get_RelayConfigAxil(XZmodscopeconfig *InstancePtr);
u32 XZmodscopeconfig_Get_StatusAxil(XZmodscopeconfig *InstancePtr);

void XZmodscopeconfig_InterruptGlobalEnable(XZmodscopeconfig *InstancePtr);
void XZmodscopeconfig_InterruptGlobalDisable(XZmodscopeconfig *InstancePtr);
void XZmodscopeconfig_InterruptEnable(XZmodscopeconfig *InstancePtr, u32 Mask);
void XZmodscopeconfig_InterruptDisable(XZmodscopeconfig *InstancePtr, u32 Mask);
void XZmodscopeconfig_InterruptClear(XZmodscopeconfig *InstancePtr, u32 Mask);
u32 XZmodscopeconfig_InterruptGetEnabled(XZmodscopeconfig *InstancePtr);
u32 XZmodscopeconfig_InterruptGetStatus(XZmodscopeconfig *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
