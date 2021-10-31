
.include "MACROSv21.s"
.data
h_state: .word 0
v_state: .word 0
grounded: .word 0
dash: .word 0
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

	li a0, 100
	li a7, 32
	ecall #delay inicial
game_loop:
	csrr s11 time #s11= last time
    input_loop:
	csrr t0 time #t0=current time
	sub t0 t0 s11 #t0 = delta time
	li t1, 200 #200ms
	bgeu t0, t1, fora_loop_input #delta time>200ms
	call MUSIC_CALL
	call INPUT_CALL
	li a0 10
	li a7 32
	ecall #delay 10ms
    j input_loop
fora_loop_input:
	call FISICA_CALL
	call MOVE_CALL
	call RENDER_CALL
	j game_loop


MUSIC_CALL:
    addi sp, sp, -4 
	sw ra, 0(sp)
    li a0, 0 # a0 = dT. Lembrar que tem que ter na memoria qual a musica atual. <--- Quando implementar, adicionar no musica.s!!
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
