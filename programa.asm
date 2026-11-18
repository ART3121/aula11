; (a + b) * (a - b), com a = mem[0] e b = mem[1] (dados.txt)
; Monte com: python3 montador.py programa.asm   -> programa.txt
;
;                  acc depois   RAM
LOD 0       ; 0    7
ADD 1       ; 1    10
SET 15      ; 2    10           mem[15] = 10
LOD 0       ; 3    7
SUB 1       ; 4    4
MLT 15      ; 5    40
SET 14      ; 6    40           mem[14] = 40
HLT         ; 7    40           o pc fica parado na linha 7
