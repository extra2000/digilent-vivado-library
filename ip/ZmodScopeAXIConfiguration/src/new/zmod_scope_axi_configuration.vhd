----------------------------------------------------------------------------------
-- Company: Digilent
-- Engineer: Nita Eduard
-- 
-- Create Date: 04/05/2022 02:04:18 PM
-- Design Name: Zmod Scope AXI Configuration
-- Module Name: zmod_scope_axi_configuration - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--  This design is to be used in controlling the Zmod Scope Controller using 
--  an AXI4-Lite interface. The signals coming to and from the 
--  Zmod Scope Controller are synchronized between clock domains.
--  The ZmodScopeConfig, req_gen and req_ack have been created using Vitis HLS.
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity zmod_scope_axi_configuration is
generic (
    C_S_AXI_CONTROL_ADDR_WIDTH : INTEGER := 7;
    C_S_AXI_CONTROL_DATA_WIDTH : INTEGER := 32 );
port (
    s_axi_control_clk : IN STD_LOGIC;
    s_axi_control_rst_n : IN STD_LOGIC;
    SysClk100: IN STD_LOGIC;
    ADC_SamplingClk: IN STD_LOGIC;
    sRstBusy : IN STD_LOGIC;
    sInitDoneADC : IN STD_LOGIC;
    sConfigError : IN STD_LOGIC;
    sInitDoneRelay : IN STD_LOGIC;
    sDataOverflow : IN STD_LOGIC;
    cExtCh1HgMultCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    cExtCh1LgMultCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    cExtCh1LgAddCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    cExtCh1HgAddCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    cExtCh2HgMultCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    cExtCh2LgMultCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    cExtCh2LgAddCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    cExtCh2HgAddCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    sCh1GainConfig : OUT STD_LOGIC;
    sCh2GainConfig : OUT STD_LOGIC;
    sCh1CouplingConfig : OUT STD_LOGIC;
    sCh2CouplingConfig : OUT STD_LOGIC;
    sEnableAcquisition : OUT STD_LOGIC;
    sTestMode : OUT STD_LOGIC;
    lReset_n: OUT STD_LOGIC;
    s_axi_control_AWVALID : IN STD_LOGIC;
    s_axi_control_AWREADY : OUT STD_LOGIC;
    s_axi_control_AWADDR : IN STD_LOGIC_VECTOR (C_S_AXI_CONTROL_ADDR_WIDTH-1 downto 0);
    s_axi_control_WVALID : IN STD_LOGIC;
    s_axi_control_WREADY : OUT STD_LOGIC;
    s_axi_control_WDATA : IN STD_LOGIC_VECTOR (C_S_AXI_CONTROL_DATA_WIDTH-1 downto 0);
    s_axi_control_WSTRB : IN STD_LOGIC_VECTOR (C_S_AXI_CONTROL_DATA_WIDTH/8-1 downto 0);
    s_axi_control_ARVALID : IN STD_LOGIC;
    s_axi_control_ARREADY : OUT STD_LOGIC;
    s_axi_control_ARADDR : IN STD_LOGIC_VECTOR (C_S_AXI_CONTROL_ADDR_WIDTH-1 downto 0);
    s_axi_control_RVALID : OUT STD_LOGIC;
    s_axi_control_RREADY : IN STD_LOGIC;
    s_axi_control_RDATA : OUT STD_LOGIC_VECTOR (C_S_AXI_CONTROL_DATA_WIDTH-1 downto 0);
    s_axi_control_RRESP : OUT STD_LOGIC_VECTOR (1 downto 0);
    s_axi_control_BVALID : OUT STD_LOGIC;
    s_axi_control_BREADY : IN STD_LOGIC;
    s_axi_control_BRESP : OUT STD_LOGIC_VECTOR (1 downto 0)
    );
end;

architecture Behavioral of zmod_scope_axi_configuration is
component ZmodScopeConfig is
generic (
    C_S_AXI_CONTROL_ADDR_WIDTH : INTEGER := 7;
    C_S_AXI_CONTROL_DATA_WIDTH : INTEGER := 32 );
