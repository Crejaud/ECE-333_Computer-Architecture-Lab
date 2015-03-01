## Simple program in MIPS Assembly to find sum of input integers
# Used in assignment 5.
.data 0x10000000
	ask1: .asciiz “\n# of integers to input: ”
	ask2: .asciiz “\nEnter number: “
	ans: .asciiz “Answer: “
.text 0x00400000
.globl main
main:
	li $v0, 4	# load syscall print_string into $v0
	la $a0, ask1	# Loads the ask1 string.
	syscall		# Display the ask string.
	li $v0, 5	# Read the input.
	syscall		# Make the syscall.
	move $t0, $v0		# n = $v0, Move the user input into t0.
	addi $t1, $0, 0		# i = 0.
	addi $t2, $0, 0		# ans = 0, starting case (n=0).
loop:
	beq $t1, $t0, END	# from i = 0 to n-1 (n times).
	addi $t1, $t1, 1	# i = i + 1.
	li $v0, 4		# load syscall print_string into $v0.
	la $a0, ask2		# Loads the ask2 string.
	syscall			# Make the syscall.
	li $v0, 5		# Read the input.
	syscall			# Make the syscall.
	add $t2, $t2, $v0	# t2 = t2 + input (sums up).
	j loop
END:
	li $v0, 4		# load syscall print_string into $v0.
	la $a0, ans		# Loads the ans string.
	syscall			# Make the syscall.
	move $a0, $t2		# Load the total sum number.
	li $v0, 1		# load syscall print_int into $v0.
	syscall			# Make the syscall.
	li $v0, 10		# load syscall exit into $v0.
	syscall			# Make the syscall.

