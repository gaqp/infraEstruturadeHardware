module Mips(clk);
//INPUTS
input clk;
//FIM DOS INPUTS
logic [31:0] PC_Saida_S;
//PC_Saida_S Fio com a saida do pc
logic PC_Escreve_C;
//PC_Escreve_C Fio que controla a escrita no pc
logic [31:0] PC_Entrada_E;
//PC_Entrada_E Fio de entrada do pc
logic PC_Reset_C;
//PC_Reset_C Fio Fio que controla o reset do pc
Registrador PC(.Clk(clk),.Reset(),.Load(PC_Escreve_C),.Entrada(PC_Entrada_E),.Saida(PC_Saida_S));
//Multiplexador da mem�ria
logic [31:0] Mux_Memoria_S;
Mux_2_1_32Bits MUX_MEMORIA(.zero(PC_Saida_S),.um(),.seletor(),.saida(Mux_Memoria_S));
//FIM do Multiplexador da mem�ria
//Mem�ria
logic Memoria_Saida_S;
Memoria MEMORIA(.Clock(clk),.Wr(),.WritaData(),.DataIn(Mux_Memoria_S),.DataOut(Memoria_Saida_S));
//Fim da Mem�ria
//Registrador de instru��es
logic [5:0] Instr31_26_S;
logic [4:0] Instr25_21_S;
logic [4:0] Instr20_16_S;
logic [15:0] Instr15_0_S;
Instr_Reg REG_INST(.Clk(clk),.Reset(),.Load_ir(),.Entrada(Memoria_Saida_S),.Instr15_0(Instr15_0_S),.Instr20_16(Instr20_16_S),.Instr25_21(Instr25_21_S),.Instr31_26(Instr31_26_S));
logic [25:0] Instr25_0_S;
assign Instr25_0_S = {Instr25_21_S,Instr20_16_S,Instr15_0_S};
logic [4:0] Instr15_11_S;
assign Instr15_11_S = {Instr15_0_S[15:11]};
//Fim do registrador de instru��es

endmodule 