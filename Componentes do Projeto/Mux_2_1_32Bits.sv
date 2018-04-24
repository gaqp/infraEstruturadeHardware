module Mux_2_1_32Bits(input [31:0] zero, input [31:0] um, input seletor, output [31:0] saida);
// Multiplexador de 2 entradas de 32 bits
always@*
begin
	case(seletor)
	1'b0:
	begin
		saida = zero;
	end
	1'b1:
	begin
		saida = um;
	end
	endcase
end
endmodule