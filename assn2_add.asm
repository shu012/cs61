;=================================================
; 
; Name: Vaughen, Joshua
; 
; Assignment name: assn2
;
; I hereby certify that the contents of this file
; are ENTIRELY my own original work. 
; 
;=================================================

.ORIG x3000                 ; Program initialization point

; ================================================
; Instruction set
; ================================================

LD R1, OFFSETNEG			; Load into R1 the negative offset value
LD R2, OFFSETPOS			; Load into R2 the positive offset value
LD R6, ZERO					; Load into R6 zero

; =======================
; I/O section. Grab two numbers from the user and store them. Then 
; offset the numbers so they are represented as the correct decimal
; number in memory. Invert the second number to facilitate subtraction
; using the two's complement scheme. Then finally subtract.
; =======================

IN 							; Grab user input
ADD R4, R0, R6				; Copy input into R4
IN							; Grab user input, again
ADD R5, R0, R6				; Copy input into R5

ADD R4, R4, R1				; Offset R4 to correct decimal number
ADD R5, R5, R1				; Offset R5 to correct decimal number

NOT R5, R5					; Invert the bits in R5
ADD R5, R5, #1				; Add one to R5

ADD R0, R4, R5				; Subtract R5 from R4

; =======================
; Branch section. If the resulting number is positive, go ahead and
; simply undo the offset done originally and output the number. If
; the resulting number is negative, output a minus sign and then
; output the number. When either is complete, terminate program.
; =======================

BRn LMR_NEG                 ; Branch: If the number is negative, 
                            ; we obviously want a way to output the 
                            ; negative sign so jump to LMR_NEG for the
                            ; negative number subroutine. Otherwise continue

LMR_POS                     ; Begin positive number subroutine
    ADD R0, R0, R1			; Offset R0 to correct ASCII number
    OUT                     ; Output the number in R0
    HALT                    ; Terminate the program
END_LMR_POS                 ; End positive number subroutine


LMR_NEG						; Begin negative number subroutine
    ADD R3, R0, R6			; Copy the value in R0 to R3 for later use
    ADD R0, R6, #-3			; Change R0 to #-3 for '-' sign output
    ADD R0, R0, R1			; Offset R0 to correct ASCII number for '-'
    OUT						; Output the '-' sign
    ADD R0, R3, R6			; Copy the value in R3 back into R0

    NOT R0, R0				; Invert the bits in R0
    ADD R0, R0, #1			; Add one to complete two's complement

    ADD R0, R0, R1			; Offset R0 to correct ASCII number
    OUT						; Output the number after the '-' sign
    HALT					; Terminate the program
END_LMR_NEG					; End negative number subroutine


; ================================================
; Program data
; ================================================

ZERO 		.FILL 	#0		; Set label ZERO to point to #0
OFFSETPOS 	.FILL 	#-48	; Set label OFFSETPOS to point to #-48
OFFSETNEG 	.FILL 	#48		; Set label OFFSETNEG to point to #48

.END                        ; End data segment
