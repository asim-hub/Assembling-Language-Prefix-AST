%include "includes/io.inc"

extern getAST
extern freeAST

section .data
op1: dd 0xF4241
op2: dd 0xF4242
op3: dd 0xF4243
op4: dd 0xF4244
myVect:    times 100000    dd 0
myVect1:    times 100000    dd 0
section .bss
    ; La aceasta adresa, scheletul stocheaza radacina arborelui
    root: resd 1

section .text
    
global main
main:
    
    mov ebp, esp; for correct debugging
    ; NU MODIFICATI
    push ebp
    mov ebp, esp 
    ; Se citeste arborele si se scrie la adresa indicata mai sus
    call getAST
    mov [root], eax
    ; Implementati rezolvarea aici:
    ; dimensiunea vectorului in care voi pune informatia din noduri
    mov esi,0
    mov eax, [root]
    xor ecx,ecx
    ; parcurg arborele pana la cel mai din stanga nod
travers:
    push eax
    mov  eax,[eax+4]
    mov ebx,[eax]
    xor edx,edx
    mov dl,'/'
    cmp [ebx],edx
    je travers
    xor edx,edx
    mov dl,'+'
    cmp [ebx],edx
    je travers
    xor edx,edx
    mov dl,'*'
    cmp [ebx],edx
    je travers
    xor edx,edx
    mov dl,'-'
    cmp [ebx],edx
    je travers
    ; adaug in vector copilul stang al nodului curent
travers2:
    mov ebx,[eax]
    xor edx,edx
    mov dword [myVect + 4*esi],ebx
    inc esi
    xor edx,edx
    mov edx,[root]
    mov edx,[edx+4]
    ; verific daca sunt in dreapta root-ului
    cmp edx,eax
    je travers3
    xor edx,edx
    mov edx,[root]
    mov edx,[edx+8]
    cmp edx,eax
    je exit
    xor edx,edx
    mov edx,[root]
    cmp edx,eax
    je END
travers3:
    pop eax
    ; ma deplasesz in copilul drept    
travers1:
    push eax
    mov eax,[eax+8]
    ; verific daca e operator, iar daca este ma voi deplasa 
    ; in cel mai din stanga copil
    mov ebx,[eax]
    xor edx,edx
    mov dl,'/'
    cmp [ebx],edx
    je travers
    xor edx,edx
    mov dl,'+'
    cmp [ebx],edx
    je travers
    xor edx,edx
    mov dl,'*'
    cmp [ebx],edx
    je travers
    xor edx,edx
    mov dl,'-'
    cmp [ebx],edx
    je travers
    xor ebx,ebx
    mov ebx,[eax]
    ;adaug copilul ,care este cu siguranta un operand, in vector 
    xor edx,edx
    mov dword [myVect + 4*esi],ebx
    inc esi
    ; scot din stiva ultimul nod din care am venit
    pop eax
    mov ecx,[eax]
    xor ebx,ebx
    mov ebx,[eax]
    ; adaug operatorul in vector
    xor edx,edx
    mov dword [myVect + 4*esi],ebx
    inc esi
    ;daca m-am intors in root din subarborele drept 
    ;am terminat parcurgerea
    cmp [root],eax
    je END
    ; altfel nu am ajuns in root si scot din stiva adresa
    ; ultimului nod din care am venit
    pop eax
    xor ebx,ebx
    ; ma duc in copilul drept al nodului scos din stiva 
    mov ebx,[eax+8]
    cmp ecx,[ebx]
    ; daca e operand il adaug in vector
    je travers2
    ; altfel inseamna ca e oprator si ma voi deplasa la stanga lui
    xor ebx,ebx
    mov ebx,[eax]
    xor edx,edx
    mov dl,'/'
    cmp [ebx],edx
    je travers1
    xor edx,edx
    mov dl,'+'
    cmp [ebx],edx
    je travers1
    xor edx,edx
    mov dl,'*'
    cmp [ebx],edx
    je travers1
    xor edx,edx
    mov dl,'-'
    cmp [ebx],edx
    je travers1
    ; adaug radacina in vector
