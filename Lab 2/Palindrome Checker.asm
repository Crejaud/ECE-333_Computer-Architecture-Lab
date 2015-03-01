## Palindrome Checker
## Used in assignment 5.
# Registers used:
# $t0 - user inputed string
# $t1 - index starting at 0
# $t2 - size of string
# $t3 - temporary characters of input string to calculate length
# $t4 - holds 6 then used as first byte pointer
# $t5 - holds 30 then used as last byte pointer
# $v0 - syscall parameter and return value.
# $a0 - syscall parameter.
.data 0x10000000
	buffer: .space 20
	ask: .asciiz "Enter a line of text:  "
	isPal: .asciiz "Palindrome!\n"
	isNotPal: .asciiz "Not a palindrome\n"
	badSize: .asciiz "The string should have been between 6 and 30 characters\n"
	newLine: .asciiz "\n"
.text 0x00400000
main:
	## Declarations
	li $t1, 0		# iterative value i
	li $t4, 6		# 6 is lower bound
	li $t5, 30		# 30 is higher bound

	## Print ask string
	la $a0, ask			# Loads the ask string
	li $v0, 4			# Sets 4 to $v0
	syscall				# display the ask string
	
	## Get string input
	li $v0, 8			# load syscall read_string into $v0.
	la $a0, buffer			# allocate string space.
	li $a1, 20			# allocate byte space for string
	add $t0, $0, $a0		# t0 now holds a copy of the string
	syscall				# make the syscall.

	## Find Length of String
	jal strlen			#  call the strlen function
	
	## Test for size out of bounds
	blt $t2, $t4, ERROR		# if length < 6 then ERROR
	bgt $t2, $t5, ERROR 		# if length > 30 then ERROR

	add $t1, $0, $a0	# t1 now holds a copy of the string
	add $s1, $0, $t2	# Copy of size into s1
loop1:
	ble $t2, 1, CONTINUE	# if size <= 1 then go to CONTINUE
	addi $t1, $t1, 1		# t1++
	sub $t2, $t2, 1			# size--
j loop1
CONTINUE:

li $s0, 0			# first index starts at 0
add $t0, $0, $a0	# t0 now holds copy of string (reset to beginning)

## Start 	
loop2:
	bge $s0, $s1, isPalindrome		# if index1 >= index2 then got to isPalindrome
	lb $t4, 0($t1)		# last byte character pointer
	lb $t5, 0($t0)		# first byte character pointer
	bne $t4, $t5, isNotPalindrome	# if the two characters do not equal, then go to isNotPalindrome
	addi $t0, $t0, 1	# ptr1++
	addi $s0, $s0, 1	# index1++
	sub $t1, $t1, 1		# ptr2--
	sub $s1, $s1, 1		# index2--
j loop2
	
isPalindrome:
	## Print isPal string
	la $a0, isPal		# Loads the isPal string
	li $v0, 4			# Sets 4 to $v0
	syscall				# display the isPal string

	li $v0, 10			# exit
	syscall
isNotPalindrome:
	## Print isNotPal string
	la $a0, isNotPal	# Loads the isNotPal string
	li $v0, 4			# Sets 4 to $v0
	syscall				# display the isNotPal string

	li $v0, 10			# exit
	syscall
	
	

strlen:
	li $t2, -1		# initialize counter to -1 (to ignore \n at the end)
	loop3:
		lb $t3,  0($t0)		# load the next character into t3
		beqz $t3, END		# if character is null then go to END
		addi $t0, $t0, 1	# increment string pointer
		addi $t2, $t2, 1	# counter++
	j loop3
END:
jr $ra		# return back to function call	

ERROR:
	li $v0, 4	# load syscall print_string into v0
	la $a0, badSize	# load badSize string into a0
	syscall

	li $v0, 10	# exit
	syscall
