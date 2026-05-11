bits 16
org 0x7c00

start:
    mov si,msg;
    jmp print
print:
    mov ax,[si]
    cmp ax,0
    je fin
    mov ah,0x0E
    int 0x10
    inc si
    jmp print

fin:
    hlt
    jmp fin

msg db "Hello World!",0

times 510 - ($ - $$) db 0
dw 0xAA55