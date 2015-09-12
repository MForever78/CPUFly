		add 	$s0, $zero, $zero	#s0 init
		lui	$s0, 0x1000		#s0 saves 7 seg addr
		add 	$s1, $zero, $zero	#s1 init, saves ram addr
		add	$s2, $zero, $zero	#s2 init
		lui 	$s2, 0x4000		#s2 saves counter addr
		lw	$t3, 0($s2)		#t3 is init time
Counter_loop1:	lw 	$t4, 0($s2)		#t4 is the Counter value
		addi	$t4, $t4, -50
		bne	$t4, $t3, Counter_loop1	#wait for a tick
		addi 	$t0, $zero, 0x1234
		lw	$t3, 0($s2)		#remember last time
		sw	$t0, 0($s0)
Counter_loop2:	lw 	$t4, 0($s2)		#t4 is the Counter value
		addi	$t4, $t4, -50
		bne	$t4, $t3, Counter_loop2	#wait for a tick
		addi 	$t0, $zero, 0x2345
		lw	$t3, 0($s2)		#remember last time
		sw	$t0, 0($s0)
Counter_loop3:	lw 	$t4, 0($s2)		#t4 is the Counter value
		addi	$t4, $t4, -50
		bne	$t4, $t3, Counter_loop3	#wait for a tick
		addi 	$t0, $zero, 0x3456
		lw	$t3, 0($s2)		#remember last time
		sw	$t0, 0($s0)
Counter_loop4:	lw 	$t4, 0($s2)		#t4 is the Counter value
		addi	$t4, $t4, -50
		bne	$t4, $t3, Counter_loop4	#wait for a tick
		addi 	$t0, $zero, 0x4567
		lw	$t3, 0($s2)		#remember last time
		sw	$t0, 0($s0)
Counter_loop5:	lw 	$t4, 0($s2)		#t4 is the Counter value
		addi	$t4, $t4, -50
		bne	$t4, $t3, Counter_loop5	#wait for a tick
		addi 	$t0, $zero, 0x5678
		lw	$t3, 0($s2)		#remember last time
		sw	$t0, 0($s0)
Counter_loop6:	lw 	$t4, 0($s2)		#t4 is the Counter value
		addi	$t4, $t4, -50
		bne	$t4, $t3, Counter_loop6	#wait for a tick
		addi 	$t0, $zero, 0x6789
		lw	$t3, 0($s2)		#remember last time
		sw	$t0, 0($s0)
Counter_loop7:	lw 	$t4, 0($s2)		#t4 is the Counter value
		addi	$t4, $t4, -50
		bne	$t4, $t3, Counter_loop7	#wait for a tick
		addi 	$t0, $zero, 0x7891
		lw	$t3, 0($s2)		#remember last time
		sw	$t0, 0($s0)
Counter_loop8:	lw 	$t4, 0($s2)		#t4 is the Counter value
		addi	$t4, $t4, -50
		bne	$t4, $t3, Counter_loop8	#wait for a tick
		addi 	$t0, $zero, 0x8912
		lw	$t3, 0($s2)		#remember last time
		sw	$t0, 0($s0)
Counter_loop9:	lw 	$t4, 0($s2)		#t4 is the Counter value
		addi	$t4, $t4, -50
		bne	$t4, $t3, Counter_loop9	#wait for a tick
		addi 	$t0, $zero, 0x9123
		lw	$t3, 0($s2)		#remember last time
		sw	$t0, 0($s0)
		j	Counter_loop1