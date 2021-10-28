.data
frogger: .string "frogger.bin"


.text
	#open
	la a0, frogger
	li a1, 0
	li a7, 1024
	ecall
	
	mv t0, a0

	li a1, 0xff000000 #frame 0
	li a2, 76800 #size
	li a7, 63 #read file
	ecall
	
	mv a0, t1
	li a7 57
	ecall
	
	li a7 10
	ecall
	  
