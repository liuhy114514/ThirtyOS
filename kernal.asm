    bits 16
    org 0x8000

    start:
        mov ax,0x0800
        mov ds,ax
        mov es,ax
        mov ss,ax
        mov sp,0xB000

        mov si,Msg
        call print

        jmp $
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

Msg db "This is Kernal!",0