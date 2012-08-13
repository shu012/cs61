;=================================================
; 
; Name: Vaughen, Josh
; 
; Assignment name: assn1
; 
;=================================================

;=================================================
; 
; REG VALUES    R0  R1  R2  R3  R4  R5  R6  R7
; Before loop   0   0   12  0   0   0   6   1168
; Iteration 1   0   12  12  0   0   0   5   1168
; Iteration 2   0   24  12  0   0   0   4   1168
; Iteration 3   0   36  12  0   0   0   3   1168
; Iteration 4   0   48  12  0   0   0   2   1168
; Iteration 5	0   60  12  0   0   0   1   1168
; Iteration 6   0   72  12  0   0   0   0   DEC_0
; End program   0   72  12  0   0   0   0   DEC_0
;
;=================================================

.ORIG x3000                 ; Program initialization point

; =======================
; Instruction set
; =======================

LD R1, DEC_0                ; Load DEC_0 into R1
LD R2, DEC_12               ; Load DEC_12 into R2
LD R6, DEC_6                ; Load DEC_6 into R6

DO_WHILE                    ; Begin do_while label loop
    ADD R1, R1, R2          ; Add values of R1 and R2, store in R1
    ADD R6, R6, #-1         ; Add values of R6 and -1, store in R6
    BRp DO_WHILE            ; Check last modified register. !positive == quit
END_DO_WHILE                ; End do_while label loop

HALT                        ; Terminate program

; =======================
; Program data
; =======================

DEC_0 .FILL #0              ; Fill DEC_0 with the value #0
DEC_6 .FILL #6              ; Fill DEC_6 with the value #6
DEC_12 .FILL #12            ; Fill DEC_12 with the value #12

.END                        ; End data segment
