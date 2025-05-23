org 100h
section .data
    komunikat db "Wprowadz ciag znakow: $"
    koniec db "Program zakonczony. $"
    newline db 13, 10, 36
    input db 100                 ; Bufor na wczytany tekst, max 100 znaków
    input_length db 0            

section .text
   	xor ax,ax  ; Czyszczenie rejestrów
	xor bx,bx
	xor cx,cx
	xor dx,dx

main:
    call wczytaj        

    cmp byte [input+1], 0    ; Drugi bajt inputu ([input+1]) zawiera ilosc znakow wpisanych przez uzytkownika
    je main          	     ; Jeśli jest =0 to wracamy do głównej pętli, czyli znowu wczytujemy dane

    cmp byte [input+2], '+'  ; Sprawdzanie czy pierwszym znakiem inputu jest '+'
    je koniec_programu       ; Jeśli tak to kończy program

    call wypisz_newline

    call przetworz_dane      ; Przetwórz dane i wypisz wynik
    call wypisz_newline   

    jmp main         


wczytaj:
    mov ah, 9                
    mov dx, komunikat
    int 21h

    mov ah, 10               
    mov dx, input
    int 21h

    mov al, [input+1]
    mov [input_length], al
    ret


sprawdz_dane:
    mov cl, [input_length]   ; Ładujemy długość wprowadzonego ciągu
    
    cmp cl, 0
    je przetworzono

    mov si, input
    add si, 2	; Wskaźnik na pierwszy znak w buforze


przetwarzanie:
    mov al, [si]             ; Załaduj znak
    cmp al, 0                ; Sprawdź, czy to koniec ciągu
    je przetworzono

    cmp al, 'A'              
    jl nie_litera
    cmp al, 'Z'
    jle litera
    cmp al, 'a'
    jl nie_litera
    cmp al, 'z'
    jg nie_litera


litera:
    mov al, ' '              
    call wypisz_znak

    mov al, [si]
    call wypisz_znak

    mov al, ' '              
    call wypisz_znak
    jmp nastepny_znak


nie_litera:
    mov al, [si]
    call wypisz_znak


nastepny_znak:
    inc si                    ; Pętla która nam przechodzi po znakach
    loop przetwarzanie       


przetworzono:
    ret


wypisz_znak:
    mov ah, 2               
    mov dl, al
    int 21h
    ret


wypisz_newline:
    mov ah, 9                
    mov dx, newline
    int 21h
    ret


koniec_programu:
    mov dx, koniec
    mov ah, 9 
    int 21h                  

    mov ah, 4Ch
    int 21h                  
