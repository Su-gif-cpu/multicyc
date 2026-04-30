# t13_shift_boundary.s - Shift Instructions Boundary Value Test
# Critical: Test shift amount = 0 and shift amount = 31
# Ensures: sll, srl, sra handle extreme shift amounts correctly

addi x1, x0, 1        # x1 = 0x00000001
addi x5, x0, 31       # x5 = 0x0000001F (shift amount = 31)

# SLL (Shift Left Logical) tests
sll x8, x1, x0        # x8 = 0x1 << 0 = 0x00000001 (shift amount 0, no change)
sll x9, x1, x5        # x9 = 0x1 << 31 = 0x80000000 (shift by 31)

# SRL (Shift Right Logical) tests
srl x10, x1, x0       # x10 = 0x1 >> 0 = 0x00000001 (shift amount 0, no change)
addi x2, x0, -1       # x2 = 0xFFFFFFFF (all 1s)
srl x11, x2, x5       # x11 = 0xFFFFFFFF >> 31 = 0x00000001 (logical shift, fill with 0)

# SRA (Shift Right Arithmetic) tests
sra x12, x1, x0       # x12 = 0x1 >> 0 = 0x00000001 (shift amount 0, no change)
sra x13, x2, x5       # x13 = 0xFFFFFFFF >> 31 (arithmetic) = 0xFFFFFFFF (fill with sign bit 1)
ori x4, x0, 0x7FFF    # x4 = 0x00007FFF (positive number)
sra x14, x4, x5       # x14 = 0x7FFF >> 31 = 0x00000000 (fill with sign bit 0)

jal x0, 0             # Infinite loop
