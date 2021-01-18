module sort#(parameter WIDTH = 24,parameter log2NUM = 4,parameter NUM = 16)(clk,rst,din_valid,d_num,din_r,din_i,dout_r,dout_i,dout_valid);
input clk,rst,din_valid;
input [log2NUM-1:0] d_num;
input [WIDTH-1:0] din_r,din_i;
output [WIDTH-1:0] dout_r,dout_i;
output dout_valid;

wire [log2NUM-1:0] d_num;
wire [log2NUM-1:0] d_num_reverse;
reverse #(.WIDTH(log2NUM)) r0 (.in(d_num),.out(d_num_reverse));

reg [WIDTH-1:0] buffer_r [NUM-1:0],buffer_i [NUM-1:0];
reg [WIDTH-1:0] result_r [NUM-1:0],result_i [NUM-1:0];

always@(posedge clk or posedge rst)
begin
	integer i;
	if(rst) 
	begin
		for(i=0;i<NUM;i=i+1)
		begin
			buffer_r[i] <= {WIDTH{1'b0}};
            buffer_i[i] <= {WIDTH{1'b0}};
            result_r[i] <= {WIDTH{1'b0}};
            result_i[i] <= {WIDTH{1'b0}};
		end
	end
    else if(d_num == {WIDTH{1'b0}})
    begin
        buffer_r[d_num_reverse] <= din_r; 
        buffer_i[d_num_reverse] <= din_i;
        for(i=0;i<NUM;i=i+1)
		begin
            result_r[i] <= buffer_r[i];
            result_i[i] <= buffer_i[i];
		end
    end
	else 
	begin
		buffer_r[d_num_reverse] <= din_r; 
        buffer_i[d_num_reverse] <= din_i; 
	end
end

wire [log2NUM-1:0] d_num_out = d_num - 1'b1;
wire [WIDTH-1:0] dout_r = result_r[d_num_out];
wire [WIDTH-1:0] dout_i = result_i[d_num_out];



reg [NUM:0]FIFO;
integer i;
always@(posedge clk or posedge rst)
begin
    if(rst) 
    begin
        for(i=0;i<NUM+1;i=i+1)
        begin
            FIFO[i] <= {WIDTH{1'b0}};
        end
    end
    else 
    begin
		FIFO[0] <= din_valid;
		for(i=0;i<(NUM);i=i+1)
        begin
            FIFO[i+1] <= FIFO[i];
        end
    end
end
wire dout_valid = FIFO[NUM];

endmodule

module reverse#(parameter WIDTH = 4) (in,out);
input [WIDTH-1:0] in;
output [WIDTH-1:0] out;
reg [WIDTH-1:0] out;

always@(*)
begin
	integer i;
	for(i=0;i<WIDTH;i=i+1)
	begin
		out[i] <= in[WIDTH-i-1];
	end
end

endmodule