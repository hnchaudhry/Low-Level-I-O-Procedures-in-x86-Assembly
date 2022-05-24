TITLE Project 6 - String Primitives and Macros     (Proj6_chaudhrh.asm)

; Author: Hassan Chaudhry 
; Last Modified: 12/5/2021
; OSU email address: chaudhrh@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 6                 Due Date: 12/5/2021
; Description: A program that displays a title, programmer name, and instructions then
;		asks the user for 10 numerical inputs as a string. The strings are converted
;		to signed integers and validated. Validation checks to make sure the strings
;		only contain numerical inputs and the converted integers individually fit in a 32-bit
;		register. If the string did not contain only '+' or '-' (first character only to show sign), 
;		numerical values, it was to large to fit in a 32-bit register, or it was empty, an error  
;		is thrown and the user is asked to input another string. Once validation is completed, 
;		the program will take the signed integers, convert them back into strings, and display
;		them to the user as a list. It will them sum up all of the integers and displays the  
;		sum. The average is then calculated and a truncated version of it is displayed to the 
;		user. Finally, a goodbye message is displayed before exiting the program.

INCLUDE Irvine32.inc

.data
	intro1            BYTE   "PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures",13,10,
				             "Written by: Hassan Chaudhry",13,10,0
	intro2            BYTE   "Please provide 10 signed decimal integers.",13,10,
				             "Each number needs to be small enough to fit inside a 32 bit register. After you have finished",13,10, 
				             "inputting the raw numbers I will display a list of the integers, their sum, and their average value.",13,10,0
	userNumPrompt     BYTE   "Please enter a signed number: ",0
	enteredNumError   BYTE   "ERROR: You did not enter a signed number or your number was too big. Try again.",13,10,0
	listPrompt        BYTE   "You entered the following numbers:",13,10,0
	sumPrompt         BYTE   "The sum of these numbers is: ",0
	averagePrompt     BYTE   "The truncated average is: ",0
	goodbyePrompt     BYTE   "Thanks for playing!",13,10,0
	spacer            BYTE   ", ",0
	userStrBuffer     BYTE   13 DUP(?)                     ; string to be entered
	intToStr          BYTE   13 DUP(?)
	revIntToStr       BYTE   13 DUP(?)
	sizeRevStr        DWORD  SIZEOF revIntToStr
	userStrBufferSize DWORD  SIZEOF userStrBuffer
	userStrByteCount  DWORD  ?
	userEnteredNum    SDWORD ?
	userInputArray    SDWORD 10 DUP(?)

.code
main PROC
	;------------------------------------------------------------------
	; Calls prompts procedure to display program title, programmer
	;		name, and intructions to the user.
	;------------------------------------------------------------------
	PUSH  OFFSET intro1
	CALL  prompts
	CALL  CrLf
	PUSH  OFFSET intro2
	CALL  prompts
	CALL  CrLf

	;------------------------------------------------------------------
	; Calls ReadVal procedure 10 times to ask user for a numerical
	;		string and each time stores the input into an array.
	;------------------------------------------------------------------
	; Set loop counter to 10 and start at first element address
	MOV   ECX, LENGTHOF userInputArray
	MOV   EAX, 0
	
_CallReadVal:
	; Call call ReadVal with passed parameters
	PUSH  OFFSET userNumPrompt
	PUSH  OFFSET userStrBuffer
	PUSH  OFFSET userStrByteCount
	PUSH  OFFSET enteredNumError
	PUSH  OFFSET userEnteredNum
	PUSH  userStrBufferSize
	CALL  ReadVal

	; Fill array with user entered num and get next string
	MOV   EDI, OFFSET userInputArray
	ADD   EDI, EAX                                    ; Increment to next element in array
	MOV   ESI, userEnteredNum
	MOV   [EDI], ESI
	ADD   EAX, TYPE userInputArray                    ; Set EAX to offset of next element
	LOOP  _CallReadVal

	;------------------------------------------------------------------
	; Calls WriteVal procedure 10 times to convert a signed integer
	;		to a string and display the strings as a list with a
	;		message to the user with prompts procedure.
	;------------------------------------------------------------------
	; Display list prompt
	CALL  CrLf
	PUSH  OFFSET listPrompt
	CALL  prompts

	; Set loop counter to 10 and start at first element address
	MOV   ECX, LENGTHOF userInputArray
	MOV   EAX, 0

