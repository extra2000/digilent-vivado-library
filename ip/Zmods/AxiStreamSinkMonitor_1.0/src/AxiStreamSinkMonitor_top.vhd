library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AxiStreamSinkMonitor_top is
generic (
    C_S_AXI_CONTROL_ADDR_WIDTH : INTEGER := 6;
    C_S_AXI_CONTROL_DATA_WIDTH : INTEGER := 32
    );
port (
    stream_clk : IN STD_LOGIC;
    s_axi_aclk : IN STD_LOGIC;
    s_axi_areset_n : IN STD_LOGIC;
    rStart : OUT STD_LOGIC_VECTOR (0 downto 0);
    rClearTlastCount : OUT STD_LOGIC_VECTOR (0 downto 0);
    rSelectVoid : OUT STD_LOGIC_VECTOR (0 downto 0);
    rIdle : IN STD_LOGIC_VECTOR (0 downto 0);
    rNumFrames : OUT STD_LOGIC_VECTOR (31 downto 0);
    rBeatCount : IN STD_LOGIC_VECTOR (31 downto 0);
    rMissCount : IN STD_LOGIC_VECTOR (31 downto 0);
    rErrorCount : IN STD_LOGIC_VECTOR (31 downto 0);
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

architecture Behavioral of AxiStreamSinkMonitor_top is
component AxiStreamSinkMonitor is
generic (
    C_S_AXI_CONTROL_ADDR_WIDTH : INTEGER := 6;
    C_S_AXI_CONTROL_DATA_WIDTH : INTEGER := 32
);
port (
    ap_clk : IN STD_LOGIC;
    ap_rst_n : IN STD_LOGIC;
    Idle : IN STD_LOGIC_VECTOR (0 downto 0);
    BeatCount : IN STD_LOGIC_VECTOR (31 downto 0);
    MissCount : IN STD_LOGIC_VECTOR (31 downto 0);
    ErrorCount : IN STD_LOGIC_VECTOR (31 downto 0);
    Start_r : OUT STD_LOGIC_VECTOR (0 downto 0);
    ClearTlastCount : OUT STD_LOGIC_VECTOR (0 downto 0);
    SelectVoid : OUT STD_LOGIC_VECTOR (0 downto 0);
    NumFrames : OUT STD_LOGIC_VECTOR (31 downto 0);
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
signal rRst_n : STD_LOGIC;
signal rRst : STD_LOGIC;
signal lRst_n : STD_LOGIC;
signal lRst : STD_LOGIC;

-- Internal signals for ports
signal lIdle : STD_LOGIC_VECTOR (0 downto 0);
signal lBeatCount : STD_LOGIC_VECTOR (31 downto 0);
signal lMissCount : STD_LOGIC_VECTOR (31 downto 0);
signal lErrorCount : STD_LOGIC_VECTOR (31 downto 0);
signal lStart : STD_LOGIC_VECTOR (0 downto 0);
signal rStartInt : STD_LOGIC_VECTOR (0 downto 0);
signal lClearTlastCount : STD_LOGIC_VECTOR (0 downto 0);
signal rClearTlastCountInt : STD_LOGIC_VECTOR (0 downto 0);
signal lSelectVoid : STD_LOGIC_VECTOR (0 downto 0);
signal rSelectVoidInt : STD_LOGIC_VECTOR (0 downto 0);
signal lNumFrames : STD_LOGIC_VECTOR (31 downto 0);
signal rNumFramesInt : STD_LOGIC_VECTOR (31 downto 0);


begin

--- Instantiate HLS register file core

AxiStreamSinkMonitor_inst: AxiStreamSinkMonitor port map(
    ap_clk => s_axi_aclk,
    ap_rst_n => s_axi_areset_n,
    Idle => lIdle,
    BeatCount => lBeatCount,
    MissCount => lMissCount,
    ErrorCount => lErrorCount,
    Start_r => lStart,
    ClearTlastCount => lClearTlastCount,
    SelectVoid => lSelectVoid,
    NumFrames => lNumFrames,
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

s_axi_aclk_to_stream_clk_rst: ResetBridge generic map(
    kPolarity => '0'
)
port map (
    aRst => s_axi_areset_n,
    outClk => stream_clk,
    oRst => rRst_n
);
rRst <= not rRst_n;
lRst_n <= s_axi_areset_n;
lRst <= not s_axi_areset_n;

--- Map external output ports to internal signals
rStart <= rStartInt;
rClearTlastCount <= rClearTlastCountInt;
rSelectVoid <= rSelectVoidInt;
rNumFrames <= rNumFramesInt;

--- Instantiate handshake clock domain crossing modules
-- Handshake CDC for Idle from stream_clk to s_axi_aclk
--- trigger handshake push on any difference in the input bus
Idle_from_stream_clk_to_s_axi_aclk_InstHandshake: ChangeDetectHandshake 
generic map (
    kDataWidth => 1
)
port map(
    InClk => stream_clk,
    OutClk => s_axi_aclk,
    iData => rIdle,
    oData => lIdle,
    iRdy => open,
    oValid => open,
    aiReset => rRst,
    aoReset => lRst
);
-- Handshake CDC for BeatCount from stream_clk to s_axi_aclk
--- trigger handshake push on any difference in the input bus
BeatCount_from_stream_clk_to_s_axi_aclk_InstHandshake: ChangeDetectHandshake 
generic map (
    kDataWidth => 32
)
port map(
    InClk => stream_clk,
    OutClk => s_axi_aclk,
    iData => rBeatCount,
    oData => lBeatCount,
    iRdy => open,
    oValid => open,
    aiReset => rRst,
    aoReset => lRst
);
-- Handshake CDC for MissCount from stream_clk to s_axi_aclk
--- trigger handshake push on any difference in the input bus
MissCount_from_stream_clk_to_s_axi_aclk_InstHandshake: ChangeDetectHandshake 
generic map (
    kDataWidth => 32
)
port map(
    InClk => stream_clk,
    OutClk => s_axi_aclk,
    iData => rMissCount,
    oData => lMissCount,
    iRdy => open,
    oValid => open,
    aiReset => rRst,
    aoReset => lRst
);
-- Handshake CDC for ErrorCount from stream_clk to s_axi_aclk
--- trigger handshake push on any difference in the input bus
ErrorCount_from_stream_clk_to_s_axi_aclk_InstHandshake: ChangeDetectHandshake 
generic map (
    kDataWidth => 32
)
port map(
    InClk => stream_clk,
    OutClk => s_axi_aclk,
    iData => rErrorCount,
    oData => lErrorCount,
    iRdy => open,
    oValid => open,
    aiReset => rRst,
    aoReset => lRst
);
-- Handshake CDC for Start from s_axi_aclk to stream_clk
--- trigger handshake on HLS interrupt
Start_from_s_axi_aclk_to_stream_clk_InstHandshake: HandshakeData 
generic map (
    kDataWidth => 1
)
port map(
    InClk => s_axi_aclk,
    OutClk => stream_clk,
    iData => lStart,
    oData => rStartInt,
    iPush => lInterrupt,
    iRdy => open,
    oAck => '1',
    oValid => open,
    aiReset => lRst,
    aoReset => rRst
);
-- Handshake CDC for ClearTlastCount from s_axi_aclk to stream_clk
--- trigger handshake on HLS interrupt
ClearTlastCount_from_s_axi_aclk_to_stream_clk_InstHandshake: HandshakeData 
generic map (
    kDataWidth => 1
)
port map(
    InClk => s_axi_aclk,
    OutClk => stream_clk,
    iData => lClearTlastCount,
    oData => rClearTlastCountInt,
    iPush => lInterrupt,
    iRdy => open,
    oAck => '1',
    oValid => open,
    aiReset => lRst,
    aoReset => rRst
);
-- Handshake CDC for SelectVoid from s_axi_aclk to stream_clk
--- trigger handshake on HLS interrupt
SelectVoid_from_s_axi_aclk_to_stream_clk_InstHandshake: HandshakeData 
generic map (
    kDataWidth => 1
)
port map(
    InClk => s_axi_aclk,
    OutClk => stream_clk,
    iData => lSelectVoid,
    oData => rSelectVoidInt,
    iPush => lInterrupt,
    iRdy => open,
    oAck => '1',
    oValid => open,
    aiReset => lRst,
    aoReset => rRst
);
-- Handshake CDC for NumFrames from s_axi_aclk to stream_clk
--- trigger handshake on HLS interrupt
NumFrames_from_s_axi_aclk_to_stream_clk_InstHandshake: HandshakeData 
generic map (
    kDataWidth => 32
)
port map(
    InClk => s_axi_aclk,
    OutClk => stream_clk,
    iData => lNumFrames,
    oData => rNumFramesInt,
    iPush => lInterrupt,
    iRdy => open,
    oAck => '1',
    oValid => open,
    aiReset => lRst,
    aoReset => rRst
);

end Behavioral;
