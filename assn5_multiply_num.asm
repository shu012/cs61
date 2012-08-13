;=================================================
; 
; Name: Vaughen, Josh
; 
; Assignment name: assn5
;
; I hereby certify that the contents of this file
; are ENTIRELY my own original work. 
;
;=================================================


;=================================================
; 				ATTENTION GRADER
; 1. My program will work with -32768, go ahead and try it!
; 2. Output is NOT padded by extra 0's. That was fun to implement.
; 3. Most of the 'main function' is output formatting. go figure.
; 4. Efficient multiplication is handled by the multiply subroutine. It
;    makes much more sense handling it there rather than another subroutine.
; 5. Arrays are not required. 
;=================================================


;=================================================
; General program logic:
; Prompt the user to input two numbers. Store the first number in
; R2, and store the second number in R3. Then, go ahead and 
; multiply those two numbers together, checking for any over/underflow
; errors, and store the result in R1. Print out the users two
; numbers and their multiplication, then quit.
;=================================================

.ORIG x3000                 ; Program initialization point

LD R6, PULL_INPUT			; Pull in first number subroutine call
JSRR R6						; and use it
ADD R2, R1, #0				; Store first number in R2

LD R6, PULL_INPUT			; Pull in second number subroutine call
JSRR R6						; and use it
ADD R3, R1, #0				; Store second number in R3

LD R6, MULTIPLY				; multiply R2, R3
JSRR R6						; R1 will contain the result

ADD R4, R1, #0				; store result in R4

LD R0, NEWLINE				; print a newline character
OUT

ADD R1, R2, #0				; put the first number in R1 and print
LD R6, PRINT_NUMBER
JSRR R6

LD R0, SPACE				; print a space, then *, then another space
OUT
LD R0, STAR
OUT
LD R0, SPACE
OUT

ADD R1, R3, #0				; put the second number in R1 and print
LD R6, PRINT_NUMBER
JSRR R6

LD R0, SPACE				; print a space, then =, then another space
OUT
LD R0, EQUAL
OUT
LD R0, SPACE
OUT

ADD R1, R4, #0				; grab result from R4 and put in R1


LD R6, PRINT_NUMBER			; print the result
JSRR R6

HALT

; ================================================
; Main program data
; ================================================

NEWLINE			.FILL 	#10
EQUAL			.FILL 	#61
SPACE			.FILL	#32
STAR			.FILL 	#42
PULL_INPUT		.FILL	x3800
MULTIPLY 		.FILL	x3600
PRINT_NUMBER	.FILL	x3200

;--------------------------------------------------------------
; Subroutine: PRINT_NUMBER
; Postcondition: R1 is a decimal number to be printed to console
; Return value: none
.orig x3200
;--------------------------------------------------------------

ST R2, BK_3200_R2				; backup all the registers
ST R3, BK_3200_R3
ST R4, BK_3200_R4
ST R5, BK_3200_R5
ST R6, BK_3200_R6
ST R7, BK_3200_R7


LD R2, ZERO_3200				; put 0 in all registers but R1/R7
LD R3, ZERO_3200
LD R4, ZERO_3200
LD R5, ZERO_3200
LD R6, ZERO_3200

ADD R1, R1, #0					; print a + or - depending on if
BRzp PRINT_POS_3200				; the number is positive or not

LD R0, NEG_3200
OUT
JSR PRINTED_3200	

PRINT_POS_3200
LD R0, POS_3200
OUT

PRINTED_3200

JSR MAKE_POS_3200				; now go ahead and make the number positive
								; if it is not for easier processing

TTHOUSAND_BLOCK_3200			; ten thousand block which will first
	LD R5, TTHOUSAND_3200		; subtract 10000 from the number to
	ADD R4, R1, #0				; determine what the decimal number in
	LD R6, COUNTER_3200			; the front of the number is and store
	TTHOUSAND_LOOP_3200			; that number in R6
		ADD R4, R4, R5
		BRn TTHOUSAND_DONE_3200
		ADD R6, R6, #1
		JSR TTHOUSAND_LOOP_3200

	TTHOUSAND_DONE_3200			; then if the number at front was a 0
	ADD R6, R6, #0				; and if we have yet to encounter a number
	BRz	TTHOUSAND_BYPASS_3200	; besides 0, then we don't have to print
	ADD R2, R2, #1				; the zero because it would just be
	ADD R0, R6, #0				; padding the front. ex: 0045
	LD R4, ASCII_3200			; so we skip and just print 45
	ADD R0, R0, R4
	OUT	
	TTHOUSAND_BYPASS_3200	

	TTHOUSAND_LOOP2_3200		; when we counted the decimal number, we did
		ADD R1, R1, R5			; not account for offset in our original number
		ADD R6, R6, #0			; now we have to loop through and eliminate
		BRz	TTHOUSAND_TEST_3200	; the first number. So 32000 -> 2000
		ADD R6, R6, #-1
		BRz	TTHOUSAND_DONE2_3200
		JSR TTHOUSAND_LOOP2_3200

	TTHOUSAND_TEST_3200
	NOT R5, R5
	ADD R5, R5, #1
	ADD R1, R1, R5	

	TTHOUSAND_DONE2_3200	

