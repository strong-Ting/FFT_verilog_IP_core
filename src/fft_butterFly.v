
module fft_butterFly#(parameter IN_W = 24,parameter Factor_W = 32)
(state,din_ar,din_ai,din_br,din_bi,W_R,W_I,dout_ar,dout_ai,dout_br,dout_bi);
input state;
input signed [IN_W-1:0] din_ar,din_ai,din_br,din_bi;
input signed [Factor_W-1:0] W_R;
input signed [Factor_W-1:0] W_I;
output signed [IN_W-1:0] dout_ar,dout_ai,dout_br,dout_bi;

reg signed [IN_W-1:0] dout_ar,dout_ai,dout_br,dout_bi;
reg signed [IN_W-1:0] a,b,c,d;
reg signed [IN_W*2:0] inter,mul_r,mul_i;

always@(*)
begin
	dout_ar = din_br;
	dout_ai = din_bi;
	dout_br = {IN_W{1'b0}};
	dout_bi = {IN_W{1'b0}};
	case(state)
	1'd0: 
	begin
		a = din_ar + din_br;
		b = din_ai + din_bi;

		c = din_ar - din_br;
		d = din_ai - din_bi;

		dout_br = a;
		dout_bi = b;

		dout_ar = c;
		dout_ai = d;
	end
	1'd1: 
	begin
		dout_ar = din_br;
		dout_ai = din_bi;

		a = din_ar;
		b = din_ai;

		inter = b*(W_R-W_I);
		mul_r = W_R*(a-b) + inter;
		mul_i = W_I*(a+b) + inter;

		dout_br = {mul_r[IN_W*2],mul_r[38:16]};
		dout_bi = {mul_i[IN_W*2],mul_i[38:16]};
	end
	default:
	begin
		dout_ar = din_br;
		dout_ai = din_bi;
	end
	endcase 
end

endmodule