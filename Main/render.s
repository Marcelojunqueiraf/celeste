#
#a0 = old_background
#a1 = old_position
#a2 = position
#a3 = player
RENDER:
	addi sp, sp, -20
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)
	
	mv s0, a0
	mv s1, a1
	mv s2, a2
	mv s3 a3
	
	call DRAW_PLAYER

	lw ra, 0(sp)	
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)
	addi sp, sp, 20
	ret

DRAW_PLAYER: 	
	addi sp, sp, -4
	sw ra, 0(sp)

	
	#clear
	lw a0, 0(s1) #X
	lw a1, 4(s1) #Y
	mv a3, s0 #sprite
	call DRAW_SPRITE
	
	#update old position
	lw t0, 0(s2)
	sw t0, 0(s1)
	lw t0, 4(s2)
	sw t0, 4(s1)
	
	#update old_background
	call COPY
	
	#draw player
	lw a0, 0(s2) #X
	lw a1, 4(s2) #Y
	mv a3, s3 #sprite
	call DRAW_SPRITE

	lw ra, 0(sp)	
	addi sp, sp, 4
	ret

#a0=x a1=y a3=sprite width=16 height=16
DRAW_SPRITE:
	addi sp, sp, -4 
	sw ra, 0(sp)
	li t0,0xFF000000 #endereco inicial do frame 0
	li t1, 320
	mul a1, a1, t1
	add t0, t0, a1 #adiciona o y
	add t0, t0, a0 #adiciona o x
	li t2, 5120 #320*16
	add t2, t0, t2 #inicio+height*screenwidth
sprite.loop_y: beq t0, t2, sprite.fim #Checa se já passou da última fileira
	addi t1, t0, 16 #inicio + width
sprite.loop_x:	beq t0, t1, sprite.fora_x
	lw t3, 0(a3)
	sw t3, 0(t0) #Salvar t3 na memoria de video
	addi a3, a3, 4 #próxima word
	addi t0, t0, 4 #próxima word
	j sprite.loop_x
sprite.fora_x: addi t0, t0, 304	#320-16 (Proxima linha)
	j sprite.loop_y
sprite.fim: 
	lw ra, 0(sp)
	addi sp, sp, 4
	ret

#a0=x a1=y a3=buffer width=16 height=16
COPY:
	addi sp, sp, -4 
	sw ra, 0(sp)
	lw a0, 0(s2)
	lw a1, 4(s2)
	mv a3, s0

	li t0,0xFF000000 #endereco inicial do frame 0
	li t1, 320
	mul a1, a1, t1
	add t0, t0, a1 #adiciona o y
	#slli a0, a0, 2
	add t0, t0, a0 #adiciona o x
	li t2, 5120 #320*16
	add t2, t0, t2 #inicio+height*screenwidth
copy.loop_y: beq t0, t2, copy.FIM #Checa se já passou da última fileira
	addi t1, t0, 16 #inicio + width
copy.loop_x:	beq t0, t1, copy.FORA_X
	lw t3, 0(t0) #pegar valor na memória de video
	sw t3, 0(a3) #Salvar t3 no buffer
	addi a3, a3, 4 #próxima word
	addi t0, t0, 4 #próxima word
	j copy.loop_x
copy.FORA_X: addi t0, t0, 304	#320-16 (Proxima linha)
	j copy.loop_y
copy.FIM: 
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
