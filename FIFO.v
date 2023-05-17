module FIFO #(
    parameter ADDR_WIDTH = 5,
    parameter DATA_WIDTH = 8
)(
    output reg [DATA_WIDTH-1 : 0] data_out,
    input [DATA_WIDTH-1 : 0] data_in,
    input clk_read,
    input clk_write,
    input Wr_enable,
    input Read_enable
);

//Full signal
parameter full = 2**(ADDR_WIDTH);

//Empty signal
parameter empty = 0;

//FIFO memory
reg [DATA_WIDTH-1 : 0] mem[0 : (2**(ADDR_WIDTH))-1];

//Adress pointer for write
reg [ADDR_WIDTH-1 : 0] wr_addr = 0;

//Adress pointer for read
reg [ADDR_WIDTH-1 : 0] read_addr = 0;

//Counter
reg [ADDR_WIDTH : 0] count = empty;

//Change Value of Counter
always @(read_addr or wr_addr) begin
    if(Wr_enable) begin
        count = count + 1;
    end
    if (Read_enable) begin
        count = count - 1;
    end
end

//Reading a value from FIFO memory
always @(posedge clk_read) begin
    if(Read_enable && (count != empty)) begin
        data_out <= mem[read_addr];
        if(read_addr == (2**(ADDR_WIDTH))-1)
            read_addr <= 0;
        else
            read_addr <= read_addr + 1;
    end
    else
        data_out <= 0;
end

//Writing a value in FIFO memory
always @(posedge clk_write) begin
    if(Wr_enable && (count != full)) begin
        mem[wr_addr] <= data_in;
        if(wr_addr == (2**(ADDR_WIDTH))-1)
            wr_addr <= 0;
        else
            wr_addr <= wr_addr + 1;
    end
    else
        mem[wr_addr] <= mem[wr_addr];
end

endmodule