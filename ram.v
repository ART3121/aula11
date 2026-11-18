// A MEMORIA DE DADOS: uma RAM de 16 palavras de 16 bits.
//
//            +-------+
//   addr --->|       |
//   din  --->|  RAM  |---> dout
//   we   --->|       |
//   clk  --->|       |
//            +-------+
//
// LEITURA ASSINCRONA, como a ROM da aula 10: o dado aparece assim que o
// endereco muda, sem clock.
//
// ESCRITA SINCRONA: so na borda de subida do clock, e so se we = 1. Entre
// uma borda e outra, o addr e o din podem mudar a vontade: nada e escrito.
//
// O conteudo inicial vem do arquivo dados.txt (16 bits por linha, em
// binario, sem separador). ATENCAO: o reset do processador NAO restaura a
// RAM. O que o programa escreveu fica escrito ate a placa ser gravada de novo.
module ram (
    input                    clk,
    input                    we,
    input             [ 3:0] addr,
    input      signed [15:0] din,
    output     signed [15:0] dout
);

    reg signed [15:0] mem [0:15];       // 16 linhas de 16 bits

    initial $readmemb("dados.txt", mem);

    always @(posedge clk) begin
        if (we) mem[addr] <= din;       // escrita sincrona
    end

    assign dout = mem[addr];            // leitura assincrona

endmodule
