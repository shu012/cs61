;=================================================
; 
; Name: Vaughen, Josh
; 
; Assignment name: assn3
;
; I hereby certify that the contents of this file
; are ENTIRELY my own original work. 
;
;=================================================

.ORIG x3000                 ; Program initialization point

; ================================================
; Instruction set
; ================================================

LD R1, NUMBER               ; Load into R1 the desired number
LD R6, MASK                 ; Load into R6 the bitmask to use
LD R4, NEGSET				; Load into R4 the offset for "1"
LD R5, OFFSET               ; Load into R5 the offset for "0"
LD R2, COUNTER				; Load into R2 the loop counter

; =======================
; Begin the loop. Essentially, take the stored in R1 and AND it with the
; bitmask to replace all bits with 0 except for the leading bit, which will
; be either 0 or 1 depending on what it was previously. If that bit is 1
; then output a 1, otherwise output a 0. Then go ahead and shift the bits 
; to the left, and repeat the process. While doing this, print a space
; every 4 bits.
; =======================

LD R3, FIVE					; Load 5 to R3 to separate each 4 bits by a space

LOOP						; Begin the loop

ADD R3, R3, #-1				; Initial subtraction to test if 4 bits have gone
BRz PRINT					; If 4 bits have passed, jump to PRINT subroutine

AND R0, R1, R6              ; AND Number with x8000


BRz IZERO					; If the number is Zero, meaning the first bit
							; was a 0, jump to IZERO. Otherwise continue	
	ADD R0, R0, R4			; Add to the 1 x31 to output to console 1
	OUT						; Output number to console
	ADD R1, R1, R1			; Left-shift the bits
	ADD R2, R2, #-1			; Decrement the control counter
	BRp LOOP				; If counter is still valid, continue
	HALT					; else, HALT the program

IZERO						; The number is zero, lets output a 0
	ADD R0, R0, R5			; Add to the 0 x30 to output to console 0
	OUT						; Output number to console	
	ADD R1, R1, R1			; Left-shift the bits
	ADD R2, R2, #-1			; Decrement the control counter
	BRp LOOP				; If counter is still valid, continue
	HALT					; else, HALT the program

PRINT						; Print subroutine
	LD R0, SPACE			; Load the space character into R0
	OUT						; Output a space
	ADD R3, R3, #5			; Reset the bit counter
	BRp LOOP				; Jump back into the loop

HALT						; Emergency halt in case something terrible happens


; ================================================
; Program data
; ================================================


NUMBER 	.FILL 	#169		; Here's the number you can change to test
							; if the program works.
MASK    .FILL   x8000		; Bitmask of x8000 to reduce all bits to 0 except
							; for the first one.
NEGSET 	.FILL 	x0031		; 1 offset
OFFSET 	.FILL   x0030		; 0 offset
COUNTER	.FILL	#16			; Counter for 16 bit numbers
FIVE	.FILL 	#5			; fill FIVE with #5
SPACE	.FILL   x0020		; fill SPACE with the space character

.END                        ; End data segment
