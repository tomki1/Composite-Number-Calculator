TITLE Composite Number Calculator     (KimberlyTomProject4.asm)

; Author: Kimberly Tom
; Last Modified: 10/31/18
; OSU email address: tomki@oregonstate.edu
; Course number/section: 271/400
; Project Number: 4                Due Date: 11/4/18
; Description: This program calculates and displays composite numbers.

INCLUDE Irvine32.inc

MAXLIMIT = 400																				; upper limit for number of composites to be displayed
MINLIMIT = 1																				; lower limit for number of composite numbers to be displayed

.data

title_1		BYTE	"Composite Number Calculator		by Kimberly Tom", 0
EC_1		BYTE	"**EC1: columns are aligned", 0
prompt_1	BYTE	"What's your name? ", 0
intro_1		BYTE	"Nice to meet you, ",0
userName	BYTE	33 DUP(0)																; string to be entered by user
intro_2		BYTE	"Enter the number of composites to be displayed.", 0dh,0ah
			BYTE	"It must be an integer in the range [1..400].", 0
prompt_2	BYTE	"Enter the number: ", 0
n			DWORD	?																		; user's number input 
invalidTerm	BYTE	"The input you entered is not in the range [1..400]. Try again.", 0
compMsg_1	BYTE	"Below are the composite numbers: ", 0
firstComp	DWORD	4																		; the first composite number is 4
intCount	DWORD	0																		; holds the number of integer results displayed
divTen		DWORD	10																		; used to divide by 10
temp		DWORD	1																		; hold temp value
goodBye		BYTE	"I hope you enjoyed this program. Good Bye, ", 0

.code

;*********************************
;main
;main function that makes procedure calls
;Receives: n/a
;Returns: n/a
;*********************************

main PROC
call introduction
call getUserData
call showComposites
call farewell
exit																						;exit to operating system
main ENDP

;*********************************
;Introduction
;Procedure to greet user and provide instructions. Obtains username from user and greets user using ther name
;Receives: userName
;Returns: userName
;Preconditions: userName length must be less than ecx
;Registers changed: eax, ecx, edx
;*********************************

introduction PROC

	mov		edx, OFFSET title_1
	call	WriteString
	call	Crlf
	mov		edx, OFFSET EC_1
	call	WriteString
	call	Crlf
	call	Crlf

	;get user's name
	mov		edx, OFFSET prompt_1
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32
	call	ReadString
	call	Crlf
	
	;greet user
	mov		edx, OFFSET intro_1
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	Crlf
	call	Crlf

	;instructions
	mov		edx, OFFSET intro_2
	call	WriteString
	call	Crlf
	ret

introduction ENDP

;*********************************
;getUserData
;Procedure to get the number of composites the user would like to see. Makes call to validate to perform input validation on number
;Receives: n (user's number)
;Returns: n/a
;Preconditions: n must be in the range [1..400]
;Registers changed: eax, edx
;*********************************

getUserData PROC
	
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt
	mov		n, eax
	call	validate
	call	Crlf
	ret
getUserData ENDP

;*********************************
;validate
;Procedure to make sure user's number is in the range [1..400]. If not, makes call to getUserData so another number can be obtained
;Receives: n (user's number)
;Returns: validated n, if number is not in [1..400] informs user number isn't valid
;Preconditions: n/a
;Registers changed: edx
;*********************************

validate PROC

	cmp		n, MAXLIMIT
	jg		errorMessage
	cmp		n, MINLIMIT
	jl		errorMessage
	jmp		numberOK
	
	;show error message and call getUserData again if user's number is out of range
	errorMessage:
	mov		edx, OFFSET invalidTerm
	call	WriteString
	call	Crlf
	call	getUserData

	numberOK:
	
	ret
validate ENDP

;*********************************
;showComposites
;Procedure to print the composite numbers. Makes call to isComposite to determine what number is composite
;prints the list of composite numbers with 10 numbers on each line
;Receives: n (user's number)
;Returns: list of n composite numbers
;Preconditions: n/a
;Registers changed: eax, ecx, edx
;*********************************

showComposites PROC

	mov		edx, OFFSET compMsg_1
	call	WriteString
	call	Crlf

	mov		ecx, n																				

	;calculate composite numbers loop
	calcLoop:
	call	isComposite

	; if there are ten integers on a line, create a new line
	mov		eax, intCount
	cdq
	div		divTen
	cmp		edx, 0
	jne		noNewLine

	;if int count is 10 and we just divided by ten previously, jump to no new line
	mov		eax, intCount
	cmp		eax, temp
	je		noNewLine
	
	;create a new line
	call	Crlf
	mov		eax, intCount
	mov		temp, eax

	noNewLine:
	loop	calcLoop
	ret
showComposites ENDP

;*********************************
;isComposite
;Procedure to calculate the composite numbers. Uses loop to determine if a number is composite
;Receives: n/a
;Returns: composite number
;Preconditions: n/a
;Registers changed: eax, ebx, ecx, edx, al
;*********************************

isComposite	PROC

	mov		eax, firstComp
	mov		ebx, 2

	mov		edx, 0
	div		ebx																					; divide by 2 to see if number is composite
	cmp		edx, 0
	je		numComposite																		; if there is no remainder, number is composite
	inc		ebx
	
	findCompLoop:
	mov		edx, 0
	cmp		ebx, firstComp																		; if ebx is equal to the current number, then not composite
	je		notComposite																		; jump outside of loop as we are at the current number
	mov		eax, firstComp
	div		ebx
	cmp		edx, 0
	je		numComposite
	add		ebx, 2																				; increment ebx by 2 on our next division to skip over even numbers
	jmp		findCompLoop																		; repeat until it is determined that number is composite or we are at number

	;display composite number
	numComposite:
	mov		eax, firstComp
	call	WriteDec
	mov		al, 9																				; ASCII tab character
	call	WriteChar																			; tab to align text
	inc		intCount
	jmp		next

	notComposite:
	inc		ecx																					; if not composite, increment ecx so the showComposites counter does not decrease

	next:	
	inc		firstComp																			;increment the number we will be checking
	ret
isComposite ENDP

;*********************************
;farewell
;Procedure to say goodbye to the user
;Receives: userName
;Returns: goodbye message
;Preconditions: n/a
;Registers changed: edx 
;*********************************

farewell PROC

	call	Crlf
	call	Crlf
	mov		edx, OFFSET goodBye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	Crlf
	ret
farewell ENDP

END main
