// O processador da aula 10, agora com uma MEMORIA DE DADOS (RAM) e SALTO.
//
//          jmp, addr (destino)
//     +---------------------------+
//     v                           |
//   +----+  pc   +-----+  wr, op, addr   +---------+
//   | PC |------>| ROM |---------------->| my_proc |---> acc
//   +----+       +-----+                 |  (RAM)  |
//     ^                                  +---------+
//     |                                       ^
//     +--------------- passo -----------------+
//
// Os numeros nao estao mais no programa: estao na RAM (dados.txt). A instrucao
// diz o que fazer (op), com qual linha da RAM (addr), se e para guardar (wr)
// e se e para saltar (jmp). Num JMP o addr e a linha de destino, e o op e 101
// ("nada"): o acc e a RAM nao mudam.
//
//   KEY[0]     -> o clock: cada aperto executa a instrucao da linha atual
//   KEY[1]     -> zera o acc E o pc: SEGURE o KEY[1] e aperte o KEY[0]
//                 (a RAM NAO e zerada: o que foi escrito continua la)
//   HEX7, HEX6 -> o pc, a linha da PROXIMA instrucao (00 a 15)
//   LEDG[7:0]  -> a instrucao dessa linha: LEDG[7] = wr, LEDG[6:4] = op, LEDG[3:0] = addr
//   LEDR[17]   -> o jmp dessa instrucao
//   LEDR[15:0] -> o que esta na RAM nesse addr, em binario
//   HEX4..0    -> o acc, em decimal;  LEDG[8] acende se o acc for negativo
module proc_ram #(parameter N = 20) (
    input         CLOCK_50,
    input  [ 1:0] KEY,
    output [ 6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX6, HEX7,
    output [17:0] LEDR,
    output [ 8:0] LEDG
);

    // o clock do processador: o KEY[0], sem trepidacao (o da aula 9)
    wire passo;
    debounce #(.N(N)) db (.clk(CLOCK_50), .key_n(KEY[0]), .estavel(passo));

    wire rst = ~KEY[1];

    // o contador de programa e a memoria de programa
    wire [3:0] pc;
    wire [8:0] instr;
    contador_programa cp  (.clk(passo), .rst(rst),
                           .jmp(instr[8]), .destino(instr[3:0]), .pc(pc));
    rom               mem (.addr(pc), .dado(instr));

    // o processador, agora com a RAM dentro
    wire signed [15:0] acc, b;
    my_proc proc (.clk(passo), .rst(rst),
                  .wr(instr[7]), .op(instr[6:4]), .addr(instr[3:0]),
                  .acc(acc), .b(b));

    // o acc nos 5 displays da direita
    wire neg;
    display5 mostra (.n(acc),
                     .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4),
                     .neg(neg));

    // o pc nos 2 displays da esquerda, em decimal
    wire [3:0] dezena  = (pc >= 4'd10) ? 4'd1 : 4'd0;
    wire [3:0] unidade = (pc >= 4'd10) ? pc - 4'd10 : pc;
    dig7 d7 (.d(dezena),  .seg(HEX7));
    dig7 d6 (.d(unidade), .seg(HEX6));

    assign LEDG = {neg, instr[7:0]};     // a instrucao que o proximo aperto executa
    assign LEDR = {instr[8], 1'b0, b};   // o jmp dela e o dado da RAM que ela vai usar

endmodule
