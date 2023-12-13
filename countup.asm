; countup.asm
;
; Kevin Chen ECE 109
;
; Date Submitted: March 22, 2023
;
; Program 1 Spring 2023 - Program takes a number the user inputs between 0-49 and prints
; "I see stars!" and the same number of stars as the inputted number. Program repeats
; until the user inputs 'q', which quits the program. 
		
		.ORIG x3000 ; set the first line to x3000

START		LEA R0, prompt	; Prompt user for input
			PUTS
			
; clearing Registers

			AND R6, R6, #0	; Clear R6 for counter
			AND R3, R3, #0	; Clear R3 in "tens" place
			AND R2, R2, #0	; Clear R2 in "ones" place
			
USERINPUT	GETC			; Puts user input in R0

; checks for 'q'

			LD R1, Negq		; Puts -113 in R1
			ADD R1, R1, R0	; Adds -113 to input and puts in R1
			BRz STOP		; If R1 is 0, user input 'q'
			
; checks for 'enter' 
			
		 	ADD R6, R6, #0	; Branch looks at R6
			BRp CHECKONE	; If counter is positive, check if enter inputted 'enter'

; checks for character less than '0'

STEP		LD R1, Neg0		; Puts -48 in R1
			ADD R1, R1, R0	; Adds -48 to input and puts in R1
			BRn USERINPUT	; If value negative, ignore loop back to USERINPUT

; checks for character greater than '9'

			LD R1, Neg9		; Puts -57 in R1	
			ADD R1, R1, R0	; Adds -57 to input and puts in R1
			BRp USERINPUT	; If value positive, ignore and loop back to USERINPUT

; number input

			OUT				; Echo in console
			ADD R6, R6, #0	; Branch looks at R6
			BRp CHECKTWO	; Positive means second number inputted
			ADD R2, R2, R0	; Put input in R2 (ones place)
			ADD R6, R6, #1	; Increment R6
			BRnzp USERINPUT	; Loop back to USERINPUT 

; one digit input check
			
CHECKONE 	LD R1, Negent	; Puts -10 in R1
			ADD R1, R1, R0	; Adds -10 to input and puts in R1
			BRz COUNTSTARS	; If R1 is 0, go print stars
			BRnp STEP		; Else, go to step
			
; two digit input check
			
CHECKTWO	LD R1, Neg0		; Setup to convert values to decimal
			ADD R3, R2, R1	; Move value in R2 to R3 (tens place) and convert to decimal
			ADD R2, R0, #0	; Move input in R2 (ones place)
			BRnzp COUNTSTARS; Go count stars

; counting up stars

COUNTSTARS	LD R6, Counter	; Set R6 to 9
			LD R1, Neg0		; Setup to convert values to decimal
			ADD R5, R3, #0	; Use R5 to store tens place digit
			ADD R2, R2, R1	; Ones place converted to decimal	
			
LOOPC		ADD R3, R3, R5	; Add R3 to tens place digit
			ADD R6, R6, #-1	; Decrement counter
			BRp LOOPC		; If counter positive, loop again
			ADD R3, R3, R2	; Add R2 (ones) to final value in R3
			LD R1, Neg49	; Puts -49 in R1
			ADD R4, R3, R1	; Adds R3 and R1 and puts in R4
			BRnz PRINTSTARS	; Go count stars if input is legal
			LEA R0, invalid	; Prints illegal input line
			PUTS
			BRnzp START		; Loops back to START

; printing stars

PRINTSTARS	LEA R0, stars	; I see stars prompt
			PUTS
			ADD R3, R3, #0	; Edge case for '0'
			BRz DONE		; Skips over printing stars			
LOOPSTARS	LD R0, Star		; Puts '*' in R0
			OUT
			ADD R3, R3, #-1	; R3 is now counter, decrement
			BRp LOOPSTARS
			
DONE		LEA R0, finish	; All done prompt
			PUTS		
			BRnzp START
				
; stopping program				
						
STOP		OUT
			LEA R0, goodbye ; Print "Goodbye!!!" in console
			PUTS
			HALT			; Stops program
			
; variables
Negq		.FILL #-113
Neg0		.FILL #-48
Neg9		.FILL #-57
Negent		.FILL #-10
Neg49		.FILL #-49
Counter		.FILL #9
Star		.FILL #42								
prompt		.STRINGZ	"\n\nEnter a number (0-49): "			
invalid 	.STRINGZ 	"\nInvalid input, try again!"	
goodbye 	.STRINGZ	"\n\nGoodbye!!!\n\n"				
stars 		.STRINGZ	"\n\nI see stars!\n"	
finish	 	.STRINGZ	"\n\nAll done"				

		.END