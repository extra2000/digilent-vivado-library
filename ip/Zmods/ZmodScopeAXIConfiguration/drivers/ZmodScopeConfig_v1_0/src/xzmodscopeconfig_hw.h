// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2021.1 (64-bit)
// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// ==============================================================
// control
// 0x00 : Control signals
//        bit 0  - ap_start (Read/Write/COH)
//        bit 1  - ap_done (Read/COR)
//        bit 2  - ap_idle (Read)
//        bit 3  - ap_ready (Read/COR)
//        bit 7  - auto_restart (Read/Write)
//        others - reserved
// 0x04 : Global Interrupt Enable Register
//        bit 0  - Global Interrupt Enable (Read/Write)
//        others - reserved
// 0x08 : IP Interrupt Enable Register (Read/Write)
//        bit 0  - enable ap_done interrupt (Read/Write)
//        bit 1  - enable ap_ready interrupt (Read/Write)
//        others - reserved
// 0x0c : IP Interrupt Status Register (Read/TOW)
//        bit 0  - ap_done (COR/TOW)
//        bit 1  - ap_ready (COR/TOW)
//        others - reserved
// 0x10 : Data signal of Ch1HgMultCoefAxil
//        bit 17~0 - Ch1HgMultCoefAxil[17:0] (Read/Write)
//        others   - reserved
// 0x14 : reserved
// 0x18 : Data signal of Ch1LgMultCoefAxil
//        bit 17~0 - Ch1LgMultCoefAxil[17:0] (Read/Write)
//        others   - reserved
// 0x1c : reserved
// 0x20 : Data signal of Ch1HgAddCoefAxil
//        bit 17~0 - Ch1HgAddCoefAxil[17:0] (Read/Write)
//        others   - reserved
// 0x24 : reserved
// 0x28 : Data signal of Ch1LgAddCoefAxil
//        bit 17~0 - Ch1LgAddCoefAxil[17:0] (Read/Write)
//        others   - reserved
// 0x2c : reserved
// 0x30 : Data signal of Ch2HgMultCoefAxil
//        bit 17~0 - Ch2HgMultCoefAxil[17:0] (Read/Write)
//        others   - reserved
// 0x34 : reserved
// 0x38 : Data signal of Ch2LgMultCoefAxil
//        bit 17~0 - Ch2LgMultCoefAxil[17:0] (Read/Write)
//        others   - reserved
// 0x3c : reserved
// 0x40 : Data signal of Ch2HgAddCoefAxil
//        bit 17~0 - Ch2HgAddCoefAxil[17:0] (Read/Write)
//        others   - reserved
// 0x44 : reserved
// 0x48 : Data signal of Ch2LgAddCoefAxil
//        bit 17~0 - Ch2LgAddCoefAxil[17:0] (Read/Write)
//        others   - reserved
// 0x4c : reserved
// 0x50 : Data signal of RelayConfigAxil
//        bit 3~0 - RelayConfigAxil[3:0] (Read/Write)
//        others  - reserved
// 0x54 : reserved
// 0x58 : Data signal of StatusAxil
//        bit 4~0 - StatusAxil[4:0] (Read)
//        others  - reserved
// 0x5c : reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XZMODSCOPECONFIG_CONTROL_ADDR_AP_CTRL                0x00
#define XZMODSCOPECONFIG_CONTROL_ADDR_GIE                    0x04
#define XZMODSCOPECONFIG_CONTROL_ADDR_IER                    0x08
#define XZMODSCOPECONFIG_CONTROL_ADDR_ISR                    0x0c
#define XZMODSCOPECONFIG_CONTROL_ADDR_CH1HGMULTCOEFAXIL_DATA 0x10
#define XZMODSCOPECONFIG_CONTROL_BITS_CH1HGMULTCOEFAXIL_DATA 18
#define XZMODSCOPECONFIG_CONTROL_ADDR_CH1LGMULTCOEFAXIL_DATA 0x18
#define XZMODSCOPECONFIG_CONTROL_BITS_CH1LGMULTCOEFAXIL_DATA 18
#define XZMODSCOPECONFIG_CONTROL_ADDR_CH1HGADDCOEFAXIL_DATA  0x20
#define XZMODSCOPECONFIG_CONTROL_BITS_CH1HGADDCOEFAXIL_DATA  18
#define XZMODSCOPECONFIG_CONTROL_ADDR_CH1LGADDCOEFAXIL_DATA  0x28
#define XZMODSCOPECONFIG_CONTROL_BITS_CH1LGADDCOEFAXIL_DATA  18
#define XZMODSCOPECONFIG_CONTROL_ADDR_CH2HGMULTCOEFAXIL_DATA 0x30
#define XZMODSCOPECONFIG_CONTROL_BITS_CH2HGMULTCOEFAXIL_DATA 18
#define XZMODSCOPECONFIG_CONTROL_ADDR_CH2LGMULTCOEFAXIL_DATA 0x38
#define XZMODSCOPECONFIG_CONTROL_BITS_CH2LGMULTCOEFAXIL_DATA 18
#define XZMODSCOPECONFIG_CONTROL_ADDR_CH2HGADDCOEFAXIL_DATA  0x40
#define XZMODSCOPECONFIG_CONTROL_BITS_CH2HGADDCOEFAXIL_DATA  18
#define XZMODSCOPECONFIG_CONTROL_ADDR_CH2LGADDCOEFAXIL_DATA  0x48
#define XZMODSCOPECONFIG_CONTROL_BITS_CH2LGADDCOEFAXIL_DATA  18
#define XZMODSCOPECONFIG_CONTROL_ADDR_RELAYCONFIGAXIL_DATA   0x50
#define XZMODSCOPECONFIG_CONTROL_BITS_RELAYCONFIGAXIL_DATA   4
#define XZMODSCOPECONFIG_CONTROL_ADDR_STATUSAXIL_DATA        0x58
#define XZMODSCOPECONFIG_CONTROL_BITS_STATUSAXIL_DATA        5

