# t02_itype.s - Immediate Type Instructions Test
# Critical: Sign Extension Test

addi x1, x0, -1       # x1 = 0xFFFFFFFF (12-bit immediate -1 sign-extended to 32-bit)
# This tests the Sign Extend module: 0xFFF -> 0xFFFFFFFF (not 0x00000FFF!)

addi x2, x1, 1        # x2 = 0xFFFFFFFF + 1 = 0x00000000 (negative + positive = zero)

ori x3, x0, -256      # x3 = 0xFFFFFFF00 (12-bit immediate -256 sign-extended, then OR'ed)
# Expected: Demonstrates sign extension correctness

jal x0, 0             # Infinite loop
