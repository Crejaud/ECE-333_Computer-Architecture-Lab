## Written in MIPS Assembly
## Simple program to print out the first Fibonacci number that is greater than 100,000
# Used in assignment 2.
# Registers used:
# $t0 - used to hold F[0] initially. Used as F[n-2].
# $t1 - used to hold F[1] initially. Used as F[n-1].
# $t2 - used to hold F[n-1] + F[n-2].
# $t3 - used to hold 100,000
# $v0 - syscall parameter and return value.
# $a0 - syscall parameter.
.data 0x10000000
	ans: .asciiz “Answer: “
.text 0x00400000
main:
	li $t0, 0	# F[0] = 0
	li $t1, 1	# F[1] = 1
	li $t3, 100000	# Breaking point is 100,000
loop:
	bgt $t1, $t3, END	# until F[n] is greater than 100000
	add $t2, $t1, $t0	# t2 = F[n] = F[n-1] + F[n-2]
	move $t0, $t1		# t0 = t1 = F[n-1]
	move $t1, $t2		# t1 = F[n]
	j loop
END:
	li $v0, 4		# load syscall print_string into $v0
	la $a0, ans		# load ans into $a0
	syscall
	move $a0, $t1		# loads the answer
	li $v0, 1		# loads syscall print_int into $v0
	syscall
	li $v0, 10		# exit
	syscall
