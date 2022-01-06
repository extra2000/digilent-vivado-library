# capture an xsa file previously created, 

# This script will create an application named after the script directory
# based on the C "Empty Application" template and for a specific processor
# It imports all source files from the src subdirectory as LINKS.
# BUG 2020.1: linker script imported as link won't build, import by setting
# linker-script app config as a workaround.
# It also sets some C/C++ build settings
# Workspace should be set externally

# xsct console: set argv PmodNAV; source create_sw.xsct.tcl
# bash: 

# set up some paths to relevant directories
set script [info script] 
set script_dir [file normalize [file dirname $script]]
set repo_dir [file dirname $script_dir]
set ws [getws]

# check argv
if {[llength $argv] == 0} {
    puts "Warning: argv should contain a hierarchy name"
}

# helper function; returns the last element of the list passed to it
proc llast {my_list} {
    return [lindex $my_list [expr [llength $my_list] - 1]]
}

# the final argument is the name of the hierarchy to test, which must match a folder in the repo's hierarchies directory
set hierarchy [llast $argv]

# capture the xsa file path, optionally provided with the -xsa flag, default to the highest-numbered xsa matching this pattern: (repo)/test_scripts/handoff/(hierarchy)_design_1_wrapper_*.xsa
set xsa_index [lsearch -exact $argv "-xsa"]
if {$xsa_index eq -1} {
    set xsa_list [glob [file join ${script_dir} handoff ${hierarchy}_design_1_wrapper_*.xsa]]
    set xsa_list [lsort $xsa_list]
	set xsa_file [llast $xsa_list]
} else {
	set xsa_file [lindex $argv [expr $xsa_index + 1]]
}

# define some settings specific to the processor. todo: move this into zynq_model.tcl
set proc "ps7_cortexa9_0"
set os "standalone"
set arch "32-bit"

puts "INFO: Running $script $argv"

# create the platform and domain using the chosen XSA file
set platform_name [file tail [file rootname ${xsa_file}]]
platform create -name ${platform_name} -hw ${xsa_file}
platform active ${platform_name}
# set domain_name ${processor_model::os}_${processor_model::proc}
set domain_name ${os}_${proc}
# set os ${processor_model::os}
# set proc ${processor_model::proc}
# set arch ${processor_model::arch}
domain create -name ${domain_name} -os ${os} -proc ${proc} -arch ${arch}

set hierarchy_dir [file join ${repo_dir} hierarchies ${hierarchy}]
set examples [glob [file join ${hierarchy_dir} sw examples *]]
foreach example_dir $examples {
    # source the demo_app script to get a create_app process which will create, configure, and populate the application project for the example
    source [file join ${example_dir} demo_app.xsct.tcl]
    set example [file tail ${example_dir}]
    
    # create the application
    set app_name ${hierarchy}_${example}_app
    set sysproj_name ${hierarchy}_${example}_system
    ${hierarchy}_${example}::create_app ${app_name} ${sysproj_name} ${domain_name} ${platform_name}

    app build -name ${app_name}
}

