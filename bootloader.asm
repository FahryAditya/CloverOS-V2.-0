; bootloader.asm - Bootloader Lengkap Dasar OS
[BITS 16]
[ORG 0x7C00]

start:
    cli                     ; matikan interrupt sementara

    ; Setup segment register
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00          ; stack di atas bootloader

    ; Setup data segment tambahan
    mov ax, 0x9000
    mov fs, ax
    mov gs, ax

    sti                     ; enable interrupt

    ; Tampilkan pesan booting dengan warna
    mov si, boot_msg
print_char:
    lodsb                   ; load byte dari DS:SI ke AL
    cmp al, 0
    je done_msg
    mov ah, 0x0E            ; teletype output
    int 0x10
    jmp print_char
done_msg:

    ; Tambahkan garis pemisah
    mov si, line
print_line:
    lodsb
    cmp al, 0
    je done_line
    mov ah, 0x0E
    int 0x10
    jmp print_line
done_line:

    ; Placeholder untuk load kernel
    ; nanti bisa diganti dengan load dari disk
    mov si, kernel_msg
print_kernel:
    lodsb
    cmp al, 0
    je wait_loop
    mov ah, 0x0E
    int 0x10
    jmp print_kernel

wait_loop:
    ; Infinite loop sambil menunggu kernel
    hlt
    jmp wait_loop

; --- Data ---
boot_msg db "==============================", 0
boot_msg2 db "Welcome to My Simple OS Bootloader!", 0
line db "==============================", 0
kernel_msg db "Loading kernel... (not implemented)", 0

; Padding hingga 510 byte
times 510-($-$$) db 0

; Boot signature
dw 0xAA55