port (
    ap_clk : IN STD_LOGIC;
    ap_rst_n : IN STD_LOGIC;
    RstBusy : IN STD_LOGIC_VECTOR (0 downto 0);
    InitDoneADC : IN STD_LOGIC_VECTOR (0 downto 0);
    ConfigError : IN STD_LOGIC_VECTOR (0 downto 0);
    InitDoneRelay : IN STD_LOGIC_VECTOR (0 downto 0);
    DataOverflow : IN STD_LOGIC_VECTOR (0 downto 0);
    Ch1HgMultCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    Ch1LgMultCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    Ch1LgAddCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    Ch1HgAddCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    Ch2HgMultCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    Ch2LgMultCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    Ch2LgAddCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    Ch2HgAddCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    Ch1Gain : OUT STD_LOGIC_VECTOR (0 downto 0);
    Ch2Gain : OUT STD_LOGIC_VECTOR (0 downto 0);
    Ch1Coupling : OUT STD_LOGIC_VECTOR (0 downto 0);
    Ch2Coupling : OUT STD_LOGIC_VECTOR (0 downto 0);
    TestMode : OUT STD_LOGIC_VECTOR (0 downto 0);
    EnableAcquisition : OUT STD_LOGIC_VECTOR (0 downto 0);
    Reset : OUT STD_LOGIC_VECTOR (0 downto 0);
    s_axi_control_AWVALID : IN STD_LOGIC;
    s_axi_control_AWREADY : OUT STD_LOGIC;
    s_axi_control_AWADDR : IN STD_LOGIC_VECTOR (C_S_AXI_CONTROL_ADDR_WIDTH-1 downto 0);
    s_axi_control_WVALID : IN STD_LOGIC;
    s_axi_control_WREADY : OUT STD_LOGIC;
    s_axi_control_WDATA : IN STD_LOGIC_VECTOR (C_S_AXI_CONTROL_DATA_WIDTH-1 downto 0);
    s_axi_control_WSTRB : IN STD_LOGIC_VECTOR (C_S_AXI_CONTROL_DATA_WIDTH/8-1 downto 0);
    s_axi_control_ARVALID : IN STD_LOGIC;
    s_axi_control_ARREADY : OUT STD_LOGIC;
    s_axi_control_ARADDR : IN STD_LOGIC_VECTOR (C_S_AXI_CONTROL_ADDR_WIDTH-1 downto 0);
    s_axi_control_RVALID : OUT STD_LOGIC;
    s_axi_control_RREADY : IN STD_LOGIC;
    s_axi_control_RDATA : OUT STD_LOGIC_VECTOR (C_S_AXI_CONTROL_DATA_WIDTH-1 downto 0);
    s_axi_control_RRESP : OUT STD_LOGIC_VECTOR (1 downto 0);
    s_axi_control_BVALID : OUT STD_LOGIC;
    s_axi_control_BREADY : IN STD_LOGIC;
    s_axi_control_BRESP : OUT STD_LOGIC_VECTOR (1 downto 0);
    interrupt : OUT STD_LOGIC );
end component;

component ResetBridge is
   Generic (
      kPolarity : std_logic := '1');
   Port (
      aRst : in STD_LOGIC; -- asynchronous reset; active-high, if kPolarity=1
      OutClk : in STD_LOGIC;
      oRst : out STD_LOGIC);
end component;

component ack_gen is
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    inLoad : IN STD_LOGIC_VECTOR (0 downto 0);
    inReq : IN STD_LOGIC_VECTOR (0 downto 0);
    outAck : OUT STD_LOGIC_VECTOR (0 downto 0);
    outValid : OUT STD_LOGIC_VECTOR (0 downto 0);
    outLoadData : OUT STD_LOGIC_VECTOR (0 downto 0) );
end component;

component req_gen is
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    inSend : IN STD_LOGIC_VECTOR (0 downto 0);
    inAck : IN STD_LOGIC_VECTOR (0 downto 0);
    outReq : OUT STD_LOGIC_VECTOR (0 downto 0);
    outReady : OUT STD_LOGIC_VECTOR (0 downto 0);
    outLoadData : OUT STD_LOGIC_VECTOR (0 downto 0) );
