module dff_async(
    input d, rst, clk, 
    output reg q);
always@(posedge clk or posedge rst)begin
    if(rst) q <= 0;
    else 
        q <= d;
end
endmodule

module break_before_make_glitch(
    input clk1, clk2, sel, rst,
    output clk_out
);
wire en1_sync1, en1_sync2;
wire en2_sync1, en2_sync2;
dff_async u_en1_sync1 (
    .d(~en2_sync2 & sel), .clk(clk1), .rst(rst), .q(en1_sync1)
);

dff_async u_en1_sync2 (
    .d(en1_sync1),        .clk(clk1), .rst(rst), .q(en1_sync2)
);

dff_async u_en2_sync1 (
    .d(~en1_sync2 & ~sel),.clk(clk2), .rst(rst), .q(en2_sync1)
);

dff_async u_en2_sync2 (
    .d(en2_sync1),        .clk(clk2), .rst(rst), .q(en2_sync2)
);

assign clk_out = (en2_sync2 & clk2) | (en1_sync2 & clk1);
endmodule