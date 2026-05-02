# t24_jal_jalr_ret - jal 保存返回地址，jalr 返回后继续执行
# 期望: x20 = 0x33, x21 = 0xAA
# RARS: mc CompactTextAtZero
# 注意: jalr 返回到 addi x21 后，若下一条仍是 callee 入口会再次进入子程序形成死循环，
# 故在返回点之后用 jal x0,end 跳过 callee 正文再来自旋。

jal  x5, callee
addi x21, x0, 0xAA
jal  x0, end
callee:
addi x20, x0, 0x33
jalr x0, x5, 0
end:
beq  x0, x0, end
