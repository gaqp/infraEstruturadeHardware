module Controle(input clock,input reset,input [5:0] Opcode,input [5:0] Funct,output PCWriteCond,output PCWrite
				output IorD,output MemRead,output MemWrite,output MemtoReg,output IRWrite,output PCSource
				output [2:0] ULAOp,output ULASrcA,output [1:0] ULASrcB,output RegWrite,output RegDst
				output Reset);
typedef enum logic [2:0] {Reset,Busca} Estados;
Estados estadoAtual;
initial
begin
estadoAtual = Reset;
end
always_ff@(posedge clock) 
begin
	if(reset)
		begin
		estadoAtual = Reset ;
		end
	else 
		begin
		case(estadoAtual) 
			Reset:
			begin
			Reset = 1'b1;
			estadoAtual = Busca;
			end
			Busca:
			begin
			
			end
		endcase
		end
end
endmodule