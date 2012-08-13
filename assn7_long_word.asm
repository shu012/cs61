;=================================================
; 
; Name: Vaughen, Josh
; 
; Assignment name: assn7
; 
; I hereby certify that the contents of this file
; are ENTIRELY my own original work. 
;
;=================================================

;=================================================
; General program logic:
; Call INPUT_SENTENCE to pull in the characters that will make
; up the sentence. Then call FIND_LONGEST_WORD to find the
; word in the stored sentence that is the longest. Return in R2
; the longest word in the sentence. Call PRINT_ANALYSIS to 
; print out the sentence itself and the longest word in 
; said sentence.
;=================================================

.ORIG x3000

LEA R0, ENTER					; load in \n character and print
PUTS

LD R1, ADDRESS					; load into R1 the address to store words

LD R6, INPUT_SENTENCE			; load INPUT_SENTENCE subroutine and
JSRR R6							; jump to it

LD R6, FIND_LONGEST_WORD		; load FIND_LONGEST_WORD subroutine and
JSRR R6							; jump to it

LD R6, PRINT_ANALYSIS			; load PRINT_ANALYSIS subroutine and
JSRR R6							; jump to it

HALT							; quit program

.END

; ================================================
; Main program data
; ================================================

ENTER				.STRINGZ "\n"
ADDRESS 			.FILL	x4000
INPUT_SENTENCE		.FILL	x3400
FIND_LONGEST_WORD	.FILL	x3600
PRINT_ANALYSIS		.FILL	x3800



;----------------------------------------------------------------------------------------------------------------- 
; Subroutine: INPUT_SENTENCE 
; Input (R1): The address of where to store the array of words 
; Postcondition: The subroutine has collected an ENTER-terminated string of words from 
;                         the user and stored them in consecutive memory locations, starting at (R1). 
; Return Value: None 
.ORIG x3400
;----------------------------------------------------------------------------------------------------------------- 

ST R1, BK_3400_R1				; store registers
ST R2, BK_3400_R2				
ST R3, BK_3400_R3
ST R4, BK_3400_R4
ST R5, BK_3400_R5
ST R6, BK_3400_R6
ST R7, BK_3400_R7

ST R1, POINTER_3400				; store the pointer in R1 to memory

INPUT_LOOP_3400					; input loop: pull in a character, and
	GETC						; output it. Load in #-10 to R2 to 
	OUT							; test to see if the user entered [ENTER]
	LD R2, ENTERN_3400			
	ADD R0, R0, R2
	BRz	ENTER_3400				; if they did enter [ENTER], process it
	LD R2, ENTERP_3400			; otherwise reset the character by adding
	ADD R0, R0, R2				; #10 back to it
	RETURN_POINT_3400
	STR R0, R1, #0				; then go ahead and store the char into memory
	ADD R1, R1, #1				; pointed to by the passed in pointer and
	JSR INPUT_LOOP_3400			; continue pulling characters

ENTER_3400						; if user entered [ENTER] then we need to
	LD R2, ZERO_3400			; store a '0' at the next location to show
	STR R2, R1, #0				; end of word. Do that, and then increment
	ADD R1, R1, #1				; the memory pointer
	GETC						; get another character from the user
	OUT							; and then test to see if that new character
	LD R2, ENTERN_3400			; is [ENTER]
	ADD R0, R0, R2
	BRz ANOTHER_ENTER_3400		; if it is [ENTER], jump out, otherwise reset
	LD R2, ENTERP_3400			; the character, and continue to pull in
	ADD R0, R0, R2				; the next word from the user
	JSR RETURN_POINT_3400

ANOTHER_ENTER_3400				; two [ENTER]s have been entered. store a '0'
	LD R2, ZERO_3400			; at the very end of the array, after the 
	STR R2, R1, #0				; previous '0'

LD R1, BK_3400_R1				; now restore all registers and return
LD R2, BK_3400_R2				
LD R3, BK_3400_R3
LD R4, BK_3400_R4
LD R5, BK_3400_R5
LD R6, BK_3400_R6
LD R7, BK_3400_R7
RET

