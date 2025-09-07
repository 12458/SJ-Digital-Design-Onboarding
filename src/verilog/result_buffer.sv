/*
* Module describing a 64-bit result buffer and the mux for controlling where
* in the buffer an adder's result is placed.
* 
* synchronous active high reset on posedge clk
*/
module result_buffer import calculator_pkg::*; (
    input logic clk_i,                              //clock signal
    input logic rst_i,                              //reset signal

    input logic [DATA_W-1 : 0] result_i,       //result from ALU
    input logic loc_sel,                            //mux control signal
    output logic [MEM_WORD_SIZE-1 : 0] buffer_o   //64-bit output of buffer
);

    //declare 64-bit buffer
    logic [MEM_WORD_SIZE-1 : 0] internal_buffer;

    //TODO: Write a sequential block to write the next values into the buffer.
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            internal_buffer <= '0;
        end else begin
            //Place result_i into buffer based on loc_sel
            case (loc_sel)
                1'b0: internal_buffer[31:0] <= result_i;
                1'b1: internal_buffer[63:32] <= result_i;
            endcase
        end
    end

endmodule