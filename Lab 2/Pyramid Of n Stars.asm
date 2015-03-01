## Print out pyramid of letters "*" n times, where n is user input
# Used in assignment 4.
# Registers used:
# $t0 - user inputed integer
# $t1 - iterative variable i
# $t2 - iterative variable j
# $v0 - syscall parameter and return value.
# $a0 - syscall parameter.
.data 0x10000000
	ask: .asciiz "The number of lines?  "
	star: .asciiz "*"
	newLine: .asciiz "\n"
.text 0x00400000
main:
	## Ask for 1st integer
	la $a0, ask		# Ask for first int
	li $v0, 4		# Loads print_string to $v0
	syscall

	li $v0, 5		# Read the first integer input.
	syscall

	move $t0, $v0			# t0 holds first integer
	li $t1, 1			# i = 1
	bge $t0, 1, loopLines		# if input >= 1 go to loop
	
	## if less than 1, quit
	li $v0 10			# exit
	syscall

loopLines:
	bgt $t1, $t0, END		# if i > input go to END
	li $t2, 0				# j = 0
	loopStars:
		bge $t2, $t1, endLoopStars	# if j >= i go to endLoopStars
		li $v0, 4			# load syscall print_string into $v0
		la $a0, star			# print star
		syscall
		addi $t2, $t2, 1		# j++
		j loopStars
	endLoopStars:
	li $v0, 4		# load syscall print_string into $v0
	la $a0, newLine	# print newLine
	syscall
	addi $t1, $t1, 1	# i++
j loopLines

END:
	li $v0, 10		#exit
	syscall
