;=================================================
; 
; Name: Vaughen, Joshua
; 
; Assignment name: assn8
; 
; I hereby certify that the contents of this file
; are ENTIRELY my own original work. 
;
;=================================================

.ORIG x3000

;=================================================
; General program logic:
; Output a menu to the user. Ask them to input a number 0-7, each with a 
; corresponding function. Depending on which number the user entered, call
; the appropriate subroutine and process it based on the number located
; in x5200, which is the BUSYNESS vector.
;=================================================


MENU_LOOP						
	LD R6, MENU						; load the menu subroutine and jump
	JSRR R6							; to it
	ADD R1, R1, #-1					; if the user entered 1, then jump to
	BRz ALL_BUSY					; busy routine
	ADD R1, R1, #-1					; if the user entered 2, then jump to
	BRz ALL_FREE					; free routine
	ADD R1, R1, #-1					; if the user entered 3, then jump to
	BRz	NUM_BUSY					; the num busy routine
	ADD R1, R1, #-1					; if the user entered 4, then jump to
	BRz NUM_FREE					; the num free routine
	ADD R1, R1, #-1					; if the user entered 5, then jump to
	BRz STATUS						; the status routine
	ADD R1, R1, #-1					; if the user entered 6, then jump to
	BRz FIRST						; the first free routine
	JSR QUIT						; else quit

ALL_BUSY							; all busy routine. Loads the ALL_MACHINES_BUSY
	LD R6, ALL_MACHINES_BUSY		; subroutine and executes it
	JSRR R6							; upon return, check to see if none were
	ADD R2, R2, #0					; busy. if so, output the correct message
	BRZ BUSY_ZERO					; otherwise just output the right message
	LEA R0, ALL_BUSY_MES
	PUTS
	JSR MENU_LOOP
	BUSY_ZERO
	LEA R0, ALL_BUSY_NMES
	PUTS
	JSR MENU_LOOP					; reset to print menu

ALL_FREE							; all free routine. loads the ALL_MACHINES_FREE
	LD R6, ALL_MACHINES_FREE		; subroutine and executes it
	JSRR R6							; upon return, check to see if none work
	ADD R2, R2, #0					; free. if so, output the correct message
	BRZ FREE_ZERO					; otherwise just output the right message
	LEA R0, ALL_FREE_MES
	PUTS
	JSR MENU_LOOP
	FREE_ZERO
	LEA R0, ALL_FREE_NMES
	PUTS
	JSR MENU_LOOP					; reset to print menu

NUM_BUSY
	LD R6, NUM_BUSY_MACHINES		; num busy routine. loads the NUM_BUSY_MACHINES
	JSRR R6							; subroutine and executes it
    LEA R0, THERE_MES				; upon return, go ahead and print out the
	PUTS							; number of machines that were busy
    ADD R1, R2, #0					; meaning the number of 0s in the 
	LD R6, PRINT_NUMBER				; BUSYNESS vector
	JSRR R6
	LEA R0, BUSY
	PUTS
	JSR MENU_LOOP

NUM_FREE							; num free routine. loads the NUM_FREE_MACHINES
	LD R6, NUM_FREE_MACHINES		; subroutine and executes it
	JSRR R6							; upon return, go ahead and print out the 
	LEA R0, THERE_MES				; number of machines that were free
	PUTS							; meaning the number of 1s in the
	ADD R1, R2, #0					; BUSYNESS vector
	LD R6, PRINT_NUMBER
	JSRR R6
	LEA R0, FREE
	PUTS
	JSR MENU_LOOP					; reset to menu

STATUS
	LD R6, PULL_INPUT				; status routine. loads the PULL_INPUT
	JSRR R6							; subroutine and get the input
	LD R6, MACHINE_STATUS			; then load the MACHINE_STATUS subroutine
	JSRR R6							; and execute it
	ADD R3, R0, #0					; upon return check to see if there was
	ADD R2, R2, #0					; a busy or free machine represented by
	BRz ZERO_PART					; the bit checked. go ahead and print
		LEA R0, MACH				; out the appropriate message
		PUTS
		LD R6, PRINT_NUMBER
		JSRR R6
		LEA R0, IS_FRE
		PUTS
		JSR MENU_LOOP
	ZERO_PART
		LEA R0, MACH
		PUTS
		LD R6, PRINT_NUMBER
		JSRR R6
		LEA R0, IS_BUS
		PUTS
		JSR MENU_LOOP				; reset to menu

