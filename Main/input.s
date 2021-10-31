#a0 = primeira flag
INPUT:
	addi sp, sp, -4 
	sw ra, 0(sp)

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
FIM_INPUT:	
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
