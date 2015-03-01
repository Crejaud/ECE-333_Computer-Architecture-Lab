## Find Median and number of positive, negative, and zeros from unsorted Array
## Used in assignment 7.
# Registers used:
# s1 - holds median
# s2 - holds num of pos ints
# s3 - holds num of neg ints
# s4 - holds num of zeros
# t0 - holds size of array
# t1 - holds address of array
# t2 - iterative index, and eventually the size
# t3 - holds each int of array
# t4 - holds index of array
# t8 - holds address of endChar
# t9 - holds 0xF
# $v0 - syscall parameter and return value.
# $a0 - syscall parameter.
.data 0x10000000
	array: .word 12, 2, -4, 16, 5, -20, 0, 10, 0xF
	buffer: .space 20
	median: .asciiz "Median: "
	numpos: .asciiz "Number of Positive Integers: "
	numneg: .asciiz "Number of Negative Integers: "
	numzero: .asciiz "Number of zeros: "
	endChar: .word 0xF
	newLine: .asciiz "\n"
.text 0x00400000
main:
	## DECLARATIONS
	la $t1, array		# put address of array into t1
	li $t2, 0			# size = 0, initially
	li $t4, 0			# holds 4 * index
	la $t8, endChar		# put address of endChar into t8
	lw $t9, 0($t8)		# t9 now holds 0xF
	li $s1, 0			# median = 0
	li $s2, 0			# numpos = 0
	li $s3, 0			# numneg = 0
	li $s4, 0			# numzero = 0
	
	## Start loop to find size and s2,s3,s4
	loop1:
		mul $t4, $t2, 4			# index = 4*size
		addi $t2, $t2, 1		# size++
		add $t5, $t4, $t1		# combine the two components of the address
		lw $t3, 0($t5)			# get the value from the array cell
		
		beq $t3, $t9, break1	# if word = 0xF, go to break1
		blt $t3, 0, addNeg		# if word < 0, go to addNeg
		bgt $t3, 0, addPos		# if word > 0, go to addPos
		beq $t3, 0, addZero		# if word == 0, go to addZero
		
		j loop1
		
		addNeg:
			addi $s3, $s3, 1	# numneg++
			j loop1
		addPos:
			addi $s2, $s2, 1	# numpos++
			j loop1
		addZero:
			addi $s4, $s4, 1	# numzero++
			j loop1
	
	break1:

	li $v0, 4			# load syscall print_string into v0
	la $a0, newLine		# load newLine string into a0
	syscall
	
	li $v0, 4			# load syscall print_string into v0
	la $a0, numpos		# load numpos string into a0
	syscall
	
	move $a0, $s2		# Load the total sum number
	li $v0, 1			# load syscall print_int into $v0
	syscall
	
	li $v0, 4			# load syscall print_string into v0
	la $a0, newLine		# load newLine string into a0
	syscall
	
	li $v0, 4			# load syscall print_string into v0
	la $a0, numneg		# load numneg string into a0
	syscall
	
	move $a0, $s3		# Load the total sum number
	li $v0, 1			# load syscall print_int into $v0
	syscall
	
	li $v0, 4			# load syscall print_string into v0
	la $a0, newLine		# load newLine string into a0
	syscall
	
	li $v0, 4			# load syscall print_string into v0
	la $a0, numzero		# load numpos numzero into a0
	syscall
	
	move $a0, $s4		# Load the total sum number
	li $v0, 1			# load syscall print_int into $v0
	syscall
	
	li $v0, 4			# load syscall print_string into v0
	la $a0, newLine		# load newLine string into a0
	syscall
	
	## Can now reuse everything except t2 (size)
	## Sort array in ascending order
	sub $t2, $t2, 2		# size-- (to ignore 0xF)
	la $t0, array		# put address of array into t0
	mul $t3, $t2, 4		# t3 = t2 * 4
	add $t0, $t0, $t3	# address + t3 (last index)
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
		bne $a1, $t0, loopj	# if current index of array is not at the end, loop back to loopj
		bne $t1, $0, loopi	# if t1 = 1, another pass is needed, loop back to loopi
	
	addi $t2, $t2, 1	# size++ (go to actual size again)
	
	div $t2, $2			# HI = t2 mod 2
	mfhi $t9			# t9 = HI
	beq $t9, 0, Median2	# if size is even , go to Median 20
	
	# else, size is odd
	sub $t2, $t2, 1		# size--
	la $t0, array		# put address of array into t0
	div $t2, $t2, 2		# size/2
	mul $t3, $t2, 4		# t3 = t2 * 4
	add $t0, $t0, $t3	# address + t3 (median index)
	lw $s2, 0($t0)		# s2 = median word
	
	li $v0, 4			# load syscall print_string into v0
	la $a0, median		# load median string into a0
	syscall
	
	move $a0, $s2		# Load the median number
	li $v0, 1			# load syscall print_int into $v0
	syscall
	
	li $v0, 4			# load syscall print_string into v0
	la $a0, newLine		# load newLine string into a0
	syscall
	
	li $v0, 10			# load exit
	syscall
	
Median2:
	sub $t2, $t2, 1		# size--
	la $t0, array		# put address of array into t0
	div $t2, $t2, 2		# size/2
	mul $t3, $t2, 4		# t3 = t2 * 4
	add $t0, $t0, $t3	# address + t3 (median index)
	lw $s2, 0($t0)		# s2 = median word
	addi $t0, $t0, 4	# go to next word
	lw $t9, 0($t0)		# t9 has next word
	
	add $s2, $s2, $t9	# s2 += t9
	div $s2, $s2, 2		# s2 /= 2
	
	li $v0, 4			# load syscall print_string into v0
	la $a0, median		# load median string into a0
	syscall
	
	move $a0, $s2		# Load the median number
	li $v0, 1			# load syscall print_int into $v0
	syscall
	
	li $v0, 4			# load syscall print_string into v0
	la $a0, newLine		# load newLine string into a0
	syscall
	
	li $v0, 10			# load exit
	syscall
