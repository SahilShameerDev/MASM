ASSUME CS:CODE, DS:DATA

DATA SEGMENT
    NUM DB ?
    RESULT DW ?
    MSG1 DB 0DH, 0AH, "Enter a number: $"
    MSG2 DB 0DH, 0AH, "FACTORIAL: $"
    NEWLINE DB 0DH, 0AH, "$"
DATA ENDS

CODE SEGMENT
    START:
        MOV AX, DATA
        MOV DS, AX

        LEA DX, MSG1
        MOV AH, 09H
        INT 21H

        LEA DX, NEWLINE
        MOV AH, 09H
        INT 21H

        MOV AH, 01H
        INT 21H

        SUB AL, 30H

        MOV NUM, AL
        MOV BL, 01
        MOV AX,1
    FACT:
        MUL BL
        INC BL
        DEC NUM
        JNZ FACT
        MOV RESULT, AX

        LEA DX, MSG2
        MOV AH, 09H
        INT 21H
        LEA DX, NEWLINE
        MOV AH, 09H
        INT 21H

        MOV AX, RESULT
        MOV BX, 10
        MOV CX, 0
        
    CONVERT:
        MOV DX, 0
        DIV BX
        PUSH DX
        INC CX
        CMP AX, 0
        JNE CONVERT   

    DISPLAY:
        POP DX
        ADD DL,30H
        MOV AH, 02H
        INT 21H
        LOOP DISPLAY

        LEA DX, NEWLINE
        MOV AH, 09H
        INT 21H

    TERMINATE:
        MOV AH, 4CH
        INT 21H
CODE ENDS
END START

