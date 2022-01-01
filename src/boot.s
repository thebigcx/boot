.code16
main:
    movw $string, %bx
    call puts

    # Find kernel

loop:
    jmp loop

string:
    .string "Loading kernel...\r\n"
