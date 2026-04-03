`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2026 08:49:23 AM
// Design Name: 
// Module Name: trad_glitch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module trad_glitch(
    input clk1, clk2, sel,
    output clk_out
    );
 assign clk_out = (clk1 & (~sel))|(clk2 & sel);
endmodule
