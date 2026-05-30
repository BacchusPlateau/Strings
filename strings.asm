putchar_ptr = $346                      ; CONSTANT: putchar_ptr = $346 (OS character output vector address)
csrhinh     = $2F0                      ; CONSTANT: csrhinh = $2F0 (OS cursor visible/hidden control address)        
rowcrs      = $54                       ; CONSTANT: rowcrs = $54 (OS zero page address that controls cursor row)
colcrs      = $55                       ; CONSTANT: colcrs = $55 (OS zero page address that controls cursor column)
offset_to_char = $30                    ; Offset from integer literal to ATASCII character equivalent of the number
strptr_lo   = $83                       ; low byte of string address
strptr_hi   = $84                       ; high byte of string address

        org $2000                       ; place the following code at memory address $2000


        .proc main                      ; declare procedure named "main", begin its scope

        mva #1 csrhinh                  ; hide the cursor
        mva #6 rowcrs                   ; set output row
        mva #10 colcrs                  ; set output column
        
        mva #<string1 strptr_lo         ; low byte of string1 address
        mva #>string1 strptr_hi         ; high byte o f string1 address
        jsr print_string                ; print the string

        mva #7 rowcrs                   ; move row output pointer down 1
        mva #10 colcrs                  ; move col output pointer back at 10

        mva #<string2 strptr_lo         ; print second string
        mva #>string2 strptr_hi
        jsr print_string

        jmp stop

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

        .proc putchar
        tax             ; X = A                       (save character from A into X because A is about to be clobbered)
        lda putchar_ptr+1 ; A = memory[$347]          (load high byte of OS print routine address)
        pha             ; push A onto stack            (high byte on stack, will be popped second by rts)
        lda putchar_ptr ; A = memory[$346]            (load low byte of OS print routine address)
        pha             ; push A onto stack            (low byte on stack, will be popped first by rts)
        txa             ; A = X                       (restore original character back into A because OS print routine expects character value in A)
        rts             ; RETURN                      (pops OS address from stack and jumps there, OS prints character in A, then returns to main)
        .endp           ; end of putchar procedure

; data section (reminded me of COBOL)

        .local string1
        .byte 'HELLO FROM STRING ONE!',0
        .endl

        .local string2
        .byte 'AND THIS IS STRING TWO!',0
        .endl

        .endp                           ; end of main procedure

; =====================================================================
; ENTRY POINT
; =====================================================================

        run main                        ; set Atari run address to main (auto-execute when program loads)