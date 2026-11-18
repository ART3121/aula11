// A ULA de 16 bits com sinal, agora com 3 bits de op e uma operacao nova:
// CARREGA, que ignora o a e passa o b direto para a saida.
//
//   op = 000  soma        r = a + b
//   op = 001  subtrai     r = a - b
//   op = 010  multiplica  r = a * b
//   op = 011  divide      r = a / b
//   op = 100  carrega     r = b      (o a nao entra na conta)
//   op = 101, 110, 111    r = a      (nao faz nada: o acc fica como esta)
//
// As quatro primeiras sao as de sempre, com um 0 na frente.
module ula16s (
    input      signed [15:0] a,
    input      signed [15:0] b,
    input             [ 2:0] op,
    output reg signed [15:0] r
);

    always @(*) begin
        case (op)
            3'b000:  r = a + b;
            3'b001:  r = a - b;
            3'b010:  r = a * b;
            3'b011:  r = a / b;
            3'b100:  r = b;
            default: r = a;
        endcase
    end

endmodule