FIRST
	LD R6, FIRST_FREE				; first routine. loads the FIRST_FREE 
	JSRR R6							; subroutine and executes it
	ADD R2, R2, #0					; gets the least significant 1 in the 
	BRn NONE_AVAIL					; busyness vector and prints out its 
	LEA R0, AVAIL					; position
	PUTS							; also checks for no machines free
	ADD R1, R2, #0					; and prints out the appropriate 
	LD R6, PRINT_NUMBER				; message
	JSRR R6
	AND R0, R0, #0
	ADD R0, R0, #10
	OUT	
	JSR MENU_LOOP					; reset to menu
	NONE_AVAIL
	LEA R0, NAVAIL
	PUTS
	JSR MENU_LOOP					; reset to menu

QUIT
	LEA R0, BYE
	PUTS
HALT

.end

; ================================================
; Main program data
; ================================================

MENU 				.FILL	x3400
ALL_MACHINES_BUSY	.FILL	x3600
ALL_MACHINES_FREE	.FILL	x3800
NUM_BUSY_MACHINES	.FILL	x4000
NUM_FREE_MACHINES	.FILL	x4200
MACHINE_STATUS		.FILL	x4400
FIRST_FREE			.FILL	x4600
PRINT_NUMBER		.FILL	x4800
PULL_INPUT			.FILL	x5000
ASC					.FILL	#48
BYE					.STRINGZ "\n7. Goodbye!\n"
ALL_BUSY_MES		.STRINGZ "\nAll machines are busy.\n"
ALL_BUSY_NMES		.STRINGZ "\nAll machines are not busy.\n"
ALL_FREE_MES		.STRINGZ "\nAll machines are free.\n"
ALL_FREE_NMES		.STRINGZ "\nAll machines are not free.\n"
THERE_MES			.STRINGZ "\nThere are "
BUSY				.STRINGZ " busy machines.\n"
FREE                .STRINGZ " free machines.\n"
MACH				.STRINGZ "\nMachine "
IS_BUS				.STRINGZ " is busy.\n"
IS_FRE				.STRINGZ " is free.\n"
AVAIL				.STRINGZ "\nThe first available machine is number "
NAVAIL				.STRINGZ "\nNo machines are available.\n"


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MENU
; Inputs: None
; Postcondition: The subroutine has printed out a menu with numerical options, allowed the
; user to select an option, and returned the selected option.
; Return Value (R1): The option selected: #1, #2, #3, #4, #5, #6 or #7
; no other return value is possible
.ORIG x3400
;-----------------------------------------------------------------------------------------------------------------

ST R0, BK_3400_R0					; store registers
ST R7, BK_3400_R7

AND R1, R1, #0						; set R1 to 0

PRINT_MENU_3400						; print out the menu
	LEA R0, MES0_3400
	PUTS

GET_INPUT_3400
	GETC							; pull user input and make sure it is
	OUT								; valid, meaning that the number was
	LD R1, ASC_3400					; a number between 0 and 7
	ADD R1, R0, R1					; if it wasn't, go ahead and keep asking
	BRnz INVALID_3400				; for the number until it is
	LD R0, SEV_3400
	ADD R1, R0, R1
	BRzp INVALID_3400
	NOT R0, R0
	ADD R0, R0, #1
	ADD R1, R0, R1
	JSR VALID_3400
	INVALID_3400
	LD R0, ERR_3400
	PUTS
	JSR PRINT_MENU_3400

VALID_3400
LD R0, BK_3400_R0					; once we have a valid number, go ahead	
LD R7, BK_3400_R7					; and restore registers and return
RET

