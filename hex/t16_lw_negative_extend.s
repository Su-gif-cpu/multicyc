# t16 - 分支 / jal / jalr 混合；jalr 目标用 x5(=槽位)+立即数 计算，兼容 PC_BASE=0x2000 与 RARS 从 0 起址
# 通过：x9 == PC(jalr)+4 == PC_BASE + 0x28（相对程序起点偏移 40）；x11 未被写入保持 0；x7==0x22
# RARS: mc CompactTextAtZero

    addi x1, x0, 0
    addi x2, x0, 3
    addi x3, x0, 0
loop:
    addi x3, x3, 1
    bne  x3, x2, loop

    jal  x5, after_skip
    addi x6, x0, 0x11
after_skip:
    addi x7, x0, 0x22
    addi x10, x5, 20
    jalr x9, x10, 0
    addi x11, x0, 0x33
end:
    beq  x0, x0, end
