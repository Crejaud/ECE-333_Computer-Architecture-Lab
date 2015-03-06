## Given mx^2 + nx + p = 0, find positive float root b
## Used in assignment 4.
# Registers used:
# f0 - used to hold read floats
# f1 - used to hold m
# f2 - used to hold n
# f3 - used to hold p
# f4 - used to hold cons
# f5 - used to hold Xi
# f6 - used to hold Xi+1
# f7 - holds inside of sqrt (b)
# f8 - holds abs(Xi+1 - Xi)
# f9 - holds first root
# f10 - holds second root
# fll - holds 4.0, then holds 2.0
# $v0 - syscall parameter and return value.
# $a0 - syscall parameter, and used to pass arguments
.data 0x10000000
	four: .float 4.0
	two: .float 2.0
	cons: .float 0.00001
	initGuess: .float 1.0
	inputm: .asciiz "Enter m: "
	inputn: .asciiz "Enter n: "
	inputp: .asciiz "Enter p: "
	output1: .asciiz "First root = "
	output2: .asciiz "Second root = "
	newLine: .asciiz "\n"
.text 0x00400000
main:
	## DECLARATIONS
	l.s $f4, cons		# f4 = cons
	l.s $f5, initGuess 	# f5 = 1.0
	l.s $f11, four		# f11 = 4.0
	
	## Ask for m
	la $a0, inputm		# Ask for first float
	li $v0, 4			# Loads print_string to $v0
	syscall

	li $v0, 6			# Read the first float input.
	syscall
	
	mov.s $f1, $f0		# f1 = m
	
	## Ask for n
	la $a0, inputn		# Ask for second float
	li $v0, 4			# Loads print_string to $v0
	syscall

	li $v0, 6			# Read the second float input.
	syscall
	
	mov.s $f2, $f0		# f2 = n
	
	## Ask for p
	la $a0, inputp		# Ask for third float
	li $v0, 4			# Loads print_string to $v0
	syscall

	li $v0, 6			# Read the third float input.
	syscall
	
	mov.s $f3, $f0		# f3 = p
	
	## (-n +- sqrt(n^2-4*m*p) )/(2 * m)
	## Find b, (inside sqrt)
	mul.s $f7, $f2, $f2		# f7 = n^2
	mul.s $f8, $f11, $f1	# f8 = 4 * m
	mul.s $f8, $f8, $f3		# f8 = 4 * m * p
	sub.s $f7, $f7, $f8		# f7 = n^2 - 4*m*p, can now reuse f8
	
	l.s $f11, two		# f11 = 2.0
	newtonMethod: # f5 = Xi = 1, f6 = Xi+1
		div.s $f6, $f7, $f5		# f6 = b/Xi
		add.s $f6, $f6, $f5		# f6 = Xi + b/Xi
		div.s $f6, $f6, $f11	# f6 = (Xi + b/Xi) / 2
		sub.s $f8, $f6, $f5		# f8 = Xi+1 - Xi
		abs.s $f8, $f8			# f8 = abs(f8)
		c.lt.s $f8, $f4			# set Condition Flag to true of abs(Xi+1 - Xi) < cons
		bc1t breakLoop			# if Condition Flag = 1 (true), then go to breakLoop
		
		mov.s $f5, $f6		# Xi = Xi+1
		
		j newtonMethod
	
	breakLoop:

	## Now f6 = sqrt(n^2 - 4*m*p)
	## Continue finding root
	neg.s $f2, $f2			# n = -n
	mul.s $f8, $f1, $f11	# f8 = 2*m
	add.s $f9, $f2, $f6		# f9 = -n + sqrt(n^2 - 4*m*p)
	div.s $f9, $f9, $f8		# f9 = root 1
	
	sub.s $f10, $f2, $f6	# f10 = -n - sqrt(n^2 - 4*m*p)
	div.s $f10, $f10, $f8	# f10 = root 2
	
	## Output Volume
	la $a0, output1		# Load output 1 string
	li $v0, 4			# Loads print_string to $v0
	syscall
	
	mov.s $f12, $f9		# Load root 1 float
	li $v0, 2
	syscall
	
	la $a0, newLine		# Load new line
	li $v0, 4			# Loads print_string to $v0
	syscall
	
	## Output Volume
	la $a0, output2		# Load output 2 string
	li $v0, 4			# Loads print_string to $v0
	syscall
	
	mov.s $f12, $f10		# Load root 2 float
	li $v0, 2
	syscall
	
	la $a0, newLine		# Load new line
	li $v0, 4			# Loads print_string to $v0
	syscall
	
	li $v0, 10			# exit
	syscall
