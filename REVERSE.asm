; This program takes a string input from the user and displays it in reverse order

ASSUME CS:CODE, DS:DATA

DATA SEGMENT
    ARR DB 100 DUP(?) ; Array to store the input string (up to 100 characters)
    MSG1 DB 'ENTER THE STRING: $' ; Prompt message for input
    MSG2 DB 'REVERSED STRING: $' ; Message to display before reversed string
    NEWLINE DB 0AH, 0DH, '$' ; Newline characters (0AH = LF, 0DH = CR)
DATA ENDS

CODE SEGMENT
    START:
        ; Initialize data segment
        MOV AX, DATA 
        MOV DS, AX 

        ; Display input prompt
        LEA DX, MSG1
        MOV AH, 09H
        INT 21H

        ; Prepare for input
        LEA SI, ARR ; Load effective address of ARR into SI
        MOV CL, 00H ; Initialize character count to 0
    
    INPUT:
        ; Read a character from user
        MOV AH, 01H
        INT 21H

        ; Check if Enter key (0DH) was pressed
        CMP AL, 0DH
        JZ DISPLAY ; If Enter, jump to DISPLAY

        ; Store character and continue input
        INC CL ; Increment character count
        INC SI ; Move to next array position
        MOV [SI], AL ; Store character in array
        JMP INPUT ; Continue input loop

    DISPLAY:
        ; Print newline
        LEA DX, NEWLINE
        MOV AH, 09H
        INT 21H

        ; Display "REVERSED STRING:" message
        LEA DX, MSG2
        MOV AH, 09H
        INT 21H

    REVERSED:
        ; Display characters in reverse order
        MOV DL, [SI] ; Load character from current position
        MOV AH, 02H ; Function to display a character
        INT 21H

        DEC SI ; Move to previous character
        DEC CL ; Decrement character count
        JNZ REVERSED ; If not zero, continue reversing

    EXIT:
        ; Terminate program
        MOV AH, 4CH
        INT 21H

CODE ENDS
END START
