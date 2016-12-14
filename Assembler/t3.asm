addi $7, $0, 16
addi $3, $0, 8 
addi $1, $0, 0 
loopn: 
lw $4, $1, 0 
lw $5, $1, 0
jmp mul 
back: 
add $6, $6, $6 
addi $6, $6, 1 
sw $6, $7, 0 
addi $7, $0, 1 
addi $1, $0, 1 
addi $2, $0, 1 
subi $3, $0, 1 
bne $3, $0, loopn 
halt
mul: 
andi $6, $6, 0 
loop1: 
add $6, $6, $4 
subi $5, $5, 1 
bne $5, $0, loop1
jmp back