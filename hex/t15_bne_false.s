# t15_bne_false.s - BNE (Branch if Not Equal) - Condition NOT Satisfied
# Complements t06_bne.s by testing the reverse condition
# Tests: Sequential execution when rs1 == rs2 (no branch)

addi x1, x0, 0x55     # x1 = 0x55
addi x2, x0, 0x55     # x2 = 0x55 (x1 == x2)
bne x1, x2, 12        # x1 == x2, so BNE is NOT taken (continue sequence)
addi x5, x0, 0xAA     # x5 = 0xAA (should execute because condition is false)
ori x6, x0, 0x11      # x6 = 0x11 (should also execute)

addi x3, x0, 0        # x3 = 0
addi x4, x0, 0        # x4 = 0 (x3 == x4)
bne x3, x4, 12        # x3 == x4, so BNE is NOT taken (continue sequence)
addi x7, x0, 0x77     # x7 = 0x77 (should execute)
ori x8, x0, 0x88      # x8 = 0x88 (should also execute)

jal x0, 0             # Infinite loop
#
# Expected Results:
# x5 = 0xAA (first BNE not taken)
# x6 = 0x11 (first BNE not taken)
# x7 = 0x77 (second BNE not taken)
# x8 = 0x88 (second BNE not taken)
