## Find average as floating-point from user inputted array of floating-point numbers
## Used in assignment 6.
# Registers used:
# t0 - used to hold size
# f0 - used to read floats
# f1 - used to hold sum of floats, then average/mean
# $v0 - syscall parameter and return value.
# $a0 - syscall parameter, and used to pass arguments
# $f12 - used to print, hold temporary floats
.data 0x10000000
	array: .word 0:100
	inputSize: .asciiz "Enter size: "
	inputFloat: .asciiz "Enter float: "
	outputError: .asciiz "Invalid String"
	outputAv: .asciiz "Average/Mean = "
	newLine: .asciiz "\n"
.text 0x00400000
main:
	## DECLARATIONS
	mtc1 $zero, $f1			# sum = 0
	
	## Ask for Size
	la $a0, inputSize		# Ask for size
	li $v0, 4				# Loads print_string to $v0
	syscall

	li $v0, 5				# Read the first integer input
	syscall
	
	move $t0, $v0		# t0 holds size
	ble $t0, 0, ERROR	# if size <= 0, go to ERROR
	
	li $t1, 0		# counter i = 0
	la $a1, array
	loopInput:				# This loop asks for all input floats
		la $a0, inputFloat	# Ask for float
		li $v0, 4			# Loads print_string to $v0
		syscall
		li $v0, 6			# Read the float
		syscall
		
		swc1 $f0, 0($a1)		# store float into array
		
		add.s $f1, $f1, $f0	# sum = sum + inputFloat	
		
		addi $t1, $t1 1		# i++
		beq $t1, $t0, breakInput	# if i = size, go to breakInput
		
		addi $a1, $a1, 4	# go to next index of array
		
		j loopInput
		
	breakInput:
		
	## Now time to find average and mean
	## We have sum, it is f1
	mtc1 $t0, $f12
	cvt.s.w $f12, $f12
	
	div.s $f1, $f1, $f12
	
	## Output Average/Mean
	la $a0, outputAv		# Load output Average string
	li $v0, 4				# Loads print_string to $v0
	syscall
	
	mov.s $f12, $f1			# Load AV float
	li $v0, 2
	syscall
	
	la $a0, newLine			# Load output newLine string
	li $v0, 4				# Loads print_string to $v0
	syscall
	
	li $v0, 10		# exit
	syscall
	
ERROR:
	la $a0, outputError		# Show error
	li $v0, 4				# Loads print_string to $v0
	syscall
	
	li $v0, 10				# exit
	syscall
