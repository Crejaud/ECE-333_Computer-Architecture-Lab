## Given two even integers, output the sum
# Used in assignment 3.
# Registers used:
# $t0 - first user inputed integer
# $t1 - second user inputed integer
# $t2 - holds 2, for using modulus
# $t3 - holds remainder
# $t4 - holds 1 (testing if odd)
# $v0 - syscall parameter and return value.
# $a0 - syscall parameter.
.data 0x10000000
	ask1: .asciiz “\nEnter first even integer: “
	ask2: .asciiz “\nEnter second even integer: “
	error: .asciiz “\nError”
	ans: .asciiz “\nAnswer: “
.text 0x00400000
main:
	## Declarations
	li $t2, 2		# Holds 2, for using modulus
	li $t4, 1		# Holds 1 to test if odd

	## Ask for 1st integer
	la $a0, ask1		# Ask for first even int
	li $v0, 4		# Loads print_string to $v0
	syscall

	li $v0, 5		# Read the first integer input.
	syscall

	move $t0, $v0		# t0 holds first integer
	div $t0, $t2		# Hi = t0 mod 2
	mfhi $t3		# t3 = Hi (remainder)
	beq  $t3, $t4, ERROR		# if remainder == 1, go to ERROR because input is odd

	## Ask for 2nd integer
	li $a0, ask2		# Ask for second even int
	li $v0, 4		# Loads print_string to $v0
	syscall

	li $v0, 5		# Read the second integer input
	syscall

	move $t1, $v0		#  t1 holds second integer
	div $t1, $t2		# Hi = t0 mod 2
	mfhi $t3		# t3 = Hi (remainder)
	beq $t3, $t4, ERROR		# if remainder == 1, go to ERROR because input is odd

	## Get sum of all numbers between these two numbers
	## t2 is reused to hold sum
	li $t2, 0		# sum = 0
	bge $t1, $t0, loop1	# cond: branch if  t1 >= t0
	bgt $t0, $t1, loop2	# cond: branch if t0 > t1

## t1 >= t0
loop1:
	addi $t0, $t0, 1	# t0 = t0 + 1
	bge $t0, $t1, endloop	# if $t0 >= $t1 then go to endloop
	add $t2, $t2, $t0	# sum += t0
b loop1

## t0 > t1
loop2:
	addi $t1, $t1, 1	# t1 += 1
	bge $t1, $t0, endloop	# if $t1 >= $t1 then go to endloop
	add $t2, $t2, $t1	# sum += t1
b loop2
	
endloop:
	move $a0, $t2		# Load the total sum number
	li $v0, 1		# load syscall print_int into $v0
	syscall
	li $v0, 10		# exit
	syscall
ERROR:
	la $a0, error		# Load error string
	li $v0, 4		# Loads print_string to $v0
	syscall
