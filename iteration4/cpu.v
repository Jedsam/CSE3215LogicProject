module cpu(
    input clk,
    input reset,


//for debugging:
    output wire [3:0] debug_opcode, // For debugging
    output wire debug_pc_write, // For debugging
    output wire debug_branch // For debugging
//
);
    parameter ALU_SUB  = 3'b100; // Parameter for CMP
    // Program Counter
    reg [9:0] program_counter;
    //ZF CF
    reg CF_bit, ZF_bit;
    // Control signals
    wire [2:0] alu_op;
    wire alu_src, reg_write, mem_read, mem_to_reg, mem_write, pc_write, branch, CF_in, ZF_in;
    wire [17:0] write_data, alu_operand2, read_data1, read_data2;

    // Instruction fields
    wire [17:0] current_instr;
    wire [3:0] opcode;  // Declaration without assignment
    wire [3:0] reg_dst, reg_src1, reg_src2;
    wire [5:0] imm;
    wire [9:0] addr;

    // ALU connections
    wire [17:0] alu_result;
    wire alu_zero, alu_carry, alu_negative;

    // Data memory connections
    wire [17:0] data_mem_out;

    // Instantiate the ALU
    alu my_alu(
        .clk(clk),
        .aluControl(alu_op),
        .a(read_data1),
        .b(alu_operand2),
        .result(alu_result),
        .zero(alu_zero),
        .negative(alu_negative),
        .carry_out(alu_carry),
	.cf_out(CF_in),
	.zf_out(ZF_in)
    );

    // Instantiate the control unit
    control_unit my_cu(
	.clk(clk),
	.reset(reset),
	.ZF(ZF_bit),
	.CF(CF_bit),
        .opcode(opcode),
        .pc_write(pc_write),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write),
        .alu_op(alu_op),
        .branch(branch)
    );

    // Instantiate the register file
    register_file my_reg_file(
        .clk(clk),
        .reg_write_en(reg_write),
        .read_sel1(reg_src1),
        .read_sel2(reg_src2),
        .write_sel(reg_dst),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Instantiate data memory
    data_memory my_data_memory(
        .clk(clk),
        .mem_write_en(mem_write),
        .mem_read_en(mem_read),
        .address(addr),
	.in_data(myCpu.my_reg_file.registers[reg_dst]),
        .out_data(data_mem_out)
    );

    // Instantiate instruction memory
    instruction_memory my_instr_memory(
        .address(program_counter),
        .instruction(current_instr)
    );



    // Assignments
    assign opcode = current_instr[17:14]; 
    assign reg_dst = current_instr[13:10];
    assign reg_src1 = alu_op == ALU_SUB ? current_instr[13:10] : current_instr[9:6];
    assign reg_src2 = current_instr[3:0];
    assign addr = current_instr[9:0];
    assign imm = current_instr[5:0]; // Assign immediate value

//for debugging:
assign debug_opcode = opcode;
assign debug_pc_write = pc_write;
assign debug_branch = my_cu.branch;

//

    // ALU operand selection and write data path logic

    assign alu_operand2 = alu_src ? {imm[5:5] ? 12'hFFF : 12'h000, imm} : read_data2; // Extend immediate value
    assign write_data = mem_to_reg ? data_mem_out : alu_result;
    assign data_mem_in = my_reg_file.registers[reg_dst];
    //assign reg_dst = (opcode == 4'b0010) ? reg_src1 : reg_src2; // Example for ADDI instruction

    // Program counter update logic
always @(posedge clk or posedge reset) begin
    	if (reset) begin
	    my_reg_file.registers[0] = 0;
	    my_reg_file.registers[1] = 0;
	    my_reg_file.registers[2] = 0;
	    my_reg_file.registers[3] = 0;
	    my_reg_file.registers[4] = 0;
	    my_reg_file.registers[5] = 0;
	    my_reg_file.registers[6] = 0;
	    my_reg_file.registers[7] = 0;
	    my_reg_file.registers[8] = 0;
	    my_reg_file.registers[9] = 0;
	    my_reg_file.registers[10] = 0;
	    my_reg_file.registers[11] = 0;
	    my_reg_file.registers[12] = 0;
	    my_reg_file.registers[13] = 0;
	    my_reg_file.registers[14] = 0;
	    my_reg_file.registers[15] = 0;
	    program_counter <= 1023;
            $display("Reset activated: PC set to 0");
        end else begin
	if (program_counter == 1022) begin 
	$finish; 
	end
	ZF_bit <= alu_op == ALU_SUB ? ZF_in : ZF_bit;
    	CF_bit <= alu_op == ALU_SUB ? CF_in : CF_bit;
	if (pc_write) begin
	program_counter <= program_counter + addr;
	end
	else begin
        program_counter <= program_counter + 1;
	end
        $display("Time: %t, Clock: %b, Reset: %b, PC: %d", $time, clk, reset, program_counter);
	end
end

endmodule

