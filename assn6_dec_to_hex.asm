;=================================================
; 
; Name: Vaughen, Josh
; 
; Assignment name: assn6
; 
; I hereby certify that the contents of this file
; are ENTIRELY my own original work. 
;
;=================================================

;=================================================
; General program logic:
; Prompt the user to enter a decimal number between 0 and 65535.
; Pull in that number, store it, and then call the DEC_TO_HEX
; subroutine to convert it to decimal. Then go ahead and print the
; hexadecimal number out.
;=================================================

.ORIG x3000

LD R6, LOAD_INPUT			; load the users input with 
JSRR R6						; this subroutine

LD R6, DEC_TO_HEX			; load the hexadecimal conversion
JSRR R6						; subroutine and jump to it

LD R0, NEWLINE				; load and print newline char
OUT	
LD R0, X					; load and print leading 'x'
OUT
ADD R0, R1, #0				; move pointer to hexadecimal number
PUTS						; to R0 and print it using PUTS

HALT

; ================================================
; Main program data
; ================================================

X			.FILL	#120	; x char
NEWLINE 	.FILL 	#10		; crlf
LOAD_INPUT	.FILL	x3800	
DEC_TO_HEX	.FILL	x3600


;--------------------------------------------------------------
; Subroutine: DEC_TO_HEX
; Postcondition: R1 will contain a pointer to an array that stores
; the hexadecimal equivalent of the number passed in in R1
; Return value: R1, a pointer
.orig x3600
;--------------------------------------------------------------

ST R2, BK_3600_R2				; store registers
ST R3, BK_3600_R3
ST R4, BK_3600_R4
ST R5, BK_3600_R5
ST R6, BK_3600_R6
ST R7, BK_3600_R7



ADD R1, R1, #0					; first test to see if the number
BRzp LESS_THAN_3600				; is positive or negative

LD R6, DN16_3_3600				; here the number is negative, meaning
LD R5, COUNTER_3600				; some voodoo has to be done.
FFIRST_LOOP_3600				; continuously subtract #4096 from the
	ADD R1, R1, R6				; number until it goes positive
	BRp FFIRST_DONE_3600		
	ADD R5, R5, #1				; keep track of how many times
	JSR FFIRST_LOOP_3600		; subtracted

FFIRST_DONE_3600				; soon as that's done, offset additional
	ADD R5, R5, #1				; #1 to counter to fix off by one errors
	
	JSR NOW_CONTINUE_3600		; now jump into the regular algorithm



LESS_THAN_3600					; here the number is positive

LD R5, COUNTER_3600				; reset counter
NOW_CONTINUE_3600				; jump in point for negative, notice
LD R6, DN16_3_3600				; this happens after the counter
								; is reset
FIRST_LOOP_3600					; subtract by #4096 until negative
    ADD R1, R1, R6				; and count the number of times
	BRn FIRST_DONE_3600			; that happens
	ADD R5, R5, #1
	JSR FIRST_LOOP_3600

FIRST_DONE_3600					; add #4096 to move back from negative
	LD R6, DP16_3_3600			; to positive for future
	ADD R1, R1, R6				; iterations

	ADD R5, R5, #-10			; test to see if counter is more than
	BRzp FIRST_ADD_3600			; 10. if so, its ABCDEF and needs
								; extra work
	ADD R5, R5, #10				; reset subtraction
	JSR FIRST_PADD_3600			; jump out if not more than 10
	FIRST_ADD_3600	
	ADD R5, R5, #10				; reset subtraction
	ADD R5, R5, #7				; add extra 7 to offset for ABCDEF

	FIRST_PADD_3600



	LD R6, ASCII_3600			; load ascii offset
	ADD R5, R5, R6				; add that to counter
	LD R6, DATA_PTR_3600		; and then store the counter
	STI R5, DATA_PTR_3600		; increment pointer to the data
	ADD R6, R6, #1				; and store the new pointer
	ST R6, DATA_PTR_3600
	
LD R6, DN16_2_3600				; reset the counter, and load
LD R5, COUNTER_3600				; #256 and reiterate the process
SECOND_LOOP_3600				; that was described above
    ADD R1, R1, R6
	BRn SECOND_DONE_3600
	ADD R5, R5, #1
	JSR SECOND_LOOP_3600