exit:
    pop eax
    xor ebx,ebx
    mov ebx,[eax]
    xor edx,edx
    mov dword [myVect + 4*esi],ebx
    inc esi
END: 
    mov ecx,0
    ; dimensiune vector
    mov edi,esi
    xor esi,esi
    ; conversia vectorului obtinut prin parcurgerea SDR
repeat:
    mov eax, [myVect + 4*ecx]
    ; verific daca e operator
    xor edx,edx
    mov dl,'+'
    cmp [eax],edx
    je ad1
    xor edx,edx
    mov dl,'-'
    cmp [eax],edx
    je ad2
    xor edx,edx
    mov dl,'*'
    cmp [eax],edx
    je ad3
    xor edx,edx
    mov dl,'/'
    cmp [eax],edx
    je ad4
    ; daca am ajuns pana aici elementul curent din vector e operand
    xor esi,esi
    ; aici pun rezultatul conversiei
    xor edx,edx
    xor ebx,ebx
    mov edx,0
    mov esi,1
    ; fac conversia sirului de caractere
convert:
    movzx ebx,byte [eax]
    cmp ebx,0
    je done 
    cmp ebx,45
    je cont
    sub ebx,48
    imul edx,10
    add edx,ebx
    inc eax
    jmp convert
cont:
    ; daca primul chiar e '-' retin asta in esi
    mov esi,-1
    inc eax
    jmp convert
    ; in cazul in care pe pozitia curenta din vector nu am operand, ci operator                
ad1:
    xor edx,edx
    mov edx,[op1]
    mov [myVect1 + 4*ecx],edx
    inc ecx
    cmp ecx,edi
    jl repeat
    jmp FINAL
ad2:
    xor edx,edx
    mov edx,[op2]
    mov [myVect1 + 4*ecx],edx
    inc ecx
    cmp ecx,edi
    jl repeat
    jmp FINAL
ad3:
    xor edx,edx
    mov edx,[op3]
    mov [myVect1 + 4*ecx],edx
    inc ecx
    cmp ecx,edi
    jl repeat
    jmp FINAL
ad4:
    xor edx,edx
    mov edx,[op4]
    mov [myVect1 + 4*ecx],edx
    inc ecx
    cmp ecx,edi
    jl repeat
    jmp FINAL
    ; imi formez numarul negativ
done:
    imul edx,esi
    mov dword  [myVect1 + 4*ecx],edx
    inc ecx
    cmp ecx,edi
    jl repeat
    ; parcurg vectorul de intregi si caut operator 
FINAL:
    xor ecx,ecx
    mov ecx,0
    jmp calculeaza
calculeaza2:
    inc ecx
calculeaza1:
    inc ecx
    inc ecx
calculeaza:
    mov dword eax, [myVect1 + 4*ecx]
    cmp dword eax,[op1]
    je back
    cmp dword eax,[op2]
    je back
    cmp dword eax,[op3]
    je back
    cmp dword eax,[op4]
    je back
    inc ecx
    cmp ecx,edi
    jl calculeaza
    jmp finl
    ; daca gasesc operator,verific daca cu doua pozitii in urma
    ; se afla doi operanzi 
back:
    dec ecx
    mov dword edx,[myVect1 + 4*ecx]
    cmp edx,[op1]
    je calculeaza1
    cmp edx,[op2]
    je calculeaza1
    cmp edx,[op3]
    je calculeaza1
    cmp edx,[op4]
    je calculeaza1
    dec ecx 
    mov ebx,[myVect1 + 4*ecx]
    cmp ebx,[op1]
    je calculeaza2
    cmp ebx,[op2]
    je calculeaza2
    cmp ebx,[op3]
    je calculeaza2
    cmp ebx,[op4]
    je calculeaza2
    ; daca am doi operanzi fac operatia corespunzatoare in ebx
    cmp dword eax,[op1]
    je operation1
    cmp dword eax,[op2]
    je operation2
    cmp dword eax,[op3]
    je operation3
    cmp dword eax,[op4]
    je operation4
    ; cele patru cazuri de operatie
