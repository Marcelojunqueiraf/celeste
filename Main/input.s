#a0 = primeira flag
INPUT:
	addi sp, sp, -4 
	sw ra, 0(sp)


	lw ra, 0(sp)
	addi sp, sp, 4
	ret
