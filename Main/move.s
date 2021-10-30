#a0=position(address) a1=speed(address) 
MOVE:
	addi sp, sp, -4 
	sw ra, 0(sp)
	
	#add t3, a0, a1
	#beq t3, zero, move.fim
	lw t2, 0(a1)#t2=x speed
	lw t3 0(a0) #t3 = x position
	add t3, t3, t2 #position+speed
	sw t3, 0(a0) #update x position
	
	lw t2, 4(a1)#t2=y speed
	lw t3 4(a0) #t3 = y position
	add t3, t3, t2 #position+speed
	sw t3, 4(a0) #update x position
	
	
move.fim:
	lw ra, 0(sp)
	addi sp, sp, 4  
	ret
