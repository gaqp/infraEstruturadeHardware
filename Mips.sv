module Mips(clk,reset,PC_O,ULA_O,IR_O,MEM_O,JUMP_O,Estado_Controle_O,OpCode_O,PCSouce_O);
//INPUTS
input clk;
input reset;
output [31:0] PC_O;
assign PC_O = PC_Saida_S;
output [31:0] ULA_O;
assign ULA_O = ULA_Resultado_S;
output [31:0] IR_O;
assign IR_O = {Instr31_26_S,Instr25_21_S,Instr20_16_S,Instr15_0_S};
output [31:0] MEM_O;
assign MEM_O = Memoria_Saida_S;
output [31:0] JUMP_O;
assign JUMP_O = SL_Jump_PC_S;
output [4:0] Estado_Controle_O; 
output [5:0] OpCode_O;
assign OpCode_O = Instr31_26_S;
output [1:0] PCSouce_O;
assign PCSource_O = PCSource;
//FIM DOS INPUTS
and AND (AND_S,ULA_Zero_S,PCWriteCond);
or OR   (OR_S,PCWrite,AND_S);
//Unidade de controle
logic Reset;
logic MemRW;
logic ULASrcA;
logic [1:0] ULASrcB;
logic [2:0] ULAOp;
logic PCWrite;
logic PCWriteCond;
logic [1:0] PCSource;
logic IorD;
logic IRWrite;
logic RESET;
Controle CONTROLE(.clk(clk),.Opcode(Instr31_26_S),.Funct(Instr5_0_S),.MemRW(MemRW),.ULASrcA(ULASrcA),.ULASrcB(ULASrcB),.ULAOp(ULAOp),.PCWrite(PCWrite),
				  .PCWriteCond(PCWriteCond),.PCSource(PCSource),.IorD(IorD),.IRWrite(IRWrite),.RESET(RESET),.reset(reset),.estadoControle(Estado_Controle_O));
//Fim da Unidade de controle
//Registrador PC
logic [31:0] PC_Saida_S;
logic PC_Escreve_C;
logic PC_Reset_C;
Registrador PC(.Clk(clk),.Reset(RESET),.Load(OR_S),.Entrada(MUX_PC_S),.Saida(PC_Saida_S));
//Fim do registrador PC
//Multiplexador da mem�ria
logic [31:0] Mux_Memoria_S;
Mux_2_1_32Bits MUX_MEMORIA(.zero(PC_Saida_S),.um(Reg_ALU_S),.seletor(IorD),.saida(Mux_Memoria_S));
//FIM do Multiplexador da mem�ria
//Mem�ria
logic [31:0] Memoria_Saida_S;
Memoria MEMORIA(.Clock(clk),.Wr(MemRW),.Address(PC_Saida_S),.Datain(Reg_B_S),.DataOut(Memoria_Saida_S));
//Fim da Mem�ria
//MDR
logic [31:0] MDR_Saida_S;
Registrador MDR(.Clk(clk),.Reset(RESET),.Load(),.Entrada(Memoria_Saida_S),.Saida(MDR_Saida_S));
//Fim do MDR
//Registrador de instru��es
logic [5:0] Instr31_26_S;
logic [4:0] Instr25_21_S;
logic [4:0] Instr20_16_S;
logic [15:0] Instr15_0_S;
Instr_Reg REG_INST(.Clk(clk),.Reset(RESET),.Load_ir(IRWrite),.Entrada(Memoria_Saida_S),.Instr15_0(Instr15_0_S),
				   .Instr20_16(Instr20_16_S),.Instr25_21(Instr25_21_S),.Instr31_26(Instr31_26_S));
