##############################################################
##  RC5 Decryption Function ##
# Assume Skey[0..25] has been store in DMem[100..125]
# Assume user's 64-bit input is stored in $8 and $9 ($8 has A, $9 has B)
# Assume $0 = 0
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
shiftRightByA:
	subi $3, $3, 1
	shr $23, $23, 1
	bne $3, $0, shiftRightByA

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
shiftRightByB:
	subi $4, $4, 1
	shr $23, $23, 1
	bne $4, $0, shiftRightByB

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