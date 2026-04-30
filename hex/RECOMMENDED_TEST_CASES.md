# RISC-V CPU 建议补充测试用例

## 测试场景总结

### 优先级1: t13_shift_boundary - 移位量0/31边界测试

**目的**: 验证移位指令的极端边界
- 移位量=0时应返回原值
- 移位量=31时是32位字的最大移位

**建议汇编代码**:
```asm
# 初始化
addi x1, x0, 1        # x1 = 0x00000001
addi x2, x0, -1       # x2 = 0xFFFFFFFF
ori x3, x0, 0x80000000 # x3 = 0x80000000
ori x4, x0, 0x7FFFFFFF # x4 = 0x7FFFFFFF

# 逻辑左移 - 移位量=0
sll x8, x1, x0        # x8 = 0x00000001 (不变)

# 逻辑左移 - 移位量=31
addi x5, x0, 31
sll x9, x1, x5        # x9 = 0x80000000

# 逻辑右移 - 移位量=0
srl x10, x3, x0       # x10 = 0x80000000 (不变)

# 逻辑右移 - 移位量=31
srl x11, x2, x5       # x11 = 0x00000001 (0xFFFFFFFF >> 31 = 0x1)

# 算术右移 - 移位量=0
sra x12, x3, x0       # x12 = 0x80000000 (不变)

# 算术右移 - 移位量=31 - 负数
sra x13, x2, x5       # x13 = 0xFFFFFFFF (全1 >> 31 = 全1)

# 算术右移 - 移位量=31 - 正数
sra x14, x4, x5       # x14 = 0x00000000 (0x7FFF... >> 31 = 0)

jal x0, 0             # 无限循环
```

**期望结果** (golden格式):
```
8 00000001    # sll x8, x1, 0 = 0x1 (不变)
9 80000000    # sll x9, x1, 31 = 0x80000000
10 80000000   # srl x10, x3, 0 = 0x80000000 (不变)
11 00000001   # srl x11, x2, 31 = 0x00000001
12 80000000   # sra x12, x3, 0 = 0x80000000 (不变)
13 ffffffff   # sra x13, x2, 31 = 0xFFFFFFFF (全补1)
14 00000000   # sra x14, x4, 31 = 0x00000000 (全补0)
```

---

### 优先级2: t14_add_negative - 算术指令负数组合

**目的**: 完整覆盖add/sub/addi的负数场景
- 负+负=负
- 负-正=负  
- 正-负=正
- 负-负=正或负(取决于大小)
- 结果为0的负数组合

**建议汇编代码**:
```asm
# 初始化负数
addi x1, x0, -1        # x1 = 0xFFFFFFFF
addi x2, x0, -2        # x2 = 0xFFFFFFFE
addi x3, x0, -5        # x3 = 0xFFFFFFFB
addi x4, x0, 5         # x4 = 0x00000005

# 负+负=负
add x8, x1, x2         # x8 = 0xFFFFFFFE + 0xFFFFFFFF = 0xFFFFFFFD

# 负+正=0
add x9, x1, x4         # x9 = 0xFFFFFFFF + 0x00000005 = 0x00000004

# 负-正=负
sub x10, x1, x4        # x10 = 0xFFFFFFFF - 0x00000005 = 0xFFFFFFFA

# 负-负(大)=负或正(取决于操作数)
sub x11, x2, x1        # x11 = 0xFFFFFFFE - 0xFFFFFFFF = 0xFFFFFFFF

# 正数与-1相减
addi x5, x0, 0x10
sub x12, x5, x1        # x12 = 0x10 - (-1) = 0x11

# addi负数形式
addi x13, x1, 1        # x13 = 0xFFFFFFFF + 1 = 0x00000000

jal x0, 0
```

**期望结果** (golden格式):
```
8 fffffffd    # 负+负 = -3
9 00000004    # -1 + 5 = 4
10 fffffffa   # -1 - 5 = -6
11 ffffffff   # -2 - (-1) = -1
12 00000011   # 16 - (-1) = 17
13 00000000   # -1 + 1 = 0
```

---

### 优先级3: t15_bne_false - BNE条件不满足测试

