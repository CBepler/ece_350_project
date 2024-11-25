#memory address 0 is buttons
# 1 is game done
# 100 - 199 is local x
# 200 -299 is local y
# 300 - 399 is vga x
# 400 - 499 is vga y

#food: #take value and show food

reset:

addi $r1, $r0, 1
sw $r1, 5($r0)      #5 is for reset status

sw $r0, 100($r0)  #100 is local x of box
sw $r0, 200($r0)  #200 is local y of box

sw $r0, 2($r0) #zero out previous button state


addi $r1, $r0, 2
sw $r1, 3($r0) #start direction as right 

addi $r1, $r0, 1
sw $r1, 4($r0)  #set length  (0 indexed)

sw $r1, 6($r0) #6 is for need new food

addi $r1, $r0, -1
sw $r1, 7($r0)   #food x position
sw $r1, 8($r0)   #food y position

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

#loop set other tail parts
addi $r4, $r0, 1
addi $r8, $r7, 0
tail_set_loop:
blt $r8, $r4, done_tail_update     #  $r7 hold length 0 indexed decrement down to reach head
addi $r5, $r8, 100  #100 range for local x 
lw $r6, -1($r5)    #load in x value of 1 ahead piece
sw $r6, 0($r5)    #store in new position
sw $r6, 200($r5)    #store in new position in VGA range

addi $r5, $r5, 100 #200 range for local y 
lw $r6, -1($r5)    #load in y value of 1 ahead piece
sw $r6, 0($r5)    #store in new position
sw $r6, 200($r5)    #store in new position in VGA range

addi $r8, $r8, -1
j tail_set_loop

done_tail_update:


#local store back for head
sw $r2, 100($r0)
sw $r3, 200($r0)

#VGA store back for head
sw $r2, 300($r0)
sw $r3, 400($r0)



#food_generation_section
addi $r4, $r0, 1
lw $r8, 6($r0) #food need
lw $r7, 4($r0) #snake length
bne $r8, $r4, food_done
#sw $r0, 6($r0) #no food needed next time   (commented out so it contionuosly generates for testing)
lw $r9, 7($r0) #load in random x value
lw $r10, 8($r0) #load in random y value

restart_check_loop:
addi $r11, $r0, 0 # Counter for checking snake parts
check_snake_loop:
blt $r7, $r11, food_position_valid # If we've checked all snake parts, position is valid

# Load snake part coordinates
addi $r12, $r11, 100 # Get address of x coordinate
lw $r13, 0($r12) # Load x coordinate
addi $r12, $r11, 200 # Get address of y coordinate
lw $r14, 0($r12) # Load y coordinate

# Check if food position matches this snake part
bne $r9, $r13, position_different # If x coordinates don't match, check next part
bne $r10, $r14, position_different # If y coordinates don't match, check next part

# Position matches snake part, increment x coordinate
addi $r9, $r9, 1
addi $r15, $r0, 9
blt $r15, $r9, wrap_x # If x > 9, wrap to 0
j restart_check_loop # Restart check with new position

wrap_x:
addi $r9, $r0, 0 # Set x back to 0
addi $r10, $r10, 1 # Increment y
addi $r15, $r0, 9
blt $r15, $r10, wrap_y # If y > 9, wrap to 0
j restart_check_loop # Restart check with new position

wrap_y:
addi $r10, $r0, 0 # Set y back to 0
j restart_check_loop # Restart check with new position

position_different:
addi $r11, $r11, 1 # Increment counter
j check_snake_loop

food_position_valid:
# Store final food position
sw $r9, 7($r0) # Store food x position
sw $r10, 8($r0) # Store food y position
# Update VGA display for food
sw $r9, 9($r0) # Store food x position in VGA
sw $r10, 10($r0) # Store food y position in VGA

food_done:


j start_loop


new_direction:
addi $r6, $r1, 0
j button_done
