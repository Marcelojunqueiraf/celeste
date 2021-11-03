###############################################
#  Programa de exemplo para Syscall MIDI      #
#  ISC Abr 2018				      #
#  Marcus Vinicius Lamar		      #
###############################################

.data
# Numero de Notas a tocar
NUM: .word 13
# lista de nota,duração,nota,duração,nota,duração,...
NOTAS: 69,500,76,500,74,500,76,500,79,600, 76,1000,0,1200,69,500,76,500,74,500,76,500,81,600,76,1000

.text
	li a1,100		# define a duração da nota em ms
	li a3,40		# define o volume e limites
	li a7,33		# define o syscall
	li s0,128		# define  limites
	
	li a2,121		# define o instrumento
Iniciar:beq a2, s0, Fim0
	li a0, 30		# define a nota
Loop:	beq a0, s0, Fim
	ecall			# toca a nota
	addi a0, a0, 1
	j Loop
Fim:	addi a2, a2, 1
	j Iniciar
	
Fim0:	li a7,10		# define o syscall Exit
	ecall			# exit

