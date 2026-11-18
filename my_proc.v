// my_proc -- o processador da aula 6 com uma RAM de dados no lugar do b.
//
//                  +------------------------------------------+
//                  |                                          |
//                  v                                          |
//              +-------+                                      |
//              |  ULA  |---- resultado --->| ACC |------------+---> acc
//    +-------->|       |                     ^  ^             |
//    |   op -->|       |                        clk           |
//    |         +-------+                                      |
//    |                                                        |
//    |  dout  +-------+   din                                 |
//    +--------|  RAM  |<--------------------------------------+
//             |       |<--- addr
//             |       |<--- wr
//             +-------+
//
// A cada borda de subida:
//
//   wr = 0:  acc <= acc (op) mem[addr]        a RAM nao muda
//   wr = 1:  mem[addr] <= acc                 e o op tem de ser 111 ("nada"):
//                                             a ULA devolve o proprio acc, e o
//                                             acc recebe o valor que ja tinha
module my_proc (
    input                    clk,
    input                    rst,
    input                    wr,
    input             [ 2:0] op,
    input             [ 3:0] addr,
    output     signed [15:0] acc,
    output     signed [15:0] b          // o dado lido da RAM, para mostrar
);

    wire signed [15:0] resultado;

    ram        dados   (.clk(clk), .we(wr), .addr(addr), .din(acc), .dout(b));
    ula16s     alu     (.a(acc), .b(b), .op(op), .r(resultado));
    acumulador acc_reg (.clk(clk), .rst(rst), .d(resultado), .q(acc));

endmodule