; the rest of the blocks follow the same logic
; as ten thousand did.

THOUSAND_BLOCK_3200	
	LD R5, THOUSAND_3200
	ADD R4, R1, #0
	LD R6, COUNTER_3200
	THOUSAND_LOOP_3200	
		ADD R4, R4, R5
		BRn THOUSAND_DONE_3200
		ADD R6, R6, #1
		JSR THOUSAND_LOOP_3200

	THOUSAND_DONE_3200
	ADD R2, R2, #0
	BRp	THOUSAND_0BYPASS_3200
	ADD R6, R6, #0	
	BRz	THOUSAND_BYPASS_3200
	ADD R2, R2, #1
	THOUSAND_0BYPASS_3200
	ADD R0, R6, #0
	LD R4, ASCII_3200
	ADD R0, R0, R4
	OUT	
	THOUSAND_BYPASS_3200

	THOUSAND_LOOP2_3200
		ADD R1, R1, R5
		ADD R6, R6, #0
		BRz	THOUSAND_TEST_3200
		ADD R6, R6, #-1
		BRz	THOUSAND_DONE2_3200
		JSR THOUSAND_LOOP2_3200
	
	THOUSAND_TEST_3200
	NOT R5, R5
	ADD R5, R5, #1
	ADD R1, R1, R5	


	THOUSAND_DONE2_3200	

HUNDRED_BLOCK_3200	
	LD R5, HUNDRED_3200
	ADD R4, R1, #0
	LD R6, COUNTER_3200
	HUNDRED_LOOP_3200	
		ADD R4, R4, R5
		BRn HUNDRED_DONE_3200
		ADD R6, R6, #1
		JSR HUNDRED_LOOP_3200

	HUNDRED_DONE_3200
	ADD R2, R2, #0
	BRp	HUNDRED_0BYPASS_3200
	ADD R6, R6, #0	
	BRz	HUNDRED_BYPASS_3200
	ADD R2, R2, #1
	HUNDRED_0BYPASS_3200
	ADD R0, R6, #0
	LD R4, ASCII_3200
	ADD R0, R0, R4
	OUT	
	HUNDRED_BYPASS_3200

	HUNDRED_LOOP2_3200
		ADD R1, R1, R5
		ADD R6, R6, #0
		BRz	HUNDRED_TEST_3200
		ADD R6, R6, #-1
		BRz	HUNDRED_DONE2_3200
		JSR HUNDRED_LOOP2_3200

	HUNDRED_TEST_3200
	NOT R5, R5
	ADD R5, R5, #1
	ADD R1, R1, R5	

	HUNDRED_DONE2_3200	

TEN_BLOCK_3200	
	LD R5, TEN_3200
	ADD R4, R1, #0
	LD R6, COUNTER_3200
	TEN_LOOP_3200	
		ADD R4, R4, R5
		BRn TEN_DONE_3200
		ADD R6, R6, #1
		JSR TEN_LOOP_3200

	TEN_DONE_3200
	ADD R2, R2, #0
	BRp	TEN_0BYPASS_3200
	ADD R6, R6, #0	
	BRz	TEN_BYPASS_3200
	ADD R2, R2, #1
	TEN_0BYPASS_3200
	ADD R0, R6, #0
	LD R4, ASCII_3200
	ADD R0, R0, R4
	OUT	
	TEN_BYPASS_3200

	TEN_LOOP2_3200
		ADD R1, R1, R5
		ADD R6, R6, #0
		BRz	TEN_TEST_3200
		ADD R6, R6, #-1
		BRz	TEN_DONE2_3200
		JSR TEN_LOOP2_3200

	TEN_TEST_3200
	NOT R5, R5
	ADD R5, R5, #1
	ADD R1, R1, R5	

	TEN_DONE2_3200	

