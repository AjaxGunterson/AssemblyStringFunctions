TITLE	STR_CONCAT
; Concatonates two strings

INCLUDE Irvine32.inc
.data
target		BYTE	"ABCDE",10 DUP (?)
source		BYTE	"BC",0


Str_concat PROTO,targetStr:PTR BYTE,
				 sourceStr:PTR BYTE,
				 sourceLength:BYTE

.code
main PROC
	
	INVOKE	Str_concat,ADDR target,
						ADDR source,
						LENGTHOF source;

	mov		edx,OFFSET target	; move offset for writestring
	call	WriteString			;
	call	Crlf				;

exit
main ENDP

;---------------------------------------------------------------;
Str_concat PROC,targetStr:PTR BYTE,
				sourceStr:PTR BYTE,
				sourceLength:BYTE

;					Description:	Concatonates source string	;
;									with target.				;
;																;
;---------------------------------------------------------------;
	pushad;
	
	mov		esi,targetStr	; move target to esi
	mov		edi,0			; reset counter
	mov		eax,0			; reset holder
	L1:	mov		eax,[esi+edi]	; current 
		cmp		eax,0			; is uninitialized?
		je		L2				; go out if uninitialized
		inc		edi				; Next pos
		jmp		L1				; do-while
	L2:
	movzx	ecx,sourceLength; use source length as counter
	mov		edx,edi			; Store last initialized pos
	mov		edi,0			; reset counter

	L3:	mov		esi,sourceStr	; move esi source
		mov		al,[esi+edi]	; move current element to al
		mov		esi,targetStr	; move esi target
		push	edi				; save counter
		mov		edi,edx			; move second counter to edi
		mov		[esi+edi],al	; move current source to target
		pop		edi				; restore counter
		inc		edi				; mov to next element
		inc		edx				; inc second counter
		Loop	L3				;

	popad;
	ret
Str_concat	ENDP
END main