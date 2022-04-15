----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2022 09:30:30 AM
-- Design Name: 
-- Module Name: cdc_sim - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
use work.req_gen;
use work.ack_gen;
entity cdc_sim is
--  Port ( );
end cdc_sim;

architecture Behavioral of cdc_sim is
  component ack_gen is
  port (
  ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    inLoad : IN STD_LOGIC_VECTOR (0 downto 0);
    inReq : IN STD_LOGIC_VECTOR (0 downto 0);
    outAck : OUT STD_LOGIC_VECTOR (0 downto 0);
    outValid : OUT STD_LOGIC_VECTOR (0 downto 0);
    outLoadData : OUT STD_LOGIC_VECTOR (0 downto 0)
  );
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
  signal clk100MHz : std_logic := '0';
  signal clk40MHz : std_logic := '0';
  signal outLoadData100MHz:  STD_LOGIC_VECTOR(0 downto 0);
  signal outLoadData40MHz:  STD_LOGIC_VECTOR(0 downto 0);

  signal inData : STD_LOGIC_VECTOR ( 17 downto 0 ) := "00" & X"0000";
  signal cdcData : STD_LOGIC_VECTOR ( 17 downto 0 ) := "00" & X"0000";
  signal outData : STD_LOGIC_VECTOR ( 17 downto 0 ) := "00" & X"0000";

  signal send : STD_LOGIC_VECTOR(0 downto 0) := "0";
  signal load: STD_LOGIC_VECTOR(0 downto 0) := "1";
  signal req: STD_LOGIC_VECTOR(0 downto 0);
  signal ack: STD_LOGIC_VECTOR(0 downto 0); 
  signal valid: STD_LOGIC_VECTOR(0 downto 0);
  signal ready: STD_LOGIC_VECTOR(0 downto 0);

begin

-- Handshake request block
REQ_HS:req_gen port map(
ap_clk=>clk100MHz,
ap_rst=>'0',
inSend => send,
inAck => ack,
outReq => req,
outReady => ready,
outLoadData => outLoadData100MHz
);

-- Handshake Acknowledge block
ACK_HS:ack_gen port map(
ap_clk=>clk40MHz,
ap_rst=>'0',
inLoad => load,
inReq => req,
outAck => ack,
outValid => valid,
outLoadData => outLoadData40MHz
);

-- Clocks
clk100MHz <= not clk100MHz after 5ns;
clk40MHz <= not clk40MHz after 12.5ns;

process (clk100MHz)
begin
    if rising_edge(clk100MHz) then
        if(outLoadData100MHz = "1") then
            cdcData <= inData;
        end if;
    end if;
end process;

process (clk40MHz)
begin
    if rising_edge(clk40MHz) then
        if(outLoadData40MHz = "1") then
            outData <= cdcData;
        end if;
    end if;
end process;

-- Req block always ready to read
load <= "1";
stim: process
begin

wait for 500ns;

inData <= "01" & X"BEEF";

if(ready = "1") then
    send <= "1";
    wait for 10ns;
    send <= "0";
end if;

wait for 500ns;
inData <= "01" & X"DEAD";

if(ready = "1") then
    send <= "1";
    wait for 10ns;
    send <= "0";
end if;
end process;
end Behavioral;
