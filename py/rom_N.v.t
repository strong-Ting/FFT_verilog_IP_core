// Copyright (c) 2012 Ben Reynwar
// Released under MIT License (see LICENSE.txt)

module twiddlefactors (
    input  [{{Nlog2}}:0] counter,
    output reg signed [{{tf_width-1}}:0] W_R[{{Nlog2 -2}}:0],
    output reg signed [{{tf_width-1}}:0] W_I[{{Nlog2 -2}}:0]
  );

{% for i in range(0,Nlog2-1) %}
always @ (*)
begin
    case (W_index[{{i}}])
	{% for j in range(0,N//2,2**(i)) %}
    {{Nlog2-1}}'d{{tfs[j].i}}: 
        begin
            W_R[{{i}}] <= {{tfs[j].re_sign}}{{tf_width}}'sd{{tfs[j].re}};
            W_I[{{i}}] <= {{tfs[j].im_sign}}{{tf_width}}'sd{{tfs[j].im}};
		end
    {% endfor %}
        default:
        begin
            W_R[{{i}}] <= {{tf_width}}'d0;
            W_I[{{i}}] <= {{tf_width}}'d0;
        end
    endcase
end
{% endfor %}

{% for i in range(0,Nlog2-1) %}
assign W_index_next[{{i}}] = counter[{{Nlog2-1-i}}] ? W_index[{{i}}] : W_index[{{i}}]+{{Nlog2-1}}'d{{2**i}};
always@(posedge clk or posedge rst)
begin
	if(rst) W_index[{{i}}] <= {{Nlog2-1}}'d{{2**(Nlog2-1)-2**(i)}};
	else W_index[{{i}}] <= W_index_next[{{i}}];
end
{% endfor %}

endmodule
