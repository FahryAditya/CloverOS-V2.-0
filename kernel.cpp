// kernel.cpp - ZaqiOS Kernel Advanced
extern "C" void kernel_main();

#include <stdint.h>

// VGA text mode
volatile uint16_t* VGA = (uint16_t*)0xB8000;
const int VGA_WIDTH = 80;
const int VGA_HEIGHT = 25;

// Cursor
uint8_t cursor_x = 0;
uint8_t cursor_y = 0;

// Clear screen
void clear_screen() {
    for(int i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++) {
        VGA[i] = 0x0700;
    }
    cursor_x = 0;
    cursor_y = 0;
}

// Scroll screen up by one line
void scroll() {
    for(int y = 1; y < VGA_HEIGHT; y++) {
        for(int x = 0; x < VGA_WIDTH; x++) {
            VGA[(y-1)*VGA_WIDTH + x] = VGA[y*VGA_WIDTH + x];
        }
    }
    // Clear last line
    for(int x = 0; x < VGA_WIDTH; x++) {
        VGA[(VGA_HEIGHT-1)*VGA_WIDTH + x] = 0x0700;
    }
    if(cursor_y > 0) cursor_y--;
}

// Print character
void put_char(char c, uint8_t color = 0x07) {
    if(c == '\n') {
        cursor_x = 0;
        cursor_y++;
    } else if(c == '\b') { // backspace
        if(cursor_x > 0) cursor_x--;
        VGA[cursor_y*VGA_WIDTH + cursor_x] = 0x0700;
    } else {
        VGA[cursor_y*VGA_WIDTH + cursor_x] = (color << 8) | c;
        cursor_x++;
        if(cursor_x >= VGA_WIDTH) {
            cursor_x = 0;
            cursor_y++;
        }
    }
    if(cursor_y >= VGA_HEIGHT) scroll();
}

// Print string
void print(const char* str, uint8_t color = 0x07) {
    for(int i=0; str[i]!='\0'; i++) {
        put_char(str[i], color);
    }
}

// Keyboard polling (simplified)
char get_key() {
    volatile uint8_t* kb = (uint8_t*)0x60;
    uint8_t scancode = 0;
    while(1) {
        scancode = *kb;
        if(scancode != 0) break;
    }
    // Map A-Z (placeholder)
    if(scancode >= 0x1E && scancode <= 0x26) return 'A' + scancode - 0x1E;
    if(scancode >= 0x02 && scancode <= 0x0B) return '0' + scancode - 0x02; // numbers
    if(scancode == 0x1C) return '\n'; // Enter
    if(scancode == 0x0E) return '\b'; // Backspace
    return '?';
}

// Read line input
void read_line(char* buffer, int max_len) {
    int idx = 0;
    while(1) {
        char c = get_key();
        if(c == '\n') {
            put_char(c);
            buffer[idx] = 0;
            break;
        } else if(c == '\b') {
            if(idx > 0) {
                idx--;
                put_char(c);
            }
        } else {
            if(idx < max_len - 1) {
                buffer[idx++] = c;
                put_char(c);
            }
        }
    }
}

// Simple command processing
void process_command(char* cmd) {
    if(strcmp(cmd, "help") == 0) {
        print("Available commands: help, version, clear\n", 0x0B);
    } else if(strcmp(cmd, "version") == 0) {
        print("ZaqiOS v0.1 - Minimal Kernel Demo\n", 0x0A);
    } else if(strcmp(cmd, "clear") == 0) {
        clear_screen();
    } else {
        print("Unknown command\n", 0x0C);
    }
}

// strcmp sederhana
int strcmp(const char* a, const char* b) {
    int i = 0;
    while(a[i] && b[i]) {
        if(a[i] != b[i]) return 1;
        i++;
    }
    return a[i] != b[i];
}

// Kernel main
extern "C" void kernel_main() {
    clear_screen();
    print("Welcome to ZaqiOS Advanced Kernel!\n", 0x0A);
    print("Type 'help' for commands.\n\n", 0x0B);

    char input[128];

    while(1) {
        print("> ", 0x0E);
        read_line(input, 128);
        process_command(input);
    }
}
