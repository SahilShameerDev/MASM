ASSUME CS:CODE
CODE SEGMENT
START:
    MOV SI, 3000H    ; Load the base address into SI
    MOV AX, [SI]     ; Load word from address 3000H into AX
    ADD SI, 2        ; Move SI to the next word (3002H)
    MOV BX, [SI]     ; Load word from address 3002H into BX
    ADD AX, BX       ; Add BX to AX
    ADD SI, 2        ; Move SI to the next word (3004H)
    MOV [SI], AX     ; Store the result at address 3004H
    INT 3            ; Interrupt for program termination (for debugging)
CODE ENDS
END START
