# A is stored at $10, B is stored at $11, i in $1, j in $2, k in $3
	# Load User-key to the designated registers: 
	lw $6, $0, 400 
	lw $7, $0, 401
	lw $8, $0, 402
	lw $9, $0, 403
	add $1, $0, $0 # let $1 be 0, $1 will be the i iterator
	add $2, $0, $0 # let $2 be 0, $2 will be the j iterator
	add $3, $0, $0 # let $3 be 0, $3 will be the k iterator
	addi $30, $0, 25 # $30 has value 25 
	addi $31, $0, 3  # $31 has value 3
	addi $7, $0, 78  # $7 has value 78
forBegin: 
	lw $16, $1, 100 # load s[i] from DMem with offset 100 
	add $17, $10, $11 
	add $18, $16, $17 
	shl $19, $18, 3 # (S[i] + A + B) <<< 3
	sw $19, $1, 100 # save the result to s[i] 
	lw $10, $1, 100 # update A
	lw $26, $2, 200 # load L[j] from Dmem with offset 200 
	add $27, $10, $11  # store (A+B) in $27 
	add $28, $26, $27 
	#left shift by (A+B) 
	andi $4, $27, 31  # copy $27 to $4
shiftLeft: 
	subi $4, $4, 1 # $4 is the shift loop counter 
	shl $28, $28, 1  # shift result will be stored in $28 
	bne $4, $0, shiftLeft 
	sw $28, $2, 200 # save the result to L[j] 
	lw $11, $2, 200 # update B

	bne  $1, $30, L1    # branch if ( i != 25 ) 
	jmp E1
L1: 
	addi $1, $1, 1     # i++ 
	jmp A1 
E1: 
	add $1, $0, $0  # else { i=0 }
	
A1: 
	bne  $2, $31, L2    # branch if ( j != 3 )
	jmp E2
L2: 	
	addi $2, $2, 1     # j++ 
	jmp A2 
E2: 
	add $2, $0, $0  # else { j=0 }
A2: 
    addi $3, $3, 1     # k++ 

	bne  $3, $7, forBegin   # jump to the beginning, if ( k != 78 ) 
	
	halt