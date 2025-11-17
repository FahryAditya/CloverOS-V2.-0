/* linker.ld - ZaqiOS Kernel Linker Script (Advanced) */

/* Output format: 32-bit ELF untuk x86 */
OUTPUT_FORMAT("elf32-i386")
ENTRY(kmain)  /* Entry point kernel */

/* Load kernel di alamat 0x1000 */
SECTIONS
{
    /* ================= Text Segment ================= */
    /* Kode program (executable) */
    . = 0x1000;
    .text : {
        *(.text)           /* semua .text dari object files */
        *(.text.*)         /* semua sub-segment text */
    }

    /* ================= Read-only Data ================= */
    /* Konstanta seperti string, pesan */
    .rodata : {
        *(.rodata)
        *(.rodata.*)
    }

    /* ================= Data Segment ================= */
    /* Data terinisialisasi */
    .data : {
        __data_start = .;
        *(.data)
        *(.data.*)
        __data_end = .;
    }

    /* ================= BSS Segment ================= */
    /* Data nol-inisialisasi */
    .bss : {
        __bss_start = .;
        *(.bss)
        *(.bss.*)
        __bss_end = .;
    }

    /* ================= Stack Segment ================= */
    /* Stack kernel (ukuran 16 KB) */
    .stack (NOLOAD) : {
        __stack_start = .;
        . += 0x4000;        /* 16 KB stack */
        __stack_end = .;
    }

    /* ================= End of Kernel ================= */
    /DISCARD/ : { *(.comment) *(.note*) *(.eh_frame*) }
}
