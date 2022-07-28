library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ZmodAwgAxiConfiguration_top is
generic (
    C_S_AXI_CONTROL_ADDR_WIDTH : INTEGER := 7;
    C_S_AXI_CONTROL_DATA_WIDTH : INTEGER := 32
    );
port (
    s_axi_aclk : IN STD_LOGIC;
    SysClk : IN STD_LOGIC;
    DAC_InIO_Clk : IN STD_LOGIC;
    s_axi_areset_n : IN STD_LOGIC;
    sDacEnable : OUT STD_LOGIC_VECTOR (0 downto 0);
    sTestMode : OUT STD_LOGIC_VECTOR (0 downto 0);
    sExtCh1Scale : OUT STD_LOGIC_VECTOR (0 downto 0);
    sExtCh2Scale : OUT STD_LOGIC_VECTOR (0 downto 0);
    sInitDoneDAC : IN STD_LOGIC_VECTOR (0 downto 0);
    sConfigError : IN STD_LOGIC_VECTOR (0 downto 0);
    cExtCh1HgMultCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    cExtCh1HgAddCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    cExtCh1LgMultCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    cExtCh1LgAddCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    cExtCh2HgMultCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    cExtCh2HgAddCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    cExtCh2LgMultCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    cExtCh2LgAddCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
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

architecture Behavioral of ZmodAwgAxiConfiguration_top is
component ZmodAwgAxiConfiguration is
generic (
    C_S_AXI_CONTROL_ADDR_WIDTH : INTEGER := 7;
    C_S_AXI_CONTROL_DATA_WIDTH : INTEGER := 32
);
port (
    ap_clk : IN STD_LOGIC;
    ap_rst_n : IN STD_LOGIC;
    InitDoneDAC : IN STD_LOGIC_VECTOR (0 downto 0);
    ConfigError : IN STD_LOGIC_VECTOR (0 downto 0);
    DacEnable : OUT STD_LOGIC_VECTOR (0 downto 0);
    TestMode : OUT STD_LOGIC_VECTOR (0 downto 0);
    ExtCh1Scale : OUT STD_LOGIC_VECTOR (0 downto 0);
    ExtCh2Scale : OUT STD_LOGIC_VECTOR (0 downto 0);
    ExtCh1HgMultCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    ExtCh1HgAddCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    ExtCh1LgMultCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    ExtCh1LgAddCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    ExtCh2HgMultCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    ExtCh2HgAddCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    ExtCh2LgMultCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    ExtCh2LgAddCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
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
    interrupt : OUT STD_LOGIC
);
end component;

component HandshakeData is
generic (
    kDataWidth : natural := 8
);
port (
    InClk : in STD_LOGIC;
    OutClk : in STD_LOGIC;
    iData : in STD_LOGIC_VECTOR (kDataWidth-1 downto 0);
    oData : out STD_LOGIC_VECTOR (kDataWidth-1 downto 0);
    iPush : in STD_LOGIC;
    iRdy : out STD_LOGIC;
    oAck : in STD_LOGIC := '1';
    oValid : out STD_LOGIC;
    aiReset : in std_logic;
    aoReset : in std_logic
);
end component;

component ChangeDetectHandshake is
generic (
    kDataWidth : natural := 8
);
port (
    InClk : in STD_LOGIC;
    OutClk : in STD_LOGIC;
    iData : in STD_LOGIC_VECTOR (kDataWidth-1 downto 0);
    oData : out STD_LOGIC_VECTOR (kDataWidth-1 downto 0);
    iRdy : out STD_LOGIC;
    oValid : out STD_LOGIC;
    aiReset : in std_logic;
    aoReset : in std_logic
);
end component;

component ResetBridge is
generic (
    kPolarity : std_logic := '1'
);
port (
    aRst : in STD_LOGIC; -- asynchronous reset; active-high, if kPolarity=1
    OutClk : in STD_LOGIC;
    oRst : out STD_LOGIC
);
end component;

-- HLS interrupt flag
signal lInterrupt : STD_LOGIC;

-- Reset signals for each clock domain
signal lRst_n : STD_LOGIC;
signal lRst : STD_LOGIC;
signal sRst_n : STD_LOGIC;
signal sRst : STD_LOGIC;
signal cRst_n : STD_LOGIC;
signal cRst : STD_LOGIC;

-- Internal signals for ports
signal lInitDoneDAC : STD_LOGIC_VECTOR (0 downto 0);
signal lConfigError : STD_LOGIC_VECTOR (0 downto 0);
signal lDacEnable : STD_LOGIC_VECTOR (0 downto 0);
signal sDacEnableInt : STD_LOGIC_VECTOR (0 downto 0);
signal lTestMode : STD_LOGIC_VECTOR (0 downto 0);
signal sTestModeInt : STD_LOGIC_VECTOR (0 downto 0);
signal lExtCh1Scale : STD_LOGIC_VECTOR (0 downto 0);
signal sExtCh1ScaleInt : STD_LOGIC_VECTOR (0 downto 0);
signal lExtCh2Scale : STD_LOGIC_VECTOR (0 downto 0);
signal sExtCh2ScaleInt : STD_LOGIC_VECTOR (0 downto 0);
signal lExtCh1HgMultCoef : STD_LOGIC_VECTOR (17 downto 0);
signal cExtCh1HgMultCoefInt : STD_LOGIC_VECTOR (17 downto 0);
signal lExtCh1HgAddCoef : STD_LOGIC_VECTOR (17 downto 0);
signal cExtCh1HgAddCoefInt : STD_LOGIC_VECTOR (17 downto 0);
signal lExtCh1LgMultCoef : STD_LOGIC_VECTOR (17 downto 0);
signal cExtCh1LgMultCoefInt : STD_LOGIC_VECTOR (17 downto 0);
signal lExtCh1LgAddCoef : STD_LOGIC_VECTOR (17 downto 0);
signal cExtCh1LgAddCoefInt : STD_LOGIC_VECTOR (17 downto 0);
signal lExtCh2HgMultCoef : STD_LOGIC_VECTOR (17 downto 0);
signal cExtCh2HgMultCoefInt : STD_LOGIC_VECTOR (17 downto 0);
signal lExtCh2HgAddCoef : STD_LOGIC_VECTOR (17 downto 0);
signal cExtCh2HgAddCoefInt : STD_LOGIC_VECTOR (17 downto 0);
signal lExtCh2LgMultCoef : STD_LOGIC_VECTOR (17 downto 0);
signal cExtCh2LgMultCoefInt : STD_LOGIC_VECTOR (17 downto 0);
signal lExtCh2LgAddCoef : STD_LOGIC_VECTOR (17 downto 0);
signal cExtCh2LgAddCoefInt : STD_LOGIC_VECTOR (17 downto 0);


begin

--- Instantiate HLS register file core

ZmodAwgAxiConfiguration_inst: ZmodAwgAxiConfiguration port map(
    ap_clk => s_axi_aclk,
    ap_rst_n => s_axi_areset_n,
    InitDoneDAC => lInitDoneDAC,
    ConfigError => lConfigError,
    DacEnable => lDacEnable,
    TestMode => lTestMode,
    ExtCh1Scale => lExtCh1Scale,
    ExtCh2Scale => lExtCh2Scale,
    ExtCh1HgMultCoef => lExtCh1HgMultCoef,
    ExtCh1HgAddCoef => lExtCh1HgAddCoef,
    ExtCh1LgMultCoef => lExtCh1LgMultCoef,
    ExtCh1LgAddCoef => lExtCh1LgAddCoef,
    ExtCh2HgMultCoef => lExtCh2HgMultCoef,
    ExtCh2HgAddCoef => lExtCh2HgAddCoef,
    ExtCh2LgMultCoef => lExtCh2LgMultCoef,
    ExtCh2LgAddCoef => lExtCh2LgAddCoef,
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
    interrupt => lInterrupt
);

--- Create synchronous resets for each clock
lRst_n <= s_axi_areset_n;
lRst <= not s_axi_areset_n;

s_axi_aclk_to_SysClk_rst: ResetBridge generic map(
    kPolarity => '0'
)
port map (
    aRst => s_axi_areset_n,
    outClk => SysClk,
    oRst => sRst_n
);
sRst <= not sRst_n;

s_axi_aclk_to_DAC_InIO_Clk_rst: ResetBridge generic map(
    kPolarity => '0'
)
port map (
    aRst => s_axi_areset_n,
    outClk => DAC_InIO_Clk,
    oRst => cRst_n
);
cRst <= not cRst_n;

--- Map external output ports to internal signals
sDacEnable <= sDacEnableInt;
sTestMode <= sTestModeInt;
sExtCh1Scale <= sExtCh1ScaleInt;
sExtCh2Scale <= sExtCh2ScaleInt;
cExtCh1HgMultCoef <= cExtCh1HgMultCoefInt;
cExtCh1HgAddCoef <= cExtCh1HgAddCoefInt;
cExtCh1LgMultCoef <= cExtCh1LgMultCoefInt;
cExtCh1LgAddCoef <= cExtCh1LgAddCoefInt;
cExtCh2HgMultCoef <= cExtCh2HgMultCoefInt;
cExtCh2HgAddCoef <= cExtCh2HgAddCoefInt;
cExtCh2LgMultCoef <= cExtCh2LgMultCoefInt;
cExtCh2LgAddCoef <= cExtCh2LgAddCoefInt;

--- Instantiate handshake clock domain crossing modules
-- Handshake CDC for InitDoneDAC from SysClk to s_axi_aclk
--- trigger handshake push on any difference in the input bus
InitDoneDAC_from_SysClk_to_s_axi_aclk_InstHandshake: ChangeDetectHandshake 
generic map (
    kDataWidth => 1
)
port map(
    InClk => SysClk,
    OutClk => s_axi_aclk,
    iData => sInitDoneDAC,
    oData => lInitDoneDAC,
    iRdy => open,
    oValid => open,
    aiReset => sRst,
    aoReset => lRst
);
-- Handshake CDC for ConfigError from SysClk to s_axi_aclk
--- trigger handshake push on any difference in the input bus
ConfigError_from_SysClk_to_s_axi_aclk_InstHandshake: ChangeDetectHandshake 
generic map (
    kDataWidth => 1
)
port map(
    InClk => SysClk,
    OutClk => s_axi_aclk,
    iData => sConfigError,
    oData => lConfigError,
    iRdy => open,
    oValid => open,
    aiReset => sRst,
    aoReset => lRst
);
-- Handshake CDC for DacEnable from s_axi_aclk to SysClk
--- trigger handshake on HLS interrupt
DacEnable_from_s_axi_aclk_to_SysClk_InstHandshake: HandshakeData 
generic map (
    kDataWidth => 1
)
port map(
    InClk => s_axi_aclk,
    OutClk => SysClk,
    iData => lDacEnable,
    oData => sDacEnableInt,
    iPush => lInterrupt,
    iRdy => open,
    oAck => '1',
    oValid => open,
    aiReset => lRst,
    aoReset => sRst
);
-- Handshake CDC for TestMode from s_axi_aclk to SysClk
--- trigger handshake on HLS interrupt
TestMode_from_s_axi_aclk_to_SysClk_InstHandshake: HandshakeData 
generic map (
    kDataWidth => 1
)
port map(
    InClk => s_axi_aclk,
    OutClk => SysClk,
    iData => lTestMode,
    oData => sTestModeInt,
    iPush => lInterrupt,
    iRdy => open,
    oAck => '1',
    oValid => open,
    aiReset => lRst,
    aoReset => sRst
);
-- Handshake CDC for ExtCh1Scale from s_axi_aclk to SysClk
--- trigger handshake on HLS interrupt
ExtCh1Scale_from_s_axi_aclk_to_SysClk_InstHandshake: HandshakeData 
generic map (
    kDataWidth => 1
)
port map(
    InClk => s_axi_aclk,
    OutClk => SysClk,
    iData => lExtCh1Scale,
    oData => sExtCh1ScaleInt,
    iPush => lInterrupt,
    iRdy => open,
    oAck => '1',
    oValid => open,
    aiReset => lRst,
    aoReset => sRst
);
-- Handshake CDC for ExtCh2Scale from s_axi_aclk to SysClk
--- trigger handshake on HLS interrupt
ExtCh2Scale_from_s_axi_aclk_to_SysClk_InstHandshake: HandshakeData 
generic map (
    kDataWidth => 1
)
port map(
    InClk => s_axi_aclk,
    OutClk => SysClk,
    iData => lExtCh2Scale,
    oData => sExtCh2ScaleInt,
    iPush => lInterrupt,
    iRdy => open,
    oAck => '1',
    oValid => open,
    aiReset => lRst,
    aoReset => sRst
);
-- Handshake CDC for ExtCh1HgMultCoef from s_axi_aclk to DAC_InIO_Clk
--- trigger handshake on HLS interrupt
ExtCh1HgMultCoef_from_s_axi_aclk_to_DAC_InIO_Clk_InstHandshake: HandshakeData 
generic map (
    kDataWidth => 18
)
port map(
    InClk => s_axi_aclk,
    OutClk => DAC_InIO_Clk,
    iData => lExtCh1HgMultCoef,
    oData => cExtCh1HgMultCoefInt,
    iPush => lInterrupt,
    iRdy => open,
    oAck => '1',
    oValid => open,
    aiReset => lRst,
    aoReset => cRst
);
-- Handshake CDC for ExtCh1HgAddCoef from s_axi_aclk to DAC_InIO_Clk
--- trigger handshake on HLS interrupt
ExtCh1HgAddCoef_from_s_axi_aclk_to_DAC_InIO_Clk_InstHandshake: HandshakeData 
generic map (
    kDataWidth => 18
)
port map(
    InClk => s_axi_aclk,
    OutClk => DAC_InIO_Clk,
    iData => lExtCh1HgAddCoef,
    oData => cExtCh1HgAddCoefInt,
    iPush => lInterrupt,
    iRdy => open,
    oAck => '1',
    oValid => open,
    aiReset => lRst,
    aoReset => cRst
);
-- Handshake CDC for ExtCh1LgMultCoef from s_axi_aclk to DAC_InIO_Clk
--- trigger handshake on HLS interrupt
ExtCh1LgMultCoef_from_s_axi_aclk_to_DAC_InIO_Clk_InstHandshake: HandshakeData 
generic map (
    kDataWidth => 18
)
port map(
    InClk => s_axi_aclk,
    OutClk => DAC_InIO_Clk,
    iData => lExtCh1LgMultCoef,
    oData => cExtCh1LgMultCoefInt,
    iPush => lInterrupt,
    iRdy => open,
    oAck => '1',
    oValid => open,
    aiReset => lRst,
    aoReset => cRst
);
-- Handshake CDC for ExtCh1LgAddCoef from s_axi_aclk to DAC_InIO_Clk
--- trigger handshake on HLS interrupt
ExtCh1LgAddCoef_from_s_axi_aclk_to_DAC_InIO_Clk_InstHandshake: HandshakeData 
generic map (
    kDataWidth => 18
)
port map(
    InClk => s_axi_aclk,
    OutClk => DAC_InIO_Clk,
    iData => lExtCh1LgAddCoef,
    oData => cExtCh1LgAddCoefInt,
    iPush => lInterrupt,
    iRdy => open,
    oAck => '1',
    oValid => open,
    aiReset => lRst,
    aoReset => cRst
);
-- Handshake CDC for ExtCh2HgMultCoef from s_axi_aclk to DAC_InIO_Clk
--- trigger handshake on HLS interrupt
ExtCh2HgMultCoef_from_s_axi_aclk_to_DAC_InIO_Clk_InstHandshake: HandshakeData 
generic map (
    kDataWidth => 18
)
port map(
    InClk => s_axi_aclk,
    OutClk => DAC_InIO_Clk,
    iData => lExtCh2HgMultCoef,
    oData => cExtCh2HgMultCoefInt,
    iPush => lInterrupt,
    iRdy => open,
    oAck => '1',
    oValid => open,
    aiReset => lRst,
    aoReset => cRst
);
-- Handshake CDC for ExtCh2HgAddCoef from s_axi_aclk to DAC_InIO_Clk
--- trigger handshake on HLS interrupt
ExtCh2HgAddCoef_from_s_axi_aclk_to_DAC_InIO_Clk_InstHandshake: HandshakeData 
generic map (
    kDataWidth => 18
)
port map(
    InClk => s_axi_aclk,
    OutClk => DAC_InIO_Clk,
    iData => lExtCh2HgAddCoef,
    oData => cExtCh2HgAddCoefInt,
    iPush => lInterrupt,
    iRdy => open,
    oAck => '1',
    oValid => open,
    aiReset => lRst,
    aoReset => cRst
);
-- Handshake CDC for ExtCh2LgMultCoef from s_axi_aclk to DAC_InIO_Clk
--- trigger handshake on HLS interrupt
ExtCh2LgMultCoef_from_s_axi_aclk_to_DAC_InIO_Clk_InstHandshake: HandshakeData 
generic map (
    kDataWidth => 18
)
port map(
    InClk => s_axi_aclk,
    OutClk => DAC_InIO_Clk,
    iData => lExtCh2LgMultCoef,
    oData => cExtCh2LgMultCoefInt,
    iPush => lInterrupt,
    iRdy => open,
    oAck => '1',
    oValid => open,
    aiReset => lRst,
    aoReset => cRst
);
-- Handshake CDC for ExtCh2LgAddCoef from s_axi_aclk to DAC_InIO_Clk
--- trigger handshake on HLS interrupt
ExtCh2LgAddCoef_from_s_axi_aclk_to_DAC_InIO_Clk_InstHandshake: HandshakeData 
generic map (
    kDataWidth => 18
)
port map(
    InClk => s_axi_aclk,
    OutClk => DAC_InIO_Clk,
    iData => lExtCh2LgAddCoef,
    oData => cExtCh2LgAddCoefInt,
    iPush => lInterrupt,
    iRdy => open,
    oAck => '1',
    oValid => open,
    aiReset => lRst,
    aoReset => cRst
);

end Behavioral;
