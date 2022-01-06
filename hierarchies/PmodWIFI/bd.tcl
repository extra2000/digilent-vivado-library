
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2021.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   common::send_gid_msg -ssname BD::TCL -id 2040 -severity "WARNING" "This script was generated using Vivado <$scripts_vivado_version> without IP versions in the create_bd_cell commands, but is now being run in <$current_vivado_version> of Vivado. There may have been major IP version changes between Vivado <$scripts_vivado_version> and <$current_vivado_version>, which could impact the parameter settings of the IPs."

}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# PmodWIFI_remap

# Please add the sources of those modules before sourcing this Tcl script.

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_gpio:*\
xilinx.com:ip:axi_quad_spi:*\
xilinx.com:ip:axi_timer:*\
digilentinc.com:ip:pmod_bridge:*\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
PmodWIFI_remap\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: PmodWIFI_0
proc create_hier_cell_PmodWIFI_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_PmodWIFI_0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv digilentinc.com:interface:pmod_rtl:1.0 Pmod_out

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_GPIO

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_GPIO_CS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_SPI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_TIMER


  # Create pins
  create_bd_pin -dir I -type clk ext_spi_clk
  create_bd_pin -dir O -type intr gpio_interrupt
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: PmodWIFI_remap_0, and set properties
  set block_name PmodWIFI_remap
  set block_cell_name PmodWIFI_remap_0
  if { [catch {set PmodWIFI_remap_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $PmodWIFI_remap_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: axi_gpio_bottom_row, and set properties
  set axi_gpio_bottom_row [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio axi_gpio_bottom_row ]
  set_property -dict [ list \
   CONFIG.C_GPIO_WIDTH {4} \
   CONFIG.C_INTERRUPT_PRESENT {1} \
 ] $axi_gpio_bottom_row

  # Create instance: axi_gpio_cs, and set properties
  set axi_gpio_cs [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio axi_gpio_cs ]
  set_property -dict [ list \
   CONFIG.C_GPIO_WIDTH {1} \
 ] $axi_gpio_cs

  # Create instance: axi_quad_spi_0, and set properties
  set axi_quad_spi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi axi_quad_spi_0 ]
  set_property -dict [ list \
   CONFIG.C_USE_STARTUP {0} \
   CONFIG.C_USE_STARTUP_INT {0} \
 ] $axi_quad_spi_0

  # Create instance: axi_timer_0, and set properties
  set axi_timer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer axi_timer_0 ]
  set_property -dict [ list \
   CONFIG.mode_64bit {1} \
 ] $axi_timer_0

  # Create instance: pmod_bridge_0, and set properties
  set pmod_bridge_0 [ create_bd_cell -type ip -vlnv digilentinc.com:ip:pmod_bridge pmod_bridge_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI_SPI] [get_bd_intf_pins axi_quad_spi_0/AXI_LITE]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_GPIO_CS] [get_bd_intf_pins axi_gpio_cs/S_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI_GPIO] [get_bd_intf_pins axi_gpio_bottom_row/S_AXI]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S_AXI_TIMER] [get_bd_intf_pins axi_timer_0/S_AXI]
  connect_bd_intf_net -intf_net PmodWIFI_remap_0_GPIO_OUT_TOP [get_bd_intf_pins PmodWIFI_remap_0/GPIO_OUT_TOP] [get_bd_intf_pins pmod_bridge_0/GPIO_Top_Row]
  connect_bd_intf_net -intf_net axi_gpio_1_GPIO [get_bd_intf_pins axi_gpio_bottom_row/GPIO] [get_bd_intf_pins pmod_bridge_0/GPIO_Bottom_Row]
  connect_bd_intf_net -intf_net axi_gpio_cs_GPIO [get_bd_intf_pins PmodWIFI_remap_0/GPIO_IN] [get_bd_intf_pins axi_gpio_cs/GPIO]
  connect_bd_intf_net -intf_net axi_quad_spi_0_SPI_0 [get_bd_intf_pins PmodWIFI_remap_0/SPI_IN] [get_bd_intf_pins axi_quad_spi_0/SPI_0]
  connect_bd_intf_net -intf_net pmod_bridge_0_Pmod_out [get_bd_intf_pins Pmod_out] [get_bd_intf_pins pmod_bridge_0/Pmod_out]

  # Create port connections
  connect_bd_net -net axi_gpio_bottom_row_ip2intc_irpt [get_bd_pins gpio_interrupt] [get_bd_pins axi_gpio_bottom_row/ip2intc_irpt]
  connect_bd_net -net ext_spi_clk_0_1 [get_bd_pins ext_spi_clk] [get_bd_pins axi_quad_spi_0/ext_spi_clk]
  connect_bd_net -net s_axi_aclk_0_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_gpio_cs/s_axi_aclk] [get_bd_pins axi_gpio_bottom_row/s_axi_aclk] [get_bd_pins axi_quad_spi_0/s_axi_aclk] [get_bd_pins axi_timer_0/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_0_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_gpio_cs/s_axi_aresetn] [get_bd_pins axi_gpio_bottom_row/s_axi_aresetn] [get_bd_pins axi_quad_spi_0/s_axi_aresetn] [get_bd_pins axi_timer_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}


proc available_tcl_procs { } {
   puts "##################################################################"
   puts "# Available Tcl procedures to recreate hierarchical blocks:"
   puts "#"
   puts "#    create_hier_cell_PmodWIFI_0 parentCell nameHier"
   puts "#"
   puts "##################################################################"
}

available_tcl_procs
