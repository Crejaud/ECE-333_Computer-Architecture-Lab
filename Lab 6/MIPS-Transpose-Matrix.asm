## Transpose a 5x5 matrix
## Registers used:
# s1 - holds Matrix_A
# s2 - holds Matrix_B
# t1 - holds 0x400
# t2 - holds 0x4
# t3 - holds index i
# t4 - holds index j
# t5 - holds A[i][j]
# t6 - holds B[j][i]
.data 0x10000880
	Matrix_A:	.word 1,2,3,4,5
			.data 0x10000C80
			.word 6,7,8,9,10
			.data 0x10001080
			.word 11,12,13,14,15
			.data 0x10001480
			.word 16,17,18,19,20
			.data 0x10001840
			.word 21,22,23,24,25
Matrix_B:	.word 0.0.0.0.0
			.data 0x10001C80
			.word 0.0.0.0.0
			.data 0x10002080
			.word 0.0.0.0.0
			.data 0x10002480
			.word 0.0.0.0.0
			.data 0x10002840
			.word 0.0.0.0.0

.text 
.globl main
main: 
	li $t3, 0			# i = 0
	li $t1, 0x400			# t1 = 0x400
	li $t2, 0x4			# t2 = 0x4
	## this loop will transpose Matrix_A onto Matrix_B
	loop1:
		la $s1, Matrix_A		# s1 holds Matrix_A
		la $s2, Matrix_B		# s2 holds Matrix_B
		mult $t3, $t2			# LO = i * 0x4
		mflo $t5			# t5 = LO
		add $s1, $s1, $t5		# go right i times in Matrix A
		mult $t3, $t1			# LO = i * 0x400
		mflo $t5			# t5 = LO
		add $s2, $s2, $t5		# go down i times in Matrix B
		li $t4, 0			# j = 0
		loop2:
			mult $t4, $t1		# LO = j * 0x400
			mflo $t5		# t5 = LO
			add $s1, $s1, $t5	# go down j times in Matrix A
			mult $t4, $t2		# LO = j * 0x4
			mflo $t5		# t5 = LO
			add $s2, $s2, $t5	# go right j times in Matrix B
			lw $t5, 0($s1)		# t5 holds element in Matrix A
			lw $t6, 0($s2)		# t6 holds element in Matrix B
			sw $t5, 0($s2)		# store t5 in Matrix B
			sw $t6, 0($s1)		# store t6 in Matrix A
			addi $t4, $t4, 1	# j++
			bne $t4, $5, loop2	# if j != 5, go to loop2
		addi $t3, $t3, 1		# i++
		bne $t3, $5, loop1		# if i != 5, go to loop1

	## Matrix_B is now the transpose of Matrix_A

	## Now we copy Matrix_B into Matrix_A
	li $t3, 0			# i = 0
	loop3:
		la $s1, Matrix_A		# s1 holds Matrix_A
		la $s2, Matrix_B		# s2 holds Matrix_B
		mult $t3, $t1			# LO = i * 0x400
		mflo $t5			# t5 = LO
		add $s1, $s1, $t5		# go down i times in Matrix A
		mult $t3, $t1			# LO = i * 0x400
		mflo $t5			# t5 = LO
		add $s2, $s2, $t5		# go down i times in Matrix B
		li $t4, 0			# j = 0
		loop4:
			mult $t4, $t2		# LO = j * 0x4
			mflo $t5		# t5 = LO
			add $s1, $s1, $t5	# go right j times in Matrix A
			mult $t4, $t2		# LO = j * 0x4
			mflo $t5		# t5 = LO
			add $s2, $s2, $t5	# go right j times in Matrix B
			lw $t6, 0($s2)		# t6 holds element in Matrix B
			sw $t6, 0($s1)		# store t6 in Matrix A
			addi $t4, $t4, 1	# j++
			bne $t4, $5, loop4	# if j != 5, go to loop4
		addi $t3, $t3, 1		# i++
		bne $t3, $5, loop3		# if i != 5, go to loop3

	## Now Matrix_A is transposed
	li $v0, 10		# exit
	syscall

