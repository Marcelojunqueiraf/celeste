#a0=position(address) a1=speed(address) 
MOVE:
	addi sp, sp, -4 
	sw ra, 0(sp)
	add t3, a0, a1
	beq t3, zero, move.fim
	
	lw t3 0(t0) #t3 = x position
	add t3, t3, a0 #position+speed
	sw t3, 0(t0) #update x position
	
	lw t3 4(t0) #t3 = y position 
	add t3, t3, a1 #position+speed
	sw t3, 4(t0) #update y position
	
move.fim:
	lw ra, 0(sp)
	addi sp, sp, 4  
	ret