SECOND_DONE_3600
	LD R6, DP16_2_3600
	ADD R1, R1, R6

	ADD R5, R5, #-10
	BRzp SECOND_ADD_3600

	ADD R5, R5, #10
	JSR SECOND_PADD_3600
	SECOND_ADD_3600
	ADD R5, R5, #10
	ADD R5, R5, #7

	SECOND_PADD_3600

	LD R6, ASCII_3600
	ADD R5, R5, R6
	LD R6, DATA_PTR_3600
	STI R5, DATA_PTR_3600
	ADD R6, R6, #1
	ST R6, DATA_PTR_3600

LD R6, DN16_1_3600
LD R5, COUNTER_3600
THIRD_LOOP_3600
    ADD R1, R1, R6
	BRn THIRD_DONE_3600
	ADD R5, R5, #1
	JSR THIRD_LOOP_3600

THIRD_DONE_3600
	LD R6, DP16_1_3600
	ADD R1, R1, R6

	ADD R5, R5, #-10
	BRzp THIRD_ADD_3600

	ADD R5, R5, #10
	JSR THIRD_PADD_3600
	THIRD_ADD_3600
	ADD R5, R5, #10
	ADD R5, R5, #7

	THIRD_PADD_3600


	LD R6, ASCII_3600
	ADD R5, R5, R6
	LD R6, DATA_PTR_3600
	STI R5, DATA_PTR_3600
	ADD R6, R6, #1
	ST R6, DATA_PTR_3600

LD R6, DN16_0_3600
LD R5, COUNTER_3600
FOURTH_LOOP_3600
    ADD R1, R1, R6
	BRn FOURTH_DONE_3600
	ADD R5, R5, #1
	JSR FOURTH_LOOP_3600

FOURTH_DONE_3600
	LD R6, DP16_0_3600
	ADD R1, R1, R6

	ADD R5, R5, #-10
	BRzp FOURTH_ADD_3600

	ADD R5, R5, #10
	JSR FOURTH_PADD_3600
	FOURTH_ADD_3600
	ADD R5, R5, #10
	ADD R5, R5, #7

	FOURTH_PADD_3600

	LD R6, ASCII_3600
	ADD R5, R5, R6
	LD R6, DATA_PTR_3600
	STI R5, DATA_PTR_3600
	ADD R6, R6, #1
	ST R6, DATA_PTR_3600

LD R5, NULL_3600				; terminate array with NULL
STI R5, DATA_PTR_3600

LD R1, DATA_PTRR_3600			; at this point, load the
LD R2, BK_3600_R2				; pointer to the data into
LD R3, BK_3600_R3				; R1, and restore all the other
LD R4, BK_3600_R4				; registers from memory
LD R5, BK_3600_R5				; then return from the 
LD R6, BK_3600_R6				; subroutine
LD R7, BK_3600_R7
RET

;=================================================
; DEC_TO_HEX subroutine program data
;=================================================

BK_3600_R2      .BLKW   #1
BK_3600_R3      .BLKW   #1
BK_3600_R4      .BLKW   #1
BK_3600_R5      .BLKW   #1
BK_3600_R6      .BLKW   #1
BK_3600_R7      .BLKW   #1
ASCII_3600		.FILL	#48
COUNTER_3600	.FILL	#0
FOUR_3600       .FILL 	#4
FIVE_3600       .FILL 	#97
SEVEN_3600		.FILL 	#7
DATA_PTR_3600 	.FILL 	x4000
DATA_PTRR_3600	.FILL 	x4000
DP16_3_3600   	.FILL   #4096
DP16_2_3600   	.FILL   #256
DP16_1_3600   	.FILL   #16
DP16_0_3600   	.FILL   #1
DN16_3_3600   	.FILL   #-4096
DN16_2_3600   	.FILL   #-256
DN16_1_3600   	.FILL   #-16
DN16_0_3600   	.FILL   #-1
NULL_3600		.FILL	#0

;--------------------------------------------------------------
; Subroutine: LOAD_INPUT
; Postcondition: R1 will contain the value that the user enters into
; the console.
; Return value: R1
.orig x3800
;--------------------------------------------------------------

ST R2, BK_3800_R2				; store registers
ST R3, BK_3800_R3
ST R4, BK_3800_R4
ST R5, BK_3800_R5
ST R6, BK_3800_R6
ST R7, BK_3800_R7

