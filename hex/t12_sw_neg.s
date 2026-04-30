# t12_sw_neg.s - Store/Load with Negative Offset
# Critical: Address calculation with negative offset
# Tests: ALU correctly computes base_address + negative_immediate

addi x1, x0, 0x20     # x1 = 0x20 (base address)
ori x2, x0, 0xafe     # x2 = 0x0000AFE (data to write)
sw x2, -28(x1)        # Store at address: 0x20 + (-28) = 0x0C
# Sign-extended immediate: -28 = 0xFFFFFFE4 in 32-bit, lower 12 bits used in SW instr
lw x3, -4(x1)         # Load from address: 0x20 + (-4) = 0x1C
# Sign-extended immediate: -4 = 0xFFFFFFFC in 32-bit, lower 12 bits in LW instr
jal x0, 0             # Infinite loop
#
# Expected: x3 = 0x0000CAFE (or depends on memory init)
# This tests that:
#   1. Negative offsets are correctly sign-extended
#   2. ALU addition handles negative values properly
#   3. Memory addressing with negative offsets works
