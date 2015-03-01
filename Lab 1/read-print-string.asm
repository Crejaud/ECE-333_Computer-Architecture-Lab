## Simple Program in MIPS Assembly to read and print a string
# Used in assignment 4
# Registers used:
# $v0 - syscall parameter and return value.
# $a0 - syscall parameter.
.data
	buffer: .space 20
	ask: .asciiz "Enter a word: "
	ans: .asciiz "\nYou Entered: "
.text
.globl main
main:
	la $a0, ask			# Loads the ask string
	li $v0, 4			# Sets 4 to $v0
	syscall				# display the ask string
	
	li $v0, 8			# load syscall read_string into $v0.
	la $a0, buffer		# allocate string space.
	li $a1, 20			# allocate byte space for string
	move $t0, $a0		# t0 now holds the string
	syscall				# make the syscall.
	
	la $a0, ans			# Loads the answer string
	li $v0, 4			# load syscall print_string into $v0.
	syscall				# make the syscall.

	la $a0, buffer		# reload byte space
	move $a0, $t0		# Loads the read_string
	li $v0, 4			# load syscall print_string into $v0
	syscall				# make the syscall.
	
	li $v0, 10			# load syscall exit into $v0.
	syscall				# make the syscall.
