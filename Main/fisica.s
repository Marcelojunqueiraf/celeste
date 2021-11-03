.data
.eqv gravity_acc 1
.eqv wall_slide_acc 1
.eqv dash_speed
.eqv h_resist 1
.eqv m_h_resist -1
.eqv v_resist 1
.eqv h_acc    7
.eqv m_h_acc    -7
.eqv v_acc    -8
.eqv h_max 10
.eqv m_h_max -10
.eqv v_max 10
.eqv m_v_max -10
.text
FISICA:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    lw t0, (a0)  #h_state (-1,0,1)
    lw t1, 4(a0) #v_state (-1,0,1)
    lw t2, 8(a0) #grounded
    #
    mv t6, a0 
    mv  a0,t2
	li a7 1
	ecall
	mv a0, t6
	#
    lw t3, 12(a0) #dash_key
    lw t4, (a1) #h_speed
    lw t5, 4(a1) #v_speed)
     # atrito horizontal e vertical, velocidades máximas, gravidade 
     #
     #     
     blt t2, zero, wall_slide
     addi t5, t5, gravity_acc
movement:bgt  t0, zero, move_right
     blt  t0, zero, move_left
    
stop_h:  bgt t4, zero, stop_h_right
	 blt t4, zero, stop_h_left
	 j air
stop_h_right: addi t4,t4, m_h_resist
	j air
stop_h_left: addi t4,t4, h_resist
        j air                                                           
        
wall_slide: addi, t5,t5, wall_slide_acc
	j movement
                                                        
move_right: addi t4,t4, h_acc
	j stop_h
move_left:  addi t4,t4 m_h_acc
	j stop_h                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
air:    blt t1, zero, jump
air2:	bgt t3, zero, exec_dash
	j fim_fis

jump:  	sw zero, 4(a0)
	blt t2, zero, wall_jump
	bgt  t2,zero, air2
	li t5 v_acc
	beqz t0, not_h
	mv t4, t0
	slli t4, t4, 3
not_h:
	li a3, 1
	sw a3, 8(a0)
	j air2

wall_jump: lw a3, 20(a0) #wall
	li a4, 1
	sw a4, 8(a0)
	bgt   a3, zero, dir
	li t5,  -9
	li t4, 9
	sw zero, 20(a0)
        j fim_fis
        
dir:	li t5, -9
	li t4, -9
	sw zero, 20(a0)
        j fim_fis
    
exec_dash:  sw zero, 12(a0) #zera dash key
	lw a3, 16(a0)  
	beqz a3, fim_fis
	beqz t0, no_dash
	
yes_dash:	
	sw zero, 16(a0)  #zera dash
	



	mv s0, a0
	mv s1, a1
	
	li a0, 40
	li a1, 500
	li a2, 119
	li a3, 127
	li a7, 31
	ecall
	
	mv a0, s0
	mv a1, s1
	
	bgt t0,zero, right_dash                  #t0 hstate, t1, vstate
n_r_dash:blt t0, zero, left_dash
n_l_dash:blt t1, zero, up_dash	
n_u_dash:bgt t1, zero, down_dash
	 j no_check

no_dash:beqz t1, fim_fis
	j yes_dash
	
right_dash: li t4, 16
	j n_r_dash
	
left_dash: li t4, -16
	j n_l_dash
up_dash: li t5, -16
	j n_u_dash
down_dash:li t5, 16
	j no_check	
		
		
fim_fis:                #checagem de velocidades , t4=hspeed t5=vspeed
     #h check
    li t6, h_max 
    bgt  t4,t6, h_over
    li t6, m_h_max
    blt t4, t6, h_over
    #v check
 v_check:   li t6, v_max 
    bgt  t5,t6, v_over
    li t6, m_v_max
    blt t5, t6, v_over
    j no_check

h_over: mv t4, t6
	j v_check
v_over: mv t5, t6

    #Logica da FISICA
no_check:
    #recolocada de valores
    sw t5, 4(a1) #vspped
    sw t4, (a1) #h_speed
    sw zero, (a0)   #hstate
    sw zero, 4(a0)  #vstate
		    
    lw ra, 0(sp)
    addi sp, sp, 4
    
    ret
