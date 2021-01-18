`timescale 1ns/10ps
`define CYCLE     10                 // Modify your clock period here
`define End_CYCLE  1200          // Modify cycle times once your design need more cycle times!
module testfixture1;

reg clk,reset,din_valid;
reg [23:0] din_r,din_i;
wire [23:0] dout_r,dout_i,sort_out_r,sort_out_i;
wire dout_valid,done,sort_valid;
wire [3:0] dout_num;

reg [15:0] din_mem [0:1023];
initial $readmemh("./dat/Golden1_FIR.dat", din_mem);

reg [15:0] fftr_mem [0:1023];
initial $readmemh("./dat/Golden1_FFT_real.dat", fftr_mem);
reg [15:0] ffti_mem [0:1023];
initial $readmemh("./dat/Golden1_FFT_imag.dat", ffti_mem);

integer i, j ,k, l,error;

FFT #(.WIDTH(24),.PointLog2(4)) 
F1(
    .clk(clk),
    .rst(reset),
    .din_valid(din_valid),
    .din_r(din_r),
    .din_i(din_i),
    .dout_num(dout_num),
    .done(done),
    .dout_valid(dout_valid),
    .dout_r(dout_r),
    .dout_i(dout_i)
);

/*
sort s1(
    .clk(clk),
    .rst(reset),
    .din_valid(dout_valid),
    .din_r(dout_r),
    .din_i(dout_i),
    .d_num(dout_num),
    .dout_r(sort_out_r),
    .dout_i(sort_out_i),
    .dout_valid(sort_valid)
);*/

initial begin
$fsdbDumpfile("FFT.fsdb");
$fsdbDumpvars;
 $fsdbDumpMDA;
end



initial begin
#0;
   clk         = 1'b0;
   reset       = 1'b0; 
   i = 0;   
   j = 0;  
   k = 0;
   l = 0;
   error =0;
   
end

always begin #(`CYCLE/2) clk = ~clk; end

initial begin
	din_valid = 0;
   #(`CYCLE*0.5)   reset = 1'b1; 
   #(`CYCLE*2);  reset = 1'b0; din_valid = 1;
end

// data input & ready
always@(posedge clk or posedge reset) begin
	if (din_valid) begin
		if (i >= 1024 ) begin
			din_r <= 0;
            din_i <= 0;
        end
		else begin
			din_r <= {din_mem[i],8'd0};
            din_i <= 0;
			i <= i + 1;
		end
	end
end

//============================================================================================================
//============================================================================================================
//============================================================================================================

initial begin
    #(`CYCLE * `End_CYCLE);
    $display("-----------------------------------------------------\n");
    $display("-------------------------FINISH------------------------\n");
    $display("-----------------------------------------------------\n");
    $finish;
end
reg [15:0] fft_mem_data_r,fft_mem_data_i;
reg [15:0] fft_mem_r [0:5],fft_mem_i [0:5];
reg fftr_vertify,ffti_vertify;
reg [31:0] fft_out_cmp,fft_mem_data;
wire sort = 1'd0;
wire [15:0] fft_result_r = sort ? sort_out_r[23:8] :dout_r[23:8];
wire [15:0] fft_result_i = sort ? sort_out_i[23:8] :dout_i[23:8];
wire fft_valid = sort ? sort_valid : dout_valid;
always@(posedge clk) begin
    fft_mem_data_r = fftr_mem[j];
    fft_mem_r[0] = fftr_mem[j] + 1;  fft_mem_r[1] = fftr_mem[j] - 1;
    fft_mem_r[2] = fftr_mem[j] + 2;  fft_mem_r[3] = fftr_mem[j] - 2;
    fft_mem_r[4] = fftr_mem[j] + 3;  fft_mem_r[5] = fftr_mem[j] - 3;

    fft_mem_data_i = ffti_mem[j];
    fft_mem_i[0] = ffti_mem[j] + 1;  fft_mem_i[1] = ffti_mem[j] - 1;
    fft_mem_i[2] = ffti_mem[j] + 2;  fft_mem_i[3] = ffti_mem[j] - 2;
    fft_mem_i[4] = ffti_mem[j] + 3;  fft_mem_i[5] = ffti_mem[j] - 3;

    fftr_vertify =  (fft_mem_r[0] == fft_result_r) ||
                    (fft_mem_r[1] == fft_result_r) ||
                    (fft_mem_r[2] == fft_result_r) ||
                    (fft_mem_r[3] == fft_result_r) ||
                    (fft_mem_r[4] == fft_result_r) ||
                    (fft_mem_r[5] == fft_result_r) ||
                    (fft_mem_data_r == fft_result_r);

    ffti_vertify =  (fft_mem_i[0] == fft_result_i) ||
                    (fft_mem_i[1] == fft_result_i) ||
                    (fft_mem_i[2] == fft_result_i) ||
                    (fft_mem_i[3] == fft_result_i) ||
                    (fft_mem_i[4] == fft_result_i) ||
                    (fft_mem_i[5] == fft_result_i) ||
                    (fft_mem_data_i == fft_result_i);   

    if(fft_valid && (j < 1024) ) begin
        fft_out_cmp = {fft_result_r,fft_result_i};
        fft_mem_data = {fftr_mem[j],ffti_mem[j]};
        if(fftr_vertify && ffti_vertify) begin
            
        end
        else if( j < 16)begin
            $display("ERROR at FFT  ppoint number =%2d: The real response output %8h != expectd %8h " ,j, fft_out_cmp,fft_mem_data );
			$display("-----------------------------------------------------");
            error = error + 1 ;
        end 
        j = j + 1;
    end
end
endmodule
