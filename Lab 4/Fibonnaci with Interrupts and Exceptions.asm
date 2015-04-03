## Assignment 5
## Fibonnaci, calculate F[n]
.data

prompt: .asciiz "Enter n: "

nl:	.asciiz "\n"

overflow: .asciiz "Arithmetic overflow.\n"

output: .asciiz "The Fibonacci number is: "
	
.text
	
.globl main

main:

# Register usage:
#		
#		t0		address of recv_ctrl
#		t1		address of recv_buffer
#		t2		address of trans_ctrl
#		t3		address of trans_buffer
#		t4, t5		temporaries: F[n-2] & F[n-1]
#		t6		n from input
#		t7		temporary
#		t8		counter

## Prompt
	li $v0, 4
	la $a0, prompt	
	syscall
	
## Initialization of F[0] and F[1]
	li $t4, 1		# t4 = F[0] = 1
	li $t5, 1		# t5 = F[1] = 1
	li $t8, 2		# counter = 2 (used as F[counter])
	
## Read input n
	li $v0, 5		# Load read_int syscall code into register v0 to get n
	syscall
	move $t6, $v0		# t6 = n
	
## Find F[n]
fib:
	move $t7, $t5		# temp = F[n-1]
	add $t5, $t5, $t4	# F[n] = F[n-1] + F[n-2]
	move $t4, $t7		# F[n-2] = temp
	beq $t8, $t6, breakFib	# if counter = n, go to breakFib
	addi $t8, $t8, 1	# counter++
	beq $0, $0, fib		# else, jump to fib
breakFib:
## output
	
	# Output
	li $v0, 4
	la $a0, output	
	syscall
	
	# Output F[n]
	move $a0, $t5
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall
	
	# Interrupt handler. Replaces the standard SPIM handler.
	.ktext 0x80000180
	mfc0 $t4,$13		# Get ExcCode field from Cause reg
	srl $t5,$t4,2
	
	# Output
	li $v0, 4
	la $a0, overflow	
	syscall
	
	and $t5,$t5,0x1f	# ExcCode field
	bne $t5,0,main		# Not interrupt, it is exception 
