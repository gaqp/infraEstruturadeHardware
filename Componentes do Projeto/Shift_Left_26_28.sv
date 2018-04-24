module Shift_Left_26_28(input [25:0] entrada, output [27:0] saida);
always@*
begin
	saida = entrada << 2;
end
endmodule