; ================================================
; INPUT_SENTENCE subroutine data
; ================================================

ZERO_3400		.FILL	#0
ENTERN_3400		.FILL	#-10
ENTERP_3400		.FILL	#10
POINTER_3400	.BLKW	#1
BK_3400_R1		.BLKW	#1
BK_3400_R2		.BLKW	#1
BK_3400_R3		.BLKW	#1
BK_3400_R4		.BLKW	#1
BK_3400_R5		.BLKW	#1
BK_3400_R6		.BLKW	#1
BK_3400_R7		.BLKW	#1

;----------------------------------------------------------------------------------------------------------------- 
; Subroutine: FIND_LONGEST_WORD 
; Input (R1): The address of the array of words 
; Postcondition: The subroutine has located and the longest word in the array of words 
; Return value (R2): The address of the beginning of the longest word 
.ORIG x3600
;----------------------------------------------------------------------------------------------------------------- 

ST R1, BK_3600_R1				; store registers
ST R3, BK_3600_R3
ST R4, BK_3600_R4
ST R5, BK_3600_R5
ST R6, BK_3600_R6
ST R7, BK_3600_R7

LD R3, ZERO_3600				; make sure R3 and R4 are '0'
LD R4, ZERO_3600

SENTENCE_BEGIN_3600				; store the pointer in R1 to POINTER and
	ST R1, POINTER_3600			; load into R5 '0', to be used as a flag
	LD R5, ZERO_3600			; to check for longest word

COUNT_LOOP_3600					; begin the counting. load into R0 the character
	LDR R0, R1, #0				; stored at R1. If its 0, end of word.
	BRz END_WORD_3600
	ADD R3, R3, #1				; otherwise incremement R3, the counter for 
	ADD R1, R1, #1				; each individual word and continue counting
	JSR COUNT_LOOP_3600			; characters
		
END_WORD_3600					; here we have reached the end of a word. go
	ADD R1, R1, #1				; ahead and load the next character after the '0'
	LDR R0, R1, #0				; and check to see if its another '0'. if so, 
	BRz END_SENTENCE_3600		; we are done
	NOT R3, R3					; otherwise invert R3, the current count
	ADD R3, R3, #1				; and add it to the previous word's count
	ADD R5, R3, R4				; length. if the result is negative, the
	BRn R3_LONGER_3600			; new word is longer than the previous most
	LD R3, ZERO_3600			; long. otherwise, reset current count and 
	JSR SENTENCE_BEGIN_3600		; continue on next word
	R3_LONGER_3600			
	NOT R3, R3					; here the new word is longer, so go ahead
	ADD R3, R3, #1				; and store that new longest length and
	ADD R4, R3, #0				; set the pointer to the longest word
	LD R5, POINTER_3600			; to the beginning of this word.
	ST R5, L_POINTER_3600		
	LD R3, ZERO_3600
	JSR SENTENCE_BEGIN_3600		; reset counter, and continue counting

END_SENTENCE_3600				; here we have reached the end of the sentence
	NOT R3, R3					; go ahead and test the very last word to see
	ADD R3, R3, #1				; if it is longer than any of the previous
	ADD R5, R3, R4
	BRn R3_LONGERR_3600			
	
	LD R1, BK_3600_R1			; if it not longer, go ahead and restore registers
	LD R3, BK_3600_R3
	LD R4, BK_3600_R4
	LD R5, BK_3600_R5
	LD R6, BK_3600_R6
	LD R7, BK_3600_R7
	LD R2, L_POINTER_3600
	BRz R2_ZERO_3600			; if the user just entered [ENTER] [ENTER]
	RET							; make sure to return a pointer to available
	R2_ZERO_3600				; memory, or to the beginning of the sentence
	LD R2, BK_3600_R1			; so we don't have any invalid memory
	RET							; accesses

	R3_LONGERR_3600				; if R3 is longer, just go ahead and return
	LD R2, POINTER_3600			; the current pointer, because it'll already
	LD R1, BK_3600_R1			; point to the last word. restore registers
	LD R3, BK_3600_R3			; and return
	LD R4, BK_3600_R4
	LD R5, BK_3600_R5
	LD R6, BK_3600_R6
	LD R7, BK_3600_R7
	RET

