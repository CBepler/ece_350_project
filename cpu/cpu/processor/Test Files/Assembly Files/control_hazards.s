nop
nop
nop
nop
nop
nop
addi $r10, $r0, 0      # Counter
addi $r16, $r0, 5      # Test value 1
addi $r17, $r0, 3      # Test value 2
addi $r18, $r0, 1      # Test value 3
j jump_test
addi $r10, $r10, 10    # Should be skipped
nop
nop
jump_test: addi $r10, $r10, 1     # Counter = 1
bne $r16, $r17, bne_test   # 5 != 3, should branch
addi $r10, $r10, 10    # Should be skipped
nop
nop
bne_test: addi $r10, $r10, 1     # Counter = 2
jal jal_test           # Jump to subroutine
nop                    # Delay slot
addi $r10, $r10, 1     # Will execute after returning (Counter = 4)
blt $r17, $r16, blt_test #3<5 branch
addi $r10, $r10, 10    # Should be skipped
nop
nop
blt_test: j end_program
nop
nop
jal_test: addi $r10, $r10, 1     # Counter = 3
jr $r31                # Return using jr
nop                    # Delay slot
end_program: nop
nop

# Final register states should be:
# $r10 = 4 (counter)
# $r16 = 5 (test value 1)
# $r17 = 3 (test value 2)
# $r18 = 1 (test value 3)
# $r31 = 21
# All other registers = 0