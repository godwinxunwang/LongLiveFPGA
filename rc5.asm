## RC5 Encryption Function ##
# DMem's Capacity: 1024 * 32 bits 
# Assume Skey[0..25] has been store in DMem[0..25]
# Assume user's 64-bit input is stored in $8 and $9 ($8 has A, $9 has B)
# Assume $0 = 0 

	lw $10, 0($0)  # Load DMem[0] (Skey[0]) to $10 
	lw $11, 1($0)  # Load DMem[1] (Skey[1]) to $10

	add $8, $8, $10  #A=A+Skey[0]
	add $9, $9, $11  #B=B+Skey[1]

for: 
	add $1, $0, 1  # let $1 = '0', $1 would be iterator
	
	add $2, $1, $1  # let $2 = 2*i
	
	# A XOR B => $20 
	nor $16, $8, $8 
	nor $17, $9, $9
	nor $18, $16, $17
	nor $19, $8, $9 
	nor $20, $18, $19 
	
	shl $21, $19, $9 # $21 <= (A xor B) << B 
	
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
	bne $0, $31, for: 
	
	halt 
	
	
	
	
	
	