BK_3400_R0	.BLKW 	#1
BK_3400_R7	.BLKW	#1
ASC_3400	.FILL	#-48
SEV_3400	.FILL	#-8
ERR_3400	.FILL	x356C
MES0_3400	.STRINGZ "\n***********************\n* The Busyness Server *\n***********************\n1. Check to see whether all machines are busy\n2. Check to see whether all machines are free\n3. Report the number of busy machines\n4. Report the number of free machines\n5. Report the status of machine n\n6. Report the number of the first available machine\n7. Quit\n"
.ORIG x356C
	.STRINGZ "\nInvalid input.\n"

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_BUSY
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are busy
; Return value (R2): 1 if all machines are busy, 0 otherwise
.ORIG x3600
;-----------------------------------------------------------------------------------------------------------------
ST R7, BK_3600_R7					; store register
LDI R0, BUSYNESS_3600				; load BUSYNESS vector

ADD R0, R0, #0						; check to see if at least one machine
BRnp ONE_FREE_3800					; is free, if so go ahead and return
	AND R2, R2, #0					; that not all machines are busy. otherwise
	ADD R2, R2, #1					; go ahead and return that all machines
	LD R7, BK_3600_R7				; are indeed busy
	RET

ONE_FREE_3800
	AND R2, R2, #0
	LD R7, BK_3600_R7
	RET

BK_3600_R7			.BLKW 	#1
BUSYNESS_3600		.FILL	x5200
COUNT_3600			.FILL	#15
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_FREE
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are free
; Return value (R2): 1 if all machines are free, 0 otherwise
.ORIG x3800
;-----------------------------------------------------------------------------------------------------------------
ST R7, BK_3800_R7					; store register
LDI R0, BUSYNESS_3800				; load BUSYNESS vector

LD R2, FFFF_3800
ADD R1, R2, R0						; check to see if at least one machine
BRnp ONE_BUSY_3800					; is busy, if so go ahead and return
	AND R2, R2, #0					; that not all machines are free. otherwise
	ADD R2, R2, #1					; go ahead and return that all machines
	LD R7, BK_3800_R7				; are indeed busy
	RET

ONE_BUSY_3800
	AND R2, R2, #0
	LD R7, BK_3800_R7
	RET

FFFF_3800			.FILL	#1
BK_3800_R7			.BLKW 	#1
BUSYNESS_3800		.FILL	x5200

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_BUSY_MACHINES
; Inputs: None
; Postcondition: The subroutine has returned the number of busy machines.
; Return Value (R2): The number of machines that are busy
.ORIG x4000
;-----------------------------------------------------------------------------------------------------------------
ST R7, BK_4000_R7					; store registers
LDI R1, BUSYNESS_4000				; load BUSYNESS vector
LD R3, COUNT_4000					; setup counting variables
AND R2, R2, #0

ADD R1, R1, #0
BRn PLUS_ONE_4000
		
COUNT_LOOP_4000						; iterate through the BUSYNESS vector
	ADD R1, R1, R1					; and count the number of 1s that we have
	BRn PLUS_ONE_4000				; 16 minus that number will be the
	ADD R3, R3, #-1					; number of 0s that we have
	BRz FINISHED_4000
	JSR COUNT_LOOP_4000

PLUS_ONE_4000
	ADD R2, R2, #1
	ADD R3, R3, #-1
	BRz FINISHED_4000
	JSR COUNT_LOOP_4000

FINISHED_4000						; once we have completed counting
LD R3, COUNT_4000					; go ahead and make the 16 - #1 subtraction
NOT R2, R2							; and return that number
ADD R2, R2, #1
ADD R2, R2, R3
LD R7, BK_4000_R7
RET

BK_4000_R7			.BLKW 	#1
BUSYNESS_4000		.FILL	x5200
COUNT_4000			.FILL	#16
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_FREE_MACHINES
; Inputs: None
; Postcondition: The subroutine has returned the number of free machines
; Return Value (R2): The number of machines that are free
.ORIG x4200
;-----------------------------------------------------------------------------------------------------------------
ST R7, BK_4200_R7					; store registers
LDI R1, BUSYNESS_4200				; load BUSYNESS vector
LD R3, COUNT_4200					; setup counting variables
AND R2, R2, #0

ADD R1, R1, #0
BRn PLUS_ONE_4200

