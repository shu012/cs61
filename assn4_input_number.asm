;=================================================
; 
; Name: Vaughen, Josh
; 
; Assignment name: assn4
;
; I hereby certify that the contents of this file
; are ENTIRELY my own original work. 
;
;=================================================

.ORIG x3000                 ; Program initialization point

; ================================================
; Instruction set
; 43 +
; 45 -
; 10 ENTER
; 48-57 0-9
; R6 jump
; ================================================

; =======================
; Program logic: Output the prompt telling the user to input their number,
; preceeded by a + or -. When they enter the sign, make sure to check to see
; if they actually entered a sign. If they entered a bogus input, complain
; and reinitialize. Then start loading the number. Take in an integer, and
; check to see if they actually entered an integer. If they did, go ahead
; and store it. If not, complain and reinitialize. If they enter another integer,
; multiply the previous one by 10 and add the new integer. Store the resulting
; value. At program halt, the final value in R1 should be the number
; that the user entered, including the sign.
; =======================

Main:                       ; Main routine
    LD R1, ZERO
    LEA R0, prompt          ; Load the user prompt into R0
    PUTS                    ; Output the user prompt to the console

; =======================
; Loadsign subroutine. Take in a sign from the user and store in R4 whether
; the final number should be positive or negative
; =======================

Loadsign:
    GETC                    ; Pull in a character
    NOT R2, R0              ; Negate the character
    ADD R2, R2, #1          ; and add one for two's complement
    LD R3, PLUS             ; Load into R3, plus ascii char
    ADD R2, R2, R3          ; Add R3 and R2, which could be the same
    BRnp ELSE               ; If they are not the same, jump to ELSE
        JSR POSITIVE        ; its a positive number, jump to positive subroutine
    ELSE
        LD R3, MINUS        ; Load into R3, minus ascii char
        NOT R2, R0          ; Negate the character
        ADD R2, R2, #1      ; and add one for two's complement
        ADD R2, R2, R3	    ; Add R3 and R2, which could be the same
		BRnp EELSE          ; if they are not the same, jump to EELSE
        JSR NEGATIVE        ; its a negative number, jump to negative subroutine
    EELSE       
        LEA R0, promptt     ; load the error prompt into R0
        PUTS                ; output the error prompt
        JSR Reinit          ; load Reinit subroutine

; =======================
; Loadfirstnumber subroutine which will load the first number into R1. It'll
; make sure to account for the ASCII offset and check to see if the input
; was valid. Also will check to see if ENTER was entered, so finish program. 
; =======================

Loadfirstnumber:
    LD R5, COUNTER
    GETC                    ; Pull in first number
    LD R3, ASCOFFSET        ; Load ascii offset
    ADD R3, R3, R0          ; Offset number to decimal equivalent

    JSR Checkenter			; Check to see if the user entered 'ENTER'
    Loadcontinue:			; return point from enter check
    
	JSR Checkother			; Check to see if the user entered 0-9
	Checkcontinue:			; return point from other check

    ADD R1, R1, R3          ; Store the number in R1

; =======================
; Loadaddnumber subroutine which will load additional numbers into R1. It'll
; make sure to account for the ASCII offset and check to see if the input
; was valid. Also will check to see if ENTER was entered, so finish program. 
; Calls multiply subroutine to account for additional numbers.
; =======================

Loadaddnumber:
    GETC                    ; Pull in consecutive number
    LD R3, ASCOFFSET        ; Load ascii offset
    ADD R3, R3, R0          ; Offset number to decimal equivalent

    JSR Checkenter			; Check to see if the user entered 'ENTER'
    Loadcontinue:			; return point from enter check
    
	JSR Checkother			; Check to see if the user entered 0-9
	Checkcontinue:			; return point from other check

    JSR Multiply            ; Jump to multiply subroutine

HALT

; =======================
; POSITIVE/NEGATIVE subroutines. Store a 1 if positive, store -1 if negative
; =======================

POSITIVE                    ; Positive subroutine
    LEA R0, sign            ; congratulate user on making it this far
    PUTS                    ; output that message
    LD R4, POS              ; Load into R4 POS
    JSR Loadfirstnumber     ; jump to loadfirstnumber subroutine
    
