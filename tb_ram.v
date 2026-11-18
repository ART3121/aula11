`timescale 1ns/1ps
// Bancada da RAM sozinha: escreve, le, e mostra que sem borda (ou com we = 0)
// nada e escrito.
module tb_ram;

    reg                clk = 0;
    reg                we  = 0;
    reg         [ 3:0] addr = 0;
    reg  signed [15:0] din  = 0;
    wire signed [15:0] dout;

    ram dut (.clk(clk), .we(we), .addr(addr), .din(din), .dout(dout));

    always #10 clk = ~clk;

    initial begin
        $dumpfile("tb_ram.vcd");
        $dumpvars(0, tb_ram);

        // 1) leitura: o dout segue o addr, sem esperar o clock
        #3  addr = 0;  #1 $display("le   mem[0]  = %6d   (do dados.txt)", dout);
            addr = 1;  #1 $display("le   mem[1]  = %6d   (do dados.txt)", dout);
            addr = 5;  #1 $display("le   mem[5]  = %6d", dout);

        // 2) com we = 0, a borda passa e nada e escrito
        din = 123; @(posedge clk); #1
        $display("we=0 mem[5]  = %6d   (a borda passou, nada mudou)", dout);

        // 3) com we = 1, escreve na borda
        we = 1; @(posedge clk); #1 we = 0;
        $display("we=1 mem[5]  = %6d   (escrito na borda)", dout);

        // 4) a escrita nao mexe nas outras linhas
        addr = 6;  #1 $display("le   mem[6]  = %6d", dout);
        addr = 0;  #1 $display("le   mem[0]  = %6d", dout);

        // 5) escrever um negativo e ler de volta
        addr = 15; din = -42; we = 1; @(posedge clk); #1 we = 0;
        $display("we=1 mem[15] = %6d", dout);
        addr = 5;  #1 $display("le   mem[5]  = %6d   (continua la)", dout);

        $finish;
    end

endmodule
