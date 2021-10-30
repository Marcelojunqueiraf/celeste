#a0=position(address) a1=speed(address) 
MOVE:
	addi sp, sp, -4 
	sw ra, 0(sp)
	
	#add t3, a0, a1
	#beq t3, zero, move.fim
	#lw t2, 0(a1)#t2=x speed
	#lw t3 0(a0) #t3 = x position
	#add t3, t3, t2 #position+speed
	#sw t3, 0(a0) #update x position
	
	#lw t2, 4(a1)#t2=y speed
	#lw t3 4(a0) #t3 = y position
	#add t3, t3, t2 #position+speed
	#sw t3, 4(a0) #update x position
	call MOVE_R
	
move.fim:
	lw ra, 0(sp)
	addi sp, sp, 4  
	ret
#a0=position a1=speed a2=colider address
MOVE_R:
	addi sp, sp, -4
	sw ra, 0(sp)
	
	lw t0, 0(a0) #position x
	lw t1, 4(a0) #position y
	#lw t2, 0(a2) #collider address
	mv t2, a2
	li t3, 320
	add t2, t2, t0
	mul t1, t1, t3
	add t2, t2, t1 #t2 = player address in collider
	li t3, 5120
	add t3, t3, t2
colider_R.loop:	
	lw t1, 16(t2)
	#check for red
	li t0, 0x07070707
	bne t1, t0, skip_death
	li a0 -1
	li a7 1
	ecall
	j move_r.fim
skip_death:
	#check for blue
	li t0, 0xc0c0c0c0
	bne t1, t0, skip_wall
	li a0 -2
	li a7 1
	ecall
	j move_r.fim
skip_wall:
	addi t2, t2, 320
	bne t2, t3, colider_R.loop #checar se já checou todas as alturas
	#Sem colisão	
	lw t2, 0(a1)#t2 = x speed
	lw t3 0(a0) #t3 = x position
	add t3, t3, t2 #position+speed
	sw t3, 0(a0) #update x position
	
move_r.fim:	lw ra, 0(sp)
	addi sp, sp, 4 
	ret