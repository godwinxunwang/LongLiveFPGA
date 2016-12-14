# DMem[512] determines whether to do Encryption(1) or Decryption(0). 
# DMem[513] determines whether to start the entire program 
# DMem[514] dtermine whether to skip the round-key expansion part 

#--------------Key-Expansion---------------
startCheckPoint: 
	# Load program start check singal to $15 
	lw $15, $0, 513 
	#if start signal is 0, then go back to the check point; otherwise, proceed 
	beq $15, $0, startCheckPoint

# Check whether skip key-expansion 
	lw $15, $0, 514
	bne $15, $0, skipKeyExpansion # if DMem[514] = 1, skip 

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
	andi $4, $27, 31  # copy the last 5 bits of $27 to $4
	beq $4, $0, loopOut0
shiftLeft: 
	subi $4, $4, 1 # $4 is the shift loop counter 
	shl $28, $28, 1  # shift result will be stored in $28 
	bne $4, $0, shiftLeft 
loopOut0:
	sw $28, $2, 200
	lw $11, $2, 200 # update B
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


#-----------------Encryption-----------------------
skipKeyExpansion: 
#Check if skip Encryption 
	lw $15, $0, 512 
	beq $15, $0, doDecryption

	lw $8, $0, 300  # load A from Dmem[300]
	lw $9, $0, 301  # load B from Dmem[301]
	
	lw $10, $0, 100  # Load DMem[100] (Skey[0]) to $10
	lw $11, $0, 101  # Load DMem[1] (Skey[1]) to $11

	add $8, $8, $10  #A=A+Skey[0]
	add $9, $9, $11  #B=B+Skey[1]

forEn:
	addi $1, $1, 1  # let $1 = '1', $1 would be iterator

	add $2, $1, $1  # let $2 = 2*i

	# A XOR B => $20
	nor $16, $8, $8
	nor $17, $9, $9
	nor $18, $16, $17
	nor $19, $8, $9
	nor $20, $18, $19

	# $20 <= (A xor B) << B
	add $4, $0, $9  # copy B's value to $4
	andi $4, $4, 31
	beq $4, $0, loopOut1
shiftLeftByB:
	subi $4, $4, 1
	shl $20, $20, 1
	bne $4, $0, shiftLeftByB
loopOut1: 
	lw $22, $2, 100  # $22 <= Skey[2*i]

	add $8, $20, $22  # A <= (A xor B) << B + Skey[2*i]

	# B XOR A => $20
	nor $16, $8, $8
	nor $17, $9, $9
	nor $18, $16, $17
	nor $19, $8, $9
	nor $20, $18, $19


	# $19 <= (B xor A) << A
	add $3, $0, $8  # copy A's value to $3
	andi $3, $3, 31
	beq $3, $0, loopOut2
shiftLeftByA:
	subi $3, $3, 1
	shl $19, $19, 1
	bne $3, $0, shiftLeftByA
loopOut2:
	lw $22, $2, 100  # $22 <= Skey[2*i + 1]

	add $9, $19, $22  # B <= ((B xor A) <<< A) + S[2×i + 1]

	subi $31, $1, 12
	bne $0, $31, forEn
	
	sw $8, $0, 600 # Store A back to DMem[600]
	sw $9, $0, 601 # Store B back to DMem[601]

doDecryption: 
#-----------------Decryption-----------------------
	lw $8, $0, 300  # load A from Dmem[300]
	lw $9, $0, 301  # load B from Dmem[301]


	lw $10, $0, 100  # Load DMem[0] (Skey[0]) to $10
	lw $11, $0, 101  # Load DMem[1] (Skey[1]) to $11

	addi $1, $0, 12
	
forDe:
	add $2, $1, $1  # let $2 = 2*i

	lw $22, $2, 100  # $22 <= Skey[2*i+1]

	sub $23, $9, $22  # B-Skey[2*i+1]

	# $23 <= B-Skey[2*i+1] >> A
	add $3, $0, $8  # copy A's value to $3
	andi $3, $3, 31
	beq $3, $0, loopOut3
shiftRightByA:
	subi $3, $3, 1
	shr $23, $23, 1
	bne $3, $0, shiftRightByA
loopOut3: 
	# (( B-Skey[2*i+1] >> A ) xor A) => B
	nor $16, $8, $8
	nor $17, $23, $23
	nor $18, $16, $17
	nor $19, $8, $23
	nor $9, $18, $19

	lw $22, $2, 100  # $22 <= Skey[2*i]

	sub $23, $8, $22  # A-Skey[2*i]

	# A-Skey[2*i] >> B
	add $4, $0, $9  # copy B's value to $4
	andi $4, $4, 31
	beq $4, $0, loopOut4
shiftRightByB:
	subi $4, $4, 1
	shr $23, $23, 1
	bne $4, $0, shiftRightByB
loopOut4: 
	# ($23 xor B)  => A
	nor $16, $9, $9
	nor $17, $23, $23
	nor $18, $16, $17
	nor $19, $9, $23
	nor $8, $18, $19

	subi $1, $1, 1

	bne $0, $1, forDe

	sub $9, $9, $11  # B = B - Skey[1]
	sub $8, $8, $10  # A = A - Skey[0]
	
	sw $8, $0, 602 # Store A back to DMem[602]
	sw $9, $0, 603 # Store B back to DMem[603]

	halt