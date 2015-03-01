## Convert hex to decimal
## Used in assignment 6.
# Registers used:
# $s0 - holds ArrayHEX
# $s1 - holds characters of ArrayHEX
# $s2 - holds hexSize
# $s3 - iterative value i
# $t0 - user inputed string
# $t1 - index starting at 0
# $t2 - size of string
# $t3 - temporary characters of input string to calculate length
# $t4 - decimal running total
# $t5 - holds 16
# $t6 - holds current value of decimal char
; # $t7 - iterative value j to get exponent 16 to the n
# $v0 - syscall parameter and return value.
# $a0 - syscall parameter.
.data 0x10000000
	ArrayHEX: .ascii "0123456789ABCDEF"
	hexSize: .word 16
	buffer: .space 20
	ask: .asciiz "Hex string: "
	ans: .asciiz "Its decimal value: "
	notHex: .asciiz "Invalid hex string\n"
	newLine: .asciiz "\n"
.text 0x00400000
main:
	## Declarations
	li $t1, 0			# decimal total = 0
	
	## Print ask string
	la $a0, ask			# Loads the ask string
	li $v0, 4			# Sets 4 to $v0
	syscall				# display the ask string
	
	## Get string input
	li $v0, 8			# load syscall read_string into $v0.
	la $a0, buffer		# allocate string space.
	li $a1, 20			# allocate byte space for string
	add $t0, $0, $a0	# t0 now holds a copy of the string
	syscall				# make the syscall.
	
	add $t9, $t9, $a0	# t9 also holds copy of string
	
	## Find Length of String and check if valid hex string
	jal strlen			#  call the strlen function, t2 holds size
	
	## Find decimal value
	li $t5, 16			# used to convert 
	jal findDec			# call the findDec function

	
findDec:
	sub $t2, $t2, 1		# size--
	beq $t2, -1, RESULT		# if size == -1, go to RESULT
	lb $t3,  0($t9)		# load the next character into t3
	addi $t9, $t9, 1		# t9++ (go to next index for next iteration)
	la $s0, ArrayHEX	# s0 holds ArrayHEX
	lw $s2, hexSize		# s2 holds hexSize
	li $s3, 0			# i = 0 (holds value of individual character)
	loopFindValue:
		lb $s1, 0($s0)	# get character from ArrayHEX
		beq $s1, $t3, break1	# if the character from ArrayHEX = character from string, go to break1
		addi $s0, $s0, 1		# s0 goes to next index
		addi $s3, $s3, 1		# value++
		j loopFindValue
	break1:
	li $t7, 1		#t7 = 1
	li $t6, 1		#t6 = 1
	loopFindExp:
		bgt $t7, $t2, break2	# if size and t7 are equal, then go to break 2
		mult $t6, $t5		# LO = t6 * 16
		mflo $t6			# t6 = LO
		addi $t7, $t7, 1	# t7++
		j loopFindExp
	break2:
	mult $t6, $s3		# LO = total value of character
	mflo $t7			# t7 temporarily holds LO
	add $t1, $t1, $t7	# total dec value += LO
j findDec

strlen:
	li $t2, 0		# initialize counter to 0 (to ignore \n at the end)
	loopFindSize:
		lb $t3,  0($t0)		# load the next character into t3
		lb $t4,  1($t0)		# load the next next character to check if that is null
		beqz $t3, END		# if character is null then go to END
		beqz $t4, END		# if character is null then go to END
		
		##TEST
		#la $a0, buffer		# reload byte space
		#move $a0, $t3		# Loads the read_string
		#li $v0, 11			# load syscall print_string into $v0
		#syscall				# make the syscall.
		
		la $s0, ArrayHEX	# s0 holds ArrayHEX
		lw $s2, hexSize		# s2 holds hexSize
		li $s3, 0			# i = 0
		j checkLoopValid	# jump to checkLoopValid
		RETURN:
		addi $t0, $t0, 1	# increment string pointer
		addi $t2, $t2, 1	# counter++
	j loopFindSize
	checkLoopValid:
		lb $s1, 0($s0)	# get each character of ArrayHEX
		
		beq $t3, $s1, RETURN	# if the character in input exists in ArrayHEX then go to RETURN
		addi $s0, $s0, 1		# go to next character in ArrayHEX
		addi $s3, $s3, 1		# i++
		beq $s3, $s2, ERROR		# if i = size then go to ERROR
	j checkLoopValid
END:
jr $ra		# return back to function call

ERROR:
	li $v0, 4	# load syscall print_string into v0
	la $a0, notHex	# load notHex string into a0
	syscall

	li $v0, 10	# exit
	syscall
	
RESULT:
	li $v0, 4	# load syscall print_string into v0
	la $a0, ans	# load ans string into a0
	syscall

	## Display decimal value
	move $a0, $t1		# Load the total sum number
	li $v0, 1		# load syscall print_int into $v0
	syscall
	
	li $v0, 4	# load syscall print_string into v0
	la $a0, newLine	# load newLine string into a0
	syscall
	
	li $v0, 10	# exit
	syscall
