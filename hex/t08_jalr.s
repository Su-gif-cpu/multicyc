# t08_jalr.s - JALR (Jump And Link Register)
# Tests: Unconditional jump using register value as target address

addi x1, x0, 0x10     # x1 = 0x10 (target address)
addi x1, x1, 0        # x1 = 0x10 (ensure x1 is set)
addi x0, x0, 0        # NOP
addi x0, x0, 0        # NOP
ori x20, x0, 0xace    # x20 = 0xACE (instruction before JALR)
jalr x1, 0            # Jump to address in x1, save return address to x1
ori x30, x0, 0xbad    # x30 = 0xBAD (should be SKIPPED)
jal x0, 0             # Infinite loop
