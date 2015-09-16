.text       0x00000000
start:      add     $s0, $zero, $zero        # s0-s4: Ram, 7 seg, VGA, Keyboard, Counter
            lui     $s0, 0x0000
            add     $s1, $zero, $zero
            lui     $s1, 0x1000
            add     $s2, $zero, $zero
            lui     $s2, 0x2000
            add     $s3, $zero, $zero
            lui     $s3, 0x3000
            add     $s4, $zero, $zero
            lui     $s4, 0x4000
            add     $s5, $zero, $zero       # s5 is the global cursor pointer
            add     $s6, $zero, $zero       # s6 is the line counter
            add     $sp, $zero, $zero       # sp init
            addi    $sp, $sp, 0xffff        # sp start at 0xffff, growing up
            j       main

            # Function: print string
print:      add     $t0, $zero, $a0         # t0 saves the string base addr
            add     $t2, $zero, $a1	        # t2 saves the base cursor position
            add     $t3, $zero, $zero       # t3 is the loop variable
            add     $a0, $zero, $ra         # save return address
            jal     push
print_loop:
            add     $t4, $t2, $t3           # t4 is the current cursor position
            add     $t5, $t0, $t3           # t5 saves the current char addr
            lw      $t5, 0($t5)             # t5 loads the word data, waiting to be converted to byte
            add     $t6, $t6, $zero         # t6 is the convert_loop variable
            addi    $t1, $t1, 4             # t1 is the convert_loop limit
convert_loop:
            beq     $t6, $t1, convert_done
            andi    $t7, $t5, 0xff          # load last 8 bit
            srl     $t5, $t5, 8             # shift right an ascii code
            beq     $t7, $zero, print_return    # returns at null char
            add     $a0, $zero, $t7
            jal     print_char              # print char properly
            addi    $t6, $t6, 1             # add convert loop variable
            j       convert_loop
convert_done:
            addi    $t3, $t3, 4
            j       print_loop
print_return:
            jal     pop
            add     $ra, $zero, $v0
            add     $v0, $t4, $t3           # returns the current ram addr
            jr      $ra

            # Function: print shell hinter
print_hinter:
            add     $a0, $zero, $ra
            jal     push                    # save return address
            la      $a0, shell_hinter	# load shell hinter string address
            add     $a1, $zero, $s5         # pass global cursor pointer
            jal     print
            add     $s5, $zero, $v0         # update global cursor pointer
            addi    $s6, $zero, 28           # update line counter
            jal     pop
            add     $ra, $zero, $v0         # pop return address
            jr      $ra

push:
            addi    $sp, $sp, -4
            sw      $a0, 0($sp)             # save argument a0
            jr      $ra
pop:
            lw      $v0, 0($sp)             # return poped value
            addi    $sp, $sp, 4
            jr      $ra

            # Function: check if a0 is enter
check_enter:
            add     $t0, $zero, $a0         # get the ASCii code
            addi    $t1, $zero, 10
            bne     $t0, $t1, not_enter
            addi    $s5, $s5, 320           # move cursor down one line
            sub     $s5, $s5, $s6           # move the cursor to the very begining
            add     $a0, $zero, $ra         # save the return address
            jal     push
            jal     print_hinter
            addi    $v0, $zero, 1           # tell callee true
            jal     pop                     # get return address from stack
            add     $ra, $zero, $v0
            j       check_enter_return
not_enter:
            add     $v0, $zero, $zero
            j       check_enter_return      # return explicityly
check_enter_return:
            jr      $ra
            # Function: check if a0 is backspace
check_backspace:
            add     $t0, $zero, $a0
            addi    $t1, $t1, 8
            bne     $t0, $t1, not_backspace
            addi    $t1, $t1, 28
            beq     $s6, $t1, check_backspace_return
            addi    $s6, $s6, -4
            addi    $s5, $s5, -4
            addi    $t1, $zero, 32          # t1 is the space char used to empty the last char
            add     $t2, $s5, $s2           # t2 is the vram addr
            sw      $t1, 0($t2)
            addi    $v0, $zero, 1
            j       check_backspace_return
not_backspace:
            add     $v0, $zero ,$zero
            j       check_backspace_return
check_backspace_return:
            jr      $ra
            # Function: print single char
print_char:
            add     $t0, $zero, $a0         # t0 is the char to be printed
            add     $t1, $s2, $s5           # t1 is the vram addr
            sw      $t0, 0($t1)
            addi    $s5, $s5, 4
            addi    $s6, $s6, 4
            addi    $t1, $t1, 320
            bne     $s6, $t1, print_char_end
            add     $s6, $zero, $zero
            j       print_char_end
print_char_end:
            jr      $ra
main:
            # System init
            jal     print_hinter
            lw      $s7, 0($s3)             # s7 is the comparator
            # Main loop
wait_kbd:
            lw      $a3, 0($s3)             # a3 is the current keyboard value
            beq     $s7, $a3, wait_kbd
            add     $s7, $zero, $a3         # saves the old keyboard value
            andi    $a3, $a3, 0xff          # a3 is the ASCii code
            add     $a0, $zero, $a3         # pass ASCii code to function
            jal     check_enter
            bne     $v0, $zero, wait_kbd    # v0 == 0: not enter
            add     $a0, $zero, $a3         # pass ASCii code to function
            jal     check_backspace
            bne     $v0, $zero, wait_kbd    # v0 == 0: not backspace

.data 0x10000000

shell_hinter:
		.asciiz "MFsh > "
