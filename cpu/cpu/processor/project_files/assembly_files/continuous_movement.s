#memory address 0 is buttons
# 1 is game done
# 100 - 199 is local x
# 200 -299 is local y
# 300 - 399 is vga x
# 400 - 499 is vga y

#Storage Idea: move where in memory the head is each time. The memory shifts not the data
#add delay to slow down the snake
#hold current direction in memory and then updare it when needed and always update position based on direction

sw $r0, 100($r0)  #100 is local x of box
sw $r0, 200($r0)  #200 is local y of box

sw $r0, 1($r0) #zero out game_done
sw $r0, 2($r0) #zero out previous button state


addi $r1, $r0, 2
sw $r1 3($r0) #start direction as right 


start_loop:
lw $r1, 0($r0)  #load in buttons value
lw $r2, 100($r0) #load local x
lw $r3, 200($r0) #load local y
lw $r5, 2($r0) #previous button state
lw $r6, 3($r0) #direction
addi $r4, $r0, 1 #button checker

bne $r5, $r0 button_done

bne $r1, $r4, not_up
addi $r6, $r0, 1
j button_done
not_up:

addi $r4, $r4, 1
bne $r1, $r4, not_right
addi $r6, $r0, 2
j button_done
not_right:

addi $r4, $r4, 1
bne $r1, $r4, not_down
addi $r6, $r0, 3
j button_done
not_down:

addi $r4, $r4, 1
bne $r1, $r4, not_left
addi $r6, $r0, 4
j button_done
not_left:

button_done:

sw $r6 3($r0) #store direction back
addi $r4, $r0, 1 #direction check

bne $r6, $r4, not_up_move
addi $r3, $r3, -1
j direction_done
not_up_move:

addi $r4, $r4, 1
bne $r6, $r4, not_right_move
addi $r2, $r2, 1
j direction_done
not_right_move:

addi $r4, $r4, 1
bne $r6, $r4, not_down_move
addi $r3, $r3, 1
j direction_done
not_down_move:

addi $r4, $r4, 1
bne $r6, $r4, not_left_move
addi $r2, $r2, -1
j direction_done
not_left_move:

direction_done:

sw $r1 2($r0) #button as new previous button

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