**目的**: 补充BNE的反向条件(不跳转情况)
- BNE条件不满足(相等)时应顺序执行

**建议汇编代码**:
```asm
# 初始化
addi x1, x0, 0x55      # x1 = 0x55
addi x2, x0, 0x55      # x2 = 0x55 (相等)
addi x3, x0, 0         # x3 = 0
addi x4, x0, 0         # x4 = 0 (相等)

# BNE不跳转 - 两个相等的正数
bne x1, x2, 12         # x1 == x2，不应跳转
addi x5, x0, 0xAA      # 应执行此行
ori x6, x0, 0x11       # 应继续执行

# BNE不跳转 - 两个都是0
bne x3, x4, 12         # x3 == x4 (都是0)，不应跳转
addi x7, x0, 0x77      # 应执行此行
ori x8, x0, 0x88       # 应继续执行

jal x0, 0
```

**期望结果** (golden格式):
```
5 000000aa    # BNE不跳转，执行addi x5
6 00000011    # 继续执行
7 00000077    # BNE(0==0)不跳转
8 00000088    # 继续执行
```

---

### 可选: t16_lw_negative_extend - LW负偏移读取

**目的**: 补充独立的lw负偏移读取测试（虽然t12已有，但可单独测试）

**建议汇编代码**:
```asm
# 设置基地址和初始值
addi x1, x0, 0x20      # x1 = 0x20 (基地址)

# 初始化数据到内存
addi x2, x0, 0xDEAD    # x2 = 0x0000DEAD
ori x2, x2, 0xBEEF << 16  # x2 = 0xDEADBEEF
sw x2, 0(x1)           # 写入[0x20] = 0xDEADBEEF

# 用负偏移读取
lw x3, -4(x1)          # 读[0x20-4] = [0x1C]
lw x4, -8(x1)          # 读[0x20-8] = [0x18]
lw x5, -32(x1)         # 读[0x20-32] = [0x00]（可能溢出）

jal x0, 0
```

**期望结果** (golden格式):
```
3 deadbeef    # 负偏移-4读取
4 xxxxxxxx    # 负偏移-8读取（依赖内存初值）
5 xxxxxxxx    # 负偏移-32读取（可能为0或其他）
```

---

## 测试优先级建议

| 优先级 | 测试名 | 原因 | 工作量 |
|------|-------|------|------|
| **1** | t13_shift_boundary | 移位边界是CPU常见缺陷，必须验证 | 中等 |
| **1** | t14_add_negative | 负数组合覆盖不足，影响可靠性 | 中等 |
| **2** | t15_bne_false | 分支反向条件完整性 | 小 |
| **3** | t16_lw_negative_extend | 补充深化负偏移测试 | 小 |

---

## 快速检查清单

### 当前测试已验证 ✓
- [ ] addi符号扩展: x1 = 0xFFFFFFFF ✓
- [ ] x0恒零: 写入无效 ✓
- [ ] beq条件满足/不满足 ✓
- [ ] BNE条件满足 ✓
- [ ] JAL/JALR无条件跳转 ✓
- [ ] 负偏移sw/lw (t12) ✓
- [ ] 循环向后跳转(负偏移) ✓

### 需补充测试 ⚠️
- [ ] sll/srl/sra移位量=0
- [ ] sll/srl/sra移位量=31
- [ ] sra负数补1完整性
- [ ] add: 负+负=负
- [ ] add: 负-正=负
- [ ] BNE条件不满足(相等时)
- [ ] 更多算术指令负数组合

---

## 实现建议

如需生成完整的hex和golden文件，建议：

1. **使用RISC-V汇编器** (如riscv-gnu-toolchain):
   ```bash
   riscv32-unknown-elf-gcc -c test_code.s -o test_code.o
   riscv32-unknown-elf-objcopy -O binary test_code.o test_code.bin
   hexdump -C test_code.bin > test_code.hex
   ```

2. **或使用模拟器运行**后导出寄存器状态:
   ```bash
   spike test_code.elf > simulation_output.log
   ```

3. **验证golden结果**通过仿真或真实硬件运行
