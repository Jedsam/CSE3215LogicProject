`timescale 1ns / 1ps

module cpu_testbench;
    reg clk;
    reg reset;
    reg start;

//for debugging
    // Declare wires for debug signals
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
    always #80 clk = ~clk; // Generate a clock with a period of 40ns (50MHz)
    initial begin
        // Initialize signals
        clk = 0;

        // Initialize registers
	reset = 1;

        // Apply a reset pulse
        #40 reset = 0;

    end
endmodule


