## RC5 Encryption Function ##
# DMem's Capacity: 1024 * 32 bits
# Assume Skey[0..25] has been store in DMem[100..125]
# Assume user's 64-bit input is stored in $8 and $9 ($8 has A, $9 has B)
# Assume $0 = 0
#-----------------Encryption-----------------------

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
shiftLeftByB:
	subi $4, $4, 1
	shl $20, $20, 1
	bne $4, $0, shiftLeftByB

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
shiftLeftByA:
	subi $3, $3, 1
	shl $19, $19, 1
	bne $3, $0, shiftLeftByA

	lw $22, $2, 100  # $22 <= Skey[2*i + 1]

	add $9, $19, $22  # B <= ((B xor A) <<< A) + S[2×i + 1]

	subi $31, $1, 12
	bne $0, $31, forEn

	sw $8, $0, 600 # Store A back to DMem[600]
	sw $9, $0, 601 # Store B back to DMem[601]