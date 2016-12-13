# DMem's Capacity: 1024 * 32 bits 
# Assume $0 = 0 
# Assume intial values of S_array are stored in Dmem[100..125]
# Assume intial values of L_array are stored in Dmem[200..203]
# Assume user-key is stored in $6, $7, $8, $9 from MSB to LSB, which is L_array from 0 to 3
# Assume A is in $10, and B is in $11  
# For each loop, S[i] is temporarily stored in $16. L[j] is temporarily stored in $26. i is in $1, j is in $2, k is in $3. $4 is for shift loop counter 

	add $1, $0, $0 # let $1 be 0, $1 will be the i iterator
	add $2, $0, $0 # let $2 be 0, $2 will be the j iterator
	add $3, $0, $0 # let $3 be 0, $3 will be the k iterator
	addi $30, $0, 26 # $30 has value 26 
	addi $31, $0, 4  # $31 has value 4
	addi $7, $0, 78  # $7 has value 78 
	
forBegin: 
	lw $16, 100($1) # load s[i] from DMem with offset 100 
	add $17, $10, $11
	add $18, $16, $17 
	
	shl $19, $18, 3 # (S[i] + A + B) <<< 3
	
	sw $19, 100($1) # save the result to s[i] 
	
	lw $26, 200($2) # load L[j] from Dmem with offset 200 
	add $27, $10, $11  # store (A+B) in $27 
	add $28, $26, $27 
	
	#left shift by (A+B) 
	add $4, $0, $27  # copy $27 to $4
shiftLeft: 
	subi $4, $4, 1 # $4 is the shift loop counter 
	shl $28, $28, 1  # shift result will be stored in $28 
	bne $4, $0, shiftLeft 
	
	sw $28, 200($2)

	bne  $1, $30, L1    # branch if ( i != 26 ) 
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