_CallWriteVal:
	; Get address of element in array and point to next element
	MOV   ESI, OFFSET userInputArray
	ADD   ESI, EAX
	
	; Call WriteVal procedure with passed parameters
	PUSH  OFFSET intToStr
	PUSH  OFFSET revIntToStr
	PUSH  sizeRevStr
	PUSH  [ESI]
	CALL  WriteVal
	CMP   ECX, 1
	JZ   _WriteValLoop

_ListSpacing:
	; Display spacing after numbers
	PUSH  OFFSET spacer
	CALL  prompts

_WriteValLoop:	
	; Increment offset to next element in array and get next element address
	ADD   EAX, TYPE userInputArray
	LOOP  _CallWriteVal

	;------------------------------------------------------------------
	; Calculates the sum of all the signed integers and uses WriteVal
	;		to convert and display it with a message to the user.
	;------------------------------------------------------------------
	; Set loop counter to 10, start at first element address, and initialize sum to 0
	MOV   ECX, LENGTHOF userInputArray
	MOV   EAX, 0
	MOV   EDX, 0
	
_SumLoop:
	; Sum up input values
	MOV   ESI, OFFSET userInputArray
	ADD   ESI, EAX                               ; Increment to next element array
	MOV   EBX, [ESI]
	ADD   EDX, EBX
	ADD   EAX, TYPE userInputArray               ; Set EAX to offset of next element
	LOOP  _SumLoop

	; Display sum prompt 
	PUSH  OFFSET sumPrompt
	CALL  CrLf
	CALL  prompts
	MOV   EAX, EDX
	
	; Call WriteVal to convert and display sum
	PUSH  OFFSET intToStr
	PUSH  OFFSET revIntToStr
	PUSH  sizeRevStr
	PUSH  EDX
	CALL  WriteVal

	;------------------------------------------------------------------
	; Calculates the average of the signed integers by taking the sum
	;		and dividing it by 10. The average is then displayed in
	;		truncated form (integer part only) along with a message.
	;------------------------------------------------------------------
	; Calulate average
	MOV   EDX, 0
	CDQ
	MOV   EBX, 10
	IDIV  EBX
	
	; Diplay average prompt 
	PUSH  OFFSET averagePrompt
	CALL  CrLf
	CALL  prompts
	
	; Display truncated average
	PUSH  OFFSET intToStr
	PUSH  OFFSET revIntToStr
	PUSH  sizeRevStr
	PUSH  EAX
	CALL  WriteVal
	CALL  CrLf

	;------------------------------------------------------------------
	; Calls prompts proecdure to display goodbye message to user 
	;		and exits the program on return.
	;------------------------------------------------------------------
	PUSH  OFFSET goodbyePrompt
	CALL  CrLf
	CALL  prompts
	Invoke ExitProcess,0	                  ; exit to operating system
main ENDP

;------------------------------------------------------------------------------
; Name: mGetString
;
; Gets string input from user and returns address of the input string
;		and adress to number of bytes entered by user.
;
; Preconditions: String buffer size is type DWORD.
;
; Postconditions: None
;
; Receives:
;		numPrompt	 = reference to prompt asking user for num
;		strBuffer	 = reference to string buffer
;		strMaxInput	 = string buffer size
;		strByteCount = reference to number of string bytes
;
; Returns:
;		strBuffer	 = reference to user entered string
;		strByteCount = reference to number of bytes entered
;------------------------------------------------------------------------------
mGetString MACRO numPrompt:REQ, strBuffer:REQ, strMaxInput:REQ, strByteCount:REQ
	PUSH  EDX
	PUSH  ECX
	PUSH  EAX
	
	; Display prompt
	MOV   EDX, numPrompt
	CALL  WriteString

	; Get user string input and store number of characters entered
	MOV   EDX, strBuffer 
	MOV   ECX, strMaxInput
	CALL  ReadString
	MOV   strByteCount, EAX
	
	POP   EAX
	POP   ECX
	POP   EDX
ENDM

;------------------------------------------------------------------------------
; Name: mDisplayString
;
; Displays a string.
;
; Preconditions: None
;
; Postconditions: None
;
; Receives:
;		someString		= reference to string location
;
; Returns: None
;------------------------------------------------------------------------------
mDisplayString MACRO someString:REQ
	PUSH  EDX

	; Display the string
	MOV   EDX, someString
	CALL  WriteString

	POP   EDX
ENDM

