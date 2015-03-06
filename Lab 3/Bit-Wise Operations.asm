# Used in assignment 1.
# Registers used:
# $t0 - used to hold A
# $t1 - used to hold B
# $t2 - used to hold C
# $t3 - used to hold A and B
# $t4 - used to hold B or C then A and (B or C)
# $t5 - used to hold A xor B then A xnor B
# $v0 - syscall parameter and return value.
# $a0 - syscall parameter.
.data 0x10000000
	inputA: .asciiz "Enter A: "
	inputB: .asciiz "Enter B: "
	inputC: .asciiz "Enter C: "
	output1: .asciiz "A and B = "
	output2: .asciiz "A and (B or C) = "
	output3: .asciiz "A xnor B = "
	newLine: .asciiz "\n"
.text 0x00400000
main:
	## Ask for A
	la $a0, inputA		# Ask for first int
	li $v0, 4			# Loads print_string to $v0
	syscall

	li $v0, 5			# Read the first integer input.
	syscall
	
	move $t0, $v0		# t0 = A
	
	## Ask for B
	la $a0, inputB		# Ask for second int
	li $v0, 4			# Loads print_string to $v0
	syscall

	li $v0, 5			# Read the second integer input.
	syscall
	
	move $t1, $v0		# t1 = B
	
	## Ask for C
	la $a0, inputC		# Ask for third int
	li $v0, 4			# Loads print_string to $v0
	syscall

	li $v0, 5			# Read the third integer input.
	syscall
	
	move $t2 $v0		# t2 = C
	
	and $t3, $t0, $t1	# t3 = A and B
	
	or $t4, $t1, $t2	# t4 = B or C
	and $t4, $t0, $t4	# t4 = A and t4 = A and (B or C)
	
	## nand does not exist in MIPS. So I'll use nors
	nor $t5, $t0, $t1	# t5 = A nor B
	nor $t6, $t0, $t5	# t6 = A nor (A nor B)
	nor $t5, $t1, $t5	# t5 = B nor (A nor B)
	nor $t6, $t6, $t5	# t6 = t6 nor t5 = (A nor (A nor B)) nor (B nor (A nor B)) = A xnor B
	
	## Output A and B
	la $a0, output1		# Load output1 string
	li $v0, 4			# Loads print_string to $v0
	syscall
	
	move $a0, $t3		# Load t3
	li $v0, 1			# load syscall print_int into $v0
	syscall
	
	la $a0, newLine		# Load newLine string
	li $v0, 4			# Loads print_string to $v0
	syscall
	
	## Output A and (B or C)
	la $a0, output2		# Load output2 string
	li $v0, 4			# Loads print_string to $v0
	syscall
	
	move $a0, $t4		# Load t4
	li $v0, 1			# load syscall print_int into $v0
	syscall
	
	la $a0, newLine		# Load newLine string
	li $v0, 4			# Loads print_string to $v0
	syscall
	
	## Output A xnor B
	la $a0, output3		# Load output3 string
	li $v0, 4			# Loads print_string to $v0
	syscall
	
	move $a0, $t6		# Load t6
	li $v0, 1			# load syscall print_int into $v0
	syscall
	
	la $a0, newLine		# Load newLine string
	li $v0, 4			# Loads print_string to $v0
	syscall
	
	li $v0, 10			# exit
	syscall