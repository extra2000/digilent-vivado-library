set_property ASYNC_REG true [get_cells s_axi_to_ADC_SamplingClk_req/ackD_V_0_reg[0]]
set_property ASYNC_REG true [get_cells s_axi_to_ADC_SamplingClk_req/ackD_V_1_reg[0]]

set_property ASYNC_REG true [get_cells s_axi_to_ADC_SamplingClk_ack/reqD_V_0_reg[0]]
set_property ASYNC_REG true [get_cells s_axi_to_ADC_SamplingClk_ack/reqD_V_1_reg[0]]

set_property ASYNC_REG true [get_cells SysClk100_to_s_axi_req/ackD_V_0_reg[0]]
set_property ASYNC_REG true [get_cells SysClk100_to_s_axi_req/ackD_V_1_reg[0]]

set_property ASYNC_REG true [get_cells SysClk100_to_s_axi_ack/reqD_V_0_reg[0]]
set_property ASYNC_REG true [get_cells SysClk100_to_s_axi_ack/reqD_V_1_reg[0]]

set_property ASYNC_REG true [get_cells s_axi_to_SysClk100_req/ackD_V_0_reg[0]]
set_property ASYNC_REG true [get_cells s_axi_to_SysClk100_req/ackD_V_1_reg[0]]

set_property ASYNC_REG true [get_cells s_axi_to_SysClk100_ack/reqD_V_0_reg[0]]
set_property ASYNC_REG true [get_cells s_axi_to_SysClk100_ack/reqD_V_1_reg[0]]

set_false_path -through [get_nets -hier -filter {NAME =~ *CDC*}]

set_false_path -through [get_pins -filter {NAME =~ *SyncAsync*/oSyncStages_reg[*]/D} -hier]
set_false_path -through [get_pins -filter {NAME =~ *SyncAsync*/oSyncStages*/PRE || NAME =~ *SyncAsync*/oSyncStages*/CLR} -hier]