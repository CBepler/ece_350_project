start_loop:
lw $r1, 0($r0)  #load in buttons value

addi $r2, $r0, 2
mul $r1, $r1, $r2

sw $r1, 1($r0)  #store buttons value

j start_loop

