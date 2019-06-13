TITLE	STR_FIND
; Finds location of a specific word/text
; and returns the location in eax

INCLUDE Irvine32.inc
.data
target		BYTE	"ABCDEF",0
source		BYTE	"BC",0

Str_find PROTO,targetStr:PTR BYTE,
				 sourceStr:PTR BYTE,
				 targetLength:BYTE,
				 sourceLength:BYTE

.code
main PROC

	INVOKE	Str_find,ADDR target,
						ADDR source,
						LENGTHOF target,
						LENGTHOF source;

	
	Call	DumpRegs			; show if eax is empty
	Call	Crlf				; Make prettier

exit
main ENDP

;---------------------------------------------------------------;
Str_find PROC,targetStr:PTR BYTE,
				 sourceStr:PTR BYTE,
				 targetLength:BYTE,
				 sourceLength:BYTE								

;				 Description:	finds (or not) the location of	;
;							a string inside of a target and		;
;							returns location in eax and sets	;
;							(or clears) zero flag				;
;																;
;---------------------------------------------------------------;
	push	edi;
	push	ecx;
	push	esi;
	push	edx;

	mov		edi,0				; Clear counter
	movzx	ecx,targetLength	; Target length (larger)
	dec		ecx					;
	push	edi					;
	push	ecx					;

	
	L1:	pop		ecx					; Returns old ecx value (outer loop)
		pop		edi					; Retusn old edi value (outer loop)
	L2:	mov		esi,targetStr		; Move target addr to esi
		mov		al,[esi+edi]		; Move current character to al
		mov		esi,sourceStr		; move source addr to esi
		cmp		al,[esi]			; cmp current target to first source str
		je		L3					; if match go to L3
		inc		edi					; go to next tartget val
		Loop	L2					;
		
		mov		eax,0	; return no address in eax
		test	al,al	; Set zero flag (not found)
		jmp		L5		;

	L3:	push	ecx					; Save inner loop
		push	edi					;
		mov		edx,-1				; Reset inner loop counter
			dec		edi					; Go back an element
		movzx	ecx,sourceLength	; Length of source as counter
		dec		ecx					; remove null character

	L4:	inc		edi				; Move to next element
		inc		edx				; inc to subtract back to start
		mov		esi,sourceStr	; move source to esi
		push	edi				; save first counter
		mov		edi,edx			; move secondary counter
		mov		al,[esi+edi]	; move source to al
		pop		edi				; load first counter
		mov		esi,targetStr	; move target to esi
		cmp		al,[esi+edi]	; compare current target to source
		jne		L1				; restart at top if NE
		Loope	L4				; keep going if equal
		mov		eax,esi			; Move array pointer to eax
		add		eax,edi			; Move offset of first char
		sub		eax,edx			; Will keep location of first element
		test	eax,eax			; Will always clear zf
		pop		ecx				;

	L5:
	
	pop	edx	;
	pop	esi	;
	pop	ecx	;
	pop	edi	;

	ret
Str_find	ENDP
END main