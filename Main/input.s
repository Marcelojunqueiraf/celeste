INPUT:
    addi sp, sp, -4 
	sw ra, 0(sp)
    #Logica do input
    lw ra, 0(sp)
    addi sp, sp, 4
    ret
