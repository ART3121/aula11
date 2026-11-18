# Código da aula 11: memória RAM

O processador da aula 10 com uma memória de dados. Os números saem do programa e vão para a RAM; a
instrução só diz o que fazer, com qual linha da RAM, e se é para guardar o `acc` nela.

| Arquivo | O que é |
|---|---|
| `ram.v` | a memória de dados: 16 linhas de 16 bits, leitura assíncrona, escrita síncrona |
| `dados.txt` | o conteúdo inicial da RAM: a = 7 na linha 0, b = 3 na linha 1 |
| `tb_ram.v` | bancada da RAM sozinha: lê, escreve, e mostra que sem `we` nada é escrito |
| `rom.v` | a memória de programa, agora com palavras de 9 bits |
| `programa.asm` | (a + b)(a − b): o `acc` termina em 40 e o programa para na linha 7 |
| `programa.txt` | o `programa.asm` montado pelo `montador.py`: é este que a ROM lê |
| `soma_sucessiva.asm` | exemplo de laço: 3, 6, 9, 12... (precisa de mem[0] = 3) |
| `montador.py` | converte um `.asm` ou `.txt` em `programa.txt` |
| `contador_programa.v` | o pc, agora com salto: `jmp = 1` carrega o `destino` em vez de somar 1 |
| `ula16s.v` | a ULA com 3 bits de `op` e a operação "carrega" (`op = 100`, r = b) |
| `acumulador.v` | o acumulador da aula 10, sem mudança: na instrução que guarda, o `op` é 111 e ele recebe ele mesmo |
| `my_proc.v` | ULA, acumulador e RAM ligados |
| `proc_ram.v` | o topo da placa |
| `tb_proc_ram.v` | bancada: 10 apertos com o botão trepidando |
| `debounce.v`, `display5.v`, `decimal16_dabble.v`, `dig7.v` | os das aulas anteriores, sem mudança |

## O formato da instrução

Uma instrução por linha, 9 bits em binário: `jmp` (1 bit), `wr` (1 bit), `op` (3 bits), `addr` (4 bits).
Os 5 bits de cima são o opcode:

| Instrução | Opcode | Faz |
|---|---|---|
| `ADD n` | `00000` | acc + mem[n] |
| `SUB n` | `00001` | acc − mem[n] |
| `MLT n` | `00010` | acc × mem[n] |
| `DIV n` | `00011` | acc ÷ mem[n] |
| `LOD n` | `00100` | acc recebe mem[n] |
| `NOP` | `00101` | não faz nada |
| `SET n` | `01101` | mem[n] recebe o acc |
| `JMP n` | `10101` | a próxima instrução é a da linha n |
| `HLT` | `10101` | JMP para a própria linha: o pc para ali |

Os campos `wr` e `op`, bit a bit:

| `op` | Faz |
|---|---|
| `000` | soma: acc + mem[addr] |
| `001` | subtrai: acc − mem[addr] |
| `010` | multiplica: acc × mem[addr] |
| `011` | divide: acc ÷ mem[addr] |
| `100` | carrega: acc recebe mem[addr] |
| `101`, `110`, `111` | não faz nada |

Com `wr = 1`, a instrução guarda o `acc` em mem[addr]. O `op` tem de ser um "nada" da ULA (o SET usa
`101`): assim o `acc` recebe ele mesmo e não muda. Com outro `op`, o `acc` faria a conta na mesma borda.

Com `jmp = 1`, o `addr` é a linha de destino e o `op` é `101`: o `acc` e a RAM não mudam.

## O montador

Escreva o programa em assembly, uma instrução por linha, com o endereço em decimal (0 a 15). Comentários
começam com `;`, `#` ou `//`.

```
LOD 0       ; acc = mem[0]
ADD 0       ; acc = acc + mem[0]
JMP 1       ; volta para o ADD
```

e monte:

```
python3 montador.py soma_sucessiva.asm               # gera programa.txt na mesma pasta
python3 montador.py soma_sucessiva.asm -o outro.txt
```

As linhas que sobram até 16 viram NOP. Se o programa não termina em HLT nem em JMP, o pc passa pelos NOP e
volta à linha 0.

O `dados.txt` continua escrito à mão: 16 bits por linha, as 16 linhas, sem `_` no meio do número.

## Na placa

Abra `quartus/proc_ram.qpf`, compile e grave.

| Na placa | O que faz |
|---|---|
| `KEY[0]` | executa a instrução da linha atual e avança o pc |
| `KEY[1]` | zera o pc e o `acc`: **segure o `KEY[1]` e aperte o `KEY[0]`** |
| `HEX7`, `HEX6` | o pc: a linha da próxima instrução |
| `LEDG[7:0]` | a instrução dessa linha: `LEDG[7]` é o `wr`, `LEDG[6:4]` o `op`, `LEDG[3:0]` o `addr` |
| `LEDR[17]` | o `jmp` dessa instrução |
| `LEDR[15:0]` | o que está na RAM nesse `addr` |
| `HEX4` a `HEX0` | o `acc`, em decimal |
| `LEDG[8]` | aceso: o `acc` é negativo |

Zere e aperte sete vezes. O `acc` deve passar por 7, 10, 10, 7, 4, 40 e 40. A partir do oitavo aperto o
pc fica em 07: é o HLT.

**O reset não restaura a RAM.** O que o programa escreveu continua lá até a placa ser gravada de novo.
Por isso as constantes ficam nas linhas de cima e as variáveis nas de baixo.

## Na simulação

As bancadas usam o filtro com `N = 4`. Rodem a simulação na pasta onde estão o `programa.txt` e o
`dados.txt`: é lá que o `$readmemb` procura os arquivos.

## Dois avisos de sempre

1. O código dos slides pode ser copiado do PDF: o apóstrofo das constantes sai reto. Os mesmos arquivos estão nesta pasta.
2. Deixem o projeto fora do OneDrive, numa pasta simples como `C:\fpga`.

Prof. Luciano Manhães de Andrade Filho, CEL110 Dispositivos Lógicos Programáveis, UFJF, 2026-3
