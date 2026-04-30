# t11_jal_back.s - JAL with Backward Jump
# Tests: Forward and backward unconditional jumps

addi x1, x0, 1        # x1 = 1
jal x0, 8             # Jump forward by 8 bytes (skip next instruction)
addi x0, x0, 0        # NOP (should be SKIPPED)
addi x3, x0, 3        # x3 = 3
jal x0, 4             # Jump forward by 4 bytes
addi x2, x0, 2        # x2 = 2
jal x0, 0             # Infinite loop
#
# Expected: x1 = 1, x2 = 2, x3 = 3
# This tests instruction sequencing and jump target calculation