logic [25:0] Instr25_0_S;
assign Instr25_0_S = {Instr25_21_S,Instr20_16_S,Instr15_0_S};
logic [4:0] Instr15_11_S;
assign Instr15_11_S = {Instr15_0_S[15:11]};
logic [5:0] Instr5_0_S;
assign Instr5_0_S = {Instr15_0_S[5:0]};
//Fim do registrador de instru��es
//Multiplexador seletor de escrita  no registrador
logic [4:0] Mux_SEL_REG_S;
Mux_2_1_5Bits MUX_SEL_REG(.zero(Instr20_16_S),.um(Instr15_11_S),.seletor(),.saida(Mux_SEL_REG_S));
//Fim do Multiplexador seletor de escrita  no registrador
//Multiplexador seletor de dado a ser escrito na mem�ria
logic [31:0] Mux_Escrita_S;
Mux_2_1_32Bits MUX_ESCRITA(.zero(),.um(MDR_Saida_S),.seletor(),.saida(Mux_Escrita_S));
// Fim do Multiplexador seletor de dado a ser escrito na mem�ria
//Extensor de sinal
logic [31:0] Extensor_Sinal_S;
Extensor_Sinal EXTENSOR_SINAL(.entrada(Instr15_0_S),.saida(Extensor_Sinal_S));
//Fim do extensor de sinal
//ShiftLeft do extensor de sinal
logic [31:0] SL_Extensor_S;
Shift_Left_32_32 SL_EXTENSOR(.entrada(Extensor_Sinal_S),.saida(SL_Extensor_S));
// Fim do ShiftLeft do extensor de sinal
//Banco de registradores
logic [31:0] Banco_Reg_Data_1_S;
logic [31:0] Banco_Reg_Data_2_S;
Banco_reg BANCO_REG(.Clk(clk),.Reset(RESET),.RegWrite(),.ReadReg1(Instr25_21_S),.ReadReg2(Instr20_16_S),
					.WriteReg(Mux_SEL_REG_S),.WriteData(Mux_Escrita_S),.ReadData1(Banco_Reg_Data_1_S),
					.ReadData2(Banco_Reg_Data_2_S));
//Fim do banco de registradores
//Registrador A
logic [31:0] Reg_A_S;
Registrador REG_A(.Clk(clk),.Reset(RESET),.Load(),.Entrada(Banco_Reg_Data_1_S),.Saida(Reg_A_S));
//Fim do registrador A
//Registrador B
logic [31:0] Reg_B_S;
Registrador REG_B(.Clk(clk),.Reset(RESET),.Load(),.Entrada(Banco_Reg_Data_2_S),.Saida(Reg_B_S));
//Fim do registrador B
//Mux ULA A
logic [31:0] Mux_ULA_A_S;
Mux_2_1_32Bits MUX_ULA_A(.zero(PC_Saida_S),.um(Reg_A_S),.seletor(ULASrcA),.saida(Mux_ULA_A_S));
//Fim do mux ULA A
//Mux ULA B
logic [31:0] Mux_ULA_B_S;
Mux_4_1_32Bits MUX_ULA_B(.zero(Reg_B_S),.um(3'b100),.dois(Extensor_Sinal_S),.tres(SL_Extensor_S),
						 .seletor(ULASrcB),.saida(Mux_ULA_B_S));
//Fim do mux ULA B
//Shift left endere�o Jump
logic [27:0] SL_Jump_S;
Shift_Left_26_28 SL_JUMP(.entrada(Instr25_0_S),.saida(SL_Jump_S));
	//Concatena o valor do jump com os 4 primeiros bits do pc
logic [31:0] SL_Jump_PC_S;
assign SL_Jump_PC_S = {PC_Saida_S[31:28],SL_Jump_S};
	//Concatenou :)
//Fim do Shift left endere�o Jump
//ULA
logic [31:0] ULA_Resultado_S;
logic ULA_Overflow_S;
logic ULA_Negativo_S;
logic ULA_Zero_S;
logic ULA_Igual_S;
logic ULA_Maior_S;
logic ULA_Menor_S;
ula32 ULA(.A(Mux_ULA_A_S),.B(Mux_ULA_B_S),.Seletor(ULAOp),.S(ULA_Resultado_S),.Overflow(ULA_Overflow_S),
		  .Negativo(ULA_Negativo_S),.z(ULA_Zero_S),.Igual(ULA_Igual_S),.Maior(ULA_Maior_S),.Menor(ULA_Menor_S));
//Fim da ULA
//Mux PC
logic [31:0] MUX_PC_S;
Mux_4_1_32Bits MUX_PC(.zero(ULA_Resultado_S),.um(Reg_ALU_S),.dois(SL_Jump_PC_S),.tres(),.saida(MUX_PC_S),.seletor(PCSource));
//Fim do Mux PC
//Registrador ALU
logic [31:0] Reg_ALU_S;
Registrador REG_ALU(.Clk(clk),.Reset(RESET),.Load(),.Entrada(ULA_Resultado_S),.Saida(Reg_ALU_S));
//Fim do registrador ALU
endmodule 