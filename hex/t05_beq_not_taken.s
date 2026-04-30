# t05_beq_not_taken.s - BEQ (Branch if Equal) - Condition NOT Satisfied
# Tests: Sequential execution when rs1 != rs2

addi x1, x0, 1        # x1 = 1
addi x2, x0, 2        # x2 = 2 (x1 != x2)
beq x1, x2, 8         # x1 != x2, so branch is NOT TAKEN, continue sequence
ori x3, x0, 0x99      # x3 = 0x99 (should execute)
addi x5, x0, 1        # x5 = 1
jal x0, 0             # Infinite loop