end component;

signal lZmodScopeConfigInterrupt : STD_LOGIC;

signal cSendData : STD_LOGIC;
signal sSendData : STD_LOGIC;
signal slSendData : STD_LOGIC;

signal cLoadData : STD_LOGIC;
signal sLoadData : STD_LOGIC;
signal lLoadData : STD_LOGIC;
signal lsLoadData : STD_LOGIC;
signal lcLoadData : STD_LOGIC;
signal slLoadData : STD_LOGIC;


signal sRst_n : STD_LOGIC;
signal cRst_n : STD_LOGIC;

signal lCh1HgMultCoef :  STD_LOGIC_VECTOR (17 downto 0);
signal lCh1LgMultCoef :  STD_LOGIC_VECTOR (17 downto 0);
signal lCh1LgAddCoef :  STD_LOGIC_VECTOR (17 downto 0);
signal lCh1HgAddCoef :  STD_LOGIC_VECTOR (17 downto 0);
signal lCh2HgMultCoef :  STD_LOGIC_VECTOR (17 downto 0);
signal lCh2LgMultCoef :  STD_LOGIC_VECTOR (17 downto 0);
signal lCh2LgAddCoef :  STD_LOGIC_VECTOR (17 downto 0);
signal lCh2HgAddCoef :  STD_LOGIC_VECTOR (17 downto 0);

signal lCh1HgMultCoefCDC :  STD_LOGIC_VECTOR (17 downto 0);
signal lCh1LgMultCoefCDC :  STD_LOGIC_VECTOR (17 downto 0);
signal lCh1LgAddCoefCDC :  STD_LOGIC_VECTOR (17 downto 0);
signal lCh1HgAddCoefCDC :  STD_LOGIC_VECTOR (17 downto 0);
signal lCh2HgMultCoefCDC :  STD_LOGIC_VECTOR (17 downto 0);
signal lCh2LgMultCoefCDC :  STD_LOGIC_VECTOR (17 downto 0);
signal lCh2LgAddCoefCDC :  STD_LOGIC_VECTOR (17 downto 0);
signal lCh2HgAddCoefCDC :  STD_LOGIC_VECTOR (17 downto 0);

signal lCh1GainCDC :  STD_LOGIC;
signal lCh2GainCDC :  STD_LOGIC;
signal lCh1CouplingCDC :  STD_LOGIC;
signal lCh2CouplingCDC :  STD_LOGIC;
signal lEnableAcquisitionCDC :  STD_LOGIC;
signal lTestModeCDC :  STD_LOGIC;

signal lRstBusy: STD_LOGIC;
signal lInitDoneADC: STD_LOGIC;
signal lConfigError: STD_LOGIC;
signal lInitDoneRelay: STD_LOGIC;
signal lDataOverflow: STD_LOGIC;

signal sRstBusyCDC: STD_LOGIC;
signal sInitDoneADC_CDC: STD_LOGIC;
signal sConfigErrorCDC: STD_LOGIC;
signal sInitDoneRelayCDC: STD_LOGIC;
signal sDataOverflowCDC: STD_LOGIC;

signal lCh1Gain :  STD_LOGIC;
signal lCh2Gain :  STD_LOGIC;
signal lCh1Coupling :  STD_LOGIC;
signal lCh2Coupling :  STD_LOGIC;
signal lEnableAcquisition :  STD_LOGIC;
signal lTestMode :  STD_LOGIC;

signal sRst : STD_LOGIC;
signal cRst : STD_LOGIC;

signal lcReqCDC : STD_LOGIC;
signal clAckCDC : STD_LOGIC;

signal slReqCDC: STD_LOGIC;
signal lsAckCDC: STD_LOGIC;

signal lsReqCDC : STD_LOGIC;
signal slAckCDC: STD_LOGIC;
signal slReady : STD_LOGIC;

