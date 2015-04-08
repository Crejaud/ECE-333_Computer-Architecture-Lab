## Perform vector multiplication of vector A and matrix B, and store the result into vector C
#  s1: holds vector A
#  s2: holds matrix B
#  s3: holds vector C
#  t1: holds i
#  t2: holds j
#  t3: holds sum
#  t4: holds A[j]
#  t5: holds B[i][j]
#  t6: holds LO
#  t7: holds 4

			.data 0x10000860
Vector_A:	.word 1,2,3,4,0,0,0,0
			.data 0x10000880
Matrix_B:	.word 1,2,3,4,5,6,7,8
			.data 0x10000C80
			.word 2,3,4,5,6,7,8,9
			.data 0x10001080
			.word 3,4,5,6,7,8,9,10
			.data 0x10001480
			.word 4,5,6,7,8,9,10,11
			.data 0x10000840
Vector_C:	.word 0,0,0,0,0,0,0,0
			.data 0x10002000
comma:
			.asciiz ", "

.text 0x00400000
.globl main # main program starts in the next line
main:
	la $s3, Vector_C	# s3 holds Vector_C
	li $t1, 0 	# i = 0
	li $t7, 4	# t7 = 4
	loopi:
		la $s1, Vector_A
		la $s2, Matrix_B
		mult $t1, $t7		# LO = i * 4
		mflo $t6			# t6 = LO
		add $s2, $s2, $t6	# go to B[i]
		li $t3, 0 	# sum = 0
		li $t2, 0 	# j = 0
		loopj:
			lw $t4, 0($s1)	# t4 = A[j]
			lw $t5, 0($s2)	# t5 = B[i][j]
			mult $t4, $t5	# LO = t4*t5
			mflo $t6		# t6 = LO
			add $t3, $t3, $t6	# sum += LO
			addi $s1, $s1, 0x4	# go to next index in A
			addi $s2, $s2, 0x400	# go to next index in B
			addi $t2, $t2, 1 		# j++
			beq $t2, 0x4, breakj	# if j == 4, go to breakj
			j loopj
		breakj:
			sw $t3, 0($s3)	# store sum into C[i]
			addi $s3, $s3, 0x4	# go to next index in C
			move $a0, $t3	# load C[i]
			li $v0, 1		# load print_int
			syscall
			
			addi $t1, $t1, 1	# i++
			beq $t1, 8, breaki	# if i == 8, go to breaki
			
			la $a0, comma	# load comma
			li $v0, 4		# load print_string
			syscall
			
			j loopi
			
	breaki:	
		li $v0, 10	# exit
		syscall

