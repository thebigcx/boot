.code16

    # Reload CS register
    ljmp $0x0, $entry
entry:
    # Set up stack
    movl $0x7c00, %esp

    # Read the rest of the loader
    movw $dap, %si
    movb $0x42, %ah
    movb $0x80, %dl
    int $0x13

.data
# Disk Access Packet
dap:
    .byte 0x0010 # Size of DAP
    .byte 0x0000 # Unused
    .word 0x0001 # Sector count
    .word 0x7e00 # Buffer offset
    .word 0x0000 # Buffer segment
    .quad 0x0001 # LBA

.text

    # Load A20
    inb $0x92, %al
    orb $0x2, %al
    outb %al, $0x92

    # Switch to unreal mode
    jmp 0x7e00

loop: jmp loop
