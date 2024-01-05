module data_memory(
    input clk,
    input mem_write_en,
    input mem_read_en,
    input [9:0] address,
    input [17:0] in_data,
    output [17:0] out_data
);


	//memory array
    reg [17:0] memory[1023:0];

    always @(posedge clk) begin
        if (mem_write_en) begin
            memory[address] <= in_data;
        end
    end

    assign out_data = (mem_read_en) ? memory[address] : 18'bz;
endmodule
