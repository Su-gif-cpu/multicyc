`timescale 1ns / 1ps

module riscv_sim();
    parameter PC_BASE = 32'h00002000;

    reg clk;
    reg rst;
    reg [8*24-1:0] test_name;
    reg [8*64-1:0] hex_path;
    integer cycle_count;
    integer timeout_cycles;
    integer stable_pc_cycles;
    reg [31:0] last_pc;
    integer i;

    function automatic bit is_pass;
        input [8*24-1:0] name;
        begin
            case (name)
                "t01_ralu": is_pass =
                    (U_RISCV.U_RF.register[3]  == 32'h00000008) &&
                    (U_RISCV.U_RF.register[4]  == 32'h00000002) &&
                    (U_RISCV.U_RF.register[5]  == 32'h00000001) &&
                    (U_RISCV.U_RF.register[6]  == 32'h00000007) &&
                    (U_RISCV.U_RF.register[7]  == 32'h00000006) &&
                    (U_RISCV.U_RF.register[9]  == 32'h00000050) &&
                    (U_RISCV.U_RF.register[11] == 32'h00000008) &&
                    (U_RISCV.U_RF.register[12] == 32'h00000008) &&
                    (U_RISCV.U_RF.register[14] == 32'hFFFF0000) &&
                    (U_RISCV.U_RF.register[15] == 32'hFFFFF000);
                "t02_itype": is_pass =
                    (U_RISCV.U_RF.register[1] == 32'hFFFFFFFF) &&
                    (U_RISCV.U_RF.register[2] == 32'h00000000) &&
                    (U_RISCV.U_RF.register[3] == 32'hFFFFF000);
                "t03_mem": is_pass =
                    (U_RISCV.U_RF.register[3] == 32'h00000EAD) &&
                    (U_RISCV.U_RF.register[5] == 32'h000000AB);
                "t04_beq_taken": is_pass =
                    (U_RISCV.U_RF.register[3] == 32'h00000000) &&
                    (U_RISCV.U_RF.register[4] == 32'h00000001);
                "t05_beq_not_taken": is_pass =
                    (U_RISCV.U_RF.register[3] == 32'h00000099) &&
                    (U_RISCV.U_RF.register[5] == 32'h00000001);
                "t06_bne": is_pass =
                    (U_RISCV.U_RF.register[6]  == 32'h00000022) &&
                    (U_RISCV.U_RF.register[9]  == 32'h00000033) &&
                    (U_RISCV.U_RF.register[10] == 32'h00000001);
                "t07_jal_link": is_pass =
                    (U_RISCV.U_RF.register[10] == 32'h00000004) &&
                    (U_RISCV.U_RF.register[12] == 32'h00000001);
                "t08_jalr": is_pass =
                    (U_RISCV.U_RF.register[1]  == 32'h00000018) &&
                    (U_RISCV.U_RF.register[20] == 32'h00000ACE) &&
                    (U_RISCV.U_RF.register[30] == 32'h00000000);
                "t09_x0": is_pass =
                    (U_RISCV.U_RF.register[0] == 32'h00000000) &&
                    (U_RISCV.U_RF.register[1] == 32'h00000055);
                "t10_loop_bne": is_pass =
                    (U_RISCV.U_RF.register[1] == 32'h00000003);
                "t11_jal_back": is_pass =
                    (U_RISCV.U_RF.register[1] == 32'h00000001) &&
                    (U_RISCV.U_RF.register[2] == 32'h00000002) &&
                    (U_RISCV.U_RF.register[3] == 32'h00000003);
                "t12_sw_neg": is_pass =
                    (U_RISCV.U_RF.register[1] == 32'h00000020) &&
                    (U_RISCV.U_RF.register[2] == 32'h00000AFE) &&
                    (U_RISCV.U_RF.register[3] == 32'h00000000);
                "t13_shift_boundary": is_pass =
                    (U_RISCV.U_RF.register[8]  == 32'h00000001) &&
                    (U_RISCV.U_RF.register[9]  == 32'h80000000) &&
                    (U_RISCV.U_RF.register[10] == 32'h00000001) &&
                    (U_RISCV.U_RF.register[11] == 32'h00000001) &&
                    (U_RISCV.U_RF.register[12] == 32'h00000001) &&
                    (U_RISCV.U_RF.register[13] == 32'hFFFFFFFF) &&
                    (U_RISCV.U_RF.register[14] == 32'h00000000);
                "t14_add_negative": is_pass =
                    (U_RISCV.U_RF.register[8]  == 32'hFFFFFFFD) &&
                    (U_RISCV.U_RF.register[9]  == 32'h00000004) &&
                    (U_RISCV.U_RF.register[10] == 32'hFFFFFFFA) &&
                    (U_RISCV.U_RF.register[11] == 32'hFFFFFFFF) &&
                    (U_RISCV.U_RF.register[12] == 32'h00000011) &&
                    (U_RISCV.U_RF.register[13] == 32'h00000000);
                "t15_bne_false": is_pass =
                    (U_RISCV.U_RF.register[5] == 32'h000000AA) &&
                    (U_RISCV.U_RF.register[6] == 32'h00000011) &&
                    (U_RISCV.U_RF.register[7] == 32'h00000077) &&
                    (U_RISCV.U_RF.register[8] == 32'h00000088);
                "t16_lw_negative_extend": is_pass =
                    (U_RISCV.U_RF.register[2] == 32'h0000BEEF) &&
                    (U_RISCV.U_RF.register[3] == 32'h00000000) &&
                    (U_RISCV.U_RF.register[4] == 32'h00000000) &&
                    (U_RISCV.U_RF.register[5] == 32'h00000000);
                default: is_pass = 1'b0;
            endcase
        end
    endfunction

    riscv U_RISCV(
        .clk(clk),
        .rst(rst)
    );

    initial begin
        test_name = "t01_ralu";
        if (!$value$plusargs("TEST=%s", test_name)) begin
            test_name = "t01_ralu";
        end

        hex_path = {"../hex/", test_name, ".hex"};
        $display("\n====================================================");
        $display("  TESTBENCH START: %0s", test_name);
        $display("  Instruction ROM: %0s", hex_path);
        $display("====================================================\n");

        for (i = 1; i < 32; i = i + 1) begin
            U_RISCV.U_RF.register[i] = 32'h0;
        end
        for (i = 0; i < 1024; i = i + 1) begin
            U_RISCV.U_DM.memory[i] = 32'h0;
        end

        $readmemh(hex_path, U_RISCV.U_IM.memory);

        clk = 1'b1;
        rst = 1'b1;
        #20;
        rst = 1'b0;

        cycle_count = 0;
        timeout_cycles = 500000;
        stable_pc_cycles = 0;
        last_pc = 32'hDEAD_BEEF;
    end

    always #50 clk = ~clk;

    always @(posedge clk) begin
        if (!rst) begin
            cycle_count = cycle_count + 1;

            if (U_RISCV.U_PC.PC == last_pc) begin
                stable_pc_cycles = stable_pc_cycles + 1;
            end else begin
                stable_pc_cycles = 0;
            end
            last_pc = U_RISCV.U_PC.PC;

            if (stable_pc_cycles >= 2 && U_RISCV.out_ins == 32'h0000006f && is_pass(test_name)) begin
                $display("\n==================== TEST PASS ====================");
                $display("  Test      : %0s", test_name);
                $display("  Final PC  : 0x%08X", U_RISCV.U_PC.PC);
                $display("  Cycles    : %0d", cycle_count);
                $display("====================================================\n");
                $finish;
            end

            if (cycle_count >= timeout_cycles) begin
                $display("\n==================== TEST FAIL ====================");
                $display("  Test      : %0s", test_name);
                $display("  Reason    : Timeout after %0d cycles", cycle_count);
                $display("  Last PC   : 0x%08X", U_RISCV.U_PC.PC);
                $display("  Last IR   : 0x%08X", U_RISCV.out_ins);
                $display("====================================================\n");
                $fatal;
            end
        end
    end

    initial begin
        $fsdbDumpvars(0, "riscv_sim");
        $fsdbDumpMDA(0, "riscv_sim");
    end

endmodule
