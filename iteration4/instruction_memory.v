
module instruction_memory(
    input [9:0] address,
    output [17:0] instruction
);
    reg [17:0] instr_mem[1023:0];

    assign instruction = instr_mem[address]; // Asynchronous read
endmodule
