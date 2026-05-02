# t09_x0.s - x0 hardwired-zero checks
# PASS: x1==0x66（最后一条 addi 把「读到的 rs1」写进 x1；若 x0 恒 0 则成立；非「与初值比 0」）
# 末尾 beq 自旋在 RARS 会跑到步数上限——与 t08 相同，属裸机测例常见现象。
# RARS 访存: mc CompactDataAtZero

addi x2, x0, 0x10
ori  x3, x0, 0x55
sw   x3, 0(x2)

addi x0, x2, 10       # try to write x0 by ALU path
lw   x0, 0(x2)        # try to write x0 by load path

addi x1, x0, 0x66     # must still read x0 as 0
end:
beq  x0, x0, end