begin
HLSZmodScopeConfig: ZmodScopeConfig port map(
    ap_clk => s_axi_control_clk,
    ap_rst_n => s_axi_control_rst_n,
    RstBusy(0) => lRstBusy,
    InitDoneADC(0) => lInitDoneADC,
    ConfigError(0) => lConfigError,
    InitDoneRelay(0) => lInitDoneRelay,
    DataOverflow(0) => lDataOverflow,
    Ch1HgMultCoef => lCh1HgMultCoef,
    Ch1LgMultCoef => lCh1LgMultCoef,
    Ch1LgAddCoef => lCh1LgAddCoef,
    Ch1HgAddCoef => lCh1HgAddCoef,
    Ch2HgMultCoef => lCh2HgMultCoef,
    Ch2LgMultCoef => lCh2LgMultCoef,
    Ch2LgAddCoef => lCh2LgAddCoef,
    Ch2HgAddCoef => lCh2HgAddCoef,
    Ch1Gain(0) => lCh1Gain,
    Ch2Gain(0) => lCh2Gain,
    Ch1Coupling(0) => lCh1Coupling,
    Ch2Coupling(0) => lCh2Coupling,
    EnableAcquisition(0) => lEnableAcquisition,
    TestMode(0) => lTestMode,
    Reset(0) => lReset_n,
    s_axi_control_AWVALID => s_axi_control_AWVALID,
    s_axi_control_AWREADY => s_axi_control_AWREADY,
    s_axi_control_AWADDR => s_axi_control_AWADDR,
    s_axi_control_WVALID => s_axi_control_WVALID,
    s_axi_control_WREADY => s_axi_control_WREADY,
    s_axi_control_WDATA => s_axi_control_WDATA,
    s_axi_control_WSTRB => s_axi_control_WSTRB,
    s_axi_control_ARVALID => s_axi_control_ARVALID,
    s_axi_control_ARREADY => s_axi_control_ARREADY,
    s_axi_control_ARADDR => s_axi_control_ARADDR,
    s_axi_control_RVALID => s_axi_control_RVALID,
    s_axi_control_RREADY => s_axi_control_RREADY,
    s_axi_control_RDATA => s_axi_control_RDATA,
    s_axi_control_RRESP => s_axi_control_RRESP,
    s_axi_control_BVALID => s_axi_control_BVALID,
    s_axi_control_BREADY => s_axi_control_BREADY,
    s_axi_control_BRESP => s_axi_control_BRESP,
    interrupt => lZmodScopeConfigInterrupt
);

s_axi_clk_to_SysClk100_rst: ResetBridge generic map(
    kPolarity => '0'
)
port map (
    aRst => s_axi_control_rst_n,
    outClk => SysClk100,
    oRst => sRst_n
);


s_axi_clk_to_ADC_SamplingClk_rst: ResetBridge generic map(
    kPolarity => '0'
)
port map (
    aRst => s_axi_control_rst_n,
    outClk => ADC_SamplingClk,
    oRst => cRst_n
);

------------------------------ Clock domain crossing --------------------------------------------
-- Handshake request from s_axi_control_clk to ADC_SamplingClk
s_axi_to_ADC_SamplingClk_req: req_gen port map(
    ap_clk => s_axi_control_clk,
    ap_rst => s_axi_control_rst_n,
    inSend(0) => lZmodScopeConfigInterrupt,
    inAck(0) => clAckCDC,
    outReq(0) => lcReqCDC,
    outLoadData(0) => lcLoadData
);
-- Handshake acknowledge from ADC_SamplingClk to s_axi_control_clk
s_axi_to_ADC_SamplingClk_ack: ack_gen port map(
    ap_clk => ADC_SamplingClk,
    ap_rst => cRst_n,
    inLoad(0) => '1',
    inReq(0) => lcReqCDC,
    outAck(0) => clAckCDC,
    outLoadData(0) => cLoadData
);
-------------------------------------------------------------------------------------------------

