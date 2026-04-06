module dff_async (
    input wire clk,
    input wire rst_n,
    input wire d,
    output reg q
);
    always @(posedge clk or posedge rst_n) begin
        if (rst_n) q <= 1'b0;
        else q <= d;
    end
endmodule




module paper_glitch_free (
    input wire clk0,
    input wire clk1,
    input wire sel,
    output wire clk_out
);

   wire t1_q1, t1_q2;
    dff_async u_t1_q1 (.clk(clk0), .rst_n(clk1), .d(~sel),   .q(t1_q1));   // d = ~sel
    dff_async u_t1_q2 (.clk(clk0), .rst_n(clk1), .d(t1_q1),  .q(t1_q2));

    wire disable_clk1 = t1_q2;   // correct name

    // ==================== Timer_clk0 (clocked by clk0, cleared by clk1) ====================
    // Monitors clk1 when sel = 1
    wire t0_q1, t0_q2;
    dff_async u_t0_q1 (.clk(clk1), .rst_n(clk0), .d(sel),    .q(t0_q1));   // d = sel
    dff_async u_t0_q2 (.clk(clk1), .rst_n(clk0), .d(t0_q1),  .q(t0_q2));

    wire disable_clk0 = t0_q2;   // correct name

    // ==================== Conventional cross-coupled mux enables ====================
    wire en_clk0_1, en_clk0_2;
    wire en_clk1_1, en_clk1_2;

    // en_clk0 chain (clocked by clk0, async reset by disable_clk0)
    dff_async u_en0_1 (.clk(clk0), .rst_n(disable_clk0), .d(~en_clk1_2 & ~sel), .q(en_clk0_1));
    dff_async u_en0_2 (.clk(~clk0), .rst_n(disable_clk0), .d(en_clk0_1),         .q(en_clk0_2));

    // en_clk1 chain (clocked by clk1, async reset by disable_clk1)
    dff_async u_en1_1 (.clk(clk1), .rst_n(disable_clk1), .d(~en_clk0_2 & sel),  .q(en_clk1_1));
    dff_async u_en1_2 (.clk(~clk1), .rst_n(disable_clk1), .d(en_clk1_1),         .q(en_clk1_2));

    // ==================== Final output gating ====================
    assign clk_out = (clk0 & en_clk0_2) | (clk1 & en_clk1_2);

endmodule