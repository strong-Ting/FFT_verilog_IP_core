module FFT#(parameter WIDTH = 24,parameter PointLog2 = 4,parameter tw_WIDTH = 32) //result not sort
(clk,rst,din_valid,din_r,din_i,dout_num,done,dout_valid,dout_r,dout_i);
input clk,rst;
input din_valid;
input [WIDTH-1:0] din_r,din_i;
output [PointLog2-1:0] dout_num;
output [WIDTH-1:0] dout_r,dout_i;
output done,dout_valid;
wire [WIDTH-1:0] dout_r,dout_i;

//counter
wire [PointLog2:0] counter_next;
reg [PointLog2:0] counter;
wire [PointLog2-1:0] dout_num = counter[PointLog2-1:0] + {{PointLog2-1{1'd0}},1'd1};

wire signed [WIDTH-1:0] dout_ar [PointLog2-1:0];
wire signed [WIDTH-1:0] dout_ai [PointLog2-1:0];
wire signed [WIDTH-1:0] dout_br [PointLog2-1:0];
wire signed [WIDTH-1:0] dout_bi [PointLog2-1:0];

wire [WIDTH-1:0] shifter_din_R[PointLog2-1:0];
wire [WIDTH-1:0] shifter_din_I[PointLog2-1:0];

wire signed [tw_WIDTH-1:0] W_R[PointLog2-2:0];
wire signed [tw_WIDTH-1:0] W_I[PointLog2-2:0];


wire state[PointLog2-1:0];

assign counter_next = (din_valid) ? counter + {{PointLog2{1'd0}},1'd1} : counter;
always@(posedge clk or posedge rst)
begin
	if(rst) counter <= {(PointLog2+1){1'b0}};
	else counter <= counter_next;
end

reg fft_first_run,done;
wire dout_valid;
//wire dout_valid =  fft_first_run;

always@(posedge clk or posedge rst)
begin
	if(rst)
	begin
		done <= 1'd0;
		fft_first_run <= 1'd0;
	end
	else if(dout_num == 5'd15 && fft_first_run == 1'd1) done <= 1'd1;
	else if(dout_num == 5'd15) 
	begin
		done <= 1'd0;
		fft_first_run <= 1'd1;
	end
	else done <= 1'd0;
end

wire [WIDTH-1:0] fft_dout_r = dout_br[PointLog2-1];
wire [WIDTH-1:0] fft_dout_i = dout_bi[PointLog2-1];

twiddle_ROM rom(
		.clk(clk),
		.rst(rst),
		.counter(counter),
		.W_R(W_R),
		.W_I(W_I)
);

genvar i;
generate
	for(i=0;i<PointLog2;i=i+1)
	begin
		assign state[i] = counter[PointLog2-1-i] ? 1'd0 : 1'd1;
		
		shifter #(.WIDTH(24),.delay(2**(PointLog2-i-1)))
		delay( .clk(clk),
				.rst(rst),
				.dataIn_R(dout_ar[i]),
				.dataIn_I(dout_ai[i]),
				.dataOut_R(shifter_din_R[i]),
				.dataOut_I(shifter_din_I[i])
		);
	end

	fft_butterFly f0(  	.state(state[0]),
					.din_ar(shifter_din_R[0]),
				   	.din_ai(shifter_din_I[0]),
					.din_br(din_r),
					.din_bi(din_i),
					.W_R(W_R[0]),
					.W_I(W_I[0]),
					.dout_ar(dout_ar[0]),
					.dout_ai(dout_ai[0]),
					.dout_br(dout_br[0]),
					.dout_bi(dout_bi[0])
	);
	for(i=1;i<PointLog2;i=i+1)
	begin
		if(i == (PointLog2-1))
		begin
			fft_butterFly 
			f(  		.state(state[i]),
						.din_ar(shifter_din_R[i]),
						.din_ai(shifter_din_I[i]),
						.din_br(dout_br[i-1]),
						.din_bi(dout_bi[i-1]),
						.W_R(32'h00010000),
						.W_I(32'h00000000),
						.dout_ar(dout_ar[i]),
						.dout_ai(dout_ai[i]),
						.dout_br(dout_br[i]),
						.dout_bi(dout_bi[i])
			);
		end
		else
		begin
			fft_butterFly 
			f(  		.state(state[i]),
						.din_ar(shifter_din_R[i]),
						.din_ai(shifter_din_I[i]),
						.din_br(dout_br[i-1]),
						.din_bi(dout_bi[i-1]),
						.W_R(W_R[i]),
						.W_I(W_I[i]),
						.dout_ar(dout_ar[i]),
						.dout_ai(dout_ai[i]),
						.dout_br(dout_br[i]),
						.dout_bi(dout_bi[i])
			);
		end
	end
endgenerate
wire sort_din_valid = fft_first_run;
wire [WIDTH-1:0] sort_dout_r,sort_dout_i;
wire sort_dout_valid;
sort #(.WIDTH(WIDTH),.log2NUM(PointLog2),.NUM(PointLog2*PointLog2)) s1(
		.clk(clk),
		.rst(rst),
		.din_valid(sort_din_valid),
		.d_num(dout_num),
		.din_r(fft_dout_r),
		.din_i(fft_dout_i),
		.dout_r(sort_dout_r),
		.dout_i(sort_dout_i),
		.dout_valid(sort_dout_valid)
);
assign dout_r = sort_dout_r;
assign dout_i = sort_dout_i;

assign dout_valid = sort_dout_valid;

endmodule