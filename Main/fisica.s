.data
.eqv gravity_acc 1
.eqv v_dash
.eqv h_resist 1
.eqv m_h_resist -1
.eqv v_resist 1
.eqv h_acc    3
.eqv v_acc    3
.eqv m_v_acc    -3
.eqv h_max 8
.eqv m_h_max -8
.eqv v_max 12
.text
FISICA:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    lw t0, (a0)  #h_state (-1,0,1)
    lw t1, 4(a0) #v_state (-1,0,1)
    lw t2, 8(a0) #grounded
    lw t3, 12(a0) #dash
    lw t4, (a1) #h_speed
    lw t5, 4(a1) #v_speed)
     # atrito horizontal e vertical, velocidades máximas, gravidade 
     #
     #     
     
    addi t5, t5, gravity_acc
    bgt  t0, zero, move_right
    blt  t0, zero, move_left
    
stop_h:  bgt t4, zero, stop_h_right
	 blt t4, zero, stop_h_left
	 j air
stop_h_right: addi t4,t4, m_h_resist
	j air
stop_h_left: addi t4,t4, h_resist
        j air                                                           
                            
move_right: addi t4,t4, v_acc
	j stop_h
move_left:  addi t4,t4 m_v_acc
	j stop_h                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
air:

      
  
    
    
		
fim_fis:                #checagem de velocidades , t4=hspeed t5=vspeed
     #h check
    li t6, h_max 
    bgt  t4,t6, h_over
    li t6, m_h_max
    blt t4, t6, h_over
    #v check
 v_check:   li t6, v_max 
    bgt  t5,t6, v_over
    li t6, m_h_max
    blt t4, t6, v_over
    j no_check
    sw t5, 4(a1)

h_over: mv t4, t6
	j v_check
v_over: mv t5, t6

    #Logica da FISICA
no_check:
    #recolocada de valores
    sw t4, (a1) #h_speed
    sw t5, 4(a1)
    
    lw ra, 0(sp)
    addi sp, sp, 4
    
    ret
