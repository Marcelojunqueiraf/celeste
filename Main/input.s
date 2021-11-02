#a0 = primeira flag
.data
h_parcial: .word 0
.text
INPUT:
	addi sp, sp, -4
	sw ra, 0(sp)
	li t1,0xFF200000		# carrega o endere�o de controle do KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo

  	
  	#ebreak
  	la t6, h_parcial
  	lw t4, 0(t6)
  	beqz t4, zero_parcial
  	blt t4, zero, less_parcial
  	li t3, 1
	sw t3 0(a0) #h_state
	addi t4, t4, -1
	sw t4, 0(t6)
  	j skip_parcial
less_parcial:
	li t3, -1
	sw t3 0(a0) #h_state
	addi t4, t4, 1
	sw t4, 0(t6)
	j skip_parcial
zero_parcial:
	sw zero 0(a0) #h_state
skip_parcial:
  	
  	beq t0,zero,FIM_INPUT   	# Se n�o h� tecla pressionada ent�o vai para FIM
  	lw t2,4(t1)  			# le o valor da tecla tecla
  	
  	#horizontal move
	#check for d
	li t0, 'd'
	bne t2, t0, SKIP_D
	la t6, h_parcial
	li t3, 100
  	sw t3, 0(t6)
SKIP_D:
	#check for a
	li t0, 'a'
	bne t2, t0, SKIP_A
	la t6, h_parcial
	li t3, -100
  	sw t3, 0(t6)
SKIP_A:
	#check for w
	li t0, 'w'
	bne t2, t0, SKIP_W
	li t3, -1
	sw t3 4(a0) #v_state
SKIP_W:
	#check for s
	li t0, 's'
	bne t2, t0, SKIP_S
	li t3, 1
	sw t3 4(a0) #v_state	
	la t6, h_parcial
	lw t3, 0(a0) #h_state
	slli t3, t3, 5
  	sw t3, 0(t6)
SKIP_S:
	#check for j
	li t0, 'j'
	bne t2, t0, SKIP_J
	li t3, 1
	sw t3 12(a0) #dash_key
SKIP_J:
		  				  			# escreve a tecla pressionada no display
FIM_INPUT:	
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