------------------------------ Clock domain crossing --------------------------------------------
-- Handshake request from s_axi_control_clk to SysClk100
s_axi_to_SysClk100_req: req_gen port map(
    ap_clk => s_axi_control_clk,
    ap_rst => s_axi_control_rst_n,
    inSend(0) => lZmodScopeConfigInterrupt,
    inAck(0) => slAckCDC,
    outReq(0) => lsReqCDC,
    outLoadData(0) => lsLoadData
);
-- Handshake acknowledge from SysClk100 to s_axi_control_clk
s_axi_to_SysClk100_ack: ack_gen port map(
    ap_clk => SysClk100,
    ap_rst => sRst_n,
    inLoad(0) => '1',
    inReq(0) => lsReqCDC,
    outAck(0) => slAckCDC,
    outLoadData(0) => sLoadData
);
-------------------------------------------------------------------------------------------------

------------------------------ Clock domain crossing --------------------------------------------
-- Handshake request from SysClk100 to s_axi_control_clk
-- It will send the data whenever it is ready
SysClk100_to_s_axi_req: req_gen port map(
    ap_clk => SysClk100,
    ap_rst => sRst_n,
    inSend(0) => slReady,
    inAck(0) => lsAckCDC,
    outReady(0) => slReady,
    outReq(0) => slReqCDC,
    outLoadData(0) => slLoadData
);
-- Handshake acknowledge from SysClk100 to s_axi_control_clk
SysClk100_to_s_axi_ack: ack_gen port map(
    ap_clk => s_axi_control_clk,
    ap_rst => s_axi_control_rst_n,
    inLoad(0) => '1',
    inReq(0) => slReqCDC,
    outAck(0) => lsAckCDC,
    outLoadData(0) => lLoadData
);
-------------------------------------------------------------------------------------------------
-- Register data in AXI-Lite domain before clock domain crossing to ADC_SamplingClk
s_axi_data_CDC: process(s_axi_control_clk, s_axi_control_rst_n) 
begin
    if(rising_edge(s_axi_control_clk)) then
        if (s_axi_control_rst_n = '0') then
            lCh1HgMultCoefCDC <= (others => '0');
            lCh1LgMultCoefCDC <= (others => '0');
            lCh1LgAddCoefCDC <= (others => '0');
            lCh1HgAddCoefCDC <= (others => '0');
            lCh2HgMultCoefCDC <= (others => '0');
            lCh2LgMultCoefCDC <= (others => '0');
            lCh2LgAddCoefCDC <= (others => '0');
            lCh2HgAddCoefCDC <= (others => '0');
        else 
            if(lcLoadData = '1') then
                lCh1HgMultCoefCDC <= lCh1HgMultCoef;
                lCh1LgMultCoefCDC <= lCh1LgMultCoef;
                lCh1LgAddCoefCDC <= lCh1LgAddCoef;
                lCh1HgAddCoefCDC <= lCh1HgAddCoef;
                lCh2HgMultCoefCDC <= lCh2HgMultCoef;
                lCh2LgMultCoefCDC <= lCh2LgMultCoef;
                lCh2LgAddCoefCDC <= lCh2LgAddCoef;
                lCh2HgAddCoefCDC <= lCh2HgAddCoef;
            end if;
        end if;
    end if;
end process;
-------------------------------------------------------------------------------------------------

-- Register data in ADC_SamplingClk domain after clock domain crossing from AXI-Lite
ADC_SamplingClk_data_CDC: process(ADC_SamplingClk, cRst_n) 
begin
    if(rising_edge(ADC_SamplingClk)) then
        if (cRst_n = '0') then
            cExtCh1HgMultCoef <= (others => '0');
            cExtCh1LgMultCoef <= (others => '0');
            cExtCh1LgAddCoef <= (others => '0');
            cExtCh1HgAddCoef <= (others => '0');
            cExtCh2HgMultCoef <= (others => '0');
            cExtCh2LgMultCoef <= (others => '0');
            cExtCh2LgAddCoef <= (others => '0');
            cExtCh2HgAddCoef <= (others => '0');
        else 
            if(cLoadData = '1') then
                cExtCh1HgMultCoef <= lCh1HgMultCoefCDC;
                cExtCh1LgMultCoef <= lCh1LgMultCoefCDC;
                cExtCh1LgAddCoef <= lCh1LgAddCoefCDC;
                cExtCh1HgAddCoef <= lCh1HgAddCoefCDC;
                cExtCh2HgMultCoef <= lCh2HgMultCoefCDC;
                cExtCh2LgMultCoef <= lCh2LgMultCoefCDC;
                cExtCh2LgAddCoef <= lCh2LgAddCoefCDC;
                cExtCh2HgAddCoef <= lCh2HgAddCoefCDC;
            end if;
        end if;
    end if;
