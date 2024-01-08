module alu(
    input clk,
    input [2:0] aluControl,
    input [17:0] a,
    input [17:0] b,
    output reg [17:0] result,
    output zero,
    output negative,
    output reg carry_out,
    output reg cf_out,
    output reg zf_out
);

    // Define operations
    localparam ALU_ADD  = 3'b000;
    localparam ALU_AND  = 3'b001;
    localparam ALU_NAND = 3'b010;
    localparam ALU_NOR  = 3'b011;
    localparam ALU_SUB  = 3'b100; // For CMP
    localparam ALU_ADDI = 3'b101;
    localparam ALU_ANDI = 3'b110;

    always @(*) begin
        case (aluControl)
            ALU_ADD: {carry_out, result} = a + b; // ADD with carry out
	    ALU_ADDI: {carry_out, result} = a + b; // ADD with carry out
            ALU_AND: begin
                result = a & b; // AND
                carry_out = 0;
            end
	    ALU_ANDI: begin
                result = a & b; // AND
                carry_out = 0;
            end
            ALU_NAND: begin
                result = ~(a & b); // NAND
                carry_out = 0;
            end
            ALU_NOR: begin
                result = ~(a | b); // NOR
                carry_out = 0;
            end
	    ALU_SUB: begin
                zf_out = a == b ? 1'b1 : 1'b0;
                cf_out = b > a ? 1'b1 : 1'b0;
            end
            default: begin
                result = 0;
                carry_out = 0;
            end
        endcase
    end


    // Setting flags based on result
    assign zero = (result == 0);
    assign negative = result[17];
endmodule
