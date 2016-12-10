## RC5 Encryption Function ##
# DMem's Capacity: 1024 * 32 bits 
# Assume Skey[0..25] has been store in DMem[0..25]
# Assume user's 64-bit input is stored in $8 and $9 ($8 has A, $9 has B)
# Assume $0 = 0 

	lw $10, 0($0)  # Load DMem[0] (Skey[0]) to $10 
	lw $11, 1($0)  # Load DMem[1] (Skey[1]) to $11

	add $8, $8, $10  #A=A+Skey[0]
	add $9, $9, $11  #B=B+Skey[1]

forEn: 
	addi $1, $1, 1  # let $1 = '0', $1 would be iterator
	
	add $2, $1, $1  # let $2 = 2*i
	
	# A XOR B => $20 
	nor $16, $8, $8 
	nor $17, $9, $9
	nor $18, $16, $17
	nor $19, $8, $9 
	nor $20, $18, $19 
	
	# $21 <= (A xor B) << B 
	add $4, $0, $9  # copy B's value to $4
shiftB: 	
	subi $4, $4, 1 
	shl $21, $19, 1
	bne $4, $0, shiftB
	
	lw $22, 0($2)  # $22 <= Skey[2*i] 
	
	add $8, $21, $22 
	
	# B XOR A => $20 
	nor $16, $8, $8 
	nor $17, $9, $9
	nor $18, $16, $17
	nor $19, $8, $9 
	nor $20, $18, $19 
	
	shl $21, $19, $8	# $21 <= (B xor A) << A
	
	lw $22, 1($2)  # $22 <= Skey[2*i + 1] 
	
	add $9, $21, $22 
	
	subi $31, $1, 12
	bne $0, $31, forEn: 
	
	halt 
	
##############################################################
##  RC5 Decryption Function ##
# Assume Skey[0..25] has been store in DMem[0..25]
# Assume user's 64-bit input is stored in $8 and $9 ($8 has A, $9 has B)
# Assume $0 = 0 

	lw $10, 0($0)  # Load DMem[0] (Skey[0]) to $10 
	lw $11, 1($0)  # Load DMem[1] (Skey[1]) to $11

	addi $1, $0, 12
forDe: 
	add $2, $1, $1  # let $2 = 2*i
	
	lw $22, 1($2)  # $22 <= Skey[2*i+1] 
	
	sub $23, $9, $22  # B-Skey[2*i+1]
	
	# B-Skey[2*i+1] >> A 
	add $3, $0, $8
shiftA: 
	subi $3, $3, 1
	shr $24, $23, 1
	bne $3, $0, shiftA
	
	# (( B-Skey[2*i+1] >> A ) xor A) => B 
	nor $16, $8, $8 
	nor $17, $24, $24
	nor $18, $16, $17
	nor $19, $8, $24 
	nor $9, $18, $19 
	
	lw $22, 0($2)  # $22 <= Skey[2*i] 
	
	sub $23, $8, $22  # A-Skey[2*i]
	
	shr $24, $23, $9  # A-Skey[2*i] >> B 
	
	# ($24 xor B)  => A
	nor $16, $9, $9 
	nor $17, $24, $24
	nor $18, $16, $17
	nor $19, $9, $24 
	nor $8, $18, $19 	

	subi $1, $1, 1 
	
	bne $0, $1, forDe 
	
	sub $9, $9, $11  # B = B - Skey[1]
	sub $8, $8, $10  # A = A - Skey[0]
	
	halt 
	
	
	
	
	






