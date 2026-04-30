# t09_x0.s - x0 (Zero Register) Test
# Critical: x0 must ALWAYS be 0, regardless of write attempts
# Tests: Register File hardwired zero constraint

addi x0, x0, -1       # Attempt to write -1 to x0 (should have NO EFFECT)
addi x0, x0, -1       # Attempt again (should still be 0)
addi x1, x0, 0x55     # x1 = 0x55 (read from x0, which should be 0, so x1 = 0x55)
jal x0, 0             # Infinite loop
# 
# Expected: x0 remains 0x00000000 after all attempts
# This tests that the Register File either:
#   1. Has hardwired x0 to 0 (no write port for x0)
#   2. Has write logic that checks if rd==0 and skips write
