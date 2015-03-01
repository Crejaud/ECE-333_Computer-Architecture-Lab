## Let a[0] = 1, a[1]=2, a[n]=(a[n-1] + a[n-2]) * (a[n-1] - a[n-2])
## A simple program in MIPS Assembly to calculate a[6] and print it to the output
# Used in assignment 6.
# Registers used:
# $t0 - the iterative variable i.
# $t1 - used to hold a[0] initially. Used as a[n-2]
# $t2 - used to hold a[1] initially. Used as a[n-1]
# $t3 - used to hold a[n-1] + a[n-2].
# $t4 - used to hold a[n-1] - a[n-2].
# $t5 - used to hold the integer 6
# $LO - used to hold (a[n-1] + a[n-2]) * (a[n-1] - a[n-2]).
# $v0 - syscall parameter and return value.
# $a0 - syscall parameter.
.data 0x10000000
ans: .asciiz "Answer: "
.text 0x00400000
main:
	li $t0, 2	# i starts at 2.
	li $t1, 1	# a[0] = 1.
	li $t2, 2	# a[1] = 2.
	li $t5, 7	# loop will run from i = 2 until i = 7
loop:
	beq $t0, $t5, END	# from i = 2 to 7 (5 times)
	add $t3, $t2, $t1	# $t3 = a[n-1] + a[n-2]
	sub $t4, $t2, $t1	# $t4 = a[n-1] - a[n-2]
	mult $t3, $t4		# $LO = (a[n-1] + a[n-2]) * (a[n-1] - a[n-2])
	move $t1, $t2		# $t1 = $t2
	mflo $t2		# $t2 = $LO
	addi $t0, $t0, 1	# i = i + 1.
	j loop
END:
	li $v0, 4		# load syscall print_string into $v0.
	la $a0, ans		# load ans into $a0.
	syscall			# make syscall.
	move $a0, $t2	# loads the answer a[6]
	li $v0, 1		# load syscall print_int into $v0.
	syscall			# make syscall.
	li $v0, 10		# load syscall exit into $v0.
	syscall			# make syscall.
