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

        icl 'routines.asm'              ; include routines.asm

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