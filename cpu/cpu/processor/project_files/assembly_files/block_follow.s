#memory address 0 is buttons
# 1 is game done
# 100 - 199 is local x
# 200 -299 is local y
# 300 - 399 is vga x
# 400 - 499 is vga y

#Storage: #update each position each time

reset:

sw $r0, 100($r0)  #100 is local x of box
sw $r0, 200($r0)  #200 is local y of box

sw $r0, 2($r0) #zero out previous button state


addi $r1, $r0, 2
sw $r1, 3($r0) #start direction as right 

addi $r1, $r0, 1
sw $r1, 4($r0)  #set length to 1 (0 indexed so 2 parts)

#loop set all tail parts to -1
addi $r1, $r0, 101
addi $r2, $r0, 199
addi $r3, $r0, -1
set_loop_x:
blt $r2, $r1, set_done_x
sw $r3, 0($r1)
addi $r1, $r1, 1
j set_loop_x

set_done_x:

addi $r1, $r0, 201
addi $r2, $r0, 299
addi $r3, $r0, -1
set_loop_y:
blt $r2, $r1, set_done_y
sw $r3, 0($r1)
addi $r1, $r1, 1
j set_loop_y

set_done_y:

start_loop:

#stall loop
addi $r3, $r0, 350   #r3 = 600
addi $r4, $r0, 0     #r4 =0
addi $r1, $r0, 30000 #r1 = 30000
outer_stall_loop:
addi $r2, $r0, 0     #r2 = 0
inner_stall_loop:
addi $r2, $r2, 1
blt $r2, $r1, inner_stall_loop
addi $r4, $r4, 1
blt $r4, $r3, outer_stall_loop

lw $r1, 0($r0)  #load in buttons value
lw $r2, 100($r0) #load local x head
lw $r3, 200($r0) #load local y head
lw $r5, 2($r0) #previous button state
lw $r6, 3($r0) #direction
lw $r7, 4($r0) #snake length

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
blt $r2, $r0, reset #branch if 0 > x
blt $r4, $r2, reset #branch if x > 9
blt $r3, $r0, reset #branch if 0 > y
blt $r4, $r3, reset #branch if y > 9

update:

#local store back
sw $r2, 100($r0)
sw $r3, 200($r0)

#VGA store back
sw $r2, 300($r0)
sw $r3, 400($r0)

#loop set other parts
addi $r4, $r0, 1
tail_set_loop:
blt $r7, $r4, done_tail_update     #  $r7 hold length 0 indexed decrement down to reach head
addi $r5, $r7, 100  #100 range for local x 
lw $r6, -1($r5)    #load in x value of 1 ahead piece
sw $r6, 0($r5)    #store in new position
sw $r6, 200($r5)    #store in new position in VGA range

addi $r5, $r5, 100 #200 range for local y 
lw $r6, -1($r5)    #load in y value of 1 ahead piece
sw $r6, 0($r5)    #store in new position
sw $r6, 200($r5)    #store in new position in VGA range

addi $r7, $r7, -1
j tail_set_loop

done_tail_update:

j start_loop


new_direction:
addi $r6, $r1, 0
j button_done
