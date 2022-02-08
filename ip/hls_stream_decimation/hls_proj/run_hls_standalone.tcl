# ------------------------------------------------------------------------------
# Vitis HLS Project Information
# ------------------------------------------------------------------------------
set PROJ_DIR "."
set SOURCE_DIR "./src"
set PROJ_NAME "ws"
set PROJ_TOP "StreamDecimate"
set SOLUTION_NAME "sol1"
set SOLUTION_PART "xc7z020-clg400-1"
set SOLUTION_CLKP 8.00
# MAJOR.MINOR.REVISION
set VERSION "1.0.0"
set DISPLAY_NAME "AXI4-Stream Decimator"
set DESCRIPTION "Configurable decimation for AXI4-Stream"
set VENDOR "digilentinc.com"

# ------------------------------------------------------------------------------
# Create Project
# ------------------------------------------------------------------------------
open_project -reset $PROJ_NAME

# ------------------------------------------------------------------------------
# Add C++ source and Testbench files
# ------------------------------------------------------------------------------
add_files "${SOURCE_DIR}/StreamDecimate.cpp" 
add_files -tb "${SOURCE_DIR}/StreamDecimateTest.cpp"

# ------------------------------------------------------------------------------
# Create Project and Solution
# ------------------------------------------------------------------------------
set_top $PROJ_TOP
open_solution -reset $SOLUTION_NAME
set_part $SOLUTION_PART
create_clock -period $SOLUTION_CLKP

# ------------------------------------------------------------------------------
# Run Vitis HLS Stages
# ------------------------------------------------------------------------------
csynth_design
# cosim_design -wave_debug -trace_level all
export_design -rtl verilog -format ip_catalog -version $VERSION -description $DESCRIPTION -vendor $VENDOR -display_name $DISPLAY_NAME -output "./ws/${PROJ_TOP}.zip"

# -----------------------------------------------------------------------------
# Open project in GUI
# -----------------------------------------------------------------------------
vitis_hls -p $PROJ_NAME