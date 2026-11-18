; Somas sucessivas: acc = 3, 6, 9, 12, ...
; Precisa de mem[0] = 3 no dados.txt.
; Monte com: python3 montador.py soma_sucessiva.asm
LOD 0       ; acc = mem[0]
ADD 0       ; acc = acc + mem[0]
JMP 1       ; volta para o ADD
