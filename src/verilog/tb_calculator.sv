module tb_calculator import calculator_pkg::*; ();

    //=============== Generate the clock =================
    localparam CLK_PERIOD = 20; //Set clock period: 20 ns
    localparam DUTY_CYCLE = 0.5;
    //define clock
    logic clk_tb;
    
    initial begin
	forever //run the clock forever
	begin		
		#(CLK_PERIOD*DUTY_CYCLE) clk_tb = 1'b1; //wait duty cycle then set clock high
		#(CLK_PERIOD*DUTY_CYCLE) clk_tb = 1'b0; //wait duty cycle then set clock low
	end
	end

    //======== Define wires going into your module ========
    logic             rst_tb;   // global
    logic [ADDR_W-1:0] read_start_addr_tb, read_end_addr_tb;  //input read addresses
    logic [ADDR_W-1:0] write_start_addr_tb, write_end_addr_tb;  //input write addresses

    //========= Instantiate a gcd module ==============
    top_lvl DUT (
        .clk                (clk_tb),
        .rst                (rst_tb),
        .read_start_addr    (read_start_addr_tb),
        .read_end_addr      (read_end_addr_tb),
        .write_start_addr   (write_start_addr_tb),
        .write_end_addr     (write_end_addr_tb)
    ) ;

    initial begin
        //These two lines just allow visibility of signals in the simulation
        $shm_open("waves.shm");
        $shm_probe("AC");
        $display("\n--------------Beginning Simulation!--------------\n");
        $display("Time: %t", $time);
        @(posedge clk_tb);
        initialize_signals();
        fork begin
            wait(DUT.u_ctrl.state == S_END);
            #100;
        end
        begin
            #100000;
        end
        join_any
        $display("\n-------------Finished Simulation!----------------\n");
        $display("Time: %t", $time);
        $writememb("sim_memory_post_state_lower.txt", DUT.sram_A.mem);
        $writememb("sim_memory_post_state_upper.txt", DUT.sram_B.mem);
        $finish;
    end

    //Task to set the initial state of the signals. Task is called up above
    task initialize_signals();
    begin
        $display("--------------Initializing Signals---------------\n");
        $display("Time: %t", $time);
        rst_tb              = 1'b1;
        read_start_addr_tb  = '0;
        read_end_addr_tb    = 9'b011111111;
        write_start_addr_tb = 9'b110000000;
        write_end_addr_tb   = 9'b111111111;
        $readmemb("memory_pre_state_lower.txt", DUT.sram_A.mem);
        $readmemb("memory_pre_state_upper.txt", DUT.sram_B.mem);
        @(posedge clk_tb);
        rst_tb              = 1'b0;
    end
    endtask
	
endmodule 
