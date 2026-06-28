    bits 16
    org 0x7c00

    start:
        mov ax,0
        mov ss,ax
        mov sp,0x7c00
        mov ds,ax
        mov es,ax
        call Read ; 读扇区，为内核做准备

        jmp 0x0800:0x0000
    print:
        mov al,[si]
        cmp al,0
        je end
        mov ah,0x0e
        int 0x10
        inc si
        jmp print
    end:
        ret
    Read:
        mov ah,0x02
        mov al,60
        mov ch,0
        mov cl,2
        mov dh,0
        mov dl,0
        mov bx,0x0800
        mov es,bx
        mov bx,0

        int 0x13

        jc error

        mov si,OK
        call print
        ret
    error:
        mov si,Error_Text
        call print
        jmp $

OK db "Done!",0x0d,0x0a,0
Error_Text db "Disk Error!",0x0d,0x0a,0
times 510-($-$$) db 0
dw 0xAA55