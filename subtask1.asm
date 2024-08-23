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
    global sort_requests
    extern printf

sort_requests:

    enter 0,0
    pusha

    mov ebx, [ebp + 8]      ; requests
    mov ecx, [ebp + 12]     ; length



    ; folosesc eax si edx contor pentru bucla for din cadrul sortari
    xor eax, eax ; pentru primul label first_sort_for (i)
    xor edx, edx ; pentru al doilea label second_sort_for (i+1)
    ; incep cu j = 1
    add edx, 1
    ; pun in registrul esi requests
    mov esi, ebx
    xor edi, edi ; pentru a calcula request_size pt i
    mov ebx, request_size ; pentru a calcula request_size pentru j

first_sort_for:
    ; pun length pe stiva
    push ecx 
    ; pun contorul de la for pe stiva
    push eax 
    ; pun contorul de la al doilea for pe stiva
    push edx
    ; prima data verific adminul
    mov dl, byte[esi + edi + admin]
    mov cl, byte[esi + ebx + admin]
    cmp dl, cl
    jl swap
    jne second_sort_for
    ; daca sunt egale verific prioritatea
    xor dx, dx
    xor cx, cx
    movzx dx, byte[esi + edi + prio]
    movzx cx, byte[esi + ebx + prio]
    cmp dx, cx
    jg swap
    jne second_sort_for
    ; daca sunt egale verific username-ul
    ; folosesc eax pentru un alt for pentru a compara cele 2 numere litera cu litera
    xor eax, eax
    push edi ; pentru i
    push ebx ; pentru j
    cmp dx, cx
    je for_by_username

for_by_username:
    xor edx, edx
    xor ecx, ecx
    ; compar litera cu litera pana cand gasesc o litera diferita
    mov dl, byte[esi + edi + login_creds + username]
    mov cl, byte[esi + ebx + login_creds + username]
    cmp dl, cl
    jg pop_username
    jl pop_non_swap
    add edi, 1
    add ebx, 1
    add eax, 1
    cmp eax, 51
    jl for_by_username
    pop ebx ; pentru j
    pop edi ; pwntru i
    jmp second_sort_for

; daca am gasit o litera mai mica in username-ul de la j atunci fac swap
pop_non_swap:
    pop ebx ; pentru j
    pop edi ; pentru i
    jmp second_sort_for

; daca am gasit o litera mai mica in username-ul de la i atunci nu mai fac swap
pop_username:
    pop ebx ; pentru j
    pop edi ; pentru i
    jmp swap

; dau unpop la indicii de pe stiva folositi pentru a stii al catelea request este
unpop:
    pop ebx ; pentru j
    pop edi ; pentru i
    push edi ; pentru i
    push ebx ; pentru j
    xor edx, edx
    jmp swap_letter

; dau swap la intregul element din structura
swap:
    xor ecx, ecx
    xor eax, eax
    ; folosesc ecx drept variabila auxiliaza la swap pentru admin , prio si passkey
    mov ecx, dword[esi + ebx]
    mov eax, dword[esi + edi]
    mov dword[esi + edi], ecx
    mov dword[esi + ebx], eax
    push edi ; pentru i
    push ebx ; pentru j
    jmp unpop
    jmp second_sort_for

; schimb litera cu litera usernameul a doua requesturi
swap_letter:
    xor ecx, ecx
    xor eax, eax
    mov cl, byte[esi + ebx + login_creds + username]
    mov al, byte[esi + edi + login_creds + username]
    mov byte[esi + edi + login_creds + username], cl
    mov byte[esi + ebx + login_creds + username], al
    add edx, 1
    add edi, 1
    add ebx, 1
    cmp edx, 51
    jl swap_letter
    pop ebx ; pentru j
    pop edi ; pentru i
    jmp second_sort_for

second_sort_for:
    ; extrag contorul pentru al doilea for
    pop edx
    ; extrag contorul pentru primul for
    pop eax
    ; extrag length
    pop ecx
    add edx, 1
    add ebx, request_size
    ; daca edx e mai mic ca length continuam prima bulca
    cmp ecx, edx
    jg first_sort_for
    ; daca nu cresc contorul la prima bucla si continui pana cand eax < lenght - 1
    add eax, 1
    add eax, 1
    ; adaug 1 de 2 ori pentru a fi mai usor sa compar cu length dupa cscat un 1
    cmp eax, ecx
    jg end
    sub eax, 1
    mov edx, eax
    add edi, request_size
    mov ebx, edi
    jmp first_sort_for

end:
    ; repun in ebx valoarea ceruta
    xor ebx, ebx
    mov ebx, esi

    popa
    leave
    ret
