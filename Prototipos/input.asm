.data
h_state: .word 0
v_state: .word 0
speed: .word 0, 0
position: .word 0, 100
old_position: .word 0, 100
old_background: .space 256
player: .space 256
frogger: .string "fase1.bin"
.text

	#load player sprite
	la t0, player
	li t1, 256
	add t1, t0, t1
	li t2, 0xa7a7a7a7
	
load.loop: 
	sw t2, 0(t0)
	addi t0, t0, 4
	bne t0, t1, load.loop


	#draw background in the start of the level
	#open
	la a0, frogger
	li a1, 0
	li a7, 1024
	ecall#open file
	mv t0, a0 #save descriptor
	#read
	li a1, 0xff000000 #frame 0
	li a2, 76800 #size
	li a7, 63 #read file
	ecall
	#close file
	mv a0, t0
	li a7 57
	ecall #close file
	call COPY
	call DRAW_PLAYER
	
lt:	#game loop	
	jal INPUT #get user input
	la t2, h_state #get h_state (-1, 0, 1)
	lw t0, 0(t2) #t0 = hstate
	sw zero, 0(t2) #refresh h_state
	slli t0, t0, 2 #h_state * 4 
	la t1, speed 
	sw t0, 0(t1) #update speed
	#vertical
	la t2, v_state #get v_state (-1, 0, 1)
	lw t0, 0(t2) #t0 = v state
	sw zero, 0(t2) #refresh v_state
	slli t0, t0, 2 #v_state * 4 
	la t1, speed 
	sw t0, 4(t1) #update speed

	call MOVE #change player position acording to speed
	
	call DRAW_PLAYER
	

	li a0, 100
	li a7, 32
	ecall# delay 100ms
	j lt	
	
	
	li a7 10
	ecall#end program


loop:	jal INPUT
	la t0 h_state
	lw a0, 0(t0)
	li a7 1
	ecall
	
	li a0 '\n'
	li a7 11
	ecall
	
	sw zero, 0(t0)
	
	li a0, 10
	li a7, 32
	ecall
	j loop
	
	
	
FRAME:	li s0,0xFF200604	# Escolhe o Frame 0 ou 1
	sw a0,0(s0)
	ret
	
MOVE:	addi sp, sp, -4 
	sw ra, 0(sp)
	la t0, position
	la t1, speed
	lw a0 0(t1) #a0 = x speed
	lw a1 4(t1) #a1 = y speed
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
	
	
DRAW_PLAYER: 	
	addi sp, sp, -4 
	sw ra, 0(sp)
	
	#clear
	la t0, old_position
	lw a0, 0(t0) #X
	lw a1, 4(t0) #Y
	la a3, old_background #sprite
	call DRAW_SPRITE
	
	#update old position
	la t0, old_position
	la t1, position
	lw t2, 0(t1)
	sw t2, 0(t0)
	lw t2, 4(t1)
	sw t2, 4(t0)
	
	#update old_background
	call COPY
	
	#draw player
	#la t0, position
	#lw a0, 0(t0) #X
	#lw a1, 4(t0) #Y
	#la a3, player #sprite
	#call DRAW_SPRITE
	#draw player as a square
	la t0, position
	lw a0, 0(t0)
	lw a1, 4(t0)
	li a3, 0x7a7a7a7a
	call DRAW_RECT
 
	lw ra, 0(sp)
	addi sp, sp, 4 
	
	ret
	

CLEAR1: 	
	addi sp, sp, -4 
	sw ra, 0(sp)
	la t0, old_position
	lw a0, 0(t0)
	lw a1, 4(t0)
#	li a3, 0xc7c7c7c7
	li a3, 0x000000
	call DRAW_RECT
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
	la t0, position
	lw a0, 0(t0)
	lw a1, 4(t0)
	la a3, old_background
	addi sp, sp, -4 
	sw ra, 0(sp)
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

#a0=x a1=y a3= color width=16 height=16
DRAW_RECT:
	addi sp, sp, -4 
	sw ra, 0(sp)
	li t0,0xFF000000 #endereco inicial do frame 0
	li t1, 320
	mul a1, a1, t1
	add t0, t0, a1 #adiciona o y
	add t0, t0, a0 #adiciona o x
	li t2, 5120 #320*16
	add t2, t0, t2 #inicio+height*screenwidth
loop_y: beq t0, t2, FIM_DRAW #Checa se já passou da última fileira
	addi t1, t0, 16 #inicio + width
loop_x:	beq t0, t1, FORA_X_DRAW
	#substituir por lw t3, 0()
	sw a3, 0(t0) #Salvar t3 na memoria de video
	addi t0, t0, 4 #próxima word
	j loop_x
FORA_X_DRAW: addi t0, t0, 304	#320-16 (Proxima linha)
	j loop_y
FIM_DRAW: 
	lw ra, 0(sp)
	addi sp, sp, 4
	ret


### Apenas verifica se h� tecla pressionada
INPUT:	li t1,0xFF200000		# carrega o endere�o de controle do KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,FIM_INPUT   	# Se n�o h� tecla pressionada ent�o vai para FIM
  	lw t2,4(t1)  			# le o valor da tecla tecla
  	
  	#horizontal move
	#check for d
	li t0, 'd'
	bne t2, t0, SKIP_D
	li t3, 1
	la t1, h_state
	sw t3 0(t1)
SKIP_D:
	#check for a
	li t0, 'a'
	bne t2, t0, SKIP_A
	li t3, -1
	la t1, h_state
	sw t3 0(t1)
SKIP_A:
	#check for w
	li t0, 'w'
	bne t2, t0, SKIP_W
	li t3, -1
	la t1, v_state
	sw t3 0(t1)
SKIP_W:
	#check for s
	li t0, 's'
	bne t2, t0, SKIP_S
	li t3, 1
	la t1, v_state
	sw t3 0(t1)
SKIP_S:

		  				  			# escreve a tecla pressionada no display
FIM_INPUT:	ret				# retorna
