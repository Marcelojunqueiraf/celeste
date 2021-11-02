#h_state: 0
#v_state: 4
#grounded: 8
#dash_key: 12
#dash: 16
#wall: 20

.data
dx: .word 0

.text
#a0=position(address) a1=speed(address) a2=colider a3=flags
MOVE:
	addi sp, sp, -24
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)
	sw s4, 20(sp)
	
	mv s0, a0
	mv s1, a1
	mv s3, a2
	mv s4, a3
	
	lw s2, 0(s1) #s2 = x speed
	la t0, dx
	lw t0, 0(t0)
	add s2, s2, t0
	bgt s2, zero, right
	blt s2, zero, left
	j move.vertical
	
right:	
	li t1, 4
	blt s2, t1, move.vertical
	mv a0, s0
	mv a1, s1
	mv a2, s3
	mv a3, s4
	call MOVE_R
	addi s2, s2, -4
	j right
left:	li t1, -4
	bgt s2, t1, move.vertical
	mv a0, s0
	mv a1, s1
	mv a2, s3
	mv a3, s4
	call MOVE_L
	addi s2, s2, 4
	j left
move.vertical:

	lw s2, 4(s1)
	bgt s2, zero, down
	blt s2, zero, up
	j move.fim
up:	beq s2, zero, move.fim
	mv a0, s0
	mv a1, s1
	mv a2, s3
	mv a3, s4
	call MOVE_U
	addi s2, s2, 1
	j up
down:	beq s2, zero, move.fim
	mv a0, s0
	mv a1, s1
	mv a2, s3
	mv a3, s4
	call MOVE_D
	addi s2, s2, -1
	j down
	
move.fim:
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	lw s3, 16(sp)
	lw s4, 20(sp)
	addi sp, sp, 24
	ret
	
#a0=position a1=speed a2=colider address a3=flags
MOVE_R:
	addi sp, sp, -4
	sw ra, 0(sp)
	
	lw t0, 0(a0) #position x
	lw t1, 4(a0) #position y
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
	li t0 -1
	sw t0, 8(a3) #grounded = -1(wall)
	li t0 1
	sw t0, 20(a3) #wall = 1(right)
	sw zero 0(a1) #x speed = 0
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
	
#a0=position a1=speed a2=colider address a3=flags
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
	li t0, -1
	sw t0, 8(a3) #grounded = -1(wall)
	sw t0, 20(a3) #wall = -1(left)	
	sw zero 0(a1) #x speed = -4
	
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
	
#a0=position a1=speed a2=colider address a3=flags
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
	sw zero 4(a1) #y speed = 0
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
	
#a0=position a1=speed a2=colider address a3=flags
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
	call die
	j move_d.fim
move_d.skip_death:
	#check for blue
	li t0, 0xc0c0c0c0
	bne t1, t0, move_d.skip_wall
	sw zero, 8(a3) #grounded = 0(ground)
	li t0, 1
	sw t0, 16(a3) #dash = 1 (enable dash)
	li t0, 0
	sw t0 4(a1) #y speed = 0
	#lw t0, 0(a1)
	#srai t0, t0, 1
	#sw t0, 0(a1)
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

die:
	li t0, 72
	sw t0, 0(s0)
	li t0, 120
	sw t0, 4(s0)
	sw zero, 0(s1)
	sw zero, 4(s1)
	ret
