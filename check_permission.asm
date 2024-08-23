%include "../include/io.mac"

extern ant_permissions

extern printf
global check_permission

section .text

check_permission:

    push    ebp
    mov     ebp, esp
    pusha

    mov     eax, [ebp + 8]  ; id and permission
    mov     ebx, [ebp + 12] ; address to return the result

    


    mov ecx, eax 
    ; calculez id -ul furnicii , shiftand la dreapta
    shr ecx , 24
    mov edx, eax
    ; salvez cei cei 24 de biti necesarii pentru rezervarea unei salii
    and edx, 0xFFFFFF
    ; presupun ca furnica poate sa ocupe toate salile
    mov eax, 1
    ; calculez unde incep permisiunile furnici in vectorul ant_permision
    ; si le pun in registrul esi
    mov esi,[ ant_permissions + 4 * ecx ]
    ; folosesc drept contor registrul ecx
    mov ecx, 24

check_biti:
    test edx , 1 
    jz remove_bit
    ; daca bitul este 1 verific sa fie 1 si in ant_permision
    test esi, 1  ; testăm permisiunea pentru sala corespunzătoare bitului
    jz room_not_good ; dacă bitul este 0, furnica nu are permisiunea
    jmp remove_bit ; furnica are permisiunea pentru sala respectivă

remove_bit:
    ; elimin ultimul bit din fiecare numar
    shr edx, 1
    shr esi, 1
    sub ecx, 1
    cmp ecx, 0
    jg check_biti
    jmp end

room_not_good:
    mov eax , 0
end:
    mov [ebx], eax 

    


    popa
    leave
    ret
    

