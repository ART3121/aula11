// A MEMORIA DE PROGRAMA: agora com palavras de 9 bits.
//
//   dado[8]   = jmp   (1: o pc salta para addr em vez de andar uma linha)
//   dado[7]   = wr    (1: guarda o acc na RAM)
//   dado[6:4] = op    (a operacao da ULA)
//   dado[3:0] = addr  (o endereco da RAM, ou a linha de destino do JMP)
//
// Os 5 bits de cima formam o opcode:
//
//   ADD 00000   SUB 00001   MLT 00010   DIV 00011
//   LOD 00100   NOP 00101   SET 01101   JMP 10101   (HLT = JMP para a propria linha)
module rom (
    input  [3:0] addr,
    output [8:0] dado
);

    reg [8:0] mem [0:15];           // 16 linhas de 9 bits

    initial $readmemb("programa.txt", mem);

    assign dado = mem[addr];        // leitura assincrona: sem clock

endmodule
