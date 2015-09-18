.text       0x00000000
start:
            add     $s5, $zero, $zero       # s5 is the global cursor pointer
            add     $s6, $zero, $zero       # s6 is the line counter
            la      $sp, STK_ADDR
            lw      $sp, 0($sp)             # load stack pointer addr
            j       main

            # Function: print string
            # param: a0 string base addr
print:      add     $t0, $zero, $a0         # t0 saves the string base addr
            add     $a0, $zero, $ra         # save return address
            jal     push
            add     $a0, $zero, $s0
            jal     push                    # save s0
            add     $a0, $zero, $s1
            jal     push                    # save s1
            add     $a0, $zero, $s2
            jal     push                    # save s2
            add     $a0, $zero, $s3
            jal     push                    # save s3
            add     $a0, $zero, $s4
            jal     push                    # save s4

            add     $s0, $zero, $t0         # s0 is the string base addr
            add     $s1, $zero, $zero       # s1 is the loop variable
print_loop:
            add     $s4, $s0, $s1           # s4 saves the current 4 chars addr
            lw      $s4, 0($s4)             # s4 loads the word data, waiting to be converted to byte
            add     $s2, $zero, $zero       # s2 is the convert_loop variable
            addi    $s3, $zero, 4           # s3 is the convert_loop limit
convert_loop:
            beq     $s2, $s3, convert_done
            andi    $t0, $s4, 0xff          # load last 8 bit
            srl     $s4, $s4, 8             # shift right an ascii code
            beq     $t0, $zero, print_return    # returns at null char
            add     $a0, $zero, $t0
            jal     print_char              # print char properly
            addi    $s2, $s2, 1             # add convert loop variable
            j       convert_loop
convert_done:
            addi    $s1, $s1, 4
            j       print_loop
print_return:
            jal     pop
            add     $s4, $zero, $v0
            jal     pop
            add     $s3, $zero, $v0
            jal     pop
            add     $s2, $zero, $v0
            jal     pop
            add     $s1, $zero, $v0
            jal     pop
            add     $s0, $zero, $v0
            jal     pop
            add     $ra, $zero, $v0
            jr      $ra

            # Function: print shell hinter
print_hinter:
            add     $a0, $zero, $ra
            jal     push                    # save return address
            la      $a0, shell_hinter       # load shell hinter string address
            add     $a1, $zero, $s5         # pass global cursor pointer
            jal     print
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
            add     $a0, $zero, $ra         # save the return address
            jal     push
            add     $a0, $zero, $s0
            jal     push                    # save s0 for later use
            addi    $t1, $zero, 10
            bne     $t0, $t1, not_enter
            addi    $s5, $s5, 320           # move cursor down one line
            sub     $s5, $s5, $s6           # move the cursor to the very begining
            add     $s6, $zero, $zero       # clear the line counter
            jal     print_hinter
            addi    $s0, $zero, 1           # tell caller true
            j       check_enter_return
not_enter:
            add     $s0, $zero, $zero
            j       check_enter_return      # return explicityly
check_enter_return:
            add     $t0, $zero, $s0         # save return value to temp reg
            jal     pop
            add     $s0, $zero, $v0         # recover s0
            jal     pop                     # get return address from stack
            add     $ra, $zero, $v0
            add     $v0, $zero, $t0         # set return value
            jr      $ra

            # Function: check if a0 is backspace
check_backspace:
            add     $t0, $zero, $a0
            addi    $t1, $zero, 8
            bne     $t0, $t1, not_backspace
            addi    $t1, $zero, 28          # can't delete shell hinter
            beq     $s6, $t1, is_backspace  # skip it
            addi    $s6, $s6, -4
            addi    $s5, $s5, -4
            addi    $t0, $zero, 32          # t0 is the space char used to empty the last char
            la      $t1, VGA_ADDR
            lw      $t1, 0($t1)             # t1 is the vram base addr
            add     $t1, $t1, $s5           # t1 is the to be written addr
            sw      $t0, 0($t1)             # write the space to vram
is_backspace:
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
            la      $t1, VGA_ADDR           # load VGA addr
            lw      $t1, 0($t1)
            add     $t1, $t1, $s5           # t1 is the vram addr to write on
            sw      $t0, 0($t1)
            la      $t1, SEG_ADDR
            lw      $t1, 0($t1)             # t1 is the 7 seg addr
            sw      $t0, 0($t1)             # write to 7 seg for debugging
            addi    $s5, $s5, 4
            addi    $s6, $s6, 4
            addi    $t1, $zero, 320
            bne     $s6, $t1, print_char_end    # handle line counter
            add     $s6, $zero, $zero
            j       print_char_end
print_char_end:
            jr      $ra
main:
            # System init
            jal     print_hinter
            la      $t0, KBD_ADDR
            lw      $s0, 0($t0)             # s0 is the KBD_ADDR
            lw      $s1, 0($s0)             # s1 is the comparator
            # Main loop
wait_kbd:
            lw      $s2, 0($s0)             # s2 is the current keyboard value
            beq     $s1, $s2, wait_kbd
            add     $s1, $zero, $s2         # saves the old keyboard value
            srl     $s2, $s2, 24            # s2 is the ASCii code
            add     $a0, $zero, $s2         # pass ASCii code to function
            jal     check_enter
            bne     $v0, $zero, wait_kbd    # v0 == 0: not enter
            add     $a0, $zero, $s2         # pass ASCii code to function
            jal     check_backspace
            bne     $v0, $zero, wait_kbd    # v0 == 0: not backspace
            add     $a0, $zero, $s2         # pass ASCii code to function
            jal     print_char
            j       wait_kbd                # dead loop

.data 0x10000000

SEG_ADDR:       .word 0x00000000
STK_ADDR:       .word 0x10003000
VGA_ADDR:       .word 0x20000000
KBD_ADDR:       .word 0x30000000
CNT_ADDR:       .word 0x40000000
shell_hinter:   .asciiz "MFsh > "
