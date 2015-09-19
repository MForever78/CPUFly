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
            jal     clear_cursor
            jal     check_command
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
            add     $a0, $zero, $ra
            jal     push                    # save return address
            addi    $t1, $zero, 8
            bne     $t0, $t1, not_backspace
            addi    $t1, $zero, 28          # can't delete shell hinter
            beq     $s6, $t1, is_backspace  # skip it
            jal     clear_cursor
            addi    $s6, $s6, -4
            addi    $s5, $s5, -4
            addi    $t0, $zero, 32          # t0 is the space char used to empty the last char
            la      $t1, VGA_ADDR
            lw      $t1, 0($t1)             # t1 is the vram base addr
            add     $t1, $t1, $s5           # t1 is the to be written addr
            sw      $t0, 0($t1)             # write the space to vram
            jal     print_cursor
is_backspace:
            addi    $v0, $zero, 1
            j       check_backspace_return
not_backspace:
            add     $v0, $zero ,$zero
            j       check_backspace_return
check_backspace_return:
            add     $t0, $zero, $v0         # save return value to temp reg
            jal     pop
            add     $ra, $zero, $a0         # pop return addr
            add     $v0, $zero, $t0         # give back return value
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

            # Function: print cursor block
print_cursor:
            la      $t0, VGA_ADDR
            lw      $t0, 0($t0)
            add     $t0, $t0, $s5           # t0 is the vram addr
            addi    $t1, $zero, 0xdb        # block ascii code
            sw      $t1, 0($t0)             # write cursor to current addr
            jr      $ra                     # doesn't need move cursor
            # Function: clear cursor block
clear_cursor:
            la      $t0, VGA_ADDR
            lw      $t0, 0($t0)
            add     $t0, $t0, $s5
            addi    $t1, $zero, 0x20        # space ascii code
            sw      $t1, 0($t0)
            jr      $ra

            # Function: compare current input to string addr with a0
compare:
            la      $t0, VGA_ADDR
            lw      $t0, 0($t0)             # t0 is the vram base addr
            add     $t0, $t0, $s5           # t0 is the current cursor addr
            sub     $t0, $t0, $s6           # t0 is the first char of current line
            addi    $t0, $t0, 28            # skip shell hinter
            add     $t1, $zero, $a0         # t1 is the string base addr
            add     $t2, $zero, $zero       # t2 is the loop variable
compare_loop:
            add     $t1, $t1, $t2           # t1 is the current word addr of the string
            lw      $t4, 0($t1)             # t4 is the string word
            add     $t6, $zero, $zero       # t6 is the convert loop variable
            addi    $t7, $zero, 4           # t7 is the convert loop limit
compare_convert_loop:
            beq     $t6, $t7, compare_convert_loop_done
            lw      $t3, 0($t0)             # t3 is the char ascii code on the screen
            andi    $t3, $t3, 0xff          # get out of garbage prefix
            andi    $t5, $t4, 0xff          # get char ascii code byte
            beq     $t5, $zero, equal       # string always finish first
            srl     $t4, $t4, 8
            bne     $t3, $t5, not_equal
            addi    $t0, $t0, 4             # move cursor forward
            addi    $t6, $t6, 1
            j       compare_convert_loop
compare_convert_loop_done:
            addi    $t2, $t2, 4             # move string addr forward
            j       compare_loop
equal:
            addi    $v0, $zero, 1
            j       compare_return
not_equal:
            add     $v0, $zero, $zero
            j       compare_return
compare_return:
            jr      $ra

            # Function: check and execute commands
check_command:
            add     $a0, $zero, $ra
            jal     push                    # save return address
            jal     check_clear
            addi    $t0, $zero, 0
            bne     $v0, $t0, check_command_return  # v0 != 0: is clear
            jal     undefined_command
            j       check_command_return
check_command_return:
            jal     pop
            add     $ra, $zero, $v0
            jr      $ra

            # Function: check clear command
            # return: v0: 1 true 0 false
check_clear:
            add     $a0, $zero, $ra         # save return address
            jal     push
            add     $a0, $zero, $s0
            jal     push
            add     $a0, $zero, $s1
            jal     push
            la      $a0, clear_CMD          # pass the clear command address to function
            jal     compare
            beq     $v0, $zero, not_clear   # v0 == 0: not clear
            add     $s0, $zero, $zero       # s0 is the loop variable
            addi    $s1, $zero, 2400        # s1 is the loop limit
            add     $s5, $zero, $zero       # reset cursor
            add     $s6, $zero, $zero       # reset line counter
clear_loop:
            beq     $s0, $s1, clear_done
            addi    $a0, $zero, 0           # null ascii code
            jal     print_char
            addi    $s0, $s0, 1
            j       clear_loop
clear_done:
            add     $s5, $zero, $zero       # reset cursor
            add     $s6, $zero, $zero       # reset line counter
            addi    $v0, $zero, 1
            j       check_clear_return
not_clear:
            add     $v0, $zero, $zero
            j       check_clear_return
check_clear_return:
            add     $t0, $zero, $v0         # save return value to temp reg
            jal     pop
            add     $s1, $zero, $v0
            jal     pop
            add     $s0, $zero, $v0
            jal     pop
            add     $ra, $zero, $v0
            add     $v0, $zero, $t0         # give back return value
            jr      $ra

undefined_command:
            add     $a0, $zero, $ra
            jal     push                    # save return address
            addi    $s5, $s5, 320
            sub     $s5, $s5, $s6           # move cursor to the very begining
            add     $s6, $zero, $zero       # reset line counter
            la      $a0, undefined_CMD
            jal     print
            jal     pop
            add     $ra, $zero, $v0
            jr      $ra

main:
            # System init
            jal     print_hinter
            jal     print_cursor
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
            jal     print_cursor
            j       wait_kbd                # dead loop

.data 0x10000000

SEG_ADDR:       .word 0x00000000
STK_ADDR:       .word 0x10003000
VGA_ADDR:       .word 0x20000000
KBD_ADDR:       .word 0x30000000
CNT_ADDR:       .word 0x40000000
.align 2
shell_hinter:   .asciiz "MFsh > "
.align 2
clear_CMD:      .asciiz "clear"
.align 2
undefined_CMD:  .asciiz "Undefined command"
