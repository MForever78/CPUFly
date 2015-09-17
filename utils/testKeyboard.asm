		add	$s0, $zero, $zero	# s0 init
		lui	$s0, 0x2000		# s0 saves the video ram base addr
		add 	$s1, $zero, $zero	# s1 init
		lui 	$s1, 0x3000		# s1 saves the keyboard addr
		add 	$s2, $zero, $zero	# s2 init
		lui 	$s2, 0x0000		# s2 saves the 7 seg addr
		add 	$t0, $zero, $zero	# t0 is the keyboard counter
		lw 	$t3, 0($s1)		# t3 is the comparator
wait_kbd:	lw	$t1, 0($s1)		# t1 is the keyboard code
		beq	$t1, $t3, wait_kbd
		srl	$t4, $t1, 24		# t4 is the ascii code
		add 	$t2, $s0, $t0		# t2 is the addr we want to write
		sw	$t4, 0($t2)		# write to screen
		sw 	$t4, 0($s2)		# write to 7 seg
		addi	$t0, $t0, 4		# counter add one
		add	$t3, $zero, $t1		# set comparator
		j 	wait_kbd		# dead loop
