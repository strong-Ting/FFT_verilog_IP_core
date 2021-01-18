module shifter#(parameter WIDTH=24,parameter delay=8)
(clk,rst,dataIn_R,dataIn_I,dataOut_R,dataOut_I);
input clk,rst;
input [WIDTH-1:0] dataIn_R,dataIn_I;
output [WIDTH-1:0] dataOut_R,dataOut_I;
wire [WIDTH-1:0] dataIn_R,dataIn_I,dataOut_R,dataOut_I;

reg [WIDTH-1:0] FIFO_R[delay-1:0];
reg [WIDTH-1:0] FIFO_I[delay-1:0];
assign dataOut_R = FIFO_R[delay-1];
assign dataOut_I = FIFO_I[delay-1];

integer i;
always@(posedge clk or posedge rst)
begin
    if(rst) 
    begin
        for(i=0;i<delay;i=i+1)
        begin
            FIFO_R[i] <= {WIDTH{1'b0}};
			FIFO_I[i] <= {WIDTH{1'b0}};
        end
    end
    else 
    begin
		FIFO_R[0] <= dataIn_R;
		FIFO_I[0] <= dataIn_I;
		for(i=0;i<(delay-1);i=i+1)
        begin
            FIFO_R[i+1] <= FIFO_R[i];
			FIFO_I[i+1] <= FIFO_I[i];	
        end
    end
end
endmodule