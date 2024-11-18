#memory address 0 is buttons
# 1 is game done
# 100 - 199 is local x
# 200 -299 is local y
# 300 - 399 is vga x
# 400 - 499 is vga y

sw $r0, 100($r0)  #100 is local x of box
sw $r0, 200($r0)  #200 is local y of box

sw $r0, 1($r0) #zero out game_done

start_loop:
lw $r1, 0($r0)  #load in buttons value
lw $r2, 100($r0) #load local x
lw $r3, 101($r0) #load local y
addi $r4, $r0, 1 #button checker

bne $r1, $r4, not_up
addi $r3, $r3, -1
j button_done
not_up:

addi $r4, $r4, 1
bne $r1, $r4, not_right
addi $r2, $r2, 1
j button_done
not_right:

addi $r4, $r4, 1
bne $r1, $r4, not_down
addi $r3, $r3, 1
j button_done
not_down:

addi $r4, $r4, 1
bne $r1, $r4, not_left
addi $r2, $r2, -1
j button_done
not_left:

button_done:

#local store back
sw $r2, 100($r0)
sw $r3, 200($r0)

#VGA store back
sw $r2, 300($r0)
sw $r3, 400($r0)


addi $r4, $r0, 10 #check if out of bounds
blt $r0, $r2, not_done #branch if 0 < x  ie  x > 0
blt $r2, $r4, not_done #branch if x < 10
blt $r0, $r3, not_done #branch if 0 < x  ie  x > 0
blt $r3, $r4, not_done #branch if y < 10

addi $r4, $r0, 1
sw $r4, 1($r0)
j game_done

not_done:

j start_loop


game_done:

