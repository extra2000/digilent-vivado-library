# tcl console: set argv "PmodAD1"; source test.tcl
# bash: vivado -mode batch -source make_xsa.tcl -tclargs -block -jobs 12 PmodAD1
# bash: vivado -mode batch -source ../test_scripts/make_xsa.tcl -tclargs -block -jobs 12 PmodAD1

puts "INFO: Running [info script]"

# get paths to this script and the repo, where all files used and written will be found and placed in
set script_dir [file dirname [file normalize [info script]]]
set repo_dir [file dirname $script_dir]

# when the -block flag is specified, after starting generating a bitstream, block continued execution of the process until it is done
set block_flag [expr [lsearch -exact $argv "-block"] ne -1]

# set the board file with the argument following the -board flag
# the argument is passed to get_board_parts to capture a board file
# matching patterns can be used as in "*:zybo-z7-10:*"
set board_index [lsearch -exact $argv "-board"]
if {$board_index eq -1} {
	set board [get_board_parts "*:zybo-z7-10:*"]
} else {
	incr board_index
	set board [get_board_parts [lindex $argv $board_index]]
}

# check for a jobs flag, which sets the number of jobs used to build the project, the default is defined in launch_runs
set jobs_idx [lsearch -exact $argv "-jobs"]
if {$jobs_idx eq -1} {
	set jobs ""
} else {
	set jobs [lindex $argv [expr $jobs_idx + 1]]
}

# check for a handoff-dir flag, which sets the directory the xsa is to be exported into, the default is test_scripts/handoff
set handoff_dir_idx [lsearch -exact $argv "-handoff-dir"]
if {$handoff_dir_idx eq -1} {
	set handoff_dir [file join $script_dir handoff]
} else {
	set handoff_dir [file normalize [lindex $argv [expr $handoff_dir_idx + 1]]]
}

# the final argument is the name of the hierarchy to test, which must match a folder in the repo's hierarchies directory
set hierarchy_to_test [lindex $argv [expr [llength $argv] - 1]]

# end argument processing, argv is not used past this point

# choose an unused project name (note that `close_project -delete` can be used to clean up existing projects)
set project_name "project_${hierarchy_to_test}"
set project_dir [file join $script_dir "proj"]
set idx 0
while {[file exists [file join $project_dir ${project_name}_${idx}]]} {incr idx}
set project_name ${project_name}_${idx}

# create a project
set part [get_property PART_NAME $board]
set project_path [file join $project_dir $project_name]
create_project $project_name $project_path -part $part
set_property board_part $board [current_project]
puts "INFO: Created project ${project_path}"

# create the bd
create_bd_design "design_1"
update_compile_order -fileset sources_1

# add vivado-library IPs and interfaces
set_property ip_repo_paths $repo_dir [current_project]
update_ip_catalog

# add the processor model procs and add the base processor to the design
source [file join $script_dir "zynq_model.tcl"]
processor_model::make_processor

# add the hierarchy to the design and connect it to the processor
set hierarchy_path [file join ${repo_dir} hierarchies ${hierarchy_to_test}]
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
if {$jobs ne ""} {
	launch_runs impl_1 -to_step write_bitstream -jobs ${jobs}
} else {
	launch_runs impl_1 -to_step write_bitstream
}

# pick an xsa name
set idx 0
set done 0
while {${done} == 0} {
	set xsa_file [file join ${handoff_dir} ${hierarchy_to_test}_${wrapper_module}_${idx}.xsa]
	incr idx
	if {[file exists ${xsa_file}] == 0} {
		set done 1
	}
}

# only block if not using the gui
if {$block_flag} {
	wait_on_run impl_1
	# export finished xsa to the current working directory
	write_hw_platform -fixed -include_bit -force -file ${xsa_file}
} else {
	puts "WARNING: since this script was run without the -block flag set, user is responsible for exporting hardware"
	puts "    the following command can be used to run it:"
	puts "    write_hw_platform -fixed -include_bit -file ${xsa_file}"
}