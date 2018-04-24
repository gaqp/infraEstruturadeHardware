module Shift_Left_32_32(input [31:0] entrada, output [31:0] saida);
always@*
begin
	saida = entrada << 2;
end
endmodule