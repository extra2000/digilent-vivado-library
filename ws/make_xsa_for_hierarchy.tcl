# tcl console: set argv "PmodAD1"; source test.tcl
# when the -block flag is specified, after starting generating a bitstream, block continued execution of the process until it is done
set block_flag [expr [lsearch -exact $argv "-block"] ne -1]
# set the board file with the argument following the -board flag. the argument is passed to get_board_parts, so matching patterns can be used as in "*:zybo-z7-10:*"
set board_index [lsearch -exact $argv "-board"]
if {$board_index eq -1} {
	set board [get_board_parts "*:zybo-z7-10:*"]
} else {
	incr board_index
	set board [get_board_parts [lindex $argv $board_index]]
}

set script_dir [file dirname [info script]]
set repo_dir [file dirname $script_dir]
# choose an unused project name (note that `close_project -delete` can be used to clean up existing projects)
set project_name "project"
set idx 0
while {[file exists [file join $script_dir ${project_name}_${idx}]]} {incr idx}
set project_name ${project_name}_${idx}
set project_dir [file join $script_dir ${project_name}]


set part [get_property PART_NAME $board]
set hierarchy_to_test [lindex $argv [expr [llength $argv] - 1]]

# create project with a block design
create_project $project_name [file join $project_dir $project_name] -part $part
set_property board_part $board [current_project]
create_bd_design "design_1"
update_compile_order -fileset sources_1
# add vivado-library IPs and interfaces
set_property  ip_repo_paths $repo_dir [current_project]
update_ip_catalog
# add the processor model procs and add the base processor to the design
source [file join $script_dir "zynq_model.tcl"]
hier_bd_model::make_processor
# add the hierarchy to the design and connect it to the processor
set hierarchy_path [file join ${repo_dir}/hierarchies/${hierarchy_to_test}]
source [file join ${hierarchy_path} create_hier.tcl]
source [file join ${hierarchy_path} connect_hier.tcl]
connect_${hierarchy_to_test} ${hierarchy_to_test}_0
# validate and create a wrapper
assign_bd_address
validate_bd_design
set wrapper [make_wrapper -files [get_files design_1.bd] -top]
add_files -norecurse ${wrapper}
set wrapper_module [file rootname [file tail $wrapper]]
set_property top ${wrapper_module} [current_fileset]
# launch build
launch_runs impl_1 -to_step write_bitstream -jobs 12
# only block if not using the gui
if {$block_flag} {
	wait_on_run impl_1
}
# export finished xsa to the current working directory
set idx 0
${hierarchy_to_test}_design_1_wrapper.xsa
while {[file exists ${hierarchy_to_test}_${wrapper_module}_${idx}.xsa]} {incr idx}
write_hw_platform -fixed -include_bit -force -file ${hierarchy_to_test}_${wrapper_module}_${idx}.xsa