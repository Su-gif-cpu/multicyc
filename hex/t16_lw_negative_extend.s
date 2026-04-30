# t16_lw_negative_extend.s - LW with Negative Offset Deep Test (Optional)
# Extended test for negative offset load operations
# Tests: Load with various negative offsets to verify address calculation

addi x1, x0, 0x20     # x1 = 0x20 (base address)
ori x2, x0, 0xDEAD    # x2 = 0x0000DEAD
addi x2, x2, 0xBEEF << 16  # Not valid, use alternative:
ori x2, x0, 0xBEEF    # x2 = 0x0000BEEF (simplified data)
sw x2, 0(x1)          # Store at [0x20]

# Load with small negative offset
lw x3, -4(x1)         # x3 = memory[0x20 - 4] = memory[0x1C]

# Load with larger negative offset
lw x4, -8(x1)         # x4 = memory[0x20 - 8] = memory[0x18]

# Load with maximum 12-bit negative offset (-2048)
lw x5, -2048(x1)      # x5 = memory[0x20 - 2048] = memory[0xFFFFF820] (wraps or out of range)

jal x0, 0             # Infinite loop
#
# This test is optional and verifies:
# 1. Negative immediate sign extension
# 2. Address calculation with large negative offsets
# 3. Memory access boundary conditions
