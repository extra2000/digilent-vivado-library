-- ==============================================================
-- RTL generated by Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2021.1 (64-bit)
-- Version: 2021.1
-- Copyright (C) Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity req_gen is
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    inSend : IN STD_LOGIC_VECTOR (0 downto 0);
    inAck : IN STD_LOGIC_VECTOR (0 downto 0);
    outReq : OUT STD_LOGIC_VECTOR (0 downto 0);
    outReady : OUT STD_LOGIC_VECTOR (0 downto 0);
    outLoadData : OUT STD_LOGIC_VECTOR (0 downto 0) );
end;


architecture behav of req_gen is 
    attribute CORE_GENERATION_INFO : STRING;
    attribute CORE_GENERATION_INFO of behav : architecture is
    "req_gen_req_gen,hls_ip_2021_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=0,HLS_INPUT_PART=xc7z020-clg484-1,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=3.544000,HLS_SYN_LAT=0,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=6,HLS_SYN_LUT=8,HLS_VERSION=2021_1}";
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_ST_fsm_state1 : STD_LOGIC_VECTOR (0 downto 0) := "1";
    constant ap_const_lv1_0 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    constant ap_const_boolean_1 : BOOLEAN := true;
    constant ap_const_lv32_0 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    constant ap_const_lv1_1 : STD_LOGIC_VECTOR (0 downto 0) := "1";

    signal ackD_V_2 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    signal ackD_V_1 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    signal currentState : STD_LOGIC_VECTOR (0 downto 0) := "0";
    signal reqD_V : STD_LOGIC_VECTOR (0 downto 0) := "0";
    signal ackD_V_0 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    signal ap_CS_fsm : STD_LOGIC_VECTOR (0 downto 0) := "1";
    attribute fsm_encoding : string;
    attribute fsm_encoding of ap_CS_fsm : signal is "none";
    signal ap_CS_fsm_state1 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state1 : signal is "none";
    signal currentState_load_load_fu_91_p1 : STD_LOGIC_VECTOR (0 downto 0);
    signal inSend_read_read_fu_50_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal ret_3_fu_85_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal ret_fu_148_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal ready_V_fu_95_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal ret_4_fu_114_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_NS_fsm : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_ST_fsm_state1_blk : STD_LOGIC;
    signal ap_ce_reg : STD_LOGIC;


begin




    ap_CS_fsm_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_CS_fsm <= ap_ST_fsm_state1;
            else
                ap_CS_fsm <= ap_NS_fsm;
            end if;
        end if;
    end process;


    currentState_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_logic_1 = ap_CS_fsm_state1)) then
                if (((ret_3_fu_85_p2 = ap_const_lv1_1) and (currentState_load_load_fu_91_p1 = ap_const_lv1_1))) then 
                    currentState <= ap_const_lv1_0;
                elsif (((inSend_read_read_fu_50_p2 = ap_const_lv1_1) and (currentState_load_load_fu_91_p1 = ap_const_lv1_0))) then 
                    currentState <= ap_const_lv1_1;
                end if;
            end if; 
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_logic_1 = ap_CS_fsm_state1)) then
                ackD_V_0 <= inAck;
                ackD_V_1 <= ackD_V_0;
                ackD_V_2 <= ackD_V_1;
                reqD_V <= ret_fu_148_p2;
            end if;
        end if;
    end process;

    ap_NS_fsm_assign_proc : process (ap_CS_fsm)
    begin
        case ap_CS_fsm is
            when ap_ST_fsm_state1 => 
                ap_NS_fsm <= ap_ST_fsm_state1;
            when others =>  
                ap_NS_fsm <= "X";
        end case;
    end process;
    ap_CS_fsm_state1 <= ap_CS_fsm(0);
    ap_ST_fsm_state1_blk <= ap_const_logic_0;
    currentState_load_load_fu_91_p1 <= currentState;
    inSend_read_read_fu_50_p2 <= inSend;
    outLoadData <= ret_4_fu_114_p2;
    outReady <= ready_V_fu_95_p2;
    outReq <= reqD_V;
    ready_V_fu_95_p2 <= (currentState xor ap_const_lv1_1);
    ret_3_fu_85_p2 <= (ackD_V_2 xor ackD_V_1);
    ret_4_fu_114_p2 <= (ready_V_fu_95_p2 and inSend);
    ret_fu_148_p2 <= (ret_4_fu_114_p2 xor reqD_V);
end behav;
