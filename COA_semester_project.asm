.data
inputFilePrompt:	.asciiz"Enter input file name: "
outputFilePrompt:	.asciiz"Enter Output File Name: "
key1Prompt:		.asciiz"Enter Key 1: "
key2Prompt:		.asciiz"Enter Key 2: "
actionPrompt:		.asciiz"\nEnter 1 for Encrypt\nEnter 2 for decrypt: "

invalidAction:		.asciiz"Invalid operation"
# Microprocessor without Interlocked Pipeline Stages
inputFile: 	.space 50
outputFile:	.space 50

inputDescriptor:	.word 0
outputDescriptor: 	.word 0
action:			.word 0 # 1 => encrypt, 2 => decrypt, else invalid response

Line:	.space 4096

.text
.globl main	

#=============== Main Function ==================
main:
	jal takeFileNames
	jal TakeKeys
	jal TakeAction
	
	la $a0, inputFile
	jal refine_string	#remove \n from input file name
	
	la $a0,outputFile
	jal refine_string	#remove \n from output file name
	

	
	#====== Open input File =====
	li $v0, 13	#open
	la $a0, inputFile
	li $a1, 0	#read mode
	li $a2, 0
	syscall
	sw $v0, inputDescriptor

	
	#===== open output File ======
	li $v0, 13
	la $a0, outputFile
	li $a1, 1 	#Write Mode
	li $a2, 0
	syscall
	sw $v0, outputDescriptor
	
	#====== Encryption Loop =======
_Encryption_loop:

	# ==== Read File =====
	li $v0, 14
	lw $a0, inputDescriptor
	la $a1, Line
	li $a2, 4096
	syscall
	move $a3, $v0
	
	blez $a3, _fileEnd	# if read bytes less or equal to zero return
	
	# ======== Encrypt File here ========
	la $s5, Line
	lw $v0, action
	beq $v0, 2, _Decrypt_file
	
	jal encrypt
	j _write_file

_Decrypt_file:
	jal decrypt
	
		
_write_file:
	# ===== Write New File ====
	li $v0,15
	lw $a0, outputDescriptor
	la $a1, Line
	move $a2, $a3
	syscall
	
	j _Encryption_loop

_fileEnd:
	# ==== close input File ====
	li $v0, 16
	lw $a0, inputDescriptor
	syscall
	
	# ===== close output File ====
	li $v0,16
	lw $a0, outputDescriptor
	syscall
	
	
	j terminate
	
	
# ============ function: Encrypt the String ===============
encrypt:
	# S0 to S3 are hold for intermediate calculation
	move $s0, $s5	# s5 = line starting Address
	move $s2, $s6	# s6 = key for XOR
	move $s3, $s7	# s7 = key for caesar cipher

_repeat1:
	lbu $s1, 0($s0)
	beqz $s1,_complete1
	# XOR Here
	xor $s1, $s1, $s2	
	
	addi $sp, $sp,-4	# make space on stack
	sw $ra, 0($sp)		# save return address
	
	# Ceasar here
	move $t0, $s1	# pass value
	move $t1, $s3	# pass key
	li $t2, 1
	jal shift
	move $s1, $v0

	lw $ra, 0($sp)      # restore return address
	addi $sp, $sp, 4    # clean up stack
	
	sb $s1, 0($s0)
	addi $s0, $s0, 1
	j _repeat1
_complete1:
	jr $ra

# ============ function: Decrypt the String ===============
decrypt:
	# S0 and S3 are hold for intermediate calculation
	move $s0, $s5	# s5 = line starting Address
	move $s2, $s6	# s6 = key for XOR
	move $s3, $s7	# s7 = key for caesar cipher

_repeat2:
	lbu $s1, 0($s0)
	beqz $s1,_complete2
	
	addi $sp, $sp,-4	# make space on stack
	sw $ra, 0($sp)		# save return address
	
	# Ceasar here
	move $t0, $s1	# pass value
	move $t1, $s3	# pass key
	li $t2, 0
	jal shift
	move $s1, $v0

	lw $ra, 0($sp)      # restore return address
	addi $sp, $sp, 4    # clean up stack
	
	# XOR Here
	xor $s1, $s1, $s2	
	
	sb $s1, 0($s0)
	addi $s0, $s0, 1
	
	j _repeat2
_complete2:
	jr $ra
    
# ======== Function: Circular Rotation ============
# registers occupied: $t0 to $t8
shift:
	move $t3, $t0      # value to rotate (1 byte)
	move $t4, $t1      # number of rotations / key
	move $t5, $t2      # direction: 1=left, 0=right
    
	li   $t8, 8
	div  $t4, $t8
	mfhi $t4           # t4 = rotations % 8

_shift_loop:
	beqz $t4, _shift_done
	beqz $t5, _shift_right

    # ======= LEFT rotate ==========
	sll $t6, $t3, 1          # shift left
	andi $t7, $t3, 0x80      # extract MSB (bit 7)
	srl $t7, $t7, 7          # move MSB to LSB
	or  $t3, $t6, $t7
	andi $t3, $t3, 0xFF
	addi $t4, $t4, -1
	j _shift_loop
    # ======= Right rotate ==========
_shift_right:
	andi $t7, $t3, 0x01      # get LSB
	sll  $t7, $t7, 7         # move LSB to MSB
	srl  $t6, $t3, 1         # shift right
	or   $t3, $t6, $t7
	andi $t3, $t3, 0xFF
	addi $t4, $t4, -1
	j _shift_loop

_shift_done:
	move $v0, $t3
	jr $ra

	

#=============== Funtion: take I/O File names from user =======================
takeFileNames:
	li $v0, 4 
	la $a0, inputFilePrompt
	syscall
	
	li $v0, 8
	la $a0, inputFile
	li $a1, 50
	syscall
	
	li $v0, 4 
	la $a0, outputFilePrompt
	syscall
	
	li $v0, 8
	la $a0, outputFile
	li $a1, 50
	syscall
	
	jr $ra

#============= Function: Take Keys ==================
TakeKeys:
	li $v0, 4
	la $a0, key1Prompt
	syscall
	
	li $v0, 5
	syscall
	move $s6, $v0 
		
	li $v0, 4
	la $a0, key2Prompt
	syscall
	
	li $v0, 5
	syscall
	move $s7, $v0 
	jr $ra

# =========== Function; Encrypt or Decrypt =============
TakeAction:
	li $v0, 4
	la $a0, actionPrompt
	syscall
	
	li $v0, 5
	syscall
	sw $v0, action
	
	beq $v0, 1, _correct
	beq $v0, 2, _correct
	
	li $v0, 4
	la $a0 ,invalidAction
	syscall
	
	j terminate
_correct:
	jr $ra
	
	
#=============== function: remove \n from the string =====================
refine_string:
	# use S0 and S1 for intermediate Calculation
	move $s0, $a0		 # a0 = String starting Address
	
_remove_loop:
    	lb $s1, 0($s0)    	 # load one character
    	beqz $s1, _done     
    	beq $s1, 10, _replace 
    	addi $s0, $s0, 1  	 # move to next char
    	j _remove_loop
    	
_replace:
    sb $zero, 0($s0)   # replace '\n' with '\0'
    
_done:
	jr $ra

# =============== Program Terminates Here =============================
terminate:
	li $v0, 10
	syscall

	
	
