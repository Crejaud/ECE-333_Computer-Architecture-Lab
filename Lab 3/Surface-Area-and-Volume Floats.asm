## Calculate surface area and volume of cylinder using float type
## Used in assignment 5.
# Registers used:
# f0 - used to hold read floats
# f1 - used to hold radius
# f2 - used to hold height
# f3 - used to hold pi
# f4 - used to hold part of Surface Area
# f5 - used to hold part of Surface Area then volume
# f6 - used to hold 2.0
# $v0 - syscall parameter and return value.
# $a0 - syscall parameter, and used to pass arguments
# $f12 - used to print floats
.data 0x10000000
	pi: .float 3.141592653589793
	two: .float 2.0
	inputR: .asciiz "Enter radius: "
	inputH: .asciiz "Enter height: "
	outputSA: .asciiz "Surface Area = "
	outputV: .asciiz "Volume = "
	newLine: .asciiz "\n"
.text 0x00400000
main:
	## DECLARATIONS
	l.s $f3, pi				# f3 = pi
	l.s $f6, two			# f6 = 2.0
	
	## Ask for R
	la $a0, inputR		# Ask for first float
	li $v0, 4			# Loads print_string to $v0
	syscall

	li $v0, 6			# Read the first float input.
	syscall
	
	mov.s $f1, $f0		# f1 = r
	
	## Ask for H
	la $a0, inputH		# Ask for second float
	li $v0, 4			# Loads print_string to $v0
	syscall

	li $v0, 6			# Read the second float input.
	syscall
	
	mov.s $f2, $f0		# f2 = h
	
	mul.s $f4, $f3, $f1	# f4 = pi * r
	mul.s $f4, $f4, $f6	# f4 = pi * r * 2.0
	mul.s $f5, $f4, $f2	# f5 = 2.0 * pi * r * h
	mul.s $f4, $f4, $f1	# f4 = 2.0 * pi * r^2
	add.s $f4, $f4, $f5	# SA = 2.0 * pi * r^2 + 2.0 * pi * r * h
	
	mul.s $f5, $f3, $f1	# Volume = pi * r
	mul.s $f5, $f5, $f1	# Volume = pi * r^2
	mul.s $f5, $f5, $f2	# Volume = pi * r^2 * h
	
	## Output Surface Area
	la $a0, outputSA		# Load output SA string
	li $v0, 4			# Loads print_string to $v0
	syscall
	
	mov.s $f12, $f4		# Load SA float
	li $v0, 2
	syscall
	
	la $a0, newLine		# Load new line
	li $v0, 4			# Loads print_string to $v0
	syscall
	
	## Output Volume
	la $a0, outputV		# Load output V string
	li $v0, 4			# Loads print_string to $v0
	syscall
	
	mov.s $f12, $f5		# Load V float
	li $v0, 2
	syscall
	
	la $a0, newLine		# Load new line
	li $v0, 4			# Loads print_string to $v0
	syscall
	
	li $v0, 10			# exit
	syscall
