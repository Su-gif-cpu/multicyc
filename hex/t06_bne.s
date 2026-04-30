# t06_bne.s - BNE (Branch if Not Equal)
# Tests: Branch taken when rs1 != rs2

addi x1, x0, 1        # x1 = 1
addi x2, x0, 2        # x2 = 2 (x1 != x2)
bne x1, x2, 8         # x1 != x2, so branch is TAKEN
addi x6, x0, 0x11     # x6 = 0x11 (should be SKIPPED)
addi x6, x0, 0x22     # x6 = 0x22 (branch target)
addi x9, x0, 0x33     # x9 = 0x33
addi x10, x0, 1       # x10 = 1
jal x0, 0             # Infinite loop
