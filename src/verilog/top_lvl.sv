/* 
 * This top_level module integrates the controller, memory, adder, and result buffer to form a complete calculator system.
 * It handles memory reads/writes, arithmetic operations, and result buffering.
 */
module top_lvl import calculator_pkg::*; (
    input  logic                 clk,
    input  logic                 rst,

    // Memory Config
    input  logic [ADDR_W-1:0]    read_start_addr,
    input  logic [ADDR_W-1:0]    read_end_addr,
    input  logic [ADDR_W-1:0]    write_start_addr,
    input  logic [ADDR_W-1:0]    write_end_addr
    
);

    //Any wires, combinational assigns, etc should go at the top for visibility
   
    //TODO: Finish instantiation of your controller module
	controller u_ctrl ();

    //TODO: Look at the sky130_sram_2kbyte_1rw1r_32x512_8 module and instantiate it using variables defined above.
    // Note: This module has two ports, port 0 for read and write and port 1 for read only. We are using port 0 writing and port 1 for reading in this design.    
    // we have provided all of the input ports of SRAM_A, which you will need to connect to calculator ports inside the parentheses. 
    // Your instantiation for SRAM_A will be similar to SRAM_B. 
  	/*
     * .clk0 : sram macro clock input. Connect to same clock as controller.sv. 
     * .csb0 : chip select, active low. Set low when you want to write. Refer to sky130_sram instantiation to see what value to use for both read and write operations in port 0.
     * .web0 : write enable, active low. Set low when you want to write.  Refer to sky130_sram instantiation to see what value to use for both read and write operations in port 0.
     * .wmask0 : write mask, used to select which bits to write. For this design, we will write all bits, so use 4'hF.
     * .addr0 : address to read/write
     * .din0 : data to write
     * .dout0 : data output from memory when performing a read. Will leave blank here because we are only writing to port 0. 
     * .clk1  : sram macro clock input for port 2. Connect to same clock as controller.sv. 
     * .csb1  : chip select, active low. Set low when you want to read. Since this second port can only be used to read, there is no write enable bit (web) 
     * .addr1 : address to read from. You will supply this value. 
     * .dout1 : data output from the SRAM macro port.
     */
  	
      sky130_sram_2kbyte_1rw1r_32x512_8 sram_A (
        .clk0   (),  
        .csb0   (),
        .web0   (), 
        .wmask0 (), 
        .addr0  (), 
        .din0   (),
        .dout0  (), 
        .clk1   (), 
        .csb1   (), 
        .addr1  (), 
        .dout1  () 
    );

  
    //TODO: Instantiate the second SRAM for the upper half of the memory.
    sky130_sram_2kbyte_1rw1r_32x512_8 sram_B ();
  	
  	//TODO: Finish instantiation of your adder module
    adder32 u_adder (

    );
 
    //TODO: Finish instantiation of your result buffer
    result_buffer u_resbuf (
      
    );

endmodule
