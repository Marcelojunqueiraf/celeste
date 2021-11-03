
.include "MACROSv21.s"
.data
h_state: .word 0
v_state: .word 0
grounded: .word 0
dash_key: .word 0
dash:  .word 0
wall: .word 0
speed: .word 0, 4
position: .word 72, 120
old_position: .word 0, 100
old_background: .space 256
player: .space 256
player_low: .space 256
character: .string "playerlow.bin"
character_low: .string "player.bin"




portrait: .string "Dialog.bin"
lastTime: .word 0
#fase 1
fase1: .string "../fases/fase2.bin"
colider1: .string "../fases/fase2colider.bin"
spawn1: .word 20, 140
STR1: .string "Cacete, que merda de controle"
#fase 2
fase2: .string "../fases/fase4.bin"
colider2: .string "../fases/fase4colider.bin"
spawn2: .word 20, 140
STR2: .string "Modo Turbo"
#fase 3
fase3: .string "../fases/fase1.bin"
colider3: .string "../fases/fase1colider.bin"
spawn3: .word 20, 160
STR3: .string "sandy"
#fase 4
fase4: .string "../fases/fase3.bin"
colider4: .string "../fases/fase3colider.bin"
spawn4: .word 20, 160
STR4: .string "aaa"
#fase5
fase5: .string "../fases/fase5.bin"
colider5: .string "../fases/fase5colider.bin"
spawn5: .word 20, 180
STR5: .string "sanfvg"
#
fases: .word 0,0,0,0 0,0,0,0 0,0,0,0 0,0,0,0 0,0,0,0
fase_atual: .word 0
spawn: .word 0, 0
mute: .word 0
portrait_buff: .space 3600

.text
#load fases
	la t0, fases
	#fase1
	la t1, fase1
	sw t1, 0(t0)
	la t1, colider1
	sw t1, 4(t0)
	la t1, spawn1
	sw t1, 8(t0)
	la t1, STR1
	sw t1, 12(t0)
	addi t0, t0, 16
	#fase2
	la t1, fase2
	sw t1, 0(t0)
	la t1, colider2
	sw t1, 4(t0)
	la t1, spawn2
	sw t1, 8(t0)
	la t1, STR2
	sw t1, 12(t0)
	addi t0, t0, 16
	#fase3
	la t1, fase3
	sw t1, 0(t0)
	la t1, colider3
	sw t1, 4(t0)
	la t1, spawn3
	sw t1, 8(t0)
	la t1, STR3
	sw t1, 12(t0)
	addi t0, t0, 16
	#fase4
	la t1, fase4
	sw t1, 0(t0)
	la t1, colider4
	sw t1, 4(t0)
	la t1, spawn4
	sw t1, 8(t0)
	la t1, STR4
	sw t1, 12(t0)
	addi t0, t0, 16
	#fase5
	la t1, fase5
	sw t1, 0(t0)
	la t1, colider5
	sw t1, 4(t0)
	la t1, spawn5
	sw t1, 8(t0)
	la t1, STR5
	sw t1, 12(t0)
lv_start:
	call LOAD_IMAGES #carrega background e player
	call DIALOG
	call LOAD_IMAGES
	call SET_MUSIC #carrega a musica

game_loop:
	csrr s11, time #s11 = last time
	li s8, 50	# tempo de cada frame

	input_loop:	
		csrr s10, time #s10 = current time
		sub s9, s10, s11 #s10 = delta time
		call INPUT_CALL
	bltu s9, s8, input_loop
	
	la t0, mute
	lw t0, 0(t0)
	bnez t0 skip_music
	mv a0, s9	# a0 = dT

	call MUSIC_CALL
skip_music:

	call FISICA_CALL
	call MOVE_CALL
	call RENDER_CALL
j game_loop
	
FIM:	li a7, 10		# Exit
	ecall


MUSIC_CALL: # a0 = dT.  
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
	la t0, dash
	lw t0, 0(t0)
	slli t0, t0, 8
	la a3 player
	add a3, a3, t0
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
	
		#load player
	#open
	la a0, character_low
	li a1, 0
	li a7, 1024
	ecall#open file
	mv t0, a0 #save descriptor
	#read
	la a1, player_low #frame 0
	li a2, 256 #size
	li a7, 63 #read file
	ecall
	#close file
	mv a0, t0
	li a7 57
	ecall #close file
	
	

	
	
	#draw background in the start of the level
	#open
	la a0, fases
	la t0, fase_atual
	lw t0, 0(t0)
	li t1, 16
	mul t0,t0,t1
	add a0, a0, t0
	lw a0, 0(a0)
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
	la a0, fases
	la t0, fase_atual
	lw t0, 0(t0)
	li t1, 16
	mul t0,t0,t1
	add a0, a0, t0
	lw a0, 4(a0)
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
	
	la a0, fases
	la t0, fase_atual
	lw t0, 0(t0)
	li t1, 16
	mul t0,t0,t1
	add a0, a0, t0
	lw a0, 8(a0)
	
	lw t0, 0(a0)
	lw t1, 4(a0)
	la t2, position
	la t3, spawn
	sw t0, 0(t2)
	sw t1, 4(t2)
	sw t0, 0(t3)
	sw t1, 4(t3)
	
	la t0, h_state #flags
	sw zero, 0(t0)
	sw zero, 4(t0)
	sw zero, 8(t0)
	sw zero, 12(t0)
	sw zero, 16(t0)
	sw zero, 20(t0)
	
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
	
DIALOG:
	addi sp, sp, -4
	sw ra 0(sp)
	
		
	li a0,0
	li a1, 180
	la a3, portrait_buff
	call DRAW_SPRITE_DIALOG
	
	
	
	li a7, 4
	la a0, fases
	la t0, fase_atual
	lw t0, 0(t0)
	li t1, 16
	mul t0,t0,t1
	add a0, a0, t0
	lw a0, 12(a0)
	ecall 
	
	#texto
	li a7 104
	li a1 80
	li a2 200
	li a3, 0x0038	
	la a0, fases
	la t0, fase_atual
	lw t0, 0(t0)
	li t1, 16
	mul t0,t0,t1
	add a0, a0, t0
	lw a0, 12(a0)
	ecall 
	#texto

	lw ra, 0(sp)
	addi sp, sp, 4

LOOP_J:	#check for j
	li t1,0xFF200000		# carrega o endere�o de controle do KDMMIO
  	lw t2,4(t1)  	
	li t0, 'j'
	bne t2, t0, LOOP_J
	
	ret

	
DRAW_SPRITE_DIALOG:
	addi sp, sp, -4 
	sw ra, 0(sp)
	li t3,0xFF000000 #endereco inicial do frame 0
	li t1, 320
	mul a1, a1, t1
	add t3, t3, a1
	
	#open
	la a0, portrait
	li a1, 0
	li a7, 1024
	ecall#open file
	mv t0, a0 #save descriptor
	#read
	  #frame 0
	li t2, 19200 #320*60
	add t2,t3,t2
loopD:	
	mv a0, t0
	mv a1, t3
	li a2, 320 #size
	li a7, 63 #read file
	ecall
	addi t3,t3,320
	bne t3,t2,loopD

	#close file
	mv a0, t0
	li a7 57
	ecall #close file
	
	
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
		
				
.include "SYSTEMv21.s"
.include "fisica.s"
.include "move.s"
.include "render.s"
.include "musica.s"
.include "input.s"
