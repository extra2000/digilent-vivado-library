# Hierarchy Testing

This folder contains some scripts intended to help build projects around the hierarchies, wiring them to a processor in block design and producing pre-built software projects.

The eventual goal of these scripts is to create a straightforward system that can be used to produce hardware projects and software examples for modular systems consisting of a variety of Pmods, Zmods, and other peripherals, through a simple set of TCL and XSCT commands.

At the time of writing, this can be used to produce an XSA that supports a single Pmod for each Pmod hierarchy and to create and build software projects for each Pmod hierarchy (excepting the WiFi, SD, and MTDS).
Build errors are known in the AMP2, DHB1, MAXSONAR, OLED, and ToF software projects.
Testing in hardware has been performed for a small subset of Pmods.

The hierarchies themselves are documented in the [hierarchies README](../hierarchies/README.md)

----
## Quickstart

1. Add your Vivado version to path.

1. Open a terminal (not TCL console) and cd into this directory:

    > `cd (...)/vivado-library/test_scripts`

1. Run the following command, which may take some time to complete:
    > `vivado -mode batch -source create_xsa.tcl -tclargs -block PmodAD1`

1. Once complete, observe that there is now a project named project_PmodAD1_0:
    > `ls ../../vivado-library-test-projects/project_PmodAD1_0/project_PmodAD1_0.xpr`

1. Observe that the XSA file has been produced:

    > `ls ./PmodAD1_design_1_wrapper_0.xsa`

1. Open Vitis, choosing the (...)/vivado-library/test_scripts/ws directory as the workspace.

1. Open the XSCT console via the Xilinx -> XSCT Console menu option. Then change the working directory to this directory via the following command:

    > `cd [getws]/..`

1. Run the following command, which may take some time to complete:
    > `set argv PmodAD1; source create_sw.xsct.tcl`

1. Observe that the `PmodAD1_basic_example_system`, `PmodAD1_basic_example_app`, and `PmodAD1_design_1_wrapper_0` projects have been created.

1. At this point, the system project can be launched in hardware via the Assistant pane (note that the Pmod connects to the port listed alphabetically, typically JA)

----
## Usage

`create_xsa.tcl` is intended to be run in the Vivado TCL console or in a terminal of your choice, and accepts several arguments through an `argv` list.
It creates a project in a proj directory adjacent to the script, creates a block design with a processor, adds the hierarchy to the design, connects it to the processor and external ports, and builds the project.
Once complete, it exports an XSA file to the working directory.

* Arguments:
  * `-block`: Set this flag to block further execution of the TCL process until a bitstream has been generated and an XSA exported. An XSA is only exported if this is specified. If not specified, the command that can be used to export is printed after runs are started
  * `-board (board)`: Specifies the FPGA development board to target. 
  * `-jobs (num)`: Specifies the number of jobs to use while building the project. see 'help launch_runs' for more info
  * `-handoff-dir (path)`: Sets the directory the xsa is to be exported into. The default is `test_scripts/handoff`
  * `-proj-dir (path)`: Sets the directory the temporary project will be created in, the default is `test_scripts/../../vivado-library-test-projects`
  * `(hierarchy)`: The final argument of the list, this is the name of the hierarchy that will be included
* Invocation (TCL): `set argv "-block -jobs 12 PmodAD1"; source test.tcl`
* Invocation (Bash/other): `vivado -mode batch -source create_xsa.tcl -tclargs -block -jobs 12 PmodAD1`
  * Note: The bin folder in the installation location of the version of Vivado you want to use should be on the PATH, for example: D:/Xilinx/Vivado/2021.1/bin

It should be noted that create_xsa.tcl does not clean up the project that it creates, which can be found in the proj directory.

----

`create_sw.xsct.tcl` is intended to be run in the Vitis XSCT console and accepts several arguments through an `argv` list.

Note, it is recommended to not create your workspace within the vivado-library repo, since Vivado scans all directories within it when refreshing the IP repo.

The script creates a hardware platform, then creates a system project and application project for each of the example software projects for the specified hierarchy. Additional configuration of the application project is performed to support any additional stuff the example needs (math library for example). Each of the projects are built.

* Arguments:
  * `-xsa (xsa path)`: Specifies the path to the XSA file that the hardware platform should be created from. By default, the highest-numbered XSA file that matches the pattern `(hierarchy)_design_1_wrapper_*` found the handoff_dir directory is used.
  * `-handoff-dir`: Specifies a path to a directory containing a set of xsa files from multiple hardware builds, from which one matching the pattern `(hierarchy)_design_1_wrapper_*` is chosen. Ignored if -xsa is used. Defaults to a `handoff` directory in the same folder as the script.
  * `(hierarchy)`: The final argument of the list, this is the name of the hierarchy that will be included.

Some Pmods may provide multiple software examples, in which case a system and application for each of them is created, sharing a single hardware platform.

*Note:* The naming convention `*.xsct.tcl` is used to denote which scripts should only be run in the XSCT console.

----

Several additional scripts, `create_all_sw.xsct.tcl` and `create_all_xsa.sh` are provided as examples of how these scripts can be used to build multiple hierarchies at once.

----
## Structure

create_xsa.tcl depends on several other scripts, as follows:

`(family)_model.tcl`: located in this directory, these scripts define a `processor_model` namespace that is an abstraction layer for different FPGA architectures. Currently only zynq_model.tcl is implemented, but it is expected that ultrascale and microblaze models be added, along with an argument in create_xsa to switch between them. These scripts should rely on board files as much as possible to make them as portable as possible across boards that share an architecture.

`(hierarchy)/connect_hier.tcl`: found in each of the hierarchy directories, these scripts create a connect_(hierarchy) proc that is responsible for calling processor_model procs to obtain interfaces and then to wire these interfaces to the hierarchy's ports. Necessary specifications for the interfaces are passed to the model through process arguments, for example, processor_model::make_clock requires a frequency argument.

----

create_sw.xsct depends on several other scripts as follows:

`(hierarchy)/sw/examples/(example)/demo_app.xsct.tcl`: found in each of teh hierarchy directories, these scripts are responsible for creating and configuring the example software applications (and systems, implicitly). One folder per example is provided, which means that some hierarchies may have several example folders and multiple demo_app scripts.

It should be noted that, at time of writing, sources are copied into the project rather than linked, due to some errors encountered with relative-path inclusions.

----
## Todo / Potential Improvements
* Add a post-bitstream script to perform the hw export when -block is not specified. As a starting point:
  * `add_files -fileset utils_1 -norecurse ${path}`
  * `set_property STEPS.WRITE_BITSTREAM.TCL.POST [ get_files ${path} -of [get_fileset utils_1] ] [get_runs impl_1]`
* Add a dedicated path to hold XSA files and change the default xsct -xsa argument and tcl export path to match
* Create a zynq_model equivalent for software
* Support selection of different ports (Pmods are connected to the first pmod port found in the board files, sorted alphabetically)
* Improve create_all_sw to continue when a project fails to build or be added
* Automatically detect the list of supported hierarchies in create_all_xsa
* Add additional processor models
* Add cleanup scripts (delete all under proj)
* Support XSCT in the command-line?
* Support Zmods

Longer term:
* Explore a makefile-based flow.
* Explore Xilinx software repo scripts for creating template applications and automatically detecting XPAR macros.