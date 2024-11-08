addi $r1, $r0, 1       # r1 = 1
addi $r2, $r0, 2       # r2 = 2
addi $r3, $r0, 3       # r3 = 3
addi $r4, $r0, 4       # r4 = 4
add $r5, $r1, $r2      # r5 = 3
add $r6, $r5, $r3      # r6 = 6 (uses r5 from previous instruction, MEM->EX bypass)
add $r7, $r3, $r4      # r7 = 7
add $r8, $r7, $r1      # r8 = 8 (uses r7 from previous instruction)
add $r9, $r8, $r2      # r9 = 10 (uses r8 from previous instruction)
addi $r10, $r0, 100    # Set up base address
sw $r1, 0($r10)        # Store 1 to memory
sw $r2, 4($r10)        # Store 2 to memory
lw $r11, 0($r10)       # Load 1 from memory
add $r12, $r11, $r3    # Use loaded value immediately
lw $r13, 4($r10)       # Load 2 from memory
sw $r13, 8($r10)       # Store value just loaded (uses MEM->EX bypass)
lw $r14, 0($r10)       # Load from address 100
add $r15, $r14, $r1    # Use loaded value (MEM->EX bypass)
sw $r15, 12($r10)      # Store computed value
lw $r16, 12($r10)      # Load the stored result
add $r17, $r16, $r2    # Use loaded value (MEM->EX bypass)
addi $r18, $r0, 200    # New base address
sw $r3, 0($r18)        # Store 3 to memory
lw $r19, 0($r18)       # Load 3 from memory
add $r20, $r19, $r4    # Use loaded value (MEM->EX bypass)
lw $r21, 0($r10)       # Load from first address
lw $r22, 4($r10)       # Load from second address
add $r23, $r21, $r22   # Use both loaded values (MEM->EX bypass for r21)
add $r24, $r1, $r2     # r24 = 3
sw $r24, 16($r10)      # Store result
lw $r25, 16($r10)      # Load the stored value
add $r26, $r25, $r3    # Use loaded value (MEM->EX bypass)
add $r27, $r1, $r2     # r27 = 3
sw $r27, 20($r10)      # Store sum
lw $r28, 20($r10)      # Load sum back
add $r29, $r28, $r3    # Use loaded value (MEM->EX bypass)
sw $r29, 24($r10)      # Store new result
lw $r30, 24($r10)      # Load new result
add $r31, $r30, $r4    # Use loaded value (MEM->EX bypass)