module control_unit(
    input clk,
    input reset,
    input [17:14] opcode, // 4-bit opcode from the instruction [17:14]
    input ZF, // Zero Flag
    input CF, // Carry Flag

    output reg branch, // Branch signal
    output reg pc_write, // Signal to write to the program counter
    output reg mem_read, // Signal to read from memory
    output reg mem_to_reg, // Signal to select memory data to write to the register file
    output reg mem_write, // Signal to write to memory
    output reg alu_src, // Signal to select second ALU operand (register/immediate)
    output reg reg_write, // Signal to write to the register file
    output reg [2:0] alu_op, // Control bits for ALU operation
    output reg is_cmp_op // Signal to write to CF and ZF
);

    // Define opcodes as parameters for readability
    parameter ADD  = 4'b0001;
    parameter AND  = 4'b0011;
    parameter NAND = 4'b0101;
    parameter NOR  = 4'b0110;
    parameter ADDI = 4'b0010;
    parameter ANDI = 4'b0100;
    parameter LD   = 4'b1000;
    parameter ST   = 4'b1001;
    parameter CMP  = 4'b1010;
    parameter JUMP = 4'b0111;
    parameter JE   = 4'b1011;
    parameter JA   = 4'b1100;
    parameter JB   = 4'b1101;
    parameter JAE  = 4'b1110;
    parameter JBE  = 4'b1111;

    // Define ALU operations
    parameter ALU_ADD  = 3'b000;
    parameter ALU_AND  = 3'b001;
    parameter ALU_NAND = 3'b010;
    parameter ALU_NOR  = 3'b011;
    parameter ALU_SUB  = 3'b100; // For CMP
    parameter ALU_ADDI = 3'b101;
    parameter ALU_ANDI = 3'b110;

    always @(*) begin
        // Default control signal values
        pc_write = 0;
        mem_read = 0;
        mem_to_reg = 0;
        mem_write = 0;
        alu_src = 0;
        reg_write = 0;
        alu_op = ALU_ADD;
        branch = 0; // No branch by default
	
        case (opcode)
            ADD: begin
                alu_op = ALU_ADD;
                reg_write = 1;
            end
            AND: begin
                alu_op = ALU_AND;
                reg_write = 1;
            end
            NAND: begin
                alu_op = ALU_NAND;
                reg_write = 1;
            end
            NOR: begin
                alu_op = ALU_NOR;
                reg_write = 1;
            end
            ADDI: begin
                alu_op = ALU_ADDI;
                alu_src = 1;
                reg_write = 1;
            end
            ANDI: begin
                alu_op = ALU_ANDI;
                alu_src = 1;
                reg_write = 1;
            end
            LD: begin
                mem_read = 1;
                mem_to_reg = 1;
                reg_write = 1;
            end
            ST: begin
                mem_write = 1;
            end
            CMP: begin
                alu_op = ALU_SUB; // Subtraction for comparison
            end
            JUMP: begin
                pc_write = 1;
            end
            JE: begin
                // For JE, one shall check if the zero flag is set
                if (ZF) begin
                    pc_write = 1; // Update the PC to the branch address
                    branch = 1; // Indicate a branch is taken
                end
            end
            JA: begin
                // For JA, check if the zero flag is clear and carry flag is clear
                if (!ZF && !CF) begin
                    pc_write = 1;
                    branch = 1;
                end
            end
	    JB: begin
                // For JA, check if the zero flag is clear and carry flag is clear
                if (!ZF && CF) begin
                    pc_write = 1;
                    branch = 1;
                end
            end
	    JAE: begin
                // For JA, check if the zero flag is clear and carry flag is clear
                if (!CF) begin
                    pc_write = 1;
                    branch = 1;
                end
            end
	    JBE: begin
                // For JA, check if the zero flag is clear and carry flag is clear
                if (ZF || CF) begin
                    pc_write = 1;
                    branch = 1;
                end
            end
            // other things to b added.. perhaps..
            // perhaps...

            default: begin
                // No operation or invalid opcode
            end
        endcase
    end
endmodule
