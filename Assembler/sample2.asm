addi $1, $0, 2 # $1=2
addi $3, $0, 10 # $3=10D (D=Decimal)
addi $4, $0, 14 # $4=14D
addi $5, $0, 2 # $5=2
sw $4, $3, 2 # 14D is stored in Data memory location 12D
sw $3, $3, 1 # 10D is stored in Data memory location 11D
sub $4, $4, $3
subi $4, $0, 1
and $4, $2, $3
andi $4, $2, 10
or $4, $2, $3
lw $2, $3, 1 # $2=10D (Loaded back from memory)
ori $4, $2, 10
nor $4, $2, $3
shl $4, $2, 10
L1: 
shr $4, $2, 10
beq $5, $0, L1
blt $5, $4, L2
L2:
bne $5, $4, L3
L3: 
jmp J
J:
hal