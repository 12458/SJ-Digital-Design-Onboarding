/*
* Module describing a 32-bit ripple carry adder, with no carry output or input
*/
module adder32 import calculator_pkg::*; (
    input logic [DATA_W - 1 : 0] a_i,
    input logic [DATA_W - 1 : 0] b_i,
    output logic [DATA_W - 1 : 0] sum_o
);

    // Internal carry chain: carry[0] is the initial carry-in (0),
    // carry[DATA_W] is the final carry-out (discarded)
    logic [DATA_W:0] carry;
    assign carry[0] = 1'b0;

    genvar i;
    generate
        for (i = 0; i < DATA_W; i++) begin : gen_rca
            full_adder fa_i (
                .a   (a_i[i]),
                .b   (b_i[i]),
                .cin (carry[i]),
                .s   (sum_o[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate
endmodule