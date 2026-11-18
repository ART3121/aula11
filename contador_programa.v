// O CONTADOR DE PROGRAMA (PC, de "program counter"): diz em que linha da ROM
// esta a proxima instrucao. A cada aperto do botao, anda uma linha, ou SALTA
// para a linha destino se a instrucao atual for um JMP.
//
//   rst = 1           -> pc <= 0
//   jmp = 1           -> pc <= destino
//   senao             -> pc <= pc + 1
//
// O reset e sincrono, como o do acumulador: zera junto com ele, no mesmo aperto.
// O HLT e um JMP para a propria linha: o pc fica parado nela.
module contador_programa (
    input            clk,
    input            rst,
    input            jmp,
    input      [3:0] destino,
    output reg [3:0] pc
);

    always @(posedge clk) begin
        if      (rst) pc <= 4'd0;
        else if (jmp) pc <= destino;
        else          pc <= pc + 4'd1;     // depois da linha 15 volta para a 0
    end

endmodule
