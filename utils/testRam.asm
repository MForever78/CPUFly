		add 	$s0, $zero, $zero	#s0 init
		lui	$s0, 0x1000		#s0 saves 7 seg addr
		add 	$s1, $zero, $zero	#s1 init, saves ram addr
		add	$s2, $zero, $zero	#s2 init
		lui 	$s2, 0x4000		#s2 saves counter addr
		addi	$t1, $zero, 9		#t1 is loop count
restart:	add 	$t0, $zero, $zero	#t0 is loop variable
loop:		add 	$t2, $s1, $t0		#t2 is the data pointer
		lw 	$t3, 0($t2)		#t3 saves the Ram data
Counter_loop:	lw 	$t4, 0($s2)		#t4 is the Counter value
		bne	$t4, 4, Counter_loop	#wait for a tick
		sw 	$t3, 0($s0)		#write to 7 seg
		addi	$t0, $t0, 1		#add loop variable
		beq	$t0, $t1, restart	#dead loop
		j	loop			#loop go on