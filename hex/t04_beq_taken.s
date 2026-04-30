# t04_beq_taken.s - BEQ (Branch if Equal) - Condition Satisfied
# Tests: Branch taken when rs1 == rs2

addi x3, x0, 0        # x3 = 0 (initialize)
addi x1, x0, 5        # x1 = 5
addi x2, x0, 5        # x2 = 5 (x1 == x2)
beq x1, x2, 8         # x1 == x2, so branch is TAKEN, jump by 8 bytes (skip next instr)
ori x3, x0, 0xbad     # x3 = 0xBAD (should be SKIPPED)
addi x4, x0, 1        # x4 = 1 (branch target, should execute)
jal x0, 0             # Infinite loop
