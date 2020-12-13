// Copyright (c) 2012 Ben Reynwar
// Released under MIT License (see LICENSE.txt)

module twiddlefactors (
    input  [5:0] counter,
    output reg signed [31:0] W_R[3:0],
    output reg signed [31:0] W_I[3:0]
  );


always @ (*)
begin
    case (W_index[0])
	
    4'd0: 
        begin
            W_R[0] <=  32'sd65536;
            W_I[0] <= -32'sd0;
		end
    
    4'd1: 
        begin
            W_R[0] <=  32'sd64276;
            W_I[0] <= -32'sd12785;
		end
    
    4'd2: 
        begin
            W_R[0] <=  32'sd60547;
            W_I[0] <= -32'sd25079;
		end
    
    4'd3: 
        begin
            W_R[0] <=  32'sd54491;
            W_I[0] <= -32'sd36409;
		end
    
    4'd4: 
        begin
            W_R[0] <=  32'sd46340;
            W_I[0] <= -32'sd46340;
		end
    
    4'd5: 
        begin
            W_R[0] <=  32'sd36409;
            W_I[0] <= -32'sd54491;
		end
    
    4'd6: 
        begin
            W_R[0] <=  32'sd25079;
            W_I[0] <= -32'sd60547;
		end
    
    4'd7: 
        begin
            W_R[0] <=  32'sd12785;
            W_I[0] <= -32'sd64276;
		end
    
    4'd8: 
        begin
            W_R[0] <=  32'sd0;
            W_I[0] <= -32'sd65536;
		end
    
    4'd9: 
        begin
            W_R[0] <= -32'sd12785;
            W_I[0] <= -32'sd64276;
		end
    
    4'd10: 
        begin
            W_R[0] <= -32'sd25079;
            W_I[0] <= -32'sd60547;
		end
    
    4'd11: 
        begin
            W_R[0] <= -32'sd36409;
            W_I[0] <= -32'sd54491;
		end
    
    4'd12: 
        begin
            W_R[0] <= -32'sd46340;
            W_I[0] <= -32'sd46340;
		end
    
    4'd13: 
        begin
            W_R[0] <= -32'sd54491;
            W_I[0] <= -32'sd36409;
		end
    
    4'd14: 
        begin
            W_R[0] <= -32'sd60547;
            W_I[0] <= -32'sd25079;
		end
    
    4'd15: 
        begin
            W_R[0] <= -32'sd64276;
            W_I[0] <= -32'sd12785;
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
	
    4'd0: 
        begin
            W_R[1] <=  32'sd65536;
            W_I[1] <= -32'sd0;
		end
    
    4'd2: 
        begin
            W_R[1] <=  32'sd60547;
            W_I[1] <= -32'sd25079;
		end
    
    4'd4: 
        begin
            W_R[1] <=  32'sd46340;
            W_I[1] <= -32'sd46340;
		end
    
    4'd6: 
        begin
            W_R[1] <=  32'sd25079;
            W_I[1] <= -32'sd60547;
		end
    
    4'd8: 
        begin
            W_R[1] <=  32'sd0;
            W_I[1] <= -32'sd65536;
		end
    
    4'd10: 
        begin
            W_R[1] <= -32'sd25079;
            W_I[1] <= -32'sd60547;
		end
    
    4'd12: 
        begin
            W_R[1] <= -32'sd46340;
            W_I[1] <= -32'sd46340;
		end
    
    4'd14: 
        begin
            W_R[1] <= -32'sd60547;
            W_I[1] <= -32'sd25079;
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
	
    4'd0: 
        begin
            W_R[2] <=  32'sd65536;
            W_I[2] <= -32'sd0;
		end
    
    4'd4: 
        begin
            W_R[2] <=  32'sd46340;
            W_I[2] <= -32'sd46340;
		end
    
    4'd8: 
        begin
            W_R[2] <=  32'sd0;
            W_I[2] <= -32'sd65536;
		end
    
    4'd12: 
        begin
            W_R[2] <= -32'sd46340;
            W_I[2] <= -32'sd46340;
		end
    
        default:
        begin
            W_R[2] <= 32'd0;
            W_I[2] <= 32'd0;
        end
    endcase
end

always @ (*)
begin
    case (W_index[3])
	
    4'd0: 
        begin
            W_R[3] <=  32'sd65536;
            W_I[3] <= -32'sd0;
		end
    
    4'd8: 
        begin
            W_R[3] <=  32'sd0;
            W_I[3] <= -32'sd65536;
		end
    
        default:
        begin
            W_R[3] <= 32'd0;
            W_I[3] <= 32'd0;
        end
    endcase
end



assign W_index_next[0] = counter[4] ? W_index[0] : W_index[0]+4'd1;
always@(posedge clk or posedge rst)
begin
	if(rst) W_index[0] <= 4'd15;
	else W_index[0] <= W_index_next[0];
end

assign W_index_next[1] = counter[3] ? W_index[1] : W_index[1]+4'd2;
always@(posedge clk or posedge rst)
begin
	if(rst) W_index[1] <= 4'd14;
	else W_index[1] <= W_index_next[1];
end

assign W_index_next[2] = counter[2] ? W_index[2] : W_index[2]+4'd4;
always@(posedge clk or posedge rst)
begin
	if(rst) W_index[2] <= 4'd12;
	else W_index[2] <= W_index_next[2];
end

assign W_index_next[3] = counter[1] ? W_index[3] : W_index[3]+4'd8;
always@(posedge clk or posedge rst)
begin
	if(rst) W_index[3] <= 4'd8;
	else W_index[3] <= W_index_next[3];
end


endmodule