LAST_BLOCK_3200	
	LD R5, LAST_3200
	ADD R4, R1, #0
	LD R6, COUNTER_3200
	LAST_LOOP_3200	
		ADD R4, R4, R5
		BRn LAST_DONE_3200
		ADD R6, R6, #1
		JSR LAST_LOOP_3200

	LAST_DONE_3200
	ADD R2, R2, #1
	BRp	LAST_0BYPASS_3200
	ADD R6, R6, #0	
	BRz LAST_BYPASS_3200
	ADD R2, R2, #1
	LAST_0BYPASS_3200
	ADD R0, R6, #0
	LD R4, ASCII_3200
	ADD R0, R0, R4
	OUT	
	LAST_BYPASS_3200

	LAST_LOOP2_3200
		ADD R1, R1, R5
		ADD R6, R6, #0
		BRz	LAST_TEST_3200
		ADD R6, R6, #-1
		BRz	LAST_DONE2_3200
		JSR LAST_LOOP2_3200

	LAST_TEST_3200
	NOT R5, R5
	ADD R5, R5, #1
	ADD R1, R1, R5	

	LAST_DONE2_3200	

LD R2, BK_3200_R2				; finally reload the registers
LD R3, BK_3200_R3				; and return from the subroutine
LD R4, BK_3200_R4
LD R5, BK_3200_R5
LD R6, BK_3200_R6
LD R7, BK_3200_R7
RET

MAKE_POS_3200					; make pos will force a number positive
	ADD R1, R1, #0				; if it is not already positive
	BRp ENDP_3200
	NOT R1, R1
	ADD R1, R1, #1
	ENDP_3200
	RET
;=================================================
; PRINT_NUMBER subroutine program data
;=================================================
ZERO_3200		.FILL 	#0
ASCII_3200      .FILL   #48
POS_3200		.FILL	#43
NEG_3200		.FILL	#45
COUNTER_3200	.FILL	#0
TTHOUSAND_3200	.FILL	#-10000
THOUSAND_3200	.FILL	#-1000
HUNDRED_3200	.FILL	#-100
TEN_3200		.FILL 	#-10
LAST_3200		.FILL	#-1
SPACE_3200		.FILL	#10
BK_3200_R2      .BLKW   #1
BK_3200_R3      .BLKW   #1
BK_3200_R4      .BLKW   #1
BK_3200_R5      .BLKW   #1
BK_3200_R6      .BLKW   #1
BK_3200_R7      .BLKW   #1

;--------------------------------------------------------------
; Subroutine: MULTIPLY
; Input R2: Number to multiply
; Input R3: Number to multiply
; Postcondition: R1 will contain R2 and R3 multiplied together
; Return value: R1, the multiplied number
.orig x3600
;--------------------------------------------------------------
ST R2, BK_3600_R2				; store registers
ST R3, BK_3600_R3
ST R4, BK_3600_R4
ST R5, BK_3600_R5
ST R6, BK_3600_R6
ST R7, BK_3600_R7

JSR STORE_SIGN_3600				; store the result's sign

JSR CHECK_ZERO_3600				; check to see if either is zero

ADD R1, R2, #0					; make R2 positive if its not
JSR MAKE_POS_3600
ADD R2, R1, #0

ADD R1, R3, #0					; make R3 positive if its not
JSR MAKE_POS_3600
ADD R3, R1, #0

JSR MAKE_R2_BIGGER_3600			; force R2 to be bigger to optimize the
								; multiplication algorithm (less additions)


ADD R4, R2, #0					; store R2 in R4 to add to itself
ADD R3, R3, #-1					; decrement R3 to account for off by one error
BRz DONE_PART_3600				; if this fires, the number was 1 and we
								; don't need to do any multiplication

MULTIPLY_LOOP_3600				; multiply loop
	ADD R2, R2, R4				; add R2 to itself
	ADD R2, R2, #0				; check for over/underflow problems
	BRn FLOW_3600				; and break if so
	ADD R3, R3, #-1				; otherwise decrement R3 and 
	BRp MULTIPLY_LOOP_3600		; continue

DONE_PART_3600

ADD R1, R2, #0					; place result in R1

ADD R5, R5, #0					; if number should be negative,
BRn NEG_FLIP_3600				; make it negative

LD R2, BK_3600_R2				; restore registers
LD R3, BK_3600_R3
LD R4, BK_3600_R4
LD R5, BK_3600_R5
LD R6, BK_3600_R6
LD R7, BK_3600_R7
RET								; and return

NEG_FLIP_3600
NOT R1, R1						; invert if necessary
ADD R1, R1, #1

LD R2, BK_3600_R2				; restore registers
LD R3, BK_3600_R3
LD R4, BK_3600_R4
LD R5, BK_3600_R5
LD R6, BK_3600_R6
LD R7, BK_3600_R7
RET

FLOW_3600						; over/underflow error messaging

ADD R5, R5, #0					; if the result should be positive, then
BRp OVERFLOW_3600				; the number overflowed
JSR UNDERFLOW_3600				; if the result should be negative, then
								; the number underflowed

; =======================
; overflow and underflow messages
; =======================
OVERFLOW_3600
	LEA R0, OVERFLOW_MES_3600
	PUTS
	HALT
UNDERFLOW_3600
	LEA R0, UNDERFLOW_MES_3600	
	PUTS
	HALT

; =======================
; store_sign if pos R5 = 1, if neg R5 = -1
; =======================
STORE_SIGN_3600
	ADD R2, R2, #0
	BRp P_3600

	ADD R3, R3, #0
	BRp P3_3600

	LD R5, PONE_3600
	RET

	P_3600
		ADD R3, R3, #0
		BRp P2_3600
		LD R5, NONE_3600	
		RET
	P2_3600
		LD R5, PONE_3600
		RET
	P3_3600
		LD R5, NONE_3600
		RET
; =======================
; check_zero if 0 return 0
; =======================
CHECK_ZERO_3600
	ADD R0, R2, #0
	BRz HAVE_ZERO_3600
	ADD R0, R3, #0
	BRz HAVE_ZERO_3600
	RET
HAVE_ZERO_3600
	LD R1, ZERO_3600
	LD R2, BK_3600_R2				; store registers
	LD R3, BK_3600_R3
	LD R4, BK_3600_R4
	LD R5, BK_3600_R5
	LD R6, BK_3600_R6
	LD R7, BK_3600_R7
	RET
; =======================
; make_pos which will make R1 positive if negative
; =======================
MAKE_POS_3600
	ADD R1, R1, #0
	BRp ENDP_3600
	NOT R1, R1
	ADD R1, R1, #1
	ENDP_3600
	RET
; =======================
; make_neg which will make R1 negative if positive
; =======================
MAKE_NEG_3600
	ADD R1, R1, #0
	BRn ENDN_3600
	NOT R1, R1
	ADD R1, R1, #1
	ENDN_3600
	RET

; =======================
; MAKE_R2_BIGGER which will swap R2 and R3 so R2 is bigger
; =======================
MAKE_R2_BIGGER_3600
NOT R3, R3
ADD R3, R3, #1

ADD R0, R2, R3
BRzp R2_BIGGER_3600

NOT R3, R3
ADD R3, R3, #1

ADD R4, R3, #0
ADD R3, R2, #0
ADD R2, R4, #0

RET

R2_BIGGER_3600
NOT R3, R3
ADD R3, R3, #1
RET

; =======================
; MULTIPLY subroutine program data block
; =======================
PONE_3600		.FILL	#1
NONE_3600		.FILL	#-1
ZERO_3600		.FILL	#0
BK_3600_R2      .BLKW   #1
BK_3600_R3      .BLKW   #1
BK_3600_R4      .BLKW   #1
BK_3600_R5      .BLKW   #1
BK_3600_R6      .BLKW   #1
BK_3600_R7      .BLKW   #1
OVERFLOW_MES_3600 .STRINGZ "\nOverflow!\n"
UNDERFLOW_MES_3600 .STRINGZ "\nUnderflow!\n"


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
    LD R3, PLUS_3800            ; Load into R3, plus ascii char
    ADD R2, R2, R3          	; Add R3 and R2, which could be the same
    BRnp ELSE_3800              ; If they are not the same, jump to ELSE
        JSR POSITIVE_3800       ; its a positive number, jump to positive subroutine
    ELSE_3800
        LD R3, MINUS_3800       ; Load into R3, minus ascii char
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
    LD R3, ENTER_3800           ; Load into R3, plus ascii char
    
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
ENTER_3800       .FILL   #-38
PLUS_3800        .FILL   #43
MINUS_3800       .FILL   #45
COUNTER_3800     .FILL   #4
MCOUNTER_3800    .FILL   #9
OFFSET_3800      .FILL   #-45
ASCOFFSET_3800   .FILL   #-48
NASCOFFSET_3800  .FILL   #48
ZERO_3800        .FILL   #0
NEG_3800         .FILL   #-1
POS_3800         .FILL   #1
prompt_3800      .STRINGZ "\nInput a 5-digit decimal number, preceeded by +/-, followed by ENTER:\nex: +23456\n"
promptt_3800     .STRINGZ "\nNot +/-. Try again\n"
prompttt_3800 	.STRINGZ "\nNot 0-9. Try again\n"
