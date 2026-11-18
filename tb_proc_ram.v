`timescale 1ns/1ps
// Bancada do processador com RAM: so se aperta o botao.
//
//   reset     -> pc = 0, acc = 0
//   aperto 1  -> carrega mem[0]       -> acc = 7
//   aperto 2  -> soma mem[1]          -> acc = 10
//   aperto 3  -> guarda em mem[15]    -> acc = 10, mem[15] = 10
//   aperto 4  -> carrega mem[0]       -> acc = 7
//   aperto 5  -> subtrai mem[1]       -> acc = 4
//   aperto 6  -> multiplica mem[15]   -> acc = 40
//   aperto 7  -> guarda em mem[14]    -> acc = 40, mem[14] = 40
//   aperto 8+ -> HLT na linha 7       -> o pc fica em 7, nada muda
//
// O programa vem do programa.asm, montado com o montador.py. Um reset e mais
// 8 apertos repetem a conta: a RAM nao foi zerada, mas o programa so
// reescreve mem[14] e mem[15].
module tb_proc_ram;

    reg         CLOCK_50 = 0;
    reg  [ 1:0] KEY = 2'b11;
    wire [ 6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX6, HEX7;
    wire [17:0] LEDR;
    wire [ 8:0] LEDG;

    proc_ram #(.N(4)) dut (.CLOCK_50(CLOCK_50), .KEY(KEY),
                           .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4),
                           .HEX6(HEX6), .HEX7(HEX7), .LEDR(LEDR), .LEDG(LEDG));

    always #10 CLOCK_50 = ~CLOCK_50;

    task passo;
        begin
            KEY[0] = 0; #40;  KEY[0] = 1; #30;  KEY[0] = 0; #60;  KEY[0] = 1; #20;
            KEY[0] = 0;  #2000;
            KEY[0] = 1; #50;  KEY[0] = 0; #30;  KEY[0] = 1;  #2000;
        end
    endtask

    integer k;
    initial begin
        $dumpfile("tb_proc_ram.vcd");
        $dumpvars(0, tb_proc_ram);
        KEY[1] = 0; #100; passo; KEY[1] = 1; #200;
        $display("depois do reset: pc = %2d, acc = %6d", dut.pc, dut.acc);
        for (k = 1; k <= 10; k = k + 1) begin
            $display("aperto %0d: linha %2d  jmp=%b wr=%b op=%b addr=%2d  (mem[addr] = %6d)",
                     k, dut.pc, dut.instr[8], dut.instr[7], dut.instr[6:4], dut.instr[3:0], dut.b);
            passo;
            $display("          ->  pc = %2d   acc = %6d   mem[14] = %6d   mem[15] = %6d",
                     dut.pc, dut.acc, dut.proc.dados.mem[14], dut.proc.dados.mem[15]);
        end
        $finish;
    end

endmodule
