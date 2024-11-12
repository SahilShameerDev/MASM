; add.asm - 2-digit addition with display in DOSBox

.MODEL SMALL
.STACK 100H
.DATA
    num1 DB 25         ; First 2-digit number
    num2 DB 47         ; Second 2-digit number
    result DB 0        ; Storage for the result
    msg DB 'Result: $' ; Message for displaying result

.CODE
MAIN PROC
    MOV AX, @DATA      ; Load the data segment address into AX
    MOV DS, AX         ; Initialize DS with the data segment

    MOV AL, num1       ; Load num1 into AL
    ADD AL, num2       ; Add num2 to AL
    MOV result, AL     ; Store the result in result variable

    ; Display message
    MOV AH, 09H        ; DOS function to display a string
    LEA DX, msg        ; Load address of msg into DX
    INT 21H            ; Interrupt to display the message

    ; Convert result to ASCII for display
    MOV AL, result     ; Load result
    MOV AH, 0          ; Clear AH to work with full 8 bits in AX
    AAM                ; Adjust AL for unpacked BCD (AL = low, AH = high)

    ADD AH, '0'        ; Convert high nibble to ASCII
    MOV DL, AH         ; Move high nibble to DL for output
    MOV AH, 02H        ; DOS function to display a character
    INT 21H            ; Display high digit

    ADD AL, '0'        ; Convert low nibble to ASCII
    MOV DL, AL         ; Move low nibble to DL for output
    MOV AH, 02H        ; DOS function to display a character
    INT 21H            ; Display low digit

    ; Exit program
    MOV AH, 4CH        ; DOS interrupt to exit
    INT 21H

MAIN ENDP
END MAIN