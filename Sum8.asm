ASSUME CS:CODE, DS:DATA

; This line tells the assembler which segments to use for the code and data

DATA SEGMENT
    ; Data segment: defines variables and constants
    NUM1 DB ?        ; First input number (1 byte)
    NUM2 DB ?        ; Second input number (1 byte)
    RESULT DW ?      ; Result of addition (2 bytes)
    MSG1 DB 'Enter first number: $'   ; Prompt for first number
    MSG2 DB 'Enter second number: $'  ; Prompt for second number
    MSG3 DB 'Sum: $'                  ; Label for sum output
    NEWLINE DB 0AH, 0DH, '$'          ; Newline characters
DATA ENDS

CODE SEGMENT
    START:
        ; Initialize data segment
        MOV AX, DATA
        MOV DS, AX

        ; Display prompt for first number
        LEA DX, MSG1
        MOV AH, 09H
        INT 21H

        ; Read first number from user
        MOV AH, 01H
        INT 21H
        SUB AL, 30H  ; Convert ASCII to number
        MOV NUM1, AL

        ; Print newline
        LEA DX, NEWLINE
        MOV AH, 09H
        INT 21H

        ; Display prompt for second number
        LEA DX, MSG2
        MOV AH, 09H
        INT 21H

        ; Read second number from user
        MOV AH, 01H
        INT 21H
        SUB AL, 30H  ; Convert ASCII to number
        MOV NUM2, AL

        ; Print newline
        LEA DX, NEWLINE
        MOV AH, 09H
        INT 21H

        ; Perform addition
        MOV AL, NUM1
        MOV BL, NUM2
        ADD AL, BL
        MOV AH, 00H  ; Clear AH for 16-bit result
        MOV RESULT, AX

        ; Display "Sum: " label
        LEA DX, MSG3
        MOV AH, 09H
        INT 21H

        ; Convert result to ASCII and display
        MOV AX, RESULT
        MOV BL, 10
        DIV BL       ; Divide by 10 to separate digits
        MOV BH, AH   ; Remainder (ones digit)
        MOV BL, AL   ; Quotient (tens digit)

        ; Display tens digit
        MOV DL, BL
        ADD DL, 30H  ; Convert to ASCII
        MOV AH, 02H
        INT 21H

        ; Display ones digit
        MOV DL, BH
        ADD DL, 30H  ; Convert to ASCII
        MOV AH, 02H
        INT 21H

    EXIT:
        ; Exit program
        MOV AH, 4CH
        INT 21H

CODE ENDS
END START
