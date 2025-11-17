; kernel_entry.asm - Entry point dari bootloader ke kernel C++
[BITS 32]
[GLOBAL kmain]

extern kernel_main      ; deklarasi fungsi C++

kmain:
    cli                 ; matikan interrupt sementara

    ; --- Setup Stack 32-bit ---
    mov eax, 0x9FC00    ; alamat stack (bisa diubah)
    mov esp, eax

    ; --- Segment Register ---
    mov ax, 0x10        ; data segment selector (dari GDT, minimal)
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    sti                 ; enable interrupt

    ; --- Panggil Kernel C++ ---
    call kernel_main

hang:
    hlt                 ; hentikan CPU
    jmp hang            ; infinite loop
