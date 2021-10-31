#a0=position(address) a1=speed(address) 
MOVE:
	addi sp, sp, -4 
	sw ra, 0(sp)
	
	lw t0, 0(a1)
	mv s0, a0
	mv s1, a1
	bgt t0, zero, right
	blt t0, zero, left
	j move.vertical
	
right:	call MOVE_R
	j move.vertical
left:	call MOVE_L
	j move.vertical
move.vertical:
	mv a0, s0
	mv a1, s1
	lw t0, 4(a1)
	bgt t0, zero, down
	blt t0, zero, up
	j move.fim
up:	call MOVE_U
	j move.fim
down:	call MOVE_D
	j move.fim
	
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
colider_r.loop:	
	lw t1, 16(t2)
	#check for red
	li t0, 0x07070707
	bne t1, t0, move_r.skip_death
	li a0 -1
	li a7 1
	ecall
	j move_r.fim
move_r.skip_death:
	#check for blue
	li t0, 0xc0c0c0c0
	bne t1, t0, move_r.skip_wall
	li a0 -2
	li a7 1
	ecall
	j move_r.fim
move_r.skip_wall:
	addi t2, t2, 320
	bne t2, t3, colider_r.loop #checar se já checou todas as alturas
	#Sem colisão	
	lw t3 0(a0) #t3 = x position
	addi t3, t3, 4 #position+4
	sw t3, 0(a0) #update x position
	
move_r.fim:	lw ra, 0(sp)
	addi sp, sp, 4 
	ret
	
#a0=position a1=speed a2=colider address
MOVE_L:
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
	li t3, 5120 #16*320
	add t3, t3, t2
colider_l.loop:	
	lw t1, -4(t2)
	#check for red
	li t0, 0x07070707
	bne t1, t0, move_l.skip_death
	li a0 -1
	li a7 1
	ecall
	j move_r.fim
move_l.skip_death:
	#check for blue
	li t0, 0xc0c0c0c0
	bne t1, t0, move_l.skip_wall
	li a0 -2
	li a7 1
	ecall
	j move_l.fim
move_l.skip_wall:
	addi t2, t2, 320
	bne t2, t3, colider_l.loop #checar se já checou todas as alturas
	#Sem colisão
	lw t3 0(a0) #t3 = x position
	addi t3, t3 -4 #position-4
	sw t3, 0(a0) #update x position
	
move_l.fim:	lw ra, 0(sp)
	addi sp, sp, 4 
	ret
	
#a0=position a1=speed a2=colider address
MOVE_U:
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
	addi t3, t2, 16
colider_u.loop:	
	lw t1, -320(t2)
	#check for red
	li t0, 0x07070707
	bne t1, t0, move_u.skip_death
	li a0 -1
	li a7 1
	ecall
	j move_u.fim
move_u.skip_death:
	#check for blue
	li t0, 0xc0c0c0c0
	bne t1, t0, move_u.skip_wall
	li a0 -2
	li a7 1
	ecall
	j move_u.fim
move_u.skip_wall:
	addi t2, t2, 4
	bne t2, t3, colider_u.loop #checar se já checou todas as alturas
	#Sem colisão
	lw t3 4(a0) #t3 = x position
	addi t3, t3 -1 #y position-1
	sw t3, 4(a0) #update x position
	
move_u.fim:  lw ra, 0(sp)
	addi sp, sp, 4 
	ret
	
#a0=position a1=speed a2=colider address
MOVE_D:
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
	li t0 5120
	add t2, t2, t0
	addi t3, t2, 16
colider_d.loop:	
	lw t1, 0(t2)
	#check for red
	li t0, 0x07070707
	bne t1, t0, move_d.skip_death
	li a0 -1
	li a7 1
	ecall
	j move_d.fim
move_d.skip_death:
	#check for blue
	li t0, 0xc0c0c0c0
	bne t1, t0, move_d.skip_wall
	li a0 -2
	li a7 1
	ecall
	j move_d.fim
move_d.skip_wall:
	addi t2, t2, 4
	bne t2, t3, colider_d.loop #checar se já checou todas as alturas
	#Sem colisão
	lw t3 4(a0) #t3 = y position
	addi t3, t3 1 #y position-+1
	sw t3, 4(a0) #update y position
	
move_d.fim:  lw ra, 0(sp)
	addi sp, sp, 4 
	ret