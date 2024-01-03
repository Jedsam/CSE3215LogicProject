module register_file(
    input clk,
    input reg_write_en,
    input [3:0] read_sel1,
    input [3:0] read_sel2,
    input [3:0] write_sel,
    input [17:0] write_data,
    output [17:0] read_data1,
    output [17:0] read_data2
);

	//register array
    reg [17:0] registers[15:0];

    always @(posedge clk) begin
        if (reg_write_en) begin
            registers[write_sel] <= write_data;
        end
    end

    assign read_data1 = registers[read_sel1];
    assign read_data2 = registers[read_sel2];
endmodule
