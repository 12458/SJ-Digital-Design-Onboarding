/*
* Module describing a single-bit full adder. 
* The full adder can be chained to create multi-bit adders. 
*/
module full_adder (
    input logic a,
    input logic b,
    input logic cin,

    output logic s,
    output logic cout
);

    assign {cout, s} = a + b + cin;
    
endmodule