module twiddle_ROM (clk,rst,counter,W_R,W_I);
input clk;
input rst;
input  [4:0] counter;
output reg signed [31:0] W_R[2:0];
output reg signed [31:0] W_I[2:0];

reg [2:0] W_index[2:0];
wire [2:0] W_index_next [2:0];


always @ (*)
begin
    case (W_index[0]) 
    
    3'd0: 
        begin
            W_R[0] <=  32'sd65536;
            W_I[0] <= -32'sd0;
		end 
    
    3'd1: 
        begin
            W_R[0] <=  32'sd60547;
            W_I[0] <= -32'sd25079;
		end 
    
    3'd2: 
        begin
            W_R[0] <=  32'sd46340;
            W_I[0] <= -32'sd46340;
		end 
    
    3'd3: 
        begin
            W_R[0] <=  32'sd25079;
            W_I[0] <= -32'sd60547;
		end 
    
    3'd4: 
        begin
            W_R[0] <=  32'sd0;
            W_I[0] <= -32'sd65536;
		end 
    
    3'd5: 
        begin
            W_R[0] <= -32'sd25079;
            W_I[0] <= -32'sd60547;
		end 
    
    3'd6: 
        begin
            W_R[0] <= -32'sd46340;
            W_I[0] <= -32'sd46340;
		end 
    
    3'd7: 
        begin
            W_R[0] <= -32'sd60547;
            W_I[0] <= -32'sd25079;
		end 
    
        default:
        begin
            W_R[0] <= 32'd0;
            W_I[0] <= 32'd0;
        end
    endcase
end

always @ (*)
begin
    case (W_index[1]) 
    
    3'd0: 
        begin
            W_R[1] <=  32'sd65536;
            W_I[1] <= -32'sd0;
		end 
    
    3'd2: 
        begin
            W_R[1] <=  32'sd46340;
            W_I[1] <= -32'sd46340;
		end 
    
    3'd4: 
        begin
            W_R[1] <=  32'sd0;
            W_I[1] <= -32'sd65536;
		end 
    
    3'd6: 
        begin
            W_R[1] <= -32'sd46340;
            W_I[1] <= -32'sd46340;
		end 
    
        default:
        begin
            W_R[1] <= 32'd0;
            W_I[1] <= 32'd0;
        end
    endcase
end

always @ (*)
begin
    case (W_index[2]) 
    
    3'd0: 
        begin
            W_R[2] <=  32'sd65536;
            W_I[2] <= -32'sd0;
		end 
    
    3'd4: 
        begin
            W_R[2] <=  32'sd0;
            W_I[2] <= -32'sd65536;
		end 
    
        default:
        begin
            W_R[2] <= 32'd0;
            W_I[2] <= 32'd0;
        end
    endcase
end



assign W_index_next[0] = counter[3] ? W_index[0] : W_index[0]+3'd1;
always@(posedge clk or posedge rst)
begin
	if(rst) W_index[0] <= 3'd7;
	else W_index[0] <= W_index_next[0];
end

assign W_index_next[1] = counter[2] ? W_index[1] : W_index[1]+3'd2;
always@(posedge clk or posedge rst)
begin
	if(rst) W_index[1] <= 3'd6;
	else W_index[1] <= W_index_next[1];
end

assign W_index_next[2] = counter[1] ? W_index[2] : W_index[2]+3'd4;
always@(posedge clk or posedge rst)
begin
	if(rst) W_index[2] <= 3'd4;
	else W_index[2] <= W_index_next[2];
end

endmodule