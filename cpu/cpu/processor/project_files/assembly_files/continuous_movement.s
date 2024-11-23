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

#sw $r0, 1($r0) #zero out game_done
sw $r0, 2($r0) #zero out previous button state


addi $r1, $r0, 2
sw $r1 3($r0) #start direction as right 


start_loop:

#stall loop
#addi $r3, $r0, 600   #r3 = 600
#addi $r4, $r0, 0     #r4 =0
#addi $r1, $r0, 30000 #r1 = 30000
#outer_stall_loop:
#addi $r2, $r0, 0     #r2 = 0
#inner_stall_loop:
#addi $r2, $r0, 1
#blt $r2, $r1, inner_stall_loop
#addi $r4, $r0, 1
#blt $r4, $r3 outer_stall_loop

lw $r1, 0($r0)  #load in buttons value
lw $r2, 100($r0) #load local x
lw $r3, 200($r0) #load local y
lw $r5, 2($r0) #previous button state
lw $r6, 3($r0) #direction

bne $r5, $r0 button_done

bne $r1, $r0, new_direction

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


addi $r4, $r0, 9 #check if out of bounds
blt $r2, $r0, done #branch if 0 > x
blt $r4, $r2, done #branch if x > 9
blt $r3, $r0, done #branch if 0 > y
blt $r4, $r3, done #branch if y > 9

#addi $r4, $r0, 1
#sw $r4, 1($r0)
#j game_done

update:

#local store back
sw $r2, 100($r0)
sw $r3, 200($r0)

#VGA store back
sw $r2, 300($r0)
sw $r3, 400($r0)

j start_loop

#game_done:

done:
addi $r2, $r0, 0
addi $r3, $r0, 0
j update


new_direction:
addi $r6, $r1, 0
j button_done