Main_3800:                      ; Main routine
    LD R1, ZERO_3800
    LEA R0, prompt_3800         ; Load the user prompt into R0
    PUTS                    	; Output the user prompt to the console

; =======================
; Loadsign subroutine. Take in a sign from the user and store in R4 whether
; the final number should be positive or negative
; =======================

Loadsign_3800:
    GETC                    	; Pull in a character
    OUT
    NOT R2, R0              	; Negate the character
    ADD R2, R2, #1          	; and add one for two's complement
    LD R3, SHARP_3800            ; Load into R3, plus ascii char
    ADD R2, R2, R3          	; Add R3 and R2, which could be the same
    BRnp ELSE_3800              ; If they are not the same, jump to ELSE
        JSR POSITIVE_3800       ; its a positive number, jump to positive subroutine
    ELSE_3800
        LD R3, SHARP_3800       ; Load into R3, minus ascii char
        NOT R2, R0          	; Negate the character
        ADD R2, R2, #1      	; and add one for two's complement
        ADD R2, R2, R3	    	; Add R3 and R2, which could be the same
		BRnp EELSE_3800         ; if they are not the same, jump to EELSE
        JSR NEGATIVE_3800       ; its a negative number, jump to negative subroutine
    EELSE_3800       
        LEA R0, promptt_3800    ; load the error prompt into R0
        PUTS                	; output the error prompt
        JSR Reinit_3800         ; load Reinit subroutine

; =======================
; Loadfirstnumber subroutine which will load the first number into R1. It'll
; make sure to account for the ASCII offset and check to see if the input
; was valid. Also will check to see if ENTER was entered, so finish program. 
; =======================

Loadfirstnumber_3800:
    LD R5, COUNTER_3800
    GETC                    	; Pull in first number
    OUT
    LD R3, ASCOFFSET_3800       ; Load ascii offset
    ADD R3, R3, R0          	; Offset number to decimal equivalent

    JSR Checkenter_3800			; Check to see if the user entered 'ENTER'
    Loadcontinue_3800:			; return point from enter check
    
	JSR Checkother_3800			; Check to see if the user entered 0-9
	Checkcontinue_3800:			; return point from other check

    ADD R1, R1, R3          	; Store the number in R1

; =======================
; Loadaddnumber subroutine which will load additional numbers into R1. It'll
; make sure to account for the ASCII offset and check to see if the input
; was valid. Also will check to see if ENTER was entered, so finish program. 
; Calls multiply subroutine to account for additional numbers.
; =======================

Loadaddnumber_3800:
    GETC                    	; Pull in consecutive number
    OUT
    LD R3, ASCOFFSET_3800       ; Load ascii offset
    ADD R3, R3, R0          	; Offset number to decimal equivalent

    JSR Checkenter_3800			; Check to see if the user entered 'ENTER'
    Loadcontinue_3800:			; return point from enter check
    
	JSR Checkother_3800			; Check to see if the user entered 0-9
	Checkcontinue_3800:			; return point from other check

    JSR Multiply_3800           ; Jump to multiply subroutine

HALT

; =======================
; POSITIVE/NEGATIVE subroutines. Store a 1 if positive, store -1 if negative
; =======================

POSITIVE_3800                   ; Positive subroutine
    LD R4, POS_3800             ; Load into R4 POS
    JSR Loadfirstnumber_3800    ; jump to loadfirstnumber subroutine
    
NEGATIVE_3800                   ; Negative subroutine
    LD R4, NEG_3800             ; Load into R4 NEG
    JSR Loadfirstnumber_3800    ; jump to loadfirstnumber subroutine

; =======================
; Multiply subroutine. Just adds the number to itself the second number's times
; which is multiplication. Returns to add another number. 
; =======================