NEGATIVE                    ; Negative subroutine
    LEA R0, sign            ; congratulate user on making it this far
    PUTS                    ; output that message
    LD R4, NEG              ; Load into R4 NEG
    JSR Loadfirstnumber     ; jump to loadfirstnumber subroutine

; =======================
; Multiply subroutine. Just adds the number to itself the second number's times
; which is multiplication. Returns to add another number. 
; =======================

Multiply:                   ; Multiply subroutine
    LD R6, MCOUNTER         ; Load into R6 the counter (#10 times)
    ADD R2, R1, #0          ; Load into R2 the initial number
    LOOP                    ; Begin loop
    ADD R1, R1, R2          ; Add the number with its original number
    ADD R6, R6, #-1         ; Decrement the counter
    BRp LOOP                ; Loop until repeated 10x
    ADD R1, R1, R3          ; Add result to R1

    ADD R5, R5, #-1         ; Decrement # digit counter
    BRz END                 ; if counter is done, end the program

    JSR Loadaddnumber       ; jump to loadaddnumber subroutine

; =======================
; Checkenter subroutine which just checks to see if ENTER character was
; entered. If it has, go ahead and END
; =======================

Checkenter:
    ADD R2, R3, #0			; Copy R3 into R2 for later use
    NOT R6, R3              ; Negate the character
    ADD R6, R6, #1          ; and add one for two's complement
    LD R3, ENTER            ; Load into R3, plus ascii char
    
    ADD R6, R6, R3          ; Add R3 and R2, which could be the same
    BRnp ELSEC              ; If they are not the same, jump to ELSE
        ADD R3, R2, #0		; Copy R2 back into R3 
        JSR END             ; enter, end
    ELSEC        
        ADD R3, R2, #0		; Copy R2 back into R3
        RET				    ; return

; =======================
; Checkother subroutine which checks to see if any character outside of 0-9
; was entered into the console. If that happens, it jumps to reinitialization
; subroutine and resets.
; =======================

Checkother:					; Check other subroutine which looks for misc. chars
	ADD R2, R2, #0			; If we add zero to the number, and its above a 
							; 0, then it'll be positive
	BRn WRONG				; If its not positive, wrong input. 
	ADD R2, R2, #-10		; Then if we subtract 10, it should be negative
							; if it was between 0-9
	BRp WRONG				; If positive, wrong input
	ADD R2, R2, #10			; Reset the number back
	RET						; Return from subroutine

	WRONG					; Input is incorrect
		LEA R0, prompttt	; Output wrong message
		PUTS
		JSR Reinit			; Jump to reinitialization 

; =======================
; Reinit subroutine which resets all the registers to 0 and jumps back to the
; beginning of the program. 
; =======================

Reinit:                     ; Reinitialization block
    LD R0, ZERO             ; Reset R0
    LD R1, ZERO             ; Reset R1
    LD R2, ZERO             ; Reset R2
    LD R3, ZERO             ; Reset R3
    LD R4, ZERO             ; Reset R4
    LD R5, ZERO             ; Reset R5
    JSR Main                ; jump to main block

; =======================
; End. If a negative flag was set, go ahead and take the two's complement of 
; the number and store it. Otherwise end.
; =======================

END
    ADD R4, R4, R4          ; Add sign to itself to use BR
    BRp FINISH              ; If positive, just halt
    NOT R1, R1              ; otherwise invert
    ADD R1, R1, #1          ; and add one for two's complement

FINISH
HALT


; ================================================
; Program data
; ================================================

FIRST		.FILL 	#48
LAST		.FILL 	#57
ENTER       .FILL   #-38
PLUS        .FILL   #43
MINUS       .FILL   #45
COUNTER     .FILL   #4
MCOUNTER    .FILL   #9
OFFSET      .FILL   #-45
ASCOFFSET   .FILL   #-48
NASCOFFSET  .FILL   #48
ZERO        .FILL   #0
NEG         .FILL   #-1
POS         .FILL   #1
sign        .STRINGZ "\nGood job! You entered the sign correctly. Now enter your 5 digit number...\n"
prompt      .STRINGZ "\nPlease input a 5-digit decimal number, preceeded with +/-, followed by ENTER:\nex: +23456\n"
promptt     .STRINGZ "\nThat was not +/-! Fail! Try again...\n"
prompttt 	.STRINGZ "\nThat was not a digit between 0 and 9! Fail! Try again...\n"
.END

