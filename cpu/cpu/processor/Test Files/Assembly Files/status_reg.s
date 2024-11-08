addi $r30, $r0, 0
setx 5
bex bex_test
addi $r1, $r0, 10
bex_test: addi $r1, $r1, 5 #r1 = 5
#addi $r2, $r0, 65535
#addi $r3, $r0, 3204
#mul $r2, $r2, $r3
#addi $r2, $r2, 61995
#addi $r2, $r0, 2100000000 #$r2 = 2100000000
#addi $r3, $r2, 100000000
#addi $r3, $r30, 0 #addi overflow $r3 = 2
#add $r4, $r2, $r2
#addi $r4, $r30, 0 #add overflow $r4 = 1
#addi $r5, $r0, -2100000000 #$r5 = -2100000000
#sub $r6, $r5, $r2
#addi $r6, $r30, 0 #sub underflow $r6 = 3
#mul $r7, $r2, $r2
#addi $r7, $r30, 0 #mult overflow $r7 = 4
#div $r8, $r7, $r0
#addi $r8, $r30, 0 #div error $r8 = 5
#setx 20
