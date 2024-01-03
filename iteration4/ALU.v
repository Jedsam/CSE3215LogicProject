module alu(
    input [2:0] aluControl,
    input [17:0] a,
    input [17:0] b,
    output reg [17:0] result,
    output zero,
    output negative,
    output reg carry_out
);

    // Define operations
    localparam ALU_ADD  = 4'b0001;
    localparam ALU_AND  = 4'b0011;
    localparam ALU_NAND = 4'b0101;
    localparam ALU_NOR  = 4'b0110;

    always @(*) begin
        case (aluControl)
            ALU_ADD: {carry_out, result} = a + b; // ADD with carry out
            ALU_AND: begin
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
