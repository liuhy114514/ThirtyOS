bits 16
    org 0x8000

    start:
        mov si,Msg
        call print

        cli
        lgdt [gdt_desc]
        
        mov eax,cr0
        or eax,1
        mov cr0,eax

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

Msg db "This is Kernal!",0x0d,0x0a,0

; base: 2 flags: 1 limit:1 AB:2 base:6 limit:4
gdt:
    dq 0x0000000000000000 ; null
    dq 0x00cf9a000000ffff ; kernal code
    dq 0x00cf92000000ffff ; kernal data
    dq 0x00cffa000000ffff ; user code
    dq 0x00cff2000000ffff ; user data

gdt_desc: ; gdtr
    dw gdt_desc - gdt - 1
    dd gdt