; print a string
; Assumptions
; strptr_lo = low address of the string
; strptr_hi = high address of the string
;       together we have a 16-bit address of the string

; Y = index of current character to process, starts at 0

        .proc print_string
        ldy #0
loop:
        lda (strptr_lo),y               ; with an offset of Y bytes, grab the byte at the 16-bit address
        cmp #0                          ; test if we found the 0 string terminator: A == 0?   
        beq exit                        ; if true, branch to exit
        tya                             ; A = Y
        pha                             ; push A onto the stack
        lda (strptr_lo),y               ; re-fetch current byte of string
        jsr putchar                     ; call putchar to write a character out
        pla                             ; A = pop stack
        tay                             ; Y = A
        iny                             ; Y = Y + 1
        jmp loop                        ; GOTO loop
exit:
        rts                             ; exit subroutine
        .endp

stop:
        jmp stop                        ; GOTO stop                   (infinite loop = program halts here)


; print a character
; Assumptions
; 1. the character is in register A
; 2. the character has been converted to ATASCII
; 3. before calling, save values of X and Y registers

        .proc putchar
        tax             ; X = A                       (save character from A into X because A is about to be clobbered)
        lda putchar_ptr+1 ; A = memory[$347]          (load high byte of OS print routine address)
        pha             ; push A onto stack            (high byte on stack, will be popped second by rts)
        lda putchar_ptr ; A = memory[$346]            (load low byte of OS print routine address)
        pha             ; push A onto stack            (low byte on stack, will be popped first by rts)
        txa             ; A = X                       (restore original character back into A because OS print routine expects character value in A)
        rts             ; RETURN                      (pops OS address from stack and jumps there, OS prints character in A, then returns to main)
        .endp           ; end of putchar procedure