; ================================================
; FIND_LONGEST_WORD subroutine data
; ================================================

L_POINTER_3600	.BLKW	#1
ADDRESS_3600	.BLKW	#1
POINTER_3600	.BLKW	#1
ZERO_3600		.FILL	#0
BK_3600_R1		.BLKW	#1
BK_3600_R2		.BLKW	#1
BK_3600_R3		.BLKW	#1
BK_3600_R4		.BLKW	#1
BK_3600_R5		.BLKW	#1
BK_3600_R6		.BLKW	#1
BK_3600_R7		.BLKW	#1

;----------------------------------------------------------------------------------------------------------------- 
; Subroutine: PRINT_ANALYSIS 
; Input (R1): The address of the beginning of the array of words 
; Input (R2): The address of the longest word 
; Postcondition: The subroutine has printed out a list of all the words entered as well as the 
;                          longest word in the sentence. 
; Return Value: None 
.ORIG x3800
;-----------------------------------------------------------------------------------------------------------------

ST R1, BK_3800_R1				; store registers
ST R2, BK_3800_R2
ST R3, BK_3800_R3
ST R4, BK_3800_R4
ST R5, BK_3800_R5
ST R6, BK_3800_R6
ST R7, BK_3800_R7

LEA R0, SENTENCEB_3800			; load initial sentence "Sentence: " and
PUTS							; print it

PRINT_LOOP_3800					; while we have not encountered a '0' in the
	LDR R0, R1, #0				; memory block, continue to print out each
	BRz OUT_LOOP_3800			; and every character
	OUT							; as soon as we have encountered '0', its time
	ADD R1, R1, #1				; to insert a spacer
	JSR PRINT_LOOP_3800

OUT_LOOP_3800					; increment the pointer to make sure it points
	ADD R1, R1, #1				; to the beginning of the new word and
	LDR R0, R1, #0				; then test to see if the new word is there
	BRz	DONE_SENTENCE_3800		; or not. if '0', we are done
	LEA R0, SPACER_3800			; otherwise output a spacer and then
	PUTS						; continue traversing the arrays
	JSR PRINT_LOOP_3800

DONE_SENTENCE_3800				; if end of sentence, go ahead and print
	LEA R0, SENTENCEE_3800		; a trailing quote and print the 
	PUTS						; "Longest: " message
	LEA R0, LONGEST_3800
	PUTS

PRINT_LONG_3800					; use pointer in R2 to loop through the 
	LDR R0, R2, #0				; longest word and print it. when encountered
	BRz DONE_LOOP_3800			; a '0' we have finished, so jump out
	OUT
	ADD R2, R2, #1
	JSR PRINT_LONG_3800

DONE_LOOP_3800					; print trailing quote, then restore registers
	LEA R0, QUOTE_3800			; and return
	PUTS

LD R1, BK_3800_R1
LD R2, BK_3800_R2
LD R3, BK_3800_R3
LD R4, BK_3800_R4
LD R5, BK_3800_R5
LD R6, BK_3800_R6
LD R7, BK_3800_R7

RET

; ================================================
; PRINT_ANALYSIS subroutine data
; ================================================

SENTENCEB_3800 	.STRINGZ "\nSentence: {\""
SENTENCEE_3800	.STRINGZ "\"}"
SPACER_3800		.STRINGZ "\", \""
LONGEST_3800	.STRINGZ "\nLongest: \""
QUOTE_3800		.STRINGZ "\""
BK_3800_R1		.BLKW	#1
BK_3800_R2		.BLKW	#1
BK_3800_R3		.BLKW	#1
BK_3800_R4		.BLKW	#1
BK_3800_R5		.BLKW	#1
BK_3800_R6		.BLKW	#1
BK_3800_R7		.BLKW	#1
