module Mux_2_1_5Bits(input [4:0] zero, input [4:0] um, input seletor, output [4:0] saida);
// Multiplexador de 2 entradas de 5 bits
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