# t01_ralu.s - Register ALU Operations Test
# Tests: add, sub, and, or, xor, sll, srl, sra

addi x1, x0, 5        # x1 = 5
addi x2, x0, 3        # x2 = 3
add x3, x1, x2        # x3 = 5 + 3 = 8
sub x4, x1, x2        # x4 = 5 - 3 = 2
and x5, x1, x2        # x5 = 5 & 3 = 0x1
or x6, x1, x2         # x6 = 5 | 3 = 0x7
xor x7, x1, x2        # x7 = 5 ^ 3 = 0x6
addi x8, x0, 4        # x8 = 4 (shift amount)
sll x9, x1, x8        # x9 = 5 << 4 = 0x50
addi x10, x0, 0x80    # x10 = 0x80 = 128
srl x11, x10, x8      # x11 = 0x80 >> 4 = 0x8
sra x12, x10, x8      # x12 = 0x80 >> 4 (arithmetic) = 0x8
ori x14, x0, -4096    # x14 = 0xFFFFF000 (12-bit imm: 0xF00 = -0x100)
sll x14, x14, x8      # x14 = 0xFFFFF000 << 4 = 0xFFFF0000
sra x15, x14, x8      # x15 = 0xFFFF0000 >> 4 (arithmetic) = 0xFFFFF000
jal x0, 0             # Infinite loop
