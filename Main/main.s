
.include "MACROSv21.s"
.data
h_state: .word 0
v_state: .word 0
grounded: .word 0
dash_key: .word 0
dash:  .word 1
wall: .word 0
speed: .word 0, 4
position: .word 72, 120
old_position: .word 0, 100
old_background: .space 256
player: .space 256
fase1: .string "fase1.bin"
#fase1: .string "fase1_colider.bin"
colider1: .string "fase1_colider.bin"
character: .string "player.bin"
lastTime: .word 0
.text
	call LOAD_IMAGES #carrega background e player
	call SET_MUSIC #carrega a musica
	
	li a0, 100
	li a7, 32
	ecall #delay inicial

	csrr s11, time #s11 = last time
	j game_loop
	
fora_loop_input:
	call FISICA_CALL
	call MOVE_CALL
	li t3, 0
	csrr s11, time #s11 = last time
game_loop:	
	csrr s10, time #s10 = current time
	sub s9, s10, s11 #s10 = delta time
		
	call INPUT_CALL
	
	li s8, 50	# tempo de cada frame
	bltu s9, s8, game_loop
	mv s11, s10 	# atualiza tempo anterior
	add t3, t3, s9
		
	mv a0, s9
	call MUSIC_CALL	# a0 = dT
	call RENDER_CALL
	
	li s9, 100 #100ms
	bgeu t3, s9, fora_loop_input #delta time > 100ms
	
	j game_loop
	
FIM:	li a7, 10		# Exit
	ecall


MUSIC_CALL: # a0 = dT. Lembrar que tem que ter na memoria qual a musica atual. <--- Quando implementar, adicionar no musica.s!! Por enquanto, Bad Apple
    addi sp, sp, -4 
	sw ra, 0(sp)
	la a1, Musica0 # Le de variavel na memoria qual eh a musica atual e bota em a1
	call MUSIC
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

INPUT_CALL:
	addi sp, sp, -4 
	sw ra, 0(sp)
	la a0, h_state #primeira flag
	call INPUT
	lw ra, 0(sp)
	addi sp, sp, 4
	ret

FISICA_CALL:
	addi sp, sp, -4 
	sw ra, 0(sp)
	la a0, h_state #set parameters
	la a1, speed
	call FISICA
	lw ra, 0(sp)
	addi sp, sp, 4
	ret	
	
MOVE_CALL:
    addi sp, sp, -4 
	sw ra, 0(sp)
	la a0, position
	la a1, speed
	li a2, 0xff100000
	la a3, h_state
	call MOVE
	lw ra, 0(sp)
	addi sp, sp, 4
	ret

RENDER_CALL:
	addi sp, sp, -4 
	sw ra, 0(sp)
	#params
	la a0 old_background
	la a1 old_position
	la a2 position
	la a3 player
	call RENDER
 	lw ra, 0(sp)
	addi sp, sp, 4
	ret

LOAD_IMAGES:
	addi sp, sp, -4
	sw ra 0(sp)
	#load player
	#open
	la a0, character
	li a1, 0
	li a7, 1024
	ecall#open file
	mv t0, a0 #save descriptor
	#read
	la a1, player #frame 0
	li a2, 256 #size
	li a7, 63 #read file
	ecall
	#close file
	mv a0, t0
	li a7 57
	ecall #close file

	#draw background in the start of the level
	#open
	la a0, fase1
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
	#draw background in the start of the level
	#open
	la a0, colider1
	li a1, 0
	li a7, 1024
	ecall#open file
	mv t0, a0 #save descriptor
	#read
	li a1, 0xff100000 #frame 1
	li a2, 76800 #size
	li a7, 63 #read file
	ecall
	#close file
	mv a0, t0
	li a7 57
	ecall #close file
	
	la s0 old_background
	la s1 old_position
	la s2 position
	la s3 player
	call COPY
	la s0 old_background
	la s1 old_position
	la s2 position
	la s3 player
	call DRAW_PLAYER

	lw ra, 0(sp)
	addi sp, sp, 4
	ret
	
.include "SYSTEMv21.s"
.include "fisica.s"
.include "move.s"
.include "render.s"
.include "musica.s"
.include "input.s"
