; This program checks if a string is a palindrome
; A palindrome reads the same forwards and backwards (e.g., "RADAR", "LEVEL")
; The program does the following:
; 1. Prompts user for input string
; 2. Stores characters one by one until Enter is pressed
; 3. Compares characters from start and end, moving inward
; 4. If all characters match, it's a palindrome
; 5. If any characters don't match, it's not a palindrome

ASSUME CS:CODE, DS:DATA

DATA SEGMENT
    STR DB 100 DUP(?) ; Array to store up to 100 input characters
    LEN DB 0          ; Variable to store length of input string
    MSG1 DB 'Enter a string: $'  ; Prompt message
    MSG2 DB 0AH,0DH,'String is a palindrome$'      ; Success message with newline
    MSG3 DB 0AH,0DH,'String is not a palindrome$'  ; Failure message with newline
    NEWLINE DB 0AH,0DH,'$'       ; Newline characters (0AH=LF, 0DH=CR)
DATA ENDS

CODE SEGMENT
    START:
        ; Initialize data segment register
        MOV AX, DATA
        MOV DS, AX

        ; Display prompt for user input
        LEA DX, MSG1    ; Load address of prompt message
        MOV AH, 09H     ; DOS function for string output
        INT 21H

        ; Input string character by character
        MOV CX, 0       ; Initialize counter for string length
        LEA SI, STR     ; SI register points to start of string buffer

    INPUT_LOOP:
        MOV AH, 01H     ; DOS function for character input
        INT 21H
        
        CMP AL, 0DH     ; Check if Enter key (carriage return) was pressed
        JE CHECK_PAL    ; If Enter pressed, begin palindrome check
        
        MOV [SI], AL    ; Store input character in string buffer
        INC SI          ; Move to next position in buffer
        INC CX          ; Increment length counter
        JMP INPUT_LOOP  ; Continue reading characters

    CHECK_PAL:
        MOV LEN, CL     ; Store final string length
        
        LEA SI, STR     ; SI points to start of string
        LEA DI, STR     ; DI will point to end of string
        ADD DI, CX      ; Move DI to position after last character
        DEC DI          ; Adjust DI to point to last character
        
        MOV CL, LEN     ; Load string length for comparison loop
        SHR CL, 1       ; Divide length by 2 (only need to check half the string)

    COMPARE_LOOP:
        MOV AL, [SI]    ; Get character from start of string
        MOV BL, [DI]    ; Get character from end of string
        
        CMP AL, BL      ; Compare the two characters
        JNE NOT_PAL     ; If they don't match, string is not a palindrome
        
        INC SI          ; Move forward one character from start
        DEC DI          ; Move backward one character from end
        LOOP COMPARE_LOOP  ; Continue until half of string is checked
        
        ; If all comparisons passed, string is a palindrome
        LEA DX, MSG2    ; Load success message
        JMP DISPLAY

    NOT_PAL:
        LEA DX, MSG3    ; Load failure message

    DISPLAY:
        MOV AH, 09H     ; DOS function for string output
        INT 21H

    EXIT:
        MOV AH, 4CH     ; DOS function to terminate program
        INT 21H

CODE ENDS
END START