;------------------------------------------------------------------------------
; Name: ReadVal
;
; Converts user inputted string to a signed integer and validates it only
;		contains numerical values.
;
; Preconditions: String buffer size is type DWORD. 
;
; Postconditions: None
;
; Receives:
;		[EBP+28]	= reference to user num prompt
;		[EBP+24]	= reference to input string buffer
;		[EBP+20]	= reference to input byte count
;		[EBP+16]	= reference to num input error message
;		[EBP+12]	= reference to user entered string
;		[EBP+8]		= value of string buffer size
;
; Returns: Converted signed integer of user entered string.
;------------------------------------------------------------------------------
ReadVal PROC
	PUSH  EBP
	MOV   EBP, ESP
	PUSH  ESI
	PUSH  ECX
	PUSH  EDX
	PUSH  EAX
	PUSH  EBX
	PUSH  EDI
	
	mGetString [EBP+28], [EBP+24], [EBP+8], [EBP+20]
	
	; Set registers with string reference, byte count, and initialized numeric value to 0
	MOV   ESI, [EBP+24]
	MOV   ECX, [EBP+20]
	MOV   EDX, 0
	CLD

_CharCompare:
	; Load first character and decrement counter
	LODSB
	DEC   ECX
	
	; Check if first character is '-'
	CMP   AL, 45
	JZ    _ConvertNeg

	; Check if first character is '+'
	CMP   AL, 43
	JZ    _ConvertPosSign
	
	; Check that character is a numerical val
	CMP   AL, 48
	JB    _ErrorAskAgain
	CMP   AL, 57
	JA    _ErrorAskAgain
	INC   ECX

_ConvertNormal:
	; Ensure characters are numerical values
	CMP   AL, 48
	JB    _ErrorAskAgain
	CMP   AL, 57
	JA    _ErrorAskAgain
	
	; Conversion: int * 10 + (ascii dec - 48)
	SUB   AL, 48
	MOVSX EAX, AL
	PUSH  EAX
	MOV   EAX, EDX
	MOV   EBX, 10
	PUSH  EDX
	MOV   EDX, 0
	MUL   EBX
	CMP   EDX, 0						; Too large of a value -> EDX:EAX
	JNZ   _PopAndError
	POP   EDX 
	POP   EBX
	ADD   EAX, EBX
	MOV   EDX, EAX
	
	; Load next character and convert 
	LODSB
	LOOP  _ConvertNormal
	
	; Make value signed and compare to max val to fit in 32-bit reg
	IMUL  EDX, 1
	CMP   EDX, 2147483647
	JA    _ErrorAskAgain
	JMP   _MoveNumToMemVar

_ConvertNeg:
	LODSB

	; Ensure characters are numerical values
	CMP   AL, 48
	JB    _ErrorAskAgain
	CMP   AL, 57
	JA    _ErrorAskAgain
	
	; Conversion: int * 10 + (ascii dec - 48)
	SUB   AL, 48
	MOVSX EAX, AL
	PUSH  EAX
	MOV   EAX, EDX
	MOV   EBX, 10
	PUSH  EDX
	MOV   EDX, 0
	MUL   EBX
	CMP   EDX, 0                    ; Too large of a value -> EDX:EAX
	JNZ   _PopAndError
	POP   EDX 
	POP   EBX
	ADD   EAX, EBX
	MOV   EDX, EAX
	LOOP  _ConvertNeg
	
	; Negate value with two's complement and check if it fits in 32-bit reg
	NEG   EDX
	CMP   EDX, 4294967295
	JA    _ErrorAskAgain
	CMP   EDX, 2147483648
	JB    _ErrorAskAgain
	JMP   _MoveNumToMemVar

_ConvertPosSign:
	LODSB

	; Ensure characters are numerical values
	CMP   AL, 48
	JB    _ErrorAskAgain
	CMP   AL, 57
	JA    _ErrorAskAgain

	; Conversion: int * 10 + (ascii dec - 48)
	SUB   AL, 48
	MOVSX EAX, AL
	PUSH  EAX
	MOV   EAX, EDX
	MOV   EBX, 10
	PUSH  EDX
	MOV   EDX, 0
	MUL   EBX
	CMP   EDX, 0					; Too large of a value -> EDX:EAX
	JNZ   _PopAndError
	POP   EDX 
	POP   EBX
	ADD   EAX, EBX
	MOV   EDX, EAX
	LOOP  _ConvertPosSign
	
	; Make value signed and compare to max val to fit in 32-bit reg
	IMUL  EDX, 1
	CMP   EDX, 2147483647
	JA    _ErrorAskAgain