COUNT_LOOP_4200						; iterate through the BUSYNESS	vector
	ADD R1, R1, R1					; and count the number of 1s that we
	BRn PLUS_ONE_4200				; have. that number will be the number
	ADD R3, R3, #-1					; of free machines
	BRz FINISHED_4200
	JSR COUNT_LOOP_4200

PLUS_ONE_4200
	ADD R2, R2, #1
	ADD R3, R3, #-1
	BRz FINISHED_4200
	JSR COUNT_LOOP_4200

FINISHED_4200						; once we finished counting go ahead
LD R7, BK_4200_R7					; and return the number
RET

BK_4200_R7			.BLKW 	#1
BUSYNESS_4200		.FILL	x5200
COUNT_4200			.FILL	#16
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MACHINE_STATUS
; Input (R1): Which machine to check
; Postcondition: The subroutine has returned a value indicating whether the machine indicated
; by (R1) is busy or not.
; Return Value (R2): 0 if machine (R1) is busy, 1 if it is free
.ORIG x4400
;-----------------------------------------------------------------------------------------------------------------
ST R7, BK_4400_R7					; store registers
ST R1, BK_4400_R1 
LDI R4, BUSYNESS_4400				; load BUSYNESS vector

NOT R1, R1							; setup counting variables
ADD R1, R1, #1
LD R2, SIXTEEN_4400
ADD R1, R1, R2

O_LOOP_4400							; iterate to the correct number
	ADD R1, R1, #-1					; each time left shifting to get to
	BRnz DONE_4400					; the bit we are interested in
	ADD R4, R4, R4
	JSR O_LOOP_4400

DONE_4400							; once we have found the correct
ADD R4, R4, #0						; bit we go ahead and return 
BRn	ONE_4400						; whether or not that bit was 1 or 0
	AND R2, R2, #0					; which will signify free or busy
	LD R7, BK_4400_R7
	LD R1, BK_4400_R1
	RET
ONE_4400
	AND R2, R2, #0
	ADD R2, R2, #1
	LD R7, BK_4400_R7				; reset registers and return
	LD R1, BK_4400_R1
	RET

SIXTEEN_4400		.FILL	#16
BUSYNESS_4400		.FILL	x5200
BK_4400_R7			.BLKW	#1
BK_4400_R1			.BLKW	#1
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: FIRST_FREE
; Inputs: None
; Postcondition:
; The subroutine has returned a value indicating the lowest numbered free machine
; Return Value (R2): the number of the free machine
.ORIG x4600
;-----------------------------------------------------------------------------------------------------------------
ST R7, BK_4600_R7					; store register
AND R2, R2, #0						; setup counting variables
AND R3, R3, #0
LD R4, COUNT_4600
LDI R1, BUSYNESS_4600				; load BUSYNESS vector

ADD R1, R1, #0						; if the number is 0, then all machines
BRz	ZERO_4600						; are busy

COUNT_LOOP_4600						; iterate through the number and 
	ADD R1, R1, #0					; test to see if the first number is
	BRn GOT_FREE_4600				; a 0 or a 1
	JSR GOT_BUSY_4600

GOT_BUSY_4600
	ADD R1, R1, R1					; if the first number was 0, then it was
	ADD R2, R2, #1					; busy. we don't 'remember' where the busy
	ADD R4, R4, #-1					; machines are, so increment counters	
	BRz DONE_4600					; and continue
	JSR COUNT_LOOP_4600

GOT_FREE_4600	
	ADD R1, R1, R1					; if the first number was 1, then it was
	ADD R3, R2, #0					; free so we go ahead and copy our counter
	ADD R2, R2, #1					; over to R3 to 'remember' where the last
	ADD R4, R4, #-1					; free machine is
	BRz DONE_4600
	JSR COUNT_LOOP_4600

ZERO_4600							; if we have all zero, return a negative
AND R2, R2, #0						; flag to signify that none of the machines
ADD R2, R2, #-1						; are free
LD R7, BK_4600_R7
RET

DONE_4600							; go ahead and take 16 - the number placement
LD R4, COUNT_4600					; that we had to select the correct bit
NOT R3, R3							; return 0 - 15 from right to left
ADD R3, R3, #1
ADD R2, R3, R4
ADD R2, R2, #-1
LD R7, BK_4600_R7					; restore registers
RET


