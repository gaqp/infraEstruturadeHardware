module Controle(input clock, input reset, input [5:0] Opcode, input [5:0] Funct);
typedef enum logic [2:0] {A,B,C,D,E,F} Estados;
Estados estadoAtual;
initial
begin
estadoAtual = A;
end
always_ff@(posedge clock) 
begin
	if(reset)
		begin
		estadoAtual = A;
		end
	else 
		begin
		case(estadoAtual) 
			A:
			begin
			RST = 5'b11111;
			estadoAtual = B;
			end
			B:
			begin
			RST = 1'b0;
			estadoAtual = C;
			end
			C:
			begin
			RST = 32'b11111111111111111111111111111111;
			estadoAtual = D;
			end
			D:
			begin
			RST = 3'b010;
			estadoAtual = A;
			end
		endcase
		end
end
endmodule