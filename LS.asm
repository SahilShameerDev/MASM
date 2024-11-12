; Linear Search Program in Assembly
; This program implements a linear search algorithm to find a number in an array

ASSUME CS:CODE, DS:DATA

DATA SEGMENT
    COUNT DB ?           ; Single byte to store number of elements (1-50)
    ARRAY DB 50 DUP(0)  ; Array of 50 bytes initialized to 0
    KEY DB ?            ; Single byte to store the search value
    MSG1 DB 'Enter count of numbers (1-50): $'  ; Prompt messages
    MSG2 DB 'Enter numbers one by one: $'
    MSG3 DB 'Enter key to search: $'
    MSG4 DB 'Found $'
    MSG5 DB 'Not found$'
    NEWLINE DB 0DH, 0AH, '$'  ; Carriage return + Line feed for new line
DATA ENDS

CODE SEGMENT
    START:
        ; Initialize DS register to point to data segment
        MOV AX, DATA
        MOV DS, AX

        ; Display prompt for count and read input
        LEA DX, MSG1    ; Load message address
        MOV AH, 09H     ; DOS function to print string
        INT 21H
        
        ; Read single digit count from user
        MOV AH, 01H     ; DOS function to read character
        INT 21H
        SUB AL, 30H     ; Convert ASCII to number (e.g., '5' -> 5)
        MOV COUNT, AL   ; Store count
        
        ; Print newline
        LEA DX, NEWLINE
        MOV AH, 09H
        INT 21H
        
        ; Display prompt for entering numbers
        LEA DX, MSG2
        MOV AH, 09H
        INT 21H
        
        ; Print newline
        LEA DX, NEWLINE
        MOV AH, 09H
        INT 21H
        
        ; Read array elements one by one
        MOV CL, COUNT   ; Set loop counter to COUNT
        LEA SI, ARRAY   ; Load effective address of array into SI
    READ_LOOP:
        MOV AH, 01H     ; Read single digit
        INT 21H
        SUB AL, 30H     ; Convert ASCII to number
        MOV [SI], AL    ; Store in array using indirect addressing
        INC SI          ; Move to next array position
        
        ; Print space between numbers
        MOV DL, 20H     ; ASCII code for space
        MOV AH, 02H     ; DOS function to print character
        INT 21H
        
        LOOP READ_LOOP  ; Repeat until CL becomes 0
        
        ; Print newline
        LEA DX, NEWLINE
        MOV AH, 09H
        INT 21H
        
        ; Prompt for and read search key
        LEA DX, MSG3
        MOV AH, 09H
        INT 21H
        
        MOV AH, 01H     ; Read search key
        INT 21H
        SUB AL, 30H     ; Convert ASCII to number
        MOV KEY, AL     ; Store key
        
        ; Print newline
        LEA DX, NEWLINE
        MOV AH, 09H
        INT 21H
        
        ; Perform linear search
        MOV CL, COUNT   ; Set loop counter
        LEA SI, ARRAY   ; Load effective address of array
    SEARCH_LOOP:
        MOV AL, [SI]    ; Get current array element using indirect addressing
        CMP AL, KEY     ; Compare with search key
        JE FOUND        ; Jump if match found
        INC SI          ; Move to next element
        LOOP SEARCH_LOOP  ; Repeat until end of array
        
        ; Display "Not found" if loop completes without finding key
        LEA DX, MSG5
        MOV AH, 09H
        INT 21H
        JMP EXIT
        
    FOUND:
        ; Display "Found at position" message
        LEA DX, MSG4
        MOV AH, 09H
        INT 21H
        
    EXIT:
        ; Print final newline
        LEA DX, NEWLINE
        MOV AH, 09H
        INT 21H
        
        ; Terminate program
        MOV AH, 4CH     ; DOS function to exit program
        INT 21H

CODE ENDS
END START
; End of Linear Search Program