operation1:
    add ebx,edx
    ; aici formez noul vector dupa efectuarea operatiei
    ; inlocuiesc al doilea numar de dinaintea operatiei
    ; cu rezultatul operatiei
    mov dword [myVect1 + 4*ecx],ebx
    ; sterg din vector operatia si numarul de dinaintea ei
    ; si scad dimensiunea lui cu 2 
    dec edi
    inc ecx
    mov edx,ecx
shift1:
    push esi
    xor esi,esi
    mov dword esi,[myVect1 + 4*ecx +4]
    mov dword [myVect1 + 4*ecx],esi
    pop esi
    inc ecx
    cmp ecx,edi
    jl shift1
    mov ecx,edx
shift2:
    push esi
    xor esi,esi
    mov dword esi,[myVect1 + 4*ecx +4]
    mov dword [myVect1 + 4*ecx],esi
    pop esi
    inc ecx
    cmp ecx,edi
    jl shift2
    dec edi  
    mov ecx,0
    cmp edi,0
    jg calculeaza
    jmp finl
    ; la fel ca la prima operatie 
operation2:
    sub ebx,edx
    mov dword [myVect1 + 4*ecx],ebx
    dec edi
    inc ecx
    mov edx,ecx
shift3:
    push esi
    xor esi,esi
    mov dword esi,[myVect1 + 4*ecx +4]
    mov dword [myVect1 + 4*ecx],esi
    pop esi
    inc ecx
    cmp ecx,edi
    jl shift3
    dec edi
    mov ecx,edx
shift4:
    push esi
    xor esi,esi
    mov dword esi,[myVect1 + 4*ecx +4]
    mov dword [myVect1 + 4*ecx],esi
    pop esi
    inc ecx
    cmp ecx,edi
    jl shift4
    mov ecx,0
    jmp calculeaza
    ; la fel ca la prima operatie
operation3:
    imul ebx,edx
    mov dword [myVect1 + 4*ecx],ebx
    dec edi
    inc ecx
    mov edx,ecx
shift5:
    push esi
    xor esi,esi
    mov dword esi,[myVect1 + 4*ecx +4]
    mov dword [myVect1 + 4*ecx],esi
    pop esi
    inc ecx
    cmp ecx,edi
    jl shift5
    dec edi
    mov ecx,edx
shift6:
    push esi
    xor esi,esi
    mov dword esi,[myVect1 + 4*ecx +4]
    mov dword [myVect1 + 4*ecx],esi
    pop esi
    inc ecx
    cmp ecx,edi
    jl shift6
    mov ecx,0
    cmp edi,0
    jg calculeaza
    jmp finl
    ; la fel ca la prima operatie
    ; si verific daca deimpartitul e negativ
    ; iar daca e negativ inmultesc deimpartitul
    ; si impartitorul cu -1
operation4:
    xchg ebx,edx
    push eax
    xor eax,eax
    mov eax,edx
    cmp eax,0
    jl neg
    jmp aa
neg:
    imul eax,-1
    imul ebx,-1
aa:
    xor edx,edx
    idiv dword ebx
    mov dword [myVect1 + 4*ecx],eax
    xor eax,eax
    pop eax
    dec edi
    inc ecx
    xor edx,edx
    mov edx,ecx
shift7:
    push esi
    xor esi,esi
    mov dword esi,[myVect1 + 4*ecx +4]
    mov dword [myVect1 + 4*ecx],esi
    pop esi
    inc ecx
    cmp ecx,edi
    jl shift7
    dec edi
    mov ecx,edx
shift8:
    push esi
    xor esi,esi
    mov dword esi,[myVect1 + 4*ecx +4]
    mov dword [myVect1 + 4*ecx],esi
    pop esi
    inc ecx
    cmp ecx,edi
    jl shift8
    mov ecx,0
    jmp calculeaza
    ; afisez rezultatul care se afla pe prima pozitie din vector
finl:
    PRINT_DEC 4,[myVect1]
    ; NU MODIFICATI
    ; Se elibereaza memoria alocata pentru arbore
    push dword [root]
    call freeAST
    
    xor eax, eax
    leave
    ret