# t07_jal_link.s - JAL (Jump And Link)
# Tests: Unconditional jump with return address saved to rd

jal x10, 8            # Jump to offset +8, save return address (PC+4) to x10
ori x11, x0, 0xbad    # x11 = 0xBAD (should be SKIPPED)
addi x12, x0, 1       # x12 = 1 (jump target, should execute)
jal x0, 0             # Infinite loop
