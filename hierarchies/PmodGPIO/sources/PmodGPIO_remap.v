`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent
// Engineer: Arthur Brown
// 
// Create Date: 09/17/2019 02:57:58 PM
// Design Name: PmodGPIO Hierarchical Block
// Module Name: PmodGPIO_remap
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module PmodGPIO_remap (
    // GPIO Slave interface, to be connected to AXI GPIO
    (* X_INTERFACE_INFO = "xilinx.com:interface:gpio:1.0 GPIO_IN TRI_T" *)
    (* X_INTERFACE_PARAMETER = "MODE Slave" *) 
    input [7:0] gpio_in_tri_t, // Tristate output signal (optional)
    (* X_INTERFACE_INFO = "xilinx.com:interface:gpio:1.0 GPIO_IN TRI_O" *)
    input [7:0] gpio_in_tri_o, // Tristate output signal (optional)
    (* X_INTERFACE_INFO = "xilinx.com:interface:gpio:1.0 GPIO_IN TRI_I" *)
    output [7:0] gpio_in_tri_i, // Tristate output signal (optional)
    
    // GPIO Master interface, to be connected to Pmod Bridge Top Row
    (* X_INTERFACE_INFO = "xilinx.com:interface:gpio:1.0 GPIO_OUT_TOP TRI_T" *)
    output [3:0] gpio_out_top_tri_t, // Tristate output enable signal (optional)
    (* X_INTERFACE_INFO = "xilinx.com:interface:gpio:1.0 GPIO_OUT_TOP TRI_O" *)
    output [3:0] gpio_out_top_tri_o, // Tristate output signal (optional)
    (* X_INTERFACE_INFO = "xilinx.com:interface:gpio:1.0 GPIO_OUT_TOP TRI_I" *)
    input [3:0] gpio_out_top_tri_i, // Tristate input signal (optional)
    
    // GPIO Master interface, to be connected to Pmod Bridge Bottom Row
    (* X_INTERFACE_INFO = "xilinx.com:interface:gpio:1.0 GPIO_OUT_BOTTOM TRI_T" *)
    output [3:0] gpio_out_bottom_tri_t, // Tristate output enable signal (optional)
    (* X_INTERFACE_INFO = "xilinx.com:interface:gpio:1.0 GPIO_OUT_BOTTOM TRI_O" *)
    output [3:0] gpio_out_bottom_tri_o, // Tristate output signal (optional)
    (* X_INTERFACE_INFO = "xilinx.com:interface:gpio:1.0 GPIO_OUT_BOTTOM TRI_I" *)
    input [3:0] gpio_out_bottom_tri_i // Tristate input signal (optional)
);
    assign {gpio_out_bottom_tri_t, gpio_out_top_tri_t} = gpio_in_tri_t;
    assign {gpio_out_bottom_tri_o, gpio_out_top_tri_o} = gpio_in_tri_o;
    assign gpio_in_tri_i = {gpio_out_bottom_tri_i, gpio_out_top_tri_i};
endmodule