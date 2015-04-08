## Calculate and print the convolution sum of two following arrays
## Registers used:
#  s1: holds array A
#  s2: holds array B
#  t1: ouput C[n]
#  t2: counter n
#  t3: holds A[k]
#  t4: holds B[n-k]
#  t5: counter k
#  t6: holds LO
#  t7: holds constant 4
.data 0x10000480
A:
	.word 1,2,3,4,5,6,7,8
B:
	.word 8,7,6,5,4,3,2,1
comma:
	.asciiz ", "
.text
.globl main
main:
	li $t2, 0	# n = 0
	li $t7, 4	# t7 = 4
	## Start loop
	loop:
		la $s1, A			# s1 holds array A
		la $s2, B			# s2 holds array B
		mult $t2, $t7		# LO = n*4
		mflo $t6			# t6 = LO
		add $s2, $s2, $t6	# s2 to set B[n]
		li $t1, 0			# output = 0
		li $t5, 0			# k = 0
		## Start loopSum
		loopSum:
			lw $t3, 0($s1)		# t3 holds A[k]
			lw $t4, 0($s2)		# t4 holds B[n-k]
			mult $t3, $t4		# LO = t3*t4
			mflo $t6			# t6 = LO
			add $t1, $t1, $t6	# t1 += A[k]*B[n-k]
			addi $s1, $s1, 4	# next index of A
			addi $s2, $s2, -4	# previous index of B
			beq $t5, $t2, breakSum	# if k = n, go to breakSum
			addi $t5, $t5, 1	# k++
			j loopSum
		breakSum:
			move $a0, $t1	# load C[n]
			li $v0, 1		# load print_int
			syscall
			
			beq $t2, 7, exit	# if n = 7, exit
			
			la $a0, comma	# load comma
			li $v0, 4		# load print_string
			syscall
			
			addi $t2, $t2, 1	# n++
			j loop
	
	exit:
		li $v0, 10
		syscall

