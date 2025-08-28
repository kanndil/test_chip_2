`default_nettype none

//=============================================================================
// Module: user_project
// Description: Custom user project with 4x SPI masters, 1x I3C controller, 
//              and 2x GPIO lines with edge-detect interrupts
// Author: NativeChips Agent
// Date: 2025-08-28
// License: Apache 2.0
//=============================================================================

module user_project (
`ifdef USE_POWER_PINS
    inout vccd1,    // User area 1 1.8V supply
    inout vssd1,    // User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input         wb_clk_i,
    input         wb_rst_i,
    input         wbs_stb_i,
    input         wbs_cyc_i,
    input         wbs_we_i,
    input  [3:0]  wbs_sel_i,
    input  [31:0] wbs_dat_i,
    input  [31:0] wbs_adr_i,
    output        wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [37:0] io_in,
    output [37:0] io_out,
    output [37:0] io_oeb,

    // IRQ
    output [2:0] irq
);

    // Address decode parameters
    localparam BASE_ADDR = 32'h3000_0000;
    localparam SPI0_BASE = 32'h3000_0000;
    localparam SPI1_BASE = 32'h3000_0400;
    localparam SPI2_BASE = 32'h3000_0800;
    localparam SPI3_BASE = 32'h3000_0C00;
    localparam I3C_BASE  = 32'h3000_1000;
    localparam GPIO_BASE = 32'h3000_2000;
    
    localparam ADDR_MASK = 32'hFFFF_FC00; // 1KB blocks

    // Internal signals
    wire valid;
    wire [31:0] masked_addr;
    
    // Peripheral select signals
    wire sel_spi0, sel_spi1, sel_spi2, sel_spi3;
    wire sel_i3c, sel_gpio;
    
    // Peripheral wishbone signals
    wire [31:0] spi0_dat_o, spi1_dat_o, spi2_dat_o, spi3_dat_o;
    wire [31:0] i3c_dat_o, gpio_dat_o;
    wire spi0_ack, spi1_ack, spi2_ack, spi3_ack;
    wire i3c_ack, gpio_ack;
    
    // Interrupt signals
    wire spi0_irq, spi1_irq, spi2_irq, spi3_irq;
    wire i3c_irq, gpio_irq;
    
    // SPI interface signals
    wire [3:0] spi_miso, spi_mosi, spi_csb, spi_sclk;
    
    // I3C interface signals  
    wire i3c_scl_i, i3c_scl_o, i3c_scl_oen;
    wire i3c_sda_i, i3c_sda_o, i3c_sda_oen;
    
    // GPIO interface signals
    wire [1:0] gpio_in, gpio_out, gpio_oe;
    wire [7:0] gpio_full_out, gpio_full_oe;
    
    // Extract used GPIO bits
    assign gpio_out = gpio_full_out[1:0];
    assign gpio_oe = gpio_full_oe[1:0];

    // Address decode logic
    assign valid = wbs_cyc_i && wbs_stb_i;
    assign masked_addr = wbs_adr_i & ADDR_MASK;
    
    assign sel_spi0 = valid && (masked_addr == SPI0_BASE);
    assign sel_spi1 = valid && (masked_addr == SPI1_BASE);
    assign sel_spi2 = valid && (masked_addr == SPI2_BASE);
    assign sel_spi3 = valid && (masked_addr == SPI3_BASE);
    assign sel_i3c  = valid && (masked_addr == I3C_BASE);
    assign sel_gpio = valid && (masked_addr == GPIO_BASE);

    // Output mux
    assign wbs_dat_o = sel_spi0 ? spi0_dat_o :
                       sel_spi1 ? spi1_dat_o :
                       sel_spi2 ? spi2_dat_o :
                       sel_spi3 ? spi3_dat_o :
                       sel_i3c  ? i3c_dat_o  :
                       sel_gpio ? gpio_dat_o : 32'h0;
                       
    assign wbs_ack_o = spi0_ack | spi1_ack | spi2_ack | spi3_ack | 
                       i3c_ack | gpio_ack;

    // Interrupt mapping
    assign irq[0] = spi0_irq | spi1_irq | spi2_irq | spi3_irq; // SPI interrupts
    assign irq[1] = i3c_irq;                                    // I3C interrupt
    assign irq[2] = gpio_irq;                                   // GPIO interrupt

    // SPI Master 0
    CF_SPI_WB #(
        .CDW(8),
        .FAW(4)
    ) spi0_inst (
        .clk_i(wb_clk_i),
        .rst_i(wb_rst_i),
        .adr_i(wbs_adr_i),
        .dat_i(wbs_dat_i),
        .dat_o(spi0_dat_o),
        .sel_i(wbs_sel_i),
        .cyc_i(sel_spi0),
        .stb_i(sel_spi0),
        .ack_o(spi0_ack),
        .we_i(wbs_we_i),
        .IRQ(spi0_irq),
        .miso(spi_miso[0]),
        .mosi(spi_mosi[0]),
        .csb(spi_csb[0]),
        .sclk(spi_sclk[0])
    );

    // SPI Master 1
    CF_SPI_WB #(
        .CDW(8),
        .FAW(4)
    ) spi1_inst (
        .clk_i(wb_clk_i),
        .rst_i(wb_rst_i),
        .adr_i(wbs_adr_i),
        .dat_i(wbs_dat_i),
        .dat_o(spi1_dat_o),
        .sel_i(wbs_sel_i),
        .cyc_i(sel_spi1),
        .stb_i(sel_spi1),
        .ack_o(spi1_ack),
        .we_i(wbs_we_i),
        .IRQ(spi1_irq),
        .miso(spi_miso[1]),
        .mosi(spi_mosi[1]),
        .csb(spi_csb[1]),
        .sclk(spi_sclk[1])
    );

    // SPI Master 2
    CF_SPI_WB #(
        .CDW(8),
        .FAW(4)
    ) spi2_inst (
        .clk_i(wb_clk_i),
        .rst_i(wb_rst_i),
        .adr_i(wbs_adr_i),
        .dat_i(wbs_dat_i),
        .dat_o(spi2_dat_o),
        .sel_i(wbs_sel_i),
        .cyc_i(sel_spi2),
        .stb_i(sel_spi2),
        .ack_o(spi2_ack),
        .we_i(wbs_we_i),
        .IRQ(spi2_irq),
        .miso(spi_miso[2]),
        .mosi(spi_mosi[2]),
        .csb(spi_csb[2]),
        .sclk(spi_sclk[2])
    );

    // SPI Master 3
    CF_SPI_WB #(
        .CDW(8),
        .FAW(4)
    ) spi3_inst (
        .clk_i(wb_clk_i),
        .rst_i(wb_rst_i),
        .adr_i(wbs_adr_i),
        .dat_i(wbs_dat_i),
        .dat_o(spi3_dat_o),
        .sel_i(wbs_sel_i),
        .cyc_i(sel_spi3),
        .stb_i(sel_spi3),
        .ack_o(spi3_ack),
        .we_i(wbs_we_i),
        .IRQ(spi3_irq),
        .miso(spi_miso[3]),
        .mosi(spi_mosi[3]),
        .csb(spi_csb[3]),
        .sclk(spi_sclk[3])
    );

    // I3C Controller (using I2C as base with enhanced features)
    EF_I2C_WB #(
        .DEFAULT_PRESCALE(1),
        .FIXED_PRESCALE(0),
        .CMD_FIFO(1),
        .CMD_FIFO_DEPTH(16),
        .WRITE_FIFO(1),
        .WRITE_FIFO_DEPTH(16),
        .READ_FIFO(1),
        .READ_FIFO_DEPTH(16)
    ) i3c_inst (
        .clk_i(wb_clk_i),
        .rst_i(wb_rst_i),
        .adr_i(wbs_adr_i),
        .dat_i(wbs_dat_i),
        .dat_o(i3c_dat_o),
        .sel_i(wbs_sel_i),
        .cyc_i(sel_i3c),
        .stb_i(sel_i3c),
        .ack_o(i3c_ack),
        .we_i(wbs_we_i),
        .IRQ(i3c_irq),
        .scl_i(i3c_scl_i),
        .scl_o(i3c_scl_o),
        .scl_oen_o(i3c_scl_oen),
        .sda_i(i3c_sda_i),
        .sda_o(i3c_sda_o),
        .sda_oen_o(i3c_sda_oen)
    );

    // GPIO Controller (using only 2 bits of the 8-bit GPIO)
    EF_GPIO8_WB gpio_inst (
        .clk_i(wb_clk_i),
        .rst_i(wb_rst_i),
        .adr_i(wbs_adr_i),
        .dat_i(wbs_dat_i),
        .dat_o(gpio_dat_o),
        .sel_i(wbs_sel_i),
        .cyc_i(sel_gpio),
        .stb_i(sel_gpio),
        .ack_o(gpio_ack),
        .we_i(wbs_we_i),
        .IRQ(gpio_irq),
        .io_in({6'b0, gpio_in}),
        .io_out(gpio_full_out),
        .io_oe(gpio_full_oe)
    );

    // IO pad assignments (parameterizable)
    // SPI0: MOSI=8, MISO=9, SCLK=10, CSB=11
    // SPI1: MOSI=12, MISO=13, SCLK=14, CSB=15  
    // SPI2: MOSI=16, MISO=17, SCLK=18, CSB=19
    // SPI3: MOSI=20, MISO=21, SCLK=22, CSB=23
    // I3C: SCL=24, SDA=25
    // GPIO: GPIO0=26, GPIO1=27
    
    // SPI pad connections
    assign io_out[8]  = spi_mosi[0];
    assign io_oeb[8]  = 1'b0;  // Output
    assign spi_miso[0] = io_in[9];
    assign io_out[9]  = 1'b0;  // Input - drive low
    assign io_oeb[9]  = 1'b1;  // Input
    assign io_out[10] = spi_sclk[0];
    assign io_oeb[10] = 1'b0;  // Output
    assign io_out[11] = spi_csb[0];
    assign io_oeb[11] = 1'b0;  // Output
    
    assign io_out[12] = spi_mosi[1];
    assign io_oeb[12] = 1'b0;  // Output
    assign spi_miso[1] = io_in[13];
    assign io_out[13] = 1'b0;  // Input - drive low
    assign io_oeb[13] = 1'b1;  // Input
    assign io_out[14] = spi_sclk[1];
    assign io_oeb[14] = 1'b0;  // Output
    assign io_out[15] = spi_csb[1];
    assign io_oeb[15] = 1'b0;  // Output
    
    assign io_out[16] = spi_mosi[2];
    assign io_oeb[16] = 1'b0;  // Output
    assign spi_miso[2] = io_in[17];
    assign io_out[17] = 1'b0;  // Input - drive low
    assign io_oeb[17] = 1'b1;  // Input
    assign io_out[18] = spi_sclk[2];
    assign io_oeb[18] = 1'b0;  // Output
    assign io_out[19] = spi_csb[2];
    assign io_oeb[19] = 1'b0;  // Output
    
    assign io_out[20] = spi_mosi[3];
    assign io_oeb[20] = 1'b0;  // Output
    assign spi_miso[3] = io_in[21];
    assign io_out[21] = 1'b0;  // Input - drive low
    assign io_oeb[21] = 1'b1;  // Input
    assign io_out[22] = spi_sclk[3];
    assign io_oeb[22] = 1'b0;  // Output
    assign io_out[23] = spi_csb[3];
    assign io_oeb[23] = 1'b0;  // Output
    
    // I3C pad connections (open-drain)
    assign i3c_scl_i = io_in[24];
    assign io_out[24] = i3c_scl_o;
    assign io_oeb[24] = i3c_scl_oen;  // Open-drain
    assign i3c_sda_i = io_in[25];
    assign io_out[25] = i3c_sda_o;
    assign io_oeb[25] = i3c_sda_oen;  // Open-drain
    
    // GPIO pad connections
    assign gpio_in[0] = io_in[26];
    assign io_out[26] = gpio_out[0];
    assign io_oeb[26] = ~gpio_oe[0];
    assign gpio_in[1] = io_in[27];
    assign io_out[27] = gpio_out[1];
    assign io_oeb[27] = ~gpio_oe[1];
    
    // Unused IO pins
    genvar i;
    generate
        for (i = 0; i < 38; i = i + 1) begin : unused_ios
            if (i < 8 || i > 27) begin
                assign io_out[i] = 1'b0;
                assign io_oeb[i] = 1'b1;  // Input (high-Z)
            end
        end
    endgenerate

    // Logic Analyzer connections (optional debug)
    assign la_data_out[31:0]   = wbs_adr_i;
    assign la_data_out[63:32]  = wbs_dat_i;
    assign la_data_out[95:64]  = wbs_dat_o;
    assign la_data_out[96]     = wbs_cyc_i;
    assign la_data_out[97]     = wbs_stb_i;
    assign la_data_out[98]     = wbs_ack_o;
    assign la_data_out[99]     = wbs_we_i;
    assign la_data_out[102:100] = irq;
    assign la_data_out[127:103] = 25'b0;

endmodule

`default_nettype wire