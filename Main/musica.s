## MIDI Multitracking
# Exemplo de como setar uma musica

.include "Bad_Apple.s" # Modelo: Volume, Nota atual, número de notas, pausa, tempo, nota, tempo, nota, tempo...
.data
Musica0: .word 8, 0, 0, 0, 0, 0, 0, 0, 0

.text
# Rotina
SET_MUSIC:	la a0, Musica0
		la a1, Track0
		sw a1, 4(a0)
		la a1, Track1
		sw a1, 8(a0)
		la a1, Track2
		sw a1, 12(a0)
		la a1, Track3
		sw a1, 16(a0)
		la a1, Track4
		sw a1, 20(a0)
		la a1, Track5
		sw a1, 24(a0)
		la a1, Track6
		sw a1, 28(a0)
		la a1, Track7
		sw a1, 32(a0)
		ret

# Rotina a0 = dT, a1 = Endereco da Array de tracks da musica atual
MUSIC:	addi sp, sp, -4
		sw ra, 0(sp) 
		
		mv a2, a1
		lw a3, 0(a2)
		addi a2, a2, 4
Loop0:		beqz a3, Fim0
		addi sp, sp, -8
		sw a2, 0(sp)
		sw a3, 4(sp)
		lw a1, 0(a2)		# a1 = Endereco da Track atual
		jal AttNotas
		lw a3, 4(sp)	
		lw a2, 0(sp)
		addi sp, sp, 8
		addi a3, a3, -1
		addi a2, a2, 4
		j Loop0
		
Fim0:		lw ra, 0(sp)
		addi sp, sp, 4
		ret			# Retorna o comando para MUSIC_CALL
		
		
# Rotina a0 = dT, a1 = Endereco da Track Atual
AttNotas:	lw a4, 8(a1) 		# a4 = Numero de notas restantes //
		beqz a4, Fim1 		# Tocou a track inteira? Pula para fim
		
		lw a5, 4(a1)		# a5 = Index da nota atual //
		li a2, 8
		mul a2, a5, a2		
		addi a2, a2, 4
		add a2, a1, a2		# a2 = Endereco da nota atual
		
		lw a3, 4(a2)		# a3 = Tempo da nota atual
		sub a3, a3, a0
		sw a3, 4(a2)		# Tempo da nota atual -= dT
		bgtz a3, Fim1		# Nota ainda nao acabou? Pula para fim
		
		addi a4, a4, -1
		sw a4, 8(a1)		# Numero de notas restantes -= 1 //
		addi a5, a5, 1
		sw a5, 4(a1)		# Index da nota atual += 1 //
		
		beqz a4, Fim1
		
		addi sp, sp, -4
		sw a0, 0(sp)
		addi a2, a2, 8
		mv a4, a1
		lw a0, 0(a2)
		lw a1, 4(a2)
		add a1, a1, a3
		sw a1, 4(a2)
		li a2, 0 		# Instrumento
		lw a3, 0(a4)		# Volume
		li a7, 31
		# Resetting variables...
		mv a4, zero
		mv a5, zero
		# a4, a5 are now free!
		ecall
		lw a0, 0(sp)
		addi sp, sp, 4
		
Fim1:		ret			# Retorna o comando para UpdateTracks
