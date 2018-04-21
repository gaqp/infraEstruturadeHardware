module Extensor_Sinal(input [15:0] entrada, output [31:0] saida);
// Recebe um vetor de 16 bits e converte o n�mero recebido para 31 bits
// A convers�o � feita transformando os bits [31:16] no bit mais significativo
// Da entrada recebida (o bit [15] da entrada).
always@*
begin
	if(entrada[15] == 0 )
	begin
		saida = {16'b0000000000000000,entrada};
	end
	else
	begin
		saida = {16'b1111111111111111,entrada};
	end
end
endmodule