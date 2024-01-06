`timescale 1ns / 1ps

module cpu_testbench;
    reg clk;
    reg reset;


//for debugging
    // Declare wires for debug signals
    wire [3:0] debug_opcode;
    wire debug_pc_write;
    wire debug_branch;
//
    // Instantiate the CPU module with debug connections
    cpu myCpu(
        .clk(clk),
        .reset(reset),
        .debug_opcode(debug_opcode),  // Connect debug signals
        .debug_pc_write(debug_pc_write),
        .debug_branch(debug_branch)

    );

    // Clock generation
    always #10 clk = ~clk; // Generate a clock with a period of 20ns (50MHz)

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;

        // Apply a reset pulse
        #20 reset = 0;

        // Initialize registers
	myCpu.my_reg_file.registers[0] = 0;
	myCpu.my_reg_file.registers[1] = 0;
	myCpu.my_reg_file.registers[2] = 0;
	myCpu.my_reg_file.registers[3] = 0;
	myCpu.my_reg_file.registers[4] = 0;

	// data memoryi s?f?rlamaya �al??t?m ama bilmiyorum oldu mu
	myCpu.my_data_memory.memory[0] = 0;
	myCpu.my_data_memory.memory[1] = 0;
	myCpu.my_data_memory.memory[2] = 0;
	myCpu.my_data_memory.memory[3] = 0;
	myCpu.my_data_memory.memory[4] = 0;


        // Load a test program into instruction memory
	myCpu.my_instr_memory.instr_mem[0] = 18'h08004; // ADDI 0 0 #4
 	myCpu.my_instr_memory.instr_mem[1] = 18'h24000; // ST 0 0  
	myCpu.my_instr_memory.instr_mem[2] = 18'h20400; // LD 1 0
	myCpu.my_instr_memory.instr_mem[3] = 18'h04840; // ADD 2 1 0
	myCpu.my_instr_memory.instr_mem[4] = 18'h24801; // ST 2 1
	myCpu.my_instr_memory.instr_mem[5] = 18'h0c081; // AND 1 2 1
	myCpu.my_instr_memory.instr_mem[6] = 18'h24c00; // ST 3 0


	// Wait for a few clock cycles after reset
    	//#10;

    	// Display initial register values
    	$display("Initial state: PC = %d, R1 = %d, R2 = %d, R3 = %d", myCpu.program_counter, myCpu.my_reg_file.registers[1], myCpu.my_reg_file.registers[2], myCpu.my_reg_file.registers[3]);
	
	// Run the simulation for a certain period
       // #20;
	 // Manually control the program counter



  	        // Check outputs and internal states
           	// we can adjust the timing (#50, #100, etc.) according to WHATEVER clock period and or instruction execution time. cheers.
   	#10 $display("After first instruction: PC = %d,R0 =%d R1 =%d, R2 =%d, R3 =%d", myCpu.program_counter, myCpu.my_reg_file.registers[0], myCpu.my_reg_file.registers[1], myCpu.my_reg_file.registers[2], myCpu.my_reg_file.registers[3]);
   	#10 $display("After first instruction: PC = %d,R0 =%d R1 =%d, R2 =%d, R3 =%d", myCpu.program_counter, myCpu.my_reg_file.registers[0], myCpu.my_reg_file.registers[1], myCpu.my_reg_file.registers[2], myCpu.my_reg_file.registers[3]);
	#10 $display("After first instruction: PC = %d,R0 =%d R1 =%d, R2 =%d, R3 =%d", myCpu.program_counter, myCpu.my_reg_file.registers[0], myCpu.my_reg_file.registers[1], myCpu.my_reg_file.registers[2], myCpu.my_reg_file.registers[3]);
   	#10 $display("After first instruction: PC = %d,R0 =%d R1 =%d, R2 =%d, R3 =%d", myCpu.program_counter, myCpu.my_reg_file.registers[0], myCpu.my_reg_file.registers[1], myCpu.my_reg_file.registers[2], myCpu.my_reg_file.registers[3]);
   	#10 $display("After first instruction: PC = %d,R0 =%d R1 =%d, R2 =%d, R3 =%d", myCpu.program_counter, myCpu.my_reg_file.registers[0], myCpu.my_reg_file.registers[1], myCpu.my_reg_file.registers[2], myCpu.my_reg_file.registers[3]);
   	#10 $display("After first instruction: PC = %d,R0 =%d R1 =%d, R2 =%d, R3 =%d", myCpu.program_counter, myCpu.my_reg_file.registers[0], myCpu.my_reg_file.registers[1], myCpu.my_reg_file.registers[2], myCpu.my_reg_file.registers[3]);
   	#10 $display("After first instruction: PC = %d,R0 =%d R1 =%d, R2 =%d, R3 =%d", myCpu.program_counter, myCpu.my_reg_file.registers[0], myCpu.my_reg_file.registers[1], myCpu.my_reg_file.registers[2], myCpu.my_reg_file.registers[3]);
   	#10 $display("After first instruction: PC = %d,R0 =%d R1 =%d, R2 =%d, R3 =%d", myCpu.program_counter, myCpu.my_reg_file.registers[0], myCpu.my_reg_file.registers[1], myCpu.my_reg_file.registers[2], myCpu.my_reg_file.registers[3]);
   	#10 $display("After first instruction: PC = %d,R0 =%d R1 =%d, R2 =%d, R3 =%d", myCpu.program_counter, myCpu.my_reg_file.registers[0], myCpu.my_reg_file.registers[1], myCpu.my_reg_file.registers[2], myCpu.my_reg_file.registers[3]);
   	#10 $display("After first instruction: PC = %d,R0 =%d R1 =%d, R2 =%d, R3 =%d", myCpu.program_counter, myCpu.my_reg_file.registers[0], myCpu.my_reg_file.registers[1], myCpu.my_reg_file.registers[2], myCpu.my_reg_file.registers[3]);
   	#10 $display("After first instruction: PC = %d,R0 =%d R1 =%d, R2 =%d, R3 =%d", myCpu.program_counter, myCpu.my_reg_file.registers[0], myCpu.my_reg_file.registers[1], myCpu.my_reg_file.registers[2], myCpu.my_reg_file.registers[3]);
   	#10 $display("After first instruction: PC = %d,R0 =%d R1 =%d, R2 =%d, R3 =%d", myCpu.program_counter, myCpu.my_reg_file.registers[0], myCpu.my_reg_file.registers[1], myCpu.my_reg_file.registers[2], myCpu.my_reg_file.registers[3]);
   	#10 $display("After first instruction: PC = %d,R0 =%d R1 =%d, R2 =%d, R3 =%d", myCpu.program_counter, myCpu.my_reg_file.registers[0], myCpu.my_reg_file.registers[1], myCpu.my_reg_file.registers[2], myCpu.my_reg_file.registers[3]);
   	#10 $display("After first instruction: PC = %d,R0 =%d R1 =%d, R2 =%d, R3 =%d", myCpu.program_counter, myCpu.my_reg_file.registers[0], myCpu.my_reg_file.registers[1], myCpu.my_reg_file.registers[2], myCpu.my_reg_file.registers[3]);
   	#10 $display("After first instruction: PC = %d,R0 =%d R1 =%d, R2 =%d, R3 =%d", myCpu.program_counter, myCpu.my_reg_file.registers[0], myCpu.my_reg_file.registers[1], myCpu.my_reg_file.registers[2], myCpu.my_reg_file.registers[3]);
   	#10 $display("After first instruction: PC = %d,R0 =%d R1 =%d, R2 =%d, R3 =%d", myCpu.program_counter, myCpu.my_reg_file.registers[0], myCpu.my_reg_file.registers[1], myCpu.my_reg_file.registers[2], myCpu.my_reg_file.registers[3]);
   	#10 $display("After first instruction: PC = %d,R0 =%d R1 =%d, R2 =%d, R3 =%d", myCpu.program_counter, myCpu.my_reg_file.registers[0], myCpu.my_reg_file.registers[1], myCpu.my_reg_file.registers[2], myCpu.my_reg_file.registers[3]);
	
	// Wait for a few clock cycles after loading instructions
    	#10;
    	$display("After instruction fetch: PC = %d, current_instr = %h", myCpu.program_counter, myCpu.current_instr);
    	$display("Control signals: pc_write = %b, branch = %b", myCpu.my_cu.pc_write, myCpu.my_cu.branch);
	$display("After first instruction: PC = %d, Opcode = %b, PC Write = %b, Branch = %b", myCpu.program_counter, debug_opcode, debug_pc_write, debug_branch);
	


	#100;
        // End the simulation
        $finish;
    end
endmodule

