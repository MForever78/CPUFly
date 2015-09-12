		add	$s0, $zero, $zero
		lui	$s0, 0x1000
		addi	$s1, $zero, 0x1234
		sw	$s1, 0($s0)
dead_loop:	j 	dead_loop
