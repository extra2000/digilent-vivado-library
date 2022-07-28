library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TriggerControl_top is
generic (
    C_S_AXI_CONTROL_ADDR_WIDTH : INTEGER := 6;
    C_S_AXI_CONTROL_DATA_WIDTH : INTEGER := 32
    );
port (
    stream_clk : IN STD_LOGIC;
    s_axi_aclk : IN STD_LOGIC;
    s_axi_areset_n : IN STD_LOGIC;
    rStart : OUT STD_LOGIC_VECTOR (0 downto 0);
    rIdle : IN STD_LOGIC_VECTOR (0 downto 0);
    rTriggerEnable : OUT STD_LOGIC_VECTOR (31 downto 0);
    rTriggerDetected : IN STD_LOGIC_VECTOR (31 downto 0);
    rTriggerToLastBeats : OUT STD_LOGIC_VECTOR (31 downto 0);
    rPrebufferBeats : OUT STD_LOGIC_VECTOR (31 downto 0);
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

architecture Behavioral of TriggerControl_top is
component TriggerControl is
generic (
    C_S_AXI_CONTROL_ADDR_WIDTH : INTEGER := 6;
    C_S_AXI_CONTROL_DATA_WIDTH : INTEGER := 32
);
port (
    ap_clk : IN STD_LOGIC;
    ap_rst_n : IN STD_LOGIC;
    Idle : IN STD_LOGIC_VECTOR (0 downto 0);
    TriggerDetected : IN STD_LOGIC_VECTOR (31 downto 0);
    Start_r : OUT STD_LOGIC_VECTOR (0 downto 0);
    TriggerEnable : OUT STD_LOGIC_VECTOR (31 downto 0);
    TriggerToLastBeats : OUT STD_LOGIC_VECTOR (31 downto 0);
    PrebufferBeats : OUT STD_LOGIC_VECTOR (31 downto 0);
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
signal lTriggerDetected : STD_LOGIC_VECTOR (31 downto 0);
signal lStart : STD_LOGIC_VECTOR (0 downto 0);
signal rStartInt : STD_LOGIC_VECTOR (0 downto 0);
signal lTriggerEnable : STD_LOGIC_VECTOR (31 downto 0);
signal rTriggerEnableInt : STD_LOGIC_VECTOR (31 downto 0);
signal lTriggerToLastBeats : STD_LOGIC_VECTOR (31 downto 0);
signal rTriggerToLastBeatsInt : STD_LOGIC_VECTOR (31 downto 0);
signal lPrebufferBeats : STD_LOGIC_VECTOR (31 downto 0);
signal rPrebufferBeatsInt : STD_LOGIC_VECTOR (31 downto 0);


begin

--- Instantiate HLS register file core

TriggerControl_inst: TriggerControl port map(
    ap_clk => s_axi_aclk,
    ap_rst_n => s_axi_areset_n,
    Idle => lIdle,
    TriggerDetected => lTriggerDetected,
    Start_r => lStart,
    TriggerEnable => lTriggerEnable,
    TriggerToLastBeats => lTriggerToLastBeats,
    PrebufferBeats => lPrebufferBeats,
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
rTriggerEnable <= rTriggerEnableInt;
rTriggerToLastBeats <= rTriggerToLastBeatsInt;
rPrebufferBeats <= rPrebufferBeatsInt;

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
-- Handshake CDC for TriggerDetected from stream_clk to s_axi_aclk
--- trigger handshake push on any difference in the input bus
TriggerDetected_from_stream_clk_to_s_axi_aclk_InstHandshake: ChangeDetectHandshake 
generic map (
    kDataWidth => 32
)
port map(
    InClk => stream_clk,
    OutClk => s_axi_aclk,
    iData => rTriggerDetected,
    oData => lTriggerDetected,
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
-- Handshake CDC for TriggerEnable from s_axi_aclk to stream_clk
--- trigger handshake on HLS interrupt
TriggerEnable_from_s_axi_aclk_to_stream_clk_InstHandshake: HandshakeData 
generic map (
    kDataWidth => 32
)
port map(
    InClk => s_axi_aclk,
    OutClk => stream_clk,
    iData => lTriggerEnable,
    oData => rTriggerEnableInt,
    iPush => lInterrupt,
    iRdy => open,
    oAck => '1',
    oValid => open,
    aiReset => lRst,
    aoReset => rRst
);
-- Handshake CDC for TriggerToLastBeats from s_axi_aclk to stream_clk
--- trigger handshake on HLS interrupt
TriggerToLastBeats_from_s_axi_aclk_to_stream_clk_InstHandshake: HandshakeData 
generic map (
    kDataWidth => 32
)
port map(
    InClk => s_axi_aclk,
    OutClk => stream_clk,
    iData => lTriggerToLastBeats,
    oData => rTriggerToLastBeatsInt,
    iPush => lInterrupt,
    iRdy => open,
    oAck => '1',
    oValid => open,
    aiReset => lRst,
    aoReset => rRst
);
-- Handshake CDC for PrebufferBeats from s_axi_aclk to stream_clk
--- trigger handshake on HLS interrupt
PrebufferBeats_from_s_axi_aclk_to_stream_clk_InstHandshake: HandshakeData 
generic map (
    kDataWidth => 32
)
port map(
    InClk => s_axi_aclk,
    OutClk => stream_clk,
    iData => lPrebufferBeats,
    oData => rPrebufferBeatsInt,
    iPush => lInterrupt,
    iRdy => open,
    oAck => '1',
    oValid => open,
    aiReset => lRst,
    aoReset => rRst
);

end Behavioral;
