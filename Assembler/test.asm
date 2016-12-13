addi $1, $0, 2  # $1 =  2
addi $3, $0, 10  # $3 = 10D  
addi $4, $0, 14
addi $5, $0, 2 
sw $4, $3, 2
sw $3, $3, 1
sub $4, $4, $3 
subi $4, $0, 1 
and $4, $2, $3 
andi $4, $2, 10 
or $4, $2, $10 
lw $2, $3, 1  # line 11
test1: 
ori $4, $2, 10 # line 12
nor $4, $2, $10 # line 13
shl $4, $2, 10 # line 14
test2: 
shr $4, $2, 10 # line 15
beq $5, $0, test1 # line 16
blt $5, $4, test2 # line 17
bne $5, $4, test2 # line 18
jmp test1 # line 19
hal 