BK_4600_R7			.BLKW 	#1
BUSYNESS_4600		.FILL	x5200
COUNT_4600			.FILL	#16

;--------------------------------------------------------------
; Subroutine: PRINT_NUMBER
; Postcondition: R1 is a decimal number to be printed to console
; Return value: none
.orig x4800
;--------------------------------------------------------------

ST R2, BK_4800_R2				; backup all the registers
ST R3, BK_4800_R3
ST R4, BK_4800_R4
ST R5, BK_4800_R5
ST R6, BK_4800_R6
ST R7, BK_4800_R7

LD R2, ZERO_3200				; put 0 in all registers but R1/R7
LD R3, ZERO_3200
LD R4, ZERO_3200
LD R5, ZERO_3200
LD R6, ZERO_3200

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

LD R2, BK_4800_R2				; finally reload the registers
LD R3, BK_4800_R3				; and return from the subroutine
LD R4, BK_4800_R4
LD R5, BK_4800_R5
LD R6, BK_4800_R6
LD R7, BK_4800_R7
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
BK_4800_R2      .BLKW   #1
BK_4800_R3      .BLKW   #1
BK_4800_R4      .BLKW   #1
BK_4800_R5      .BLKW   #1
BK_4800_R6      .BLKW   #1
BK_4800_R7      .BLKW   #1
;--------------------------------------------------------------
; Subroutine: LOAD_INPUT
; Postcondition: R1 will contain the value that the user enters into
; the console.
; Return value: R1
.orig x5000
;--------------------------------------------------------------

ST R2, BK_5000_R2				; store registers
ST R3, BK_5000_R3
ST R4, BK_5000_R4
ST R5, BK_5000_R5
ST R6, BK_5000_R6
ST R7, BK_5000_R7

Main_3800:                      ; Main routine
    LD R1, ZERO_3800
    LEA R0, prompt_3800         ; Load the user prompt into R0
    PUTS                    	; Output the user prompt to the console

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


; =======================
; Multiply subroutine. Just adds the number to itself the second number's times
; which is multiplication. Returns to add another number. 
; =======================

Multiply_3800:                  ; Multiply subroutine
    LD R6, MCOUNTER_3800        ; Load into R6 the counter (#10 times)
    ADD R2, R1, #0          	; Load into R2 the initial number
    LOOP_3800                   ; Begin loop
    ADD R1, R1, R2          	; Add the number with its original number
    ADD R6, R6, #-1         	; Decrement the counte	LD R1, BK_4400_R1r
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

FINISH_3800						; finish up section. restore registers

ADD R1, R1, #-16
BRp WRONG_3800

LD R2, SIX_3800
ADD R1, R1, R2

LD R2, BK_5000_R2
LD R3, BK_5000_R3
LD R4, BK_5000_R4
LD R5, BK_5000_R5
LD R6, BK_5000_R6
LD R7, BK_5000_R7
RET

; =======================
; LOAD_INPUT subroutine program data block
; =======================

BK_5000_R2      .BLKW   #1
BK_5000_R3      .BLKW   #1
BK_5000_R4      .BLKW   #1
BK_5000_R5      .BLKW   #1
BK_5000_R6      .BLKW   #1
BK_5000_R7      .BLKW   #1
FIRST_3800		.FILL 	#48
LAST_3800		.FILL 	#57
SIX_3800		.FILL	#16
ENTER_3800       .FILL   #-38
COUNTER_3800     .FILL   #4
MCOUNTER_3800    .FILL   #9
OFFSET_3800      .FILL   #-45
ASCOFFSET_3800   .FILL   #-48
NASCOFFSET_3800  .FILL   #48
ZERO_3800        .FILL   #0
NEG_3800         .FILL   #-1
POS_3800         .FILL   #1
prompt_3800      .STRINGZ "\nWhich machine would you like to check? (Followed by [ENTER])\n"
prompttt_3800 	.STRINGZ "\nThat wasn't a number between 0 and 15. Try again\n"


;=================================================
; BUSYNESS number for grader
;=================================================
.ORIG x5200
BUSYNESS		.FILL		xABCD
