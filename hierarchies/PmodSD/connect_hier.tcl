set hierarchy [file tail [file dirname [info script]]]
proc connect_${hierarchy} {hierarchy_name} {
    # # Create interface pins
    # create_bd_intf_pin -mode Master -vlnv digilentinc.com:interface:pmod_rtl:1.0 Pmod_out
    # create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_GPIO
    # create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_SPI
    # # Create pins
    # create_bd_pin -dir I -type clk ext_spi_clk
    # create_bd_pin -dir I -type clk s_axi_aclk
    # create_bd_pin -dir I -type rst s_axi_aresetn

    set clock [processor_model::make_clock 50]
    connect_bd_net [get_bd_pins ${hierarchy_name}/ext_spi_clk] [get_bd_pins ${clock}]
    connect_bd_net [get_bd_pins ${hierarchy_name}/s_axi_aclk] [get_bd_pins ${clock}]

    set reset [processor_model::make_reset ${clock}]
    connect_bd_net [get_bd_pins ${hierarchy_name}/s_axi_aresetn] [get_bd_pins ${reset}]

    set axi_interfaces [list \
        ${hierarchy_name}/S_AXI_GPIO \
        ${hierarchy_name}/S_AXI_SPI \
    ]
    set master_interfaces [processor_model::make_interconnect [llength ${axi_interfaces}] ${clock} ${reset}]
    foreach master_interface $master_interfaces axi_interface $axi_interfaces {
        connect_bd_intf_net -boundary_type upper [get_bd_intf_pins ${master_interface}] [get_bd_intf_pins ${axi_interface}]
    }

    set pmod_port [processor_model::make_pmod_port]
    set bridge_ip ${hierarchy_name}/pmod_bridge_0
    set_property CONFIG.PMOD ${pmod_port} [get_bd_cells -quiet ${bridge_ip}]
    connect_bd_intf_net [get_bd_intf_pins ${bridge_ip}/Pmod_out] [get_bd_intf_pins ${pmod_port}]
    
    save_bd_design
}