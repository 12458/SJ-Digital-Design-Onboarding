module controller import calculator_pkg::*;(
  	input  logic              clk_i,
    input  logic              rst_i,
  
  	// Memory Access
    input  logic [ADDR_W-1:0] read_start_addr,
    input  logic [ADDR_W-1:0] read_end_addr,
    input  logic [ADDR_W-1:0] write_start_addr,
    input  logic [ADDR_W-1:0] write_end_addr,
  
  	// Control
    output logic write,
    output logic [ADDR_W-1:0] w_addr,
    output logic [MEM_WORD_SIZE-1:0] w_data,

    output logic read,
    output logic [ADDR_W-1:0] r_addr,
    input  logic [MEM_WORD_SIZE-1:0] r_data,

  	// Buffer Control (1 = upper, 0, = lower)
    output logic              buffer_control,
  
  	// These go into adder
  	output logic [DATA_W-1:0]       op_a,
    output logic [DATA_W-1:0]       op_b,
  
    input  logic [MEM_WORD_SIZE-1:0]       buff_result
  
); 
	//TODO: Write your controller state machine as you see fit. 
	//HINT: See "6.2 Two Always BLock FSM coding style" from refmaterials/1_fsm_in_systemVerilog.pdf
	// This serves as a good starting point, but you might find it more intuitive to add more than two always blocks.

	//See calculator_pkg.sv for state_t enum definition
  	state_t state, next;

	logic [ADDR_W-1:0] rd_ptr, wr_ptr;
	logic [DATA_W-1:0] a_reg, b_reg;
	logic              have_a;            // 0 = next READ fills a_reg, 1 = next READ fills b_reg
	logic [MEM_WORD_SIZE-1:0] result_buf; // [31:0] lower, [63:32] upper

	logic done_writes;

	//State reg, other registers as needed
	always_ff @(posedge clk_i) begin
		if (rst_i) begin
			state <= S_IDLE;
			rd_ptr          <= '0;
            wr_ptr          <= '0;

            a_reg           <= '0;
            b_reg           <= '0;
            have_a          <= 1'b0;

            result_buf      <= '0;
            buffer_control  <= 1'b0; // start filling lower half first
		end
		else begin
			state <= next;
			// Address pointers and datapath actions by state
            case (state)
                // -------------------------------------------------------------
                // IDLE: one-cycle settle; initialize pointers
                // -------------------------------------------------------------
                S_IDLE: begin
                    rd_ptr         <= read_start_addr;
                    wr_ptr         <= write_start_addr;
                    have_a         <= 1'b0;
                    buffer_control <= 1'b0;    // fill lower half first
                    result_buf     <= '0;
                end

                // -------------------------------------------------------------
                // READ: issue read at rd_ptr, latch into a_reg then b_reg
                // (assume r_data is valid by the time we leave READ->ADD)
                // -------------------------------------------------------------
                S_READ: begin
                    // capture into a_reg, then b_reg on alternating READs
                    if (!have_a) begin
                        a_reg  <= r_data[31:0];     // take lower 32 of word
                        have_a <= 1'b1;
                        // advance after each READ
                        if (rd_ptr != read_end_addr) rd_ptr <= rd_ptr + 1'b1;
                    end
                    else begin
                        b_reg  <= r_data[31:0];
                        have_a <= 1'b0; // consumed pair
                        if (rd_ptr != read_end_addr) rd_ptr <= rd_ptr + 1'b1;
                    end
                end

                // -------------------------------------------------------------
                // ADD: external adder uses op_a/op_b; latch 32-bit sum into
                // result_buf lower or upper half depending on buffer_control
                // -------------------------------------------------------------
                S_ADD: begin
                    if (buffer_control == 1'b0) begin
                        // write lower half
                        result_buf[31:0] <= buff_result[31:0];
                        buffer_control   <= 1'b1; // next will be upper
                    end
                    else begin
                        // write upper half
                        result_buf[63:32] <= buff_result[31:0];
                        buffer_control    <= 1'b0; // buffer full; next goes to lower after WRITE
                    end
                end

                // -------------------------------------------------------------
                // WRITE: push result_buf to memory at wr_ptr, then advance
                // -------------------------------------------------------------
                S_WRITE: begin
                    if (!done_writes) begin
                        if (wr_ptr != write_end_addr)
                            wr_ptr <= wr_ptr + 1'b1;
                        // else wr_ptr stays; END will be next
                    end
                end

                // END: hold
                default: /* S_END */ begin
                    // no sequential updates
                end
            endcase
		end
	end
	
	//Next state logic, outputs
	always_comb begin
        // Defaults
        next         = state;

        // Memory interface defaults
        read         = 1'b0;
        r_addr       = rd_ptr;

        write        = 1'b0;
        w_addr       = wr_ptr;
        w_data       = result_buf;

        // Adder operands driven from regs
        op_a         = a_reg;
        op_b         = b_reg;

        // Completion condition: finished all writes
        // (we reach END right after writing write_end_addr)
        done_writes  = (wr_ptr == write_end_addr);

        unique case (state)
            // -------------------------------------------------------------
            // IDLE: leave after 1 cycle to READ
            // -------------------------------------------------------------
            S_IDLE: begin
                next = S_READ;
            end

            // -------------------------------------------------------------
            // READ: assert read; always exit to ADD next cycle
            // -------------------------------------------------------------
            S_READ: begin
                read   = 1'b1;
                r_addr = rd_ptr;
                next   = S_ADD; // per spec: READ always exits to ADD
            end

            // -------------------------------------------------------------
            // ADD: place operands to adder (op_a/op_b already from regs)
            // If we just filled lower half → go READ (to compute another sum)
            // If we just filled upper half (buffer full) → go WRITE
            // -------------------------------------------------------------
            S_ADD: begin
                if (buffer_control == 1'b1) begin
                    // we just filled lower half in seq block (buffer_control flipped to 1)
                    // Next: READ to produce the second result for the upper half
                    next = S_READ;
                end
                else begin
                    // we just filled upper half in seq block (buffer is full now)
                    next = S_WRITE;
                end
            end

            // -------------------------------------------------------------
            // WRITE: perform one 64-bit write then either READ (more work)
            // or END (done)
            // -------------------------------------------------------------
            S_WRITE: begin
                write  = 1'b1;
                w_addr = wr_ptr;
                w_data = result_buf;

                if (done_writes) begin
                    next = S_END;
                end
                else begin
                    next = S_READ;
                end
            end

            // -------------------------------------------------------------
            // END: wait for reset
            // -------------------------------------------------------------
            S_END: begin
                // remain here; no outputs asserted
                next = S_END;
            end

            default: next = S_IDLE;
        endcase
    end

endmodule
