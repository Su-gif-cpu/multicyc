# t03_mem.s - Memory Access (Load/Store) Test
# Tests: lw, sw with positive offsets

addi x1, x0, 0x10     # x1 = 0x10 (base address)
ori x2, x0, 0xead     # x2 = 0x0000EAD (data to write)
sw x2, 0(x1)          # Store 0x0000EAD at memory[0x10]
addi x2, x0, 0        # x2 = 0 (clear)
lw x3, 0(x1)          # x3 = memory[0x10] = 0x0000EAD (test read after write timing)
ori x4, x0, 0xab      # x4 = 0x000000AB
sw x4, 4(x1)          # Store 0xAB at memory[0x14] (4 bytes offset)
lw x5, 4(x1)          # x5 = memory[0x14] = 0xAB (continuous read/write)
jal x0, 0             # Infinite loop
