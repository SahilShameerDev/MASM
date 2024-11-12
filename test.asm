

ASSUME CS:CODE, DS:DATA

DATA SEGMENT
    NUM1 DW ?
    NUM2 DW ?
    RESULT DW ?
    NEWLINE DB 0AH, 0DH, '$'          ; Newline characters
DATA ENDS

CODE SEGMENT
    START:
        MOV AX, DATA
        MOV DS, AX

        ; Read first number from user 
        MOV AH, 01H
        INT 21H
        SUB AL, 30H  ; Convert ASCII to number
        MOV NUM1, AL

        ; Print newline
        LEA DX, NEWLINE
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


        ; Load the numbers
        MOV AX, NUM1
        ADD AX, NUM2
        MOV RESULT, AX

        ; Convert result to ASCII and display                        15/10 = 1 quotient, 5 remainder
        MOV AX, RESULT                                                      ; AX , AH - 5 AL - 1
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

        MOV AH, 4CH
        INT 21H
CODE ENDS
END START
