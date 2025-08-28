`timescale 1ns/1ps
`default_nettype none

// Utility module aliases for IP compatibility

module ef_util_ned (
    input wire clk,
    input wire in,
    output wire out
);
    aucohl_ned ned_inst (.clk(clk), .in(in), .out(out));
endmodule

module cf_util_ped (
    input wire clk,
    input wire in,
    output wire out
);
    aucohl_ped ped_inst (.clk(clk), .in(in), .out(out));
endmodule

module cf_util_fifo #(
    parameter DW = 8,
    parameter AW = 4
) (
    input wire clk,
    input wire rst,
    input wire rd,
    input wire wr,
    input wire [DW-1:0] w_data,
    output wire [DW-1:0] r_data,
    output wire empty,
    output wire full,
    output wire [AW:0] level
);
    aucohl_fifo #(.DW(DW), .AW(AW)) fifo_inst (
        .clk(clk),
        .rst_n(~rst),
        .rd(rd),
        .wr(wr),
        .w_data(w_data),
        .r_data(r_data),
        .empty(empty),
        .full(full),
        .level(level)
    );
endmodule

module ef_util_gating_cell (
    input wire clk,
    input wire en,
    output wire gclk
);
    ef_gating_cell gating_inst (.clk(clk), .en(en), .gclk(gclk));
endmodule

module cf_util_gating_cell (
    input wire clk,
    input wire en,
    output wire gclk
);
    ef_gating_cell gating_inst (.clk(clk), .en(en), .gclk(gclk));
endmodule

module ef_util_sync #(parameter NUM_STAGES = 2) (
    input wire clk,
    input wire in,
    output wire out
);
    aucohl_sync #(.NUM_STAGES(NUM_STAGES)) sync_inst (.clk(clk), .in(in), .out(out));
endmodule

module ef_util_ped (
    input wire clk,
    input wire in,
    output wire out
);
    aucohl_ped ped_inst (.clk(clk), .in(in), .out(out));
endmodule

`default_nettype wire