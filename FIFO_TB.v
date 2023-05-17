module FIFO_TB();

//Constants
parameter ADDR_WIDTH = 4;
parameter DATA_WIDTH = 8;

//Clock domains
parameter clk_read_prd = 1ns;
parameter clk_write_prd = 2ns;
reg clk_read = 0;
reg clk_write = 0;
always #(clk_read_prd/2) clk_read = ~clk_read;
always #(clk_write_prd/2) clk_write = ~clk_write;

//Input Variables
wire [DATA_WIDTH-1 : 0] data_out; //Output data
reg [DATA_WIDTH-1 : 0] data_in;   //Input data
reg Wr_enable = 0;
reg Read_enable = 0;

FIFO #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) DUT (
    .clk_read(clk_read),
    .clk_write(clk_write),
    .data_in(data_in),
    .data_out(data_out),
    .Wr_enable(Wr_enable),
    .Read_enable(Read_enable)
);

//variable for looping
integer i;

initial begin

    //Reading while memory is empty
    Read_enable = 1;
    #(clk_read_prd);
    $display("Value of empty FIFO is %d", data_out);
    Read_enable = 0;

    //Writing 2 memory spaces
    Wr_enable = 1;
    data_in = 5;
    #(clk_write_prd);
    data_in = 10;
    #(clk_write_prd);
    Wr_enable = 0;

    //Reading 2 memory spaces
    Read_enable = 1;
    #(clk_read_prd);
    $display("Value of number 1 written is %d", data_out);
    #(clk_read_prd);
    $display("Value of number 2 written is %d", data_out);
    #(clk_read_prd);
    $display("Value of empty FIFO is %d", data_out);
    Read_enable = 0;

    //Writing the whole memory
    Wr_enable = 1;
    for(i = 0;i<=(2**(ADDR_WIDTH));i=i+1) begin
        data_in = i;
        #(clk_write_prd);
    end
    Wr_enable = 0;

    //Reading the whole memory
    Read_enable = 1;
    for(i = 0;i<=(2**(ADDR_WIDTH));i=i+1) begin
        #(clk_read_prd);
        $display("Value of number %d written is %d", i+1, data_out);
    end
    Read_enable = 0;

    $finish();
end

endmodule