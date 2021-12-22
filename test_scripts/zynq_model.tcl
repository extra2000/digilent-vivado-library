namespace eval processor_model {
	proc make_processor {} {
		puts "making processor"

		create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
		apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]
	}

	proc make_clock {frequency} {
		puts "making clock"

		for {set i 0} {$i < 4} {incr i} {
			set ps_clock_enabled [get_property CONFIG.PCW_EN_CLK${i}_PORT [get_bd_cells processing_system7_0]]
			set ps_clock_frequency [get_property CONFIG.PCW_FPGA${i}_PERIPHERAL_FREQMHZ [get_bd_cells processing_system7_0]]
			if {$ps_clock_enabled && $ps_clock_frequency == $frequency} {
				return processing_system7_0/FCLK_CLK${i}
			}
			if {!$ps_clock_enabled} {
				set_property CONFIG.PCW_EN_CLK${i}_PORT {1} [get_bd_cells processing_system7_0]
				set_property CONFIG.PCW_FPGA${i}_PERIPHERAL_FREQMHZ ${frequency} [get_bd_cells processing_system7_0]
				return processing_system7_0/FCLK_CLK${i}
			}
		}
		# todo throw error; no available fclk pins were found
	}

	proc make_interrupts {num_interrupts} {
		# enable irq_f2p
		set_property CONFIG.PCW_USE_FABRIC_INTERRUPT {1} [get_bd_cells processing_system7_0]
		set_property CONFIG.PCW_IRQ_F2P_INTR {1} [get_bd_cells processing_system7_0]
		# create concat
		set concat "xlconcat_irq_f2p"
		create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 ${concat}
		set_property CONFIG.NUM_PORTS ${num_interrupts} [get_bd_cells ${concat}]
		connect_bd_net [get_bd_pins ${concat}/dout] [get_bd_pins processing_system7_0/IRQ_F2P]
		# return the list of concat input pins
		return [get_bd_pins /${concat}/In*]
	}

	proc make_reset {sync_clock} {
		puts "making reset"

		set sysreset "proc_sys_reset_0"
		puts ${sysreset}
		create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 ${sysreset}
		connect_bd_net [get_bd_pins ${sync_clock}] [get_bd_pins ${sysreset}/slowest_sync_clk]
		connect_bd_net [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins ${sysreset}/ext_reset_in]
		return ${sysreset}/peripheral_aresetn
	}

	proc make_interconnect {num_interfaces clock_source reset_source} {
		# set clock [make_clock 50]
		# set reset [make_reset $clock]
		# make_interconnect [list PmodAD1_0/AXI_LITE_SAMPLE] $clock $reset
		puts "making interconnect"
		set interconnect "axi_interconnect_0"

		create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ${interconnect}
		set_property CONFIG.NUM_SI {1} [get_bd_cells ${interconnect}]
		set_property CONFIG.NUM_MI ${num_interfaces} [get_bd_cells ${interconnect}]

		connect_bd_net [get_bd_pins ${clock_source}] [get_bd_pins ${interconnect}/ACLK]
		connect_bd_net [get_bd_pins ${clock_source}] [get_bd_pins ${interconnect}/S00_ACLK]
		connect_bd_net [get_bd_pins ${reset_source}] [get_bd_pins ${interconnect}/ARESETN]
		connect_bd_net [get_bd_pins ${reset_source}] [get_bd_pins ${interconnect}/S00_ARESETN]

		connect_bd_net [get_bd_pins ${clock_source}] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK]
		connect_bd_intf_net -boundary_type upper [get_bd_intf_pins ${interconnect}/S00_AXI] [get_bd_intf_pins processing_system7_0/M_AXI_GP0]

		set master_interfaces [list]
		for {set i 0} {$i < $num_interfaces} {incr i} {
			set label M0${i}
			connect_bd_net [get_bd_pins ${clock_source}] [get_bd_pins ${interconnect}/${label}_ACLK]
			connect_bd_net [get_bd_pins ${reset_source}] [get_bd_pins ${interconnect}/${label}_ARESETN]
			lappend master_interfaces ${interconnect}/${label}_AXI
		}
		return $master_interfaces
	}

	proc make_pmod_port {} {
		puts "making pmod port"

		set if_vlnv "digilentinc.com:interface:pmod_rtl:1.0"
		# todo: find an unused pmod port instead of picking the first one
		set pmod [lindex [get_board_component_interfaces -filter "VLNV==${if_vlnv}"] 0]
		create_bd_intf_port -mode Master -vlnv ${if_vlnv} ${pmod}
		return ${pmod}
	}
}