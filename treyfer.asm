section .rodata
	global sbox
	global num_rounds
	sbox db 126, 3, 45, 32, 174, 104, 173, 250, 46, 141, 209, 96, 230, 155, 197, 56, 19, 88, 50, 137, 229, 38, 16, 76, 37, 89, 55, 51, 165, 213, 66, 225, 118, 58, 142, 184, 148, 102, 217, 119, 249, 133, 105, 99, 161, 160, 190, 208, 172, 131, 219, 181, 248, 242, 93, 18, 112, 150, 186, 90, 81, 82, 215, 83, 21, 162, 144, 24, 117, 17, 14, 10, 156, 63, 238, 54, 188, 77, 169, 49, 147, 218, 177, 239, 143, 92, 101, 187, 221, 247, 140, 108, 94, 211, 252, 36, 75, 103, 5, 65, 251, 115, 246, 200, 125, 13, 48, 62, 107, 171, 205, 124, 199, 214, 224, 22, 27, 210, 179, 132, 201, 28, 236, 41, 243, 233, 60, 39, 183, 127, 203, 153, 255, 222, 85, 35, 30, 151, 130, 78, 109, 253, 64, 34, 220, 240, 159, 170, 86, 91, 212, 52, 1, 180, 11, 228, 15, 157, 226, 84, 114, 2, 231, 106, 8, 43, 23, 68, 164, 12, 232, 204, 6, 198, 33, 152, 227, 136, 29, 4, 121, 139, 59, 31, 25, 53, 73, 175, 178, 110, 193, 216, 95, 245, 61, 97, 71, 158, 9, 72, 194, 196, 189, 195, 44, 129, 154, 168, 116, 135, 7, 69, 120, 166, 20, 244, 192, 235, 223, 128, 98, 146, 47, 134, 234, 100, 237, 74, 138, 206, 149, 26, 40, 113, 111, 79, 145, 42, 191, 87, 254, 163, 167, 207, 185, 67, 57, 202, 123, 182, 176, 70, 241, 80, 122, 0
	num_rounds dd 10

section .text
	global treyfer_crypt
	global treyfer_dcrypt

; void treyfer_crypt(char text[8], char key[8]);
treyfer_crypt:

	push ebp
	mov ebp, esp
	pusha

	mov esi, [ebp + 8] ; plaintext
	mov edi, [ebp + 12] ; key	

	;; TODO implement treyfer_crypt
	; folosesc eax drept contor la bucla for
	xor eax, eax
	; folosesc registrul edx pentru text 
	mov dl, byte[esi]
	mov ebx, [num_rounds]
	shl ebx, 3

for_crypt:
	mov ecx, eax
	; calculez modulo 8 de i
	and cl, 7
	add dl, byte[edi + ecx]
	; calculez modulo 8 de i+1
	; implementez algoritmul explicat in enuntul temei de criptare
	mov ecx, eax
	add ecx, 1
	and cl, 7
	mov dl, byte[sbox + edx]
	add dl, byte[esi + ecx]
	rol dl, 1
	mov byte[esi + ecx], dl
	add eax, 1
	cmp eax, ebx
	jnz for_crypt

	popa
	leave
	ret

; void treyfer_dcrypt(char text[8], char key[8]);
treyfer_dcrypt:

	push ebp
	mov ebp, esp
	pusha

	;; TODO implement treyfer_dcrypt
	mov esi, [ebp + 8] ; plaintext
	mov edi, [ebp + 12] ; key	
	; folosesc eax drept contor la bucla for_numround
	xor eax, eax
	; folosesc ebp drept contor la bucla for_inside
	mov ebp, 7
	xor ecx, ecx ; top
	xor edx, edx ; bottom

for_numround:
	; implementez algoritmul expus in enuntul temei de decriptare
	mov cl, byte[esi + ebp]
	add cl, byte[edi + ebp]
	mov cl, byte[sbox + ecx]
	mov ebx, ebp
	add ebx, 1
	; calculez modulo 8 la i+1
	and bl, 7
	mov dl, byte[esi + ebx]
	; rotesc la dreapta cu 1 byte
	ror dl, 1
	sub dl, cl
	mov byte[esi + ebx], dl
	sub ebp, 1
	cmp ebp, 0
	jge for_numround
	add eax, 1
	cmp eax, [num_rounds]
	jne for_inside
	jmp end

for_inside:
	mov ebp, 7
	jmp for_numround

end:

	popa
	leave
	ret

