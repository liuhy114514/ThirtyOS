global isr0_handlers

section .text
    isr0_handler:
        cli
        jmp .hang
    .hang:
        hlt
        jmp .hang