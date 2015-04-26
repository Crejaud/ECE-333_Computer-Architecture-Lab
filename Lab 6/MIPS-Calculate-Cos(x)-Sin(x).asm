## Calculate cos(x), sin(x)
## Registers used:
# f0 - holds x
# t1 - holds i (exponent)
# t2 - holds flag: (-1 = sin), (1 = cos)
# t3 - holds cosflag
# t4 - holds sinflag
# t5 - holds -1
# f1 - holds numerator
# f2 - holds denominator
# f3 - holds partial (num/denom)
# f4 - holds float casted flag
# f5 - holds denom + 1
# f6 - holds 1
# f11 - holds cos(x)
# f12 - holds sin(x)
.data 
	inputX: .asciiz “Enter x: “
.text 
.globl main
main: 
	li $t1, 0			# i = 0
	li $t2, 1			# flag = 1
	li $t3, 1			# cosflag = 1
	li $t4, 1			# sinflag = 1
	li $t5, -1			# t5 = -1 (used to invert flags)
	li.s $f1, 1			# numerator = 1
	li.s $f2, 1			# denominator = 1
	li.s $f6, 1			# f6 = 1
	li.s $f11, 0			# cos(x) = 0
	li.s $f12, 0			# sin(x) = 0

	## Take x as input and store in f1
	la $a0, inputX			# Ask for x
	li $v0, 4			# Loads print_string into $v0
	syscall

	li $v0, 6			# Read the first float
	syscall

	mov.s $f0, $f0			# f0 = x

loop:
	bne i, 1, denomCase		# if i != 1, go to denomCase
	li.s $f2, 1			# denom = 1
denomCase:
	div.s $f3, $f1, $f2		# partial = num/denom
	bne $t2, 1, notCos		# if flag != 1, go to notCos
	mtc1 $t3, $f4			# cast cosflag to float
	cvt.s.w $f4, $f4
	mul.s $f3, $f3, $f4		# partial = cosflag*partial
	add.s $f11, $f11, $f3		# cos += partial
	mult $t3, $t5			# LO = cosflag * -1
	mflo $t3			# cosflag = LO
notCos:
	bne $t2, -1, notSin		# if flag != -1, go to notSin
	mtc1 $t4, $f4			# cast sinflag to float
	cvt.s.w $f4, $f4
	mul.s $f3, $f3, $f4		# partial = sinflag*partial
	add.s $f12, $f12, $f3		# sin += partial
	mult $t4, $t5			# LO = sinflag * -1
	mflo $t4			# sinflag = LO
notSin:
	mul.s $f1, $f1, $f0		# numerator *= x
	add.s $f5, $f2, $f6		# f5 = denom + 1
	mul.s $f2, $f2, $f5		# denom *= (denom+1)
	mult $t2, $t5			# LO = flag * -1
	mflo $t2			# flag = LO
	addi $t1, $t1, 1		# i++
	beq $t1, 8, breakLoop		# if i == 8, go to breakLoop
	j loop
breakLoop:
	li $v0, 10			# exit
	syscall

