set hierarchy [file tail [file dirname [info script]]]
proc connect_${hierarchy} {hierarchy_name} {
    set clock [processor_model::make_clock 100]
    connect_bd_net [get_bd_pins ${hierarchy_name}/s_axi_aclk] [get_bd_pins ${clock}]

    set reset [processor_model::make_reset ${clock}]
    connect_bd_net [get_bd_pins ${hierarchy_name}/s_axi_aresetn] [get_bd_pins ${reset}]

    set axi_interfaces [list \
        ${hierarchy_name}/AXI_LITE_SAMPLE \
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