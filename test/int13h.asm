    bits 16
    org 0x7c00

    start:
        mov si,msg
        mov ah,0x02
        mov al,3
        mov ch,0
        mov cl,1
        mov dh,0
        mov dl,0
        int 0x13
        jc print
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

    msg db "Disk Error!",0

    times 510 - ($ - $$) db 0
    dw 0xAA55