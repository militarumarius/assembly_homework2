%include "../include/io.mac"

extern printf
extern position
global solve_labyrinth

; you can declare any helper variables in .data or .bss

section .text

; void solve_labyrinth(int *out_line, int *out_col, int m, int n, char **labyrinth);
solve_labyrinth:

    push    ebp
    mov     ebp, esp
    pusha

    mov     eax, [ebp + 8]  ; unsigned int *out_line, pointer to structure containing exit position
    mov     ebx, [ebp + 12] ; unsigned int *out_col, pointer to structure containing exit position
    mov     ecx, [ebp + 16] ; unsigned int m, number of lines in the labyrinth
    mov     edx, [ebp + 20] ; unsigned int n, number of colons in the labyrinth
    mov     esi, [ebp + 24] ; char **a, matrix represantation of the labyrinth


    ; decrementez fiecare dimensiune pentru a ma opri la m-1 sau n-1
    sub ecx, 1
    sub edx, 1
    push eax ; pun pe stiva adresa out_col
    push ebx ; pun pe stiva adresa out_line
    xor eax, eax ; indiciele i din matrice , adica linia
    xor ebx, ebx ; indicele j din matrice , adica coloana    

labyrinth_loop:
    ; marchez prima pzitie cu 1 drept zid
    mov edx , [esi + 4  * eax] ; pun in edx adresa liniei curente
    mov byte[edx + ebx], 0x39
    mov edx , [esi + 4  * eax] ; pun in edx adresa liniei curente
    ; verirfic sa fi ajung la iesirea din labirind
    cmp eax, ecx
    je end_labyrinth
    cmp ebx, edx
    je end_labyrinth
    ; verific daca poate sa se deplaseze la stanga
    cmp byte[edx + ebx + 1], 0x30
    je move_right
    ; verific daca se poate deplasa jos
    mov edx , [esi + 4  * (eax + 1)] ; pun in edx adresa liniei de jos
    cmp byte[edx + ebx], 0x30
    je move_down
    ; verific daca se poate deplasa la stanga
    mov edx , [esi + 4  * eax] ; pun in edx adresa liniei curente
    cmp byte[edx + ebx - 1], 0x30
    je move_left
    ; verific daca se poate deplasa in sus
    test eax, eax ; verifica daca eax este 0
    ; daca e 0 ma aflu in varful labirindului si nu pot sa ma deplasez in sus
    jz end_labyrinth   
    mov edx , [esi + 4  * (eax - 1)] ; pun in edx adresa liniei de sus
    cmp byte[edx + ebx], 0x30
    je move_up
    ; daca nu se poate deplasa in nicio directie, inseamna ca a ajuns la final
    jmp end_labyrinth
move_right:
    ; adaug 1 in coeficientul j al coloanei pentru a ma deplasa la dreapta
    add ebx, 1
    ; compar cu dimensiunea sa nu fi ajuns la capat
    cmp ebx, edx
    jne labyrinth_loop
    je end_labyrinth

move_down:
    ; adaug 1 in coeficientul i al liniei pentru a ma deplasa in jos
    add eax, 1
    ; compar cu dimensiunea sa nu fi ajuns la capat
    cmp eax, ecx
    jne labyrinth_loop
    je end_labyrinth

move_left:
    ; adaug 1 in coeficientul j al coloanei pentru a ma deplasa la stanga
    sub ebx, 1
    ; compar cu dimensiunea sa nu fi ajuns la capat
    cmp ebx, edx
    jne labyrinth_loop
    je end_labyrinth

move_up:
    ; adaug 1 in coeficientul i al liniei pentru a ma deplasa in sus
    sub eax, 1
    ; compar cu dimensiunea sa nu fi ajuns la capat
    cmp eax, ecx
    jne labyrinth_loop
    je end_labyrinth

end_labyrinth:
    mov ecx, eax
    mov edx, ebx
    ; scot de pe stiva adresele lui eax si ebx unde trebuia sa salvez rezultatul
    pop ebx
    pop eax
    ; pun rezultatul la final
    mov [eax], ecx
    mov [ebx], edx

end:

    popa
    leave
    ret
    

