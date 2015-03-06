# Used in assignment 2.
# Registers used:
# $t0 - used to hold size
# $t1 - used as interative variable i to find input
# array - used to hold array
# $v0 - syscall parameter and return value.
# $a0 - syscall parameter.
.data 0x10000000
	inputSize: .asciiz "Enter size of array: "
	inputNum: .asciiz "Enter an integer: "
	errorMessage: .asciiz "Invalid size\n"
	blankSpace: .asciiz " "
	newLine: .asciiz "\n"
	array: .word 0:100
.text 0x00400000
main:
	

	## Ask for Size
	la $a0, inputSize		# Ask for size
	li $v0, 4				# Loads print_string to $v0
	syscall

	li $v0, 5				# Read the first integer input.
	syscall
	
	move $t0, $v0		# t0 holds size
	ble $t0, 0, ERROR	# if size <= 0, go to ERROR
	
	li $t1, 0		# counter i = 0
	la $a1, array
	loopInput:				# This loop asks for all input integers
		la $a0, inputNum	# Ask for integer
		li $v0, 4			# Loads print_string to $v0
		syscall
		li $v0, 5			# Read the integer
		syscall
		
		sw $v0, 0($a1)		# store integer into array
		
		addi $t1, $t1 1		# i++
		beq $t1, $t0, breakInput	# if i = size, go to breakInput
		
		addi $a1, $a1, 4	# go to next index of array
		
		j loopInput
		
	breakInput:
	
	## Start Bubble Sort
	sub $t0, $t0, 1		# size--
	la $t2, array		# put address of array into t2
	mul $t3, $t0, 4		# t3 = size * 4
	add $t2, $t2, $t3	# address + t3 (last index)
	loopi:
		li $t1, 0			# t1 holds flag (helps determine when list is sorted)
		la $a1, array		# a1 now holds base address of array
		loopj:
			lw $s2, 0($a1)	# s2 is current element in array
			lw $s3, 4($a1)	# s3 is next element in array
			blt $s2, $s3, continue	# if s2 < s3, then continue
			add $t1, $t1, 1	# if swap is necessary, check list again
			sw $s2, 4($a1)	# store s2 in s3's index
			sw $s3, 0($a1) 	# store s3 in s2's index
	continue:
		addi $a1, $a1, 4	# go to next index in array
		bne $a1, $t2, loopj	# if current index of array is not at the end, loop back to loopj
		bne $t1, $0, loopi	# if t1 = 1, another pass is needed, loop back to loopi
		
	## Now time to output array
	
	la $t2, array		# put address of array into t2
	mul $t3, $t0, 4		# t3 = size * 4
	add $t2, $t2, $t3	# address + t3 (last index)
	la $a1, array		# a1 now holds base address of array
	loopOutput:
		lw $s2, 0($a1)	# a1 holds current element in array
		
		## Output current element
		move $a0, $s2		# Load current int
		li $v0, 1			# load syscall print_int into $v0
		syscall
		
		## Output space for easier readability
		la $a0, blankSpace	# Load blankSpace into a0
		li $v0, 4			# load syscall print_string into $v0
		syscall
		
		addi $a1, $a1, 4	# go to next index in array
		ble $a1, $t2, loopOutput	# if current element is not at the end, loop back to loopOutput	
	
	li $v0, 10		# exit
	syscall
		
ERROR:
	la $a0, errorMessage		# Show error message
	li $v0, 4					# Loads print_string to $v0
	syscall
	
	li $v0, 10		# exit
	syscall