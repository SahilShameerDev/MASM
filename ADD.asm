ASSUME CS:CODE, DS:DATA


DATA SEGMENT
    ; This marks the beginning of the data segment where variables are defined
    NUM1 DW ?        ; First 16-bit number (Word size, uninitialized)
    NUM2 DW ?        ; Second 16-bit number (Word size, uninitialized)
    SUM DW ?         ; Sum of the two numbers (Word size, uninitialized)
    MSG1 DB 'Enter first number (0-9999): $'  ; Prompt for first number ($ terminates the string)
    MSG2 DB 'Enter second number (0-9999): $' ; Prompt for second number
    MSG3 DB 'Sum: $'                          ; Label for sum output
    NEWLINE DB 0DH, 0AH, '$'                  ; Newline characters (Carriage Return, Line Feed, string terminator)
DATA ENDS

CODE SEGMENT
    ; This marks the beginning of the code segment where instructions are defined
    START:
        MOV AX, DATA     ; Move the address of DATA segment to AX
        MOV DS, AX       ; Set DS to point to our data segment

        ; Display prompt for first number
        LEA DX, MSG1     ; Load Effective Address of MSG1 into DX
        MOV AH, 09H      ; DOS function: print string
        INT 21H          ; Call DOS interrupt to print

        ; Read first number
        MOV BX, 0        ; Clear BX to store the number
        MOV CX, 4        ; Set counter for 4 digits
    READ_NUM1:
        MOV AH, 01H      ; DOS function: read character       
        INT 21H          ; Read a single digit
        SUB AL, 30H      ; Convert ASCII to number (e.g., '5' -> 5)
        MOV AH, 0        ; Clear AH (extend AL to 16-bit in AX)
        PUSH AX          ; Save digit on stack
        MOV AX, BX       ; Move current value to AX
        MOV DX, 10       ; Prepare to multiply by 10
        MUL DX           ; Multiply current value by 10
        POP DX           ; Get digit from stack
        ADD AX, DX       ; Add digit to result
        MOV BX, AX       ; Store result back in BX
        LOOP READ_NUM1   ; Repeat for all 4 digits
        MOV NUM1, BX     ; Store complete first number

        ; Print newline
        LEA DX, NEWLINE
        MOV AH, 09H
        INT 21H

        ; Display prompt for second number
        LEA DX, MSG2
        MOV AH, 09H
        INT 21H

        ; Read second number (same process as first number)
        MOV BX, 0
        MOV CX, 4
    READ_NUM2:
        MOV AH, 01H
        INT 21H
        SUB AL, 30H
        MOV AH, 0
        PUSH AX
        MOV AX, BX
        MOV DX, 10
        MUL DX
        POP DX
        ADD AX, DX
        MOV BX, AX
        LOOP READ_NUM2
        MOV NUM2, BX

        ; Print newline
        LEA DX, NEWLINE
        MOV AH, 09H
        INT 21H

        ; Add the numbers
        MOV AX, NUM1     ; Move first number to AX
        ADD AX, NUM2     ; Add second number to AX
        MOV SUM, AX      ; Store result in SUM

        ; Display sum message
        LEA DX, MSG3
        MOV AH, 09H
        INT 21H

        ; Convert sum to ASCII and display
        MOV AX, SUM      ; Move sum to AX for division
        MOV CX, 4        ; Counter for 4 digits
        MOV BX, 1000     ; Start with thousands (1000, 100, 10, 1)
    DISPLAY_SUM:
        MOV DX, 0       ; Clear DX for division
        DIV BX           ; Divide AX by BX, quotient in AX, remainder in DX
        ADD AL, 30H      ; Convert quotient to ASCII
        MOV DL, AL       ; Move ASCII character to DL
        MOV AH, 02H      ; DOS function: display character
        INT 21H          ; Display the digit
        MOV AX, DX       ; Move remainder to AX for next iteration
        PUSH AX          ; Save AX (remainder)
        MOV AX, BX       ; Move current divisor to AX
        MOV BX, 10       ; Prepare to divide by 10
        MOV DX, 0       ; Clear DX for division
        DIV BX           ; Divide current divisor by 10
        MOV BX, AX       ; Store new divisor
        POP AX           ; Restore AX (remainder)
        LOOP DISPLAY_SUM ; Repeat for all 4 digits

        ; Print newline
        LEA DX, NEWLINE
        MOV AH, 09H
        INT 21H

        ; Exit program
        MOV AH, 4CH      ; DOS function: terminate program
        INT 21H

CODE ENDS
END START
; This marks the end of the code segment and specifies the entry point (START)
