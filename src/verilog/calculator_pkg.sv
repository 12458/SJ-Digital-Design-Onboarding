/*
 * This package defines common parameters used across various modules in the design to ensure consistency and ease of maintenance. 
 * It includes parameters for data width, memory word size, and address width (defined by size of SRAM).
 */
package calculator_pkg;
    //parameter for size of data
    parameter DATA_W = 32;

    //parameter for size of memory word
    parameter MEM_WORD_SIZE = 64;

    //number of address bits needed to access every line of SRAM. log_2 (512 lines)
    parameter ADDR_W = 9;

    typedef enum logic [2:0] {S_IDLE,S_READ,S_ADD,S_WRITE,S_END} state_t;
    //TODO: Add any typedefs, enums, or parameters as neccessary for your project

endpackage