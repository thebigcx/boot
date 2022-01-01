    .code16
    .section .boot

    jmp skip_bpb

    .skip 0x3c

skip_bpb:
    # Reload CS register
    ljmp $0x0, $entry

entry:
    # Set up segment registers
    xorw %ax, %ax
    movw %ax, %ds
    movw %ax, %ss

    # Set up stack
    movw $0x7c00, %sp

    # Read the rest of the loader
    movw $dap, %si
    movb $0x42, %ah
    movb $0x80, %dl
    int $0x13

    # Print message
    movw $str, %bx
    call puts   
 
    # Load A20
    inb $0x92, %al
    orb $0x2, %al
    outb %al, $0x92

    # Switch to unreal mode
    cli
    push %ds

    lgdt (gdtptr)

    movl %cr0, %eax # Enable pmode
    orb $1, %al
    movl %eax, %cr0

    jmp unreal

unreal:   
    movw $0x08, %bx
    movw %bx, %ds
  
    andb $~1, %al # Disable pmode
    movl %eax, %cr0

    pop %ds
    sti

    # Jump to second stage
    jmp 0x7e00

# puts: bx = string
    .global puts
puts:
    push %bx
    movb $0xe, %ah

nextc:
    movb (%bx), %al
    cmpb $0, %al
    jz end
    int $0x10
    inc %bx
    jmp nextc
end:
    pop %bx
    ret

str:
    .string "Loading stage 2...\r\n"

# Disk Access Packet
dap:
    .byte 0x0010 # Size of DAP
    .byte 0x0000 # Unused
    .word 0x0001 # Sector count
    .word 0x7e00 # Buffer offset
    .word 0x0000 # Buffer segment
    .quad 0x0001 # LBA

gdtptr:
    .word gdtend - gdt - 1
    .long gdt

gdt:
    .long 0, 0
    .byte 0xff, 0xff, 0, 0, 0, 0b10010010, 0b11001111, 0
gdtend:

    .org 0x1fe
    .byte 0x55
    .byte 0xaa

stage2:
    movw $string, %bx
    call puts
    
loop:
    jmp loop

string:
    .string "Loading kernel...\r\n"
