%include "../include/io.mac"

struc creds
    passkey: resw 1
    username: resb 51
endstruc

struc request
    admin: resb 1
    prio: resb 1
    login_creds: resb creds_size
endstruc

section .text
    global check_passkeys
    extern printf

check_passkeys:

    enter 0, 0
    pusha

    mov ebx, [ebp + 8]      ; requests
    mov ecx, [ebp + 12]     ; length
    mov eax, [ebp + 16]     ; connected


    ; folosesc edx contor pentru bucla for din cadrul sortari
    push eax ; connected
    xor edx, edx ; i
    ; incep cu i = 0
    ; pun in registrul esi requests
    mov esi, ebx
    xor edi, edi ; pentru a calcula request_size pt i

for_check_pass:
    ; presupun ca nu e hacker
    xor eax, eax
    ; pun length pe stiva
    push ecx 
    ; pun contorul de la for pe stiva
    push edx
    ; mut in bx parola
    mov bx, word[esi + edi + login_creds + passkey]
    jmp cmp_hacker ; compar prima data daca ultimul bit e 1
    jmp exit_for

cmp_hacker:
    ; compar ultimul bit din passkey cu 1
    push ebx
    test bx, 1
    jnz cmp_hacker2 ; daca e 1 continuam 
    jmp exit_no_hacker ; daca nu nu e hacker

cmp_hacker2:
    ; compar primul bit din passkey
    shr bx, 15
    test bx, 1
    jz exit_no_hacker ; daca nu e 1 ma opresc
    pop ebx
    jmp cmp_hacker3 ; daca e 1 continui compararea

cmp_hacker3:
    push ebx
    ; calculez nr de biti de 1 din bl
    xor ecx, ecx
    xor edx, edx ; contor pentru for
    shr bl, 1 ; shiftez la dreapta pentru a elimina primul bit

for_first_7_biti:
    test bl, 1
    ; adaug 1 la contor daca bitul e 1
    jz add_1
    jmp continue_for_1

add_1:
    add ecx, 1
    jmp continue_for_1

continue_for_1:
    shr bl, 1
    add edx, 1
    cmp edx, 7
    jne for_first_7_biti
    test ecx, 1 ; verific daca e impar si daca ccontinui verificare
    jz exit_no_hacker ; daca nu ma opresc
    pop ebx
    jmp cmp_hacker4

cmp_hacker4:
    push ebx
    ; calculez nr de biti de 1 din bl
    xor ecx, ecx
    xor edx, edx ; contor pentru for

for_last_7_biti:
    test bh, 1
    ; adaug 1 la contor daca bitul e 1
    jz add_2
    jmp continue_for_2

add_2:
    add ecx, 1
    jmp continue_for_2

continue_for_2:
    shr bh, 1
    add edx, 1
    cmp edx, 7
    jne for_last_7_biti
    test ecx, 1
    jz exit_hacker ; daca e impar este hacker
    jmp exit_no_hacker ; daca nu nu e hacker

exit_no_hacker:
    pop ebx
    mov eax, 0
    jmp exit_for

exit_hacker:
    pop ebx
    mov eax, 1
    jmp exit_for

exit_for:
    ; extrag contorul pentru  for
    pop edx
    ; extrag length
    pop ecx
    pop ebx
    cmp eax, 0
    je no_hacker
    cmp eax, 1
    je yes_hacker

no_hacker:
    mov byte[ebx + edx], 0
    jmp continue

yes_hacker:
    mov byte[ebx + edx], 1
    jmp continue

continue:
    add edx, 1
    add edi, request_size
    push ebx
    ; daca edx e mai mic ca length continuam prima bulca
    cmp ecx, edx
    jg for_check_pass
    jmp end_check

end_check:
    xor ebx, ebx
    mov ebx, esi
    pop eax



    popa
    leave
    ret
