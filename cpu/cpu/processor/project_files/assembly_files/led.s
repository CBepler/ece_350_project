start_loop:
lw $r1, 0($r0)  #load in buttons value

sw $r1, 1($r0)  #store buttons value

j start_loop