Multiply_3800:                  ; Multiply subroutine
    LD R6, MCOUNTER_3800        ; Load into R6 the counter (#10 times)
    ADD R2, R1, #0          	; Load into R2 the initial number
    LOOP_3800                   ; Begin loop
    ADD R1, R1, R2          	; Add the number with its original number
    ADD R6, R6, #-1         	; Decrement the counter
    BRp LOOP_3800               ; Loop until repeated 10x
    ADD R1, R1, R3          	; Add result to R1

    ADD R5, R5, #-1         	; Decrement # digit counter
    BRz END_3800                ; if counter is done, end the program

    JSR Loadaddnumber_3800      ; jump to loadaddnumber subroutine

; =======================
; Checkenter subroutine which just checks to see if ENTER character was
; entered. If it has, go ahead and END
; =======================

Checkenter_3800:
    ADD R2, R3, #0				; Copy R3 into R2 for later use
    NOT R6, R3              	; Negate the character
    ADD R6, R6, #1          	; and add one for two's complement
    LD R3, ENTER_3800       
    
    ADD R6, R6, R3          	; Add R3 and R2, which could be the same
    BRnp ELSEC_3800             ; If they are not the same, jump to ELSE
        ADD R3, R2, #0			; Copy R2 back into R3 
        JSR END_3800            ; enter, end
    ELSEC_3800        
        ADD R3, R2, #0			; Copy R2 back into R3
        RET				    	; return

; =======================
; Checkother subroutine which checks to see if any character outside of 0-9
; was entered into the console. If that happens, it jumps to reinitialization
; subroutine and resets.
; =======================

Checkother_3800:				; Check other subroutine which looks for misc. chars
	ADD R2, R2, #0				; If we add zero to the number, and its above a 
								; 0, then it'll be positive
	BRn WRONG_3800				; If its not positive, wrong input. 
	ADD R2, R2, #-10			; Then if we subtract 10, it should be negative
								; if it was between 0-9
	BRp WRONG_3800				; If positive, wrong input
	ADD R2, R2, #10				; Reset the number back
	RET							; Return from subroutine

	WRONG_3800					; Input is incorrect
		LEA R0, prompttt_3800	; Output wrong message
		PUTS
		JSR Reinit_3800			; Jump to reinitialization 

; =======================
; Reinit subroutine which resets all the registers to 0 and jumps back to the
; beginning of the program. 
; =======================

Reinit_3800:                    ; Reinitialization block
    LD R0, ZERO_3800            ; Reset R0
    LD R1, ZERO_3800            ; Reset R1
    LD R2, ZERO_3800            ; Reset R2
    LD R3, ZERO_3800            ; Reset R3
    LD R4, ZERO_3800            ; Reset R4
    LD R5, ZERO_3800            ; Reset R5
    JSR Main_3800               ; jump to main block

; =======================
; End. If a negative flag was set, go ahead and take the two's complement of 
; the number and store it. Otherwise end.
; =======================

END_3800
    ADD R4, R4, R4          	; Add sign to itself to use BR
    BRp FINISH_3800             ; If positive, just halt
    NOT R1, R1              	; otherwise invert
    ADD R1, R1, #1          	; and add one for two's complement

FINISH_3800						; finish up section. restore registers
LD R2, BK_3800_R2
LD R3, BK_3800_R3
LD R4, BK_3800_R4
LD R5, BK_3800_R5
LD R6, BK_3800_R6
LD R7, BK_3800_R7
RET

; =======================
; LOAD_INPUT subroutine program data block
; =======================

BK_3800_R2      .BLKW   #1
BK_3800_R3      .BLKW   #1
BK_3800_R4      .BLKW   #1
BK_3800_R5      .BLKW   #1
BK_3800_R6      .BLKW   #1
BK_3800_R7      .BLKW   #1
FIRST_3800		.FILL 	#48
LAST_3800		.FILL 	#57
ENTER_3800      .FILL   #-38
PLUS_3800       .FILL   #43
MINUS_3800      .FILL   #45
SHARP_3800		.FILL	#35
COUNTER_3800    .FILL   #4
MCOUNTER_3800   .FILL   #9
OFFSET_3800     .FILL   #-45
ASCOFFSET_3800  .FILL   #-48
NASCOFFSET_3800 .FILL   #48
ZERO_3800       .FILL   #0
NEG_3800        .FILL   #-1
POS_3800        .FILL   #1
prompt_3800     .STRINGZ "\nEnter a decimal number in the range [0, 65535], preceeded by #\n"
promptt_3800    .STRINGZ "\nNot #. Try again\n"
prompttt_3800 	.STRINGZ "\nNot 0-9. Try again\n"


.orig x4000					; array with which to store the 
ARRAY_3600  .BLKW   #5		; hexadecimal number, null terminated