end process;
-------------------------------------------------------------------------------------------------

-- Register configuration in AXI-Lite domain before clock domain crossing to SysClk100
s_axi_config_CDC: process(s_axi_control_clk, s_axi_control_rst_n) 
begin
    if(rising_edge(s_axi_control_clk)) then
        if (s_axi_control_rst_n = '0') then
            lCh1GainCDC <= '0';
            lCh2GainCDC <= '0';
            lCh1CouplingCDC  <= '0';
            lCh2CouplingCDC <= '0';
            lEnableAcquisitionCDC <= '0';
            lTestModeCDC <= '0';
        else 
            if(lsLoadData = '1') then
                lCh1GainCDC <= lCh1Gain;
                lCh2GainCDC <= lCh2Gain;
                lCh1CouplingCDC  <= lCh1Coupling;
                lCh2CouplingCDC <= lCh2Coupling;
                lEnableAcquisitionCDC <= lEnableAcquisition;
                lTestModeCDC <= lTestMode;
            end if;
        end if;
    end if;
end process;
-------------------------------------------------------------------------------------------------

-- Register configuration in SysClk100 domain after clock domain crossing from AXI-Lite
SysClk100_config_CDC: process(SysClk100, sRst_n) 
begin
    if(rising_edge(SysClk100)) then
        if (sRst_n = '0') then
            sCh1GainConfig <= '0';
            sCh2GainConfig <= '0';
            sCh1CouplingConfig <= '0';
            sCh2CouplingConfig <= '0';
            sEnableAcquisition <= '0';
            sTestMode <= '0';
        else 
            if(sLoadData = '1') then
                sCh1GainConfig <= lCh1GainCDC;
                sCh2GainConfig <= lCh2GainCDC;
                sCh1CouplingConfig <= lCh1CouplingCDC;
                sCh2CouplingConfig <= lCh2CouplingCDC;
                sEnableAcquisition <= lEnableAcquisitionCDC;
                sTestMode <= lTestModeCDC;
            end if;
        end if;
    end if;
end process;
-------------------------------------------------------------------------------------------------

-- Register status flags in SysClk100 domain before clock domain crossing to AXI-Lite
SysClk100_status_CDC: process(SysClk100, sRst_n) 
begin
    if(rising_edge(SysClk100)) then
        if (sRst_n = '0') then
            sRstBusyCDC <= '0';
            sInitDoneADC_CDC <= '0';
            sConfigErrorCDC <= '0';
            sInitDoneRelayCDC <= '0';
            sDataOverflowCDC <= '0';
        else 
            if(slLoadData = '1') then
                sRstBusyCDC <= sRstBusy;
                sInitDoneADC_CDC <= sInitDoneADC;
                sConfigErrorCDC <= sConfigError;
                sInitDoneRelayCDC <= sInitDoneRelay;
                sDataOverflowCDC <= sDataOverflow;
            end if;
        end if;
    end if;
end process;
-------------------------------------------------------------------------------------------------

-- Register status flags in AXI-Lite domain after clock domain crossing from SysClk100
s_axi_status_CDC: process(s_axi_control_clk, s_axi_control_rst_n) 
begin
    if(rising_edge(s_axi_control_clk)) then
        if (s_axi_control_rst_n = '0') then
            lRstBusy <= '0';
            lInitDoneADC <= '0';
            lConfigError <= '0';
            lInitDoneRelay <= '0';
            lDataOverflow <= '0';
        else 
            if(lLoadData = '1') then
                lRstBusy <= sRstBusyCDC;
                lInitDoneADC <= sInitDoneADC_CDC;
                lConfigError <= sConfigErrorCDC;
                lInitDoneRelay <= sInitDoneRelayCDC;
                lDataOverflow <= sDataOverflowCDC;
            end if;
        end if;
    end if;
end process;
-------------------------------------------------------------------------------------------------

end Behavioral;