_MoveNumToMemVar:
	; Store the converted numerical value in a memory variable
	MOV   EDI, [EBP+12]
	MOV   [EDI], EDX
	JMP   _PopAndReturn

_PopAndError:
	; Pop the top of stack for alignment then move to error
	POP   EDX 
	POP   EBX

_ErrorAskAgain:
	; Display error to user and request number again
	PUSH  [EBP+16]
	CALL  prompts
	mGetString [EBP+28], [EBP+24], [EBP+8], [EBP+20]
	MOV   ESI, [EBP+24]
	MOV   ECX, [EBP+20]
	MOV   EDX, 0
	CLD
	JMP   _CharCompare

_PopAndReturn:
	POP   EDI
	POP   EBX
	POP   EAX
	POP   EDX
	POP   ECX
	POP   ESI
	POP   EBP
	RET   24
ReadVal ENDP

;------------------------------------------------------------------------------
; Name: WriteVal
;
; Takes a signed integer and converts it to a string.
;
; Preconditions: Integer is type SDWORD and string size is type DWORD.
;
; Postconditions: None
;
; Receives:
;		[EBP+20]	= reference to converted string
;		[EBP+16]	= reference to reversed converted string
;		[EBP+12]	= value of size of string
;		[EBP+8]		= value of signed integer
;
; Returns: Converted string and reversed converted string of signed integer.
;------------------------------------------------------------------------------
WriteVal PROC
	PUSH  EBP
	MOV   EBP, ESP
	PUSH  ESI
	PUSH  EDI
	PUSH  EAX
	PUSH  EBX
	PUSH  ECX
	PUSH  EDX

	; Clear string
	CLD
	MOV   EDI, [EBP+20]
	MOV   ECX, [EBP+12]
	MOV   AL, 0
	REP   STOSB

	; Clear reversed string
	MOV   EDI, [EBP+16]
	MOV   ECX, [EBP+12]
	MOV   AL, 0
	REP   STOSB

	; Set registers to convert number to string
	MOV   EAX, [EBP+8]
	MOV   EDI, [EBP+20]
	MOV   EBX, 10
	MOV   ECX, 0

	; Compare number to max 32-bit reg to determine if pos or neg
	CMP   EAX, 2147483647
	JA    _NegateVal
	JBE   _ConvertPosVal

_NegateVal:
	NEG   EAX                   ; Two's complement to create negative value

_ConvertNegVal:
	; Convert a negative integer to string, integer/10 -> remainder + 48 = ascii
	MOV   EDX, 0
	DIV   EBX
	ADD   DL, 48
	PUSH  EAX
	MOV   AL, DL
	STOSB
	INC   ECX
	POP   EAX
	CMP   EAX, 0
	JZ    _AppendNegSign
	JNZ   _ConvertNegVal

_AppendNegSign:
	; Append ascii '-' to string for negative
	MOV   AL, 45      
	STOSB
	INC   ECX
	JMP   _RevStr

_ConvertPosVal:
	; Convert a positive integer to string, integer/10 -> remainder + 48 = ascii
	MOV   EDX, 0
	DIV   EBX
	ADD   DL, 48
	PUSH  EAX
	MOV   AL, DL
	STOSB
	INC   ECX
	POP   EAX
	CMP   EAX, 0
	JZ    _RevStr
	JNZ   _ConvertPosVal

_RevStr:
	; Set registers to reverse string
	MOV   ESI, [EBP+20]
	MOV   EDI, [EBP+16]
	ADD   ESI, ECX
	DEC   ESI

_RevStrLoop:
	; Reverse the string and display it
	STD   
	LODSB
	CLD
	STOSB
	LOOP  _RevStrLoop
	mDisplayString [EBP+16]

_PopAndReturn:
	POP   EDX
	POP   ECX
	POP   EBX
	POP   EAX
	POP   EDI
	POP   ESI
	POP   EBP
	RET   16
WriteVal ENDP

;------------------------------------------------------------------------------
; Name: prompts
;
; Passes reference of string to mDisplayString macro to display prompt.
;
; Preconditions: None
;
; Postconditions: None
;
; Receives:
;		[EBP+8]		= reference to string
;
; Returns: None
;------------------------------------------------------------------------------
prompts PROC
	PUSH  EBP
	MOV   EBP, ESP
	
	mDisplayString [EBP+8]

	POP   EBP
	RET   4
prompts ENDP

END main
