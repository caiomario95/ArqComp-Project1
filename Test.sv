module testbenchULA32;
// Entradas
reg [31:0] A;
reg [31:0] B;
reg [2:0] F;
// SAidas
wire [31:0] Saida;
wire Zero, Overflow;
reg clk;
reg [31:0] vectornum, Erros;
reg [100:0] testvectors[10000:0];
reg [31:0] SaidaEsperada;
reg ZeroEsperado;
reg OverflowEsperado;
// Iniciando Ula a ser testada
alu32 uut (A, B, F, Saida, Zero, Overflow); 
// Gerando clok
always 
begin
	clk = 1; #5; clk = 0; #5;
end

// Carrega o vetor de testes contido no arquivo "ArqTestes.txt"
initial begin
	$readmemh("ArqTestes.txt", testvectors);
	vectornum = 0; Erros = 0;
end

always @ (posedge clk)
begin
	#1; {OverflowEsperado, ZeroEsperado, F, A, B, SaidaEsperada} = testvectors[vectornum];
end
// Verifica os resultados na queda do clk
always @(negedge clk)
begin
	if ({Saida, Zero, Overflow} !== {SaidaEsperada, ZeroEsperado, OverflowEsperado})
	begin 
		$display("Error: inputs: F = %h, A = %h,
		B = %h", F, A, B);
		$display(" Y = %h, Zero = %b 
		Overflow = %b\n (Saida Esperada = %h, Zero Esperado = %b, Overflow Esperado = %b)", Saida, Zero, Overflow, 
		SaidaEsperada, ZeroEsperado, 
		OverflowEsperado);
		Erros = Erros + 1;
	end
	vectornum = vectornum + 1;
	if (testvectors[vectornum] === 101'hx) 
	begin 
		$display("%d TESTE FINALIZADO COM %d ERROS", vectornum, Erros);
		$finish;
	end
end
endmodule
