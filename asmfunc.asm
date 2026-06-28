bits 32

global _io_hlt
global _io_cli,_io_sti,_io_stihlt
global _io_in8,_io_in16,_io_in32
global _io_out8,_io_out16,_io_out32
global _load_eflags, _store_eflags

section .text

_io_hlt:
    hlt
    ret

_io_cli:
    cli
    ret

_io_sti:
    sti
    ret

_io_stihlt:
    sti
    hlt
    ret

_io_in8:
    mov edx,[esp+4]
    mov eax,0
    in al,dx
    ret

_io_in16:
    mov edx,[esp+4]
    mov eax,0
    in ax,dx
    ret

_io_in32:
    mov edx,[esp+4]
    mov eax,0
    in eax,dx
    ret

_io_out8:
    mov edx,[esp+4]
    mov al,[esp+8]
    out dx,al
    ret

_io_out16:
    mov edx,[esp+4]
    mov eax,[esp+8]
    out dx,ax
    ret

_io_out32:
    mov edx,[esp+4]
    mov eax,[esp+8]
    out dx,eax
    ret

_load_eflags:
    pushfd
    pop eax
    ret

_store_eflags:
    mov eax,[esp+4]
    push eax
    popfd
    ret

_write_mem8:
    mov ecx,[esp+4]
    mov al,[esp+8]
    mov [ecx],al
    ret