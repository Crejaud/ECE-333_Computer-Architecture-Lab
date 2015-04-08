## Swap elements of two given arrays
#  s1: holds arrayA
#  s2: holds arrayB
#  t1: holds counter
#  t2: A[i]
#  t3: B[i]
		.data 0x10000480
ArrayA: .word 1 3 5 7 9 11 13 15 17 19
		.data 0x100004B0
ArrayB: .word 2 4 6 8 10 12 14 16 18 20
.text 0x00400000
.globl main
main:
	la $s1, ArrayA		# s1 holds ArrayA
	la $s2, ArrayB		# s2 holds ArrayB
	li $t1, 0 			# counter = 0
	
	loop:
		lw $t2, 0($s1)	# t2 holds ArrayA[counter]
		lw $t3, 0($s2)	# t3 holds arrayB[counter]
		sw $t2, 0($s2)	# store ArrayA[counter] into ArrayB[counter]
		sw $t2, 0($s2)	# store ArrayB[counter] into ArrayA[counter]
		addi $s1, $s1, 4	# go to next index in ArrayA
		addi $s2, $s2, 4	# go to next index in ArrayB
		addi $t1, $t1, 1 	# counter++
		beq $t1, 10, breakLoop	# if counter == 10, go to breakLoop
		j loop
	breakLoop:
		li $v0, 10	# exit
		syscall

