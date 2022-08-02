library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UserRegisters_top is
generic (
    C_S_AXI_CONTROL_ADDR_WIDTH : INTEGER := 7;
    C_S_AXI_CONTROL_DATA_WIDTH : INTEGER := 32
    );
port (
    io_clk : IN STD_LOGIC;
    s_axi_aclk : IN STD_LOGIC;
    s_axi_areset_n : IN STD_LOGIC;
    rInput0 : IN STD_LOGIC_VECTOR (31 downto 0);
    rInput1 : IN STD_LOGIC_VECTOR (31 downto 0);
    rInput2 : IN STD_LOGIC_VECTOR (31 downto 0);
    rInput3 : IN STD_LOGIC_VECTOR (31 downto 0);
    rOutput0 : OUT STD_LOGIC_VECTOR (31 downto 0);
    rOutput1 : OUT STD_LOGIC_VECTOR (31 downto 0);
    rOutput2 : OUT STD_LOGIC_VECTOR (31 downto 0);
    rOutput3 : OUT STD_LOGIC_VECTOR (31 downto 0);
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

architecture Behavioral of UserRegisters_top is
component UserRegisters is
generic (
    C_S_AXI_CONTROL_ADDR_WIDTH : INTEGER := 7;
    C_S_AXI_CONTROL_DATA_WIDTH : INTEGER := 32
);
port (
    ap_clk : IN STD_LOGIC;
    ap_rst_n : IN STD_LOGIC;
    Input0 : IN STD_LOGIC_VECTOR (31 downto 0);
    Input1 : IN STD_LOGIC_VECTOR (31 downto 0);
    Input2 : IN STD_LOGIC_VECTOR (31 downto 0);
    Input3 : IN STD_LOGIC_VECTOR (31 downto 0);
    Output0 : OUT STD_LOGIC_VECTOR (31 downto 0);
    Output1 : OUT STD_LOGIC_VECTOR (31 downto 0);
    Output2 : OUT STD_LOGIC_VECTOR (31 downto 0);
    Output3 : OUT STD_LOGIC_VECTOR (31 downto 0);
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
signal lInput0 : STD_LOGIC_VECTOR (31 downto 0);
signal lInput1 : STD_LOGIC_VECTOR (31 downto 0);
signal lInput2 : STD_LOGIC_VECTOR (31 downto 0);
signal lInput3 : STD_LOGIC_VECTOR (31 downto 0);
signal lOutput0 : STD_LOGIC_VECTOR (31 downto 0);
signal rOutput0Int : STD_LOGIC_VECTOR (31 downto 0);
signal lOutput1 : STD_LOGIC_VECTOR (31 downto 0);
signal rOutput1Int : STD_LOGIC_VECTOR (31 downto 0);
signal lOutput2 : STD_LOGIC_VECTOR (31 downto 0);
signal rOutput2Int : STD_LOGIC_VECTOR (31 downto 0);
signal lOutput3 : STD_LOGIC_VECTOR (31 downto 0);
signal rOutput3Int : STD_LOGIC_VECTOR (31 downto 0);


begin

--- Instantiate HLS register file core

UserRegisters_inst: UserRegisters port map(
    ap_clk => s_axi_aclk,
    ap_rst_n => s_axi_areset_n,
    Input0 => lInput0,
    Input1 => lInput1,
    Input2 => lInput2,
    Input3 => lInput3,
    Output0 => lOutput0,
    Output1 => lOutput1,
    Output2 => lOutput2,
    Output3 => lOutput3,
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

s_axi_aclk_to_io_clk_rst: ResetBridge generic map(
    kPolarity => '0'
)
port map (
    aRst => s_axi_areset_n,
    outClk => io_clk,
    oRst => rRst_n
);
rRst <= not rRst_n;
lRst_n <= s_axi_areset_n;
lRst <= not s_axi_areset_n;

--- Map external output ports to internal signals
rOutput0 <= rOutput0Int;
rOutput1 <= rOutput1Int;
rOutput2 <= rOutput2Int;
rOutput3 <= rOutput3Int;

--- Instantiate handshake clock domain crossing modules
-- Handshake CDC for Input0 from io_clk to s_axi_aclk
--- trigger handshake push on any difference in the input bus
Input0_from_io_clk_to_s_axi_aclk_InstHandshake: ChangeDetectHandshake 
generic map (
    kDataWidth => 32
)
port map(
    InClk => io_clk,
    OutClk => s_axi_aclk,
    iData => rInput0,
    oData => lInput0,
    iRdy => open,
    oValid => open,
    aiReset => rRst,
    aoReset => lRst
);
-- Handshake CDC for Input1 from io_clk to s_axi_aclk
--- trigger handshake push on any difference in the input bus
Input1_from_io_clk_to_s_axi_aclk_InstHandshake: ChangeDetectHandshake 
generic map (
    kDataWidth => 32
)
port map(
    InClk => io_clk,
    OutClk => s_axi_aclk,
    iData => rInput1,
    oData => lInput1,
    iRdy => open,
    oValid => open,
    aiReset => rRst,
    aoReset => lRst
);
-- Handshake CDC for Input2 from io_clk to s_axi_aclk
--- trigger handshake push on any difference in the input bus
Input2_from_io_clk_to_s_axi_aclk_InstHandshake: ChangeDetectHandshake 
generic map (
    kDataWidth => 32
)
port map(
    InClk => io_clk,
    OutClk => s_axi_aclk,
    iData => rInput2,
    oData => lInput2,
    iRdy => open,
    oValid => open,
    aiReset => rRst,
    aoReset => lRst
);
-- Handshake CDC for Input3 from io_clk to s_axi_aclk
--- trigger handshake push on any difference in the input bus
Input3_from_io_clk_to_s_axi_aclk_InstHandshake: ChangeDetectHandshake 
generic map (
    kDataWidth => 32
)
port map(
    InClk => io_clk,
    OutClk => s_axi_aclk,
    iData => rInput3,
    oData => lInput3,
    iRdy => open,
    oValid => open,
    aiReset => rRst,
    aoReset => lRst
);
-- Handshake CDC for Output0 from s_axi_aclk to io_clk
--- trigger handshake on HLS interrupt
Output0_from_s_axi_aclk_to_io_clk_InstHandshake: HandshakeData 
generic map (
    kDataWidth => 32
)
port map(
    InClk => s_axi_aclk,
    OutClk => io_clk,
    iData => lOutput0,
    oData => rOutput0Int,
    iPush => lInterrupt,
    iRdy => open,
    oAck => '1',
    oValid => open,
    aiReset => lRst,
    aoReset => rRst
);
-- Handshake CDC for Output1 from s_axi_aclk to io_clk
--- trigger handshake on HLS interrupt
Output1_from_s_axi_aclk_to_io_clk_InstHandshake: HandshakeData 
generic map (
    kDataWidth => 32
)
port map(
    InClk => s_axi_aclk,
    OutClk => io_clk,
    iData => lOutput1,
    oData => rOutput1Int,
    iPush => lInterrupt,
    iRdy => open,
    oAck => '1',
    oValid => open,
    aiReset => lRst,
    aoReset => rRst
);
-- Handshake CDC for Output2 from s_axi_aclk to io_clk
--- trigger handshake on HLS interrupt
Output2_from_s_axi_aclk_to_io_clk_InstHandshake: HandshakeData 
generic map (
    kDataWidth => 32
)
port map(
    InClk => s_axi_aclk,
    OutClk => io_clk,
    iData => lOutput2,
    oData => rOutput2Int,
    iPush => lInterrupt,
    iRdy => open,
    oAck => '1',
    oValid => open,
    aiReset => lRst,
    aoReset => rRst
);
-- Handshake CDC for Output3 from s_axi_aclk to io_clk
--- trigger handshake on HLS interrupt
Output3_from_s_axi_aclk_to_io_clk_InstHandshake: HandshakeData 
generic map (
    kDataWidth => 32
)
port map(
    InClk => s_axi_aclk,
    OutClk => io_clk,
    iData => lOutput3,
    oData => rOutput3Int,
    iPush => lInterrupt,
    iRdy => open,
    oAck => '1',
    oValid => open,
    aiReset => lRst,
    aoReset => rRst
);

end Behavioral;
