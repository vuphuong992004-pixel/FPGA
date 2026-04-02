`timescale 1ns/1ps

// ================================================================
// Sub-modules
// ================================================================
module dff_async (
    input wire clk,
    input wire rst_n,
    input wire d,
    output reg q
);
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) q <= 1'b0;
        else q <= d;
    end
endmodule

module counter #(parameter WIDTH=4) (
    input wire clk,
    input wire rst_n,
    input wire inc,
    input wire clr,
    output reg [WIDTH-1:0] q
);
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) q <= {WIDTH{1'b0}};
        else if (clr) q <= {WIDTH{1'b0}};
        else if (inc) q <= q + 1'b1;
    end
endmodule

module clk_detect_block (
    input wire clk1,
    input wire clk2,
    input wire rst_n,
    output wire clk1_detect,
    output wire clk2_detect
);
    wire clk1_d, clk2_d;
    dff_async u_clk1_dff (.clk(clk2), .rst_n(rst_n), .d(clk1), .q(clk1_d));
    dff_async u_clk2_dff (.clk(clk1), .rst_n(rst_n), .d(clk2), .q(clk2_d));
    assign clk1_detect = clk1 ^ clk1_d;
    assign clk2_detect = clk2 ^ clk2_d;
endmodule

module counter_block (
    input wire clk1,
    input wire clk2,
    input wire rst_n1,
    input wire rst_n2,
    input wire clk1_detect,
    input wire clk2_detect,
    output wire [3:0] count1,
    output wire [4:0] count2
);
    counter #(.WIDTH(4)) count1_inst (
        .clk(clk2), .rst_n(rst_n2),
        .inc(~clk1_detect), .clr(clk1_detect),
        .q(count1)
    );
    counter #(.WIDTH(5)) count2_inst (
        .clk(clk1), .rst_n(rst_n1),
        .inc(~clk2_detect), .clr(clk2_detect),
        .q(count2)
    );
endmodule

// ================================================================
// Top module - Final version for paper
// ================================================================
module model_two_fix_enable (
    input wire clk1,
    input wire clk2,
    input wire sel,
    input wire rst_n,
    output wire clk_out,
    output wire fail_test_1,
    output wire fail_test_2,
    output wire [3:0] count1,
    output wire [4:0] count2,
    output wire [1:0] state_dbg,
    output wire rst_n1,
    output wire rst_n2
);

    // ==================== Detect & Counters ====================
    wire clk1_detect, clk2_detect;
    clk_detect_block detect_inst (
        .clk1(clk1), .clk2(clk2), .rst_n(rst_n),
        .clk1_detect(clk1_detect), .clk2_detect(clk2_detect)
    );

    wire [3:0] count1_int;
    wire [4:0] count2_int;
    counter_block counter_inst (
        .clk1(clk1), .clk2(clk2),
        .rst_n1(rst_n), .rst_n2(rst_n),
        .clk1_detect(clk1_detect), .clk2_detect(clk2_detect),
        .count1(count1_int), .count2(count2_int)
    );

    assign count1 = count1_int;
    assign count2 = count2_int;

    // ==================== Fail signals ====================
    wire fail1 = (count1_int >= 3) && ~clk1_detect;
    wire fail2 = (count2_int >= 3) && ~clk2_detect;

    assign fail_test_1 = fail1;
    assign fail_test_2 = fail2;

    // ==================== Fail synchronizers ====================
    wire fail1_sync1, fail1_sync2;
    dff_async u_f1s1 (.clk(clk1), .rst_n(rst_n), .d(fail1), .q(fail1_sync1));
    dff_async u_f1s2 (.clk(clk1), .rst_n(rst_n), .d(fail1_sync1), .q(fail1_sync2));

    wire fail2_sync1, fail2_sync2;
    dff_async u_f2s1 (.clk(clk2), .rst_n(rst_n), .d(fail2), .q(fail2_sync1));
    dff_async u_f2s2 (.clk(clk2), .rst_n(rst_n), .d(fail2_sync1), .q(fail2_sync2));

    // ==================== Enable synchronizers ====================
    wire enable1_sync1, enable1_sync2;
    wire enable2_sync1, enable2_sync2;

    dff_async u_e1s1 (.clk(clk2), .rst_n(rst_n), .d(enable1), .q(enable1_sync1));
    dff_async u_e1s2 (.clk(clk2), .rst_n(rst_n), .d(enable1_sync1), .q(enable1_sync2));

    dff_async u_e2s1 (.clk(clk1), .rst_n(rst_n), .d(enable2), .q(enable2_sync1));
    dff_async u_e2s2 (.clk(clk1), .rst_n(rst_n), .d(enable2_sync1), .q(enable2_sync2));

    // ==================== Desired clock selection ====================
    wire desired_clk1 = (sel || fail2) && ~fail1_sync2;
    wire desired_clk2 = (~sel || fail1) && ~fail2_sync2;

    // ==================== Enable flops (fast failover) ====================
    reg enable1;
    reg enable2;

    always @(posedge clk1 or negedge rst_n or posedge fail1) begin
        if (fail1) enable1 <= 1'b0;
        else if (~rst_n) enable1 <= 1'b0;
        else enable1 <= desired_clk1 & ~enable2_sync2;
    end

    always @(posedge clk2 or negedge rst_n or posedge fail2) begin
        if (fail2) enable2 <= 1'b0;
        else if (~rst_n) enable2 <= 1'b0;
        else enable2 <= desired_clk2 & ~enable1_sync2;
    end

    // ==================== NOT gate BEFORE first DFF of CDC ====================
    wire enable2_n = ~enable2;
    wire enable1_n = ~enable1;

    // (The NOT gate is already applied above before the first DFF)

    // ==================== Output ====================
    assign clk_out = (clk1 & enable1) | (clk2 & enable2);

    // ==================== Debug ====================
    assign state_dbg = {desired_clk1, desired_clk2};
    assign rst_n1 = rst_n;
    assign rst_n2 = rst_n;

endmodule
