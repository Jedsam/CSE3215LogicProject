module data_memory(
    input clk,
    input mem_write_en,
    input mem_read_en,
    input [9:0] address,
    inout [17:0] data
);


	//memory array
    reg [17:0] memory[1023:0];

    always @(posedge clk) begin
        if (mem_write_en) begin
            memory[address] <= data;
        end
    end

    assign data = (mem_read_en) ? memory[address] : 18'bz;
endmodule
