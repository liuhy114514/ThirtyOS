bits 16
;org 0x8000

section .data
    ; ------------gdt----------------
    ; base: 2 flags: 1 limit:1 AB:2 base:6 limit:4
    gdt:
        dq 0x0000000000000000   ; null
        dq 0x00cf9a000000ffff   ; kernal code
        dq 0x00cf92000000ffff   ; kernal data

    gdt_desc: ; gdtr
        dw gdt_desc - gdt - 1
        dd gdt
    ; ---------constants-------------

section .text
    start:
        mov ax,0
        mov es,ax
        mov ds,ax
    VGA_set:
        mov	al,0x13
		mov	ah,0x00
		int	0x10
    gdt_set:
        cli
        lgdt [gdt_desc]

        mov ax,0
        mov eax, cr0
        and eax, 0x7fffffff   ; 清 PG 位
        or	eax, 0x00000001	; bit0到1转换（保护模式过渡）
        mov cr0, eax

        jmp 0x08:_start

bits 32
section .data2
    ; ------------idt----------------
    idt:
        times (256 * 8) db 0 ; 256 个项
    idtr:
        dw (256 * 8)  - 1   ; size
        dd idt              ; base
section .text2
    _start:
        mov ax, 0x10
        mov ds, ax
        mov es, ax
        mov ss, ax
        mov esp, 0x90000 ; 设置栈顶，避免栈溢出覆盖代码或数据

        cli
        call idt_set
        lidt [idtr]

        extern _kmain
        call _kmain

        jmp $

;idt_functions
    isr0_handler:
        cli
        jmp .hang0
    .hang0:
        hlt
        jmp .hang0

    isr6_handler:
        cli
        jmp .hang1
    .hang1:
        hlt
        jmp .hang1
; idt_set
    idt_set:
        call isr0_Entry
        call isr6_Entry
        ret
    isr0_Entry:
        mov eax,isr0_handler
        mov word[idt+0*8+0], ax
        mov word[idt+0*8+2], 0x08
        mov word[idt+0*8+4], 0x00
        mov word[idt+0*8+5], 0x8e
        shr eax,16 ; 取高16位
        mov word[idt+0*8+6], ax
        ret
    isr6_Entry:
        mov eax,isr6_handler
        mov word[idt+6*8+0], ax
        mov word[idt+6*8+2], 0x08
        mov word[idt+6*8+4], 0x00
        mov word[idt+6*8+5], 0x8e
        shr eax,16 ; 取高16位
        mov word[idt+6*8+6], ax
        ret