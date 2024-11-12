ASSUME CS:CODE, DS:DATA
; This directive tells the assembler to assume that CS (Code Segment) register points to CODE segment and DS (Data Segment) register points to DATA segment

DATA SEGMENT
    ; This marks the beginning of the data segment where variables are defined
    NUM1 DW ?        ; Define a 2-byte (word) variable NUM1, uninitialized
    NUM2 DW ?        ; Define a 2-byte (word) variable NUM2, uninitialized
    RESULT DW ?      ; Define a 2-byte (word) variable RESULT, uninitialized
    MSG1 DB 'Enter first number (0-65535): $'   ; Define a string MSG1, terminated with '$'
    MSG2 DB 'Enter second number (0-65535): $'  ; Define a string MSG2, terminated with '$'
    MSG3 DB 'Sum: $'                            ; Define a string MSG3, terminated with '$'
    NEWLINE DB 0AH, 0DH, '$'                    ; Define a newline string (Line Feed, Carriage Return, terminator)
DATA ENDS
; This marks the end of the data segment

CODE SEGMENT
    ; This marks the beginning of the code segment where instructions are defined
    START:
        ; Initialize data segment
        MOV AX, DATA     ; Move the address of DATA segment to AX
        MOV DS, AX       ; Move AX to DS, setting up the data segment

        ; Display prompt for first number
        LEA DX, MSG1     ; Load Effective Address of MSG1 into DX
        MOV AH, 09H      ; Set AH to 09H (DOS function: print string)
        INT 21H          ; Call DOS interrupt to print the string

        ; Read first number from user
        CALL READ_NUMBER ; Call the READ_NUMBER procedure
        MOV NUM1, AX     ; Store the read number in NUM1

        ; Print newline
        LEA DX, NEWLINE  ; Load Effective Address of NEWLINE into DX
        MOV AH, 09H      ; Set AH to 09H (DOS function: print string)
        INT 21H          ; Call DOS interrupt to print the newline

        ; Display prompt for second number
        LEA DX, MSG2     ; Load Effective Address of MSG2 into DX
        MOV AH, 09H      ; Set AH to 09H (DOS function: print string)
        INT 21H          ; Call DOS interrupt to print the string

        ; Read second number from user
        CALL READ_NUMBER ; Call the READ_NUMBER procedure
        MOV NUM2, AX     ; Store the read number in NUM2

        ; Print newline
        LEA DX, NEWLINE  ; Load Effective Address of NEWLINE into DX
        MOV AH, 09H      ; Set AH to 09H (DOS function: print string)
        INT 21H          ; Call DOS interrupt to print the newline

        ; Perform addition
        MOV AX, NUM1     ; Move NUM1 to AX
        ADD AX, NUM2     ; Add NUM2 to AX
        MOV RESULT, AX   ; Store the result in RESULT

        ; Display "Sum: " label
        LEA DX, MSG3     ; Load Effective Address of MSG3 into DX
        MOV AH, 09H      ; Set AH to 09H (DOS function: print string)
        INT 21H          ; Call DOS interrupt to print the string

        ; Display result
        MOV AX, RESULT   ; Move RESULT to AX
        CALL DISPLAY_NUMBER ; Call the DISPLAY_NUMBER procedure to print the result

    EXIT:
        ; Exit program
        MOV AH, 4CH      ; Set AH to 4CH (DOS function: terminate program)
        INT 21H          ; Call DOS interrupt to exit the program

    READ_NUMBER PROC
        MOV AX, 0        ; Clear AX register (set to 0)
        MOV BX, 0        ; Clear BX register (set to 0)
        MOV CX, 5        ; Set counter to 5 (max 5 digits for 16-bit number)
    READ_LOOP:
        MOV AH, 01H      ; Set AH to 01H (DOS function: read character)
        INT 21H          ; Call DOS interrupt to read a character
        CMP AL, 0DH      ; Compare input with Enter key (0DH)
        JE READ_DONE     ; If Enter, jump to READ_DONE
        SUB AL, 30H      ; Convert ASCII to number by subtracting 30H
        MOV AH, 0        ; Clear AH (extend AL to 16-bit in AX)
        PUSH AX          ; Save the digit on the stack
        MOV AX, BX       ; Move current accumulated value to AX
        MOV BX, 10       ; Set BX to 10 (for multiplication)
        MUL BX           ; Multiply current value in AX by 10
        POP BX           ; Retrieve the digit from stack
        ADD AX, BX       ; Add new digit to current value
        MOV BX, AX       ; Move result back to BX
        LOOP READ_LOOP   ; Decrement CX and continue loop if CX != 0
    READ_DONE:
        MOV AX, BX       ; Move final result to AX
        RET              ; Return from procedure
    READ_NUMBER ENDP

    DISPLAY_NUMBER PROC
        ; Display a 16-bit number
        MOV CX, 0        ; Initialize digit counter to 0
        MOV BX, 10       ; Set divisor to 10
    DIVIDE_LOOP:
        MOv DX, 0      ; Clear DX for division
        DIV BX           ; Divide AX by 10, quotient in AX, remainder in DX
        PUSH DX          ; Push remainder (digit) to stack
        INC CX           ; Increment digit counter
        CMP AX, 0        ; Check if quotient is zero
        JNZ DIVIDE_LOOP  ; If not zero, continue dividing
    DISPLAY_LOOP:
        POP DX           ; Pop a digit from stack
        ADD DL, 30H      ; Convert number to ASCII by adding 30H
        MOV AH, 02H      ; Set AH to 02H (DOS function: display character)
        INT 21H          ; Call DOS interrupt to display the digit
        LOOP DISPLAY_LOOP ; Decrement CX and continue loop if CX != 0
        RET              ; Return from procedure
    DISPLAY_NUMBER ENDP

CODE ENDS
END START
; This marks the end of the code segment and specifies the entry point (START)
