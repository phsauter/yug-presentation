// Copyright 2023 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Authors:
// - Philippe Sauter <phsauter@ethz.ch>

// Configure the SoCs internals
package config_pkg;
  // typedef macros
  `include "cheshire/typedef.svh"

  import cheshire_pkg::*;

  // GPIO parameters
  localparam int unsigned GpioNumWired = 8;

  // use mostly default cheshire configuration
  function automatic cheshire_cfg_t gen_cheshire_cfg();
    cheshire_cfg_t ret = DefaultCfg;
    // Last-Level-Cache: 4-way 256-sets @ 8x64b
    ret.LlcSetAssoc  = 4;
    ret.LlcNumLines  = 256;
    ret.LlcNumBlocks = 8;

    return ret;
  endfunction

  localparam cheshire_cfg_t CheshireCfg = gen_cheshire_cfg();

  // Define used types (makes them 'real')
  `CHESHIRE_TYPEDEF_ALL(, CheshireCfg)
endpackage

// import settings of internals from config
// some things (Number of Serial-Link channels, number of SPI Chip-Select)
// are determined by generating register files instead
// the parameters SlinkNumChan, SpihNumCs etc are set in cheshire_pkg
// but the underlying value comes from these generated register files
module example_soc import config_pkg::*; import cheshire_pkg::*; (
  input  logic        clk_i,
  input  logic        rst_ni,
  input  logic        test_mode_i,
  input  logic [1:0]  boot_mode_i,
  input  logic        rtc_i,
  // JTAG interface
  input  logic  jtag_tck_i,
  input  logic  jtag_trst_ni,
  input  logic  jtag_tms_i,
  input  logic  jtag_tdi_i,
  output logic  jtag_tdo_o,
  output logic  jtag_tdo_oe_o,
  // UART interface
  output logic  uart_tx_o,
  input  logic  uart_rx_i,
  // I2C interface
  output logic  i2c_sda_o,
  input  logic  i2c_sda_i,
  output logic  i2c_sda_en_o,
  output logic  i2c_scl_o,
  input  logic  i2c_scl_i,
  output logic  i2c_scl_en_o,
  // SPI host interface
  output logic                  spih_sck_o,
  output logic                  spih_sck_en_o,
  output logic [SpihNumCs-1:0]  spih_csb_o,
  output logic [SpihNumCs-1:0]  spih_csb_en_o,
  output logic [ 3:0]           spih_sd_o,
  output logic [ 3:0]           spih_sd_en_o,
  input  logic [ 3:0]           spih_sd_i,
  // GPIO interface
  input  logic [GpioNumWired-1:0] gpio_i,
  output logic [GpioNumWired-1:0] gpio_o,
  output logic [GpioNumWired-1:0] gpio_en_o,
  // Serial link interface
  input  logic [SlinkNumChan-1:0]                     slink_rcv_clk_i,
  output logic [SlinkNumChan-1:0]                     slink_rcv_clk_o,
  input  logic [SlinkNumChan-1:0][SlinkNumLanes-1:0]  slink_i,
  output logic [SlinkNumChan-1:0][SlinkNumLanes-1:0]  slink_o,
  // VGA interface
  output logic                                  vga_hsync_o,
  output logic                                  vga_vsync_o,
  output logic [CheshireCfg.VgaRedWidth  -1:0]  vga_red_o,
  output logic [CheshireCfg.VgaGreenWidth-1:0]  vga_green_o,
  output logic [CheshireCfg.VgaBlueWidth -1:0]  vga_blue_o
);
  // GPIO width conversion (implicit)
  logic [31:0] gpio32_i;
  logic [31:0] gpio32_o;
  logic [31:0] gpio32_en_o;
  assign gpio32_i   = gpio_i;
  assign gpio_o     = gpio32_o;
  assign gpio_en_o  = gpio32_en_o;

  // Global reset synchronizer
  logic synced_rst_n;
  rstgen i_rstgen (
    .clk_i,
    .rst_ni,
    .test_mode_i,
    .rst_no  ( synced_rst_n ),
    .init_no ( )
  );

  // Cheshire SoC platform
  cheshire_soc #(
    .Cfg                ( CheshireCfg ),
    .ExtHartinfo        ( '0 ),
    .axi_ext_llc_req_t  ( axi_llc_req_t ),
    .axi_ext_llc_rsp_t  ( axi_llc_rsp_t ),
    .axi_ext_mst_req_t  ( axi_mst_req_t ),
    .axi_ext_mst_rsp_t  ( axi_mst_rsp_t ),
    .axi_ext_slv_req_t  ( axi_slv_req_t ),
    .axi_ext_slv_rsp_t  ( axi_slv_rsp_t ),
    .reg_ext_req_t      ( reg_req_t ),
    .reg_ext_rsp_t      ( reg_rsp_t )
  ) i_cheshire_soc (
    .clk_i,
    .rst_ni             ( synced_rst_n ),
    .test_mode_i,
    .boot_mode_i,
    .rtc_i,
    .axi_llc_mst_req_o  (    ),
    .axi_llc_mst_rsp_i  ( '0 ),
    .axi_ext_mst_req_i  ( '0 ),
    .axi_ext_mst_rsp_o  (    ),
    .axi_ext_slv_req_o  (    ),
    .axi_ext_slv_rsp_i  ( '0 ),
    .reg_ext_slv_req_o  (    ),
    .reg_ext_slv_rsp_i  ( '0 ),
    .intr_ext_i         ( '0 ),
    .intr_ext_o         (    ),
    .xeip_ext_o         (    ),
    .mtip_ext_o         (    ),
    .msip_ext_o         (    ),
    .dbg_active_o       (    ),
    .dbg_ext_req_o      (    ),
    .dbg_ext_unavail_i  ( '0 ),
    .jtag_tck_i,
    .jtag_trst_ni,
    .jtag_tms_i,
    .jtag_tdi_i,
    .jtag_tdo_o,
    .jtag_tdo_oe_o,
    .uart_tx_o,
    .uart_rx_i,
    .uart_rts_no        (      ),
    .uart_dtr_no        (      ),
    .uart_cts_ni        ( 1'b0 ),
    .uart_dsr_ni        ( 1'b0 ),
    .uart_dcd_ni        ( 1'b0 ),
    .uart_rin_ni        ( 1'b0 ),
    .i2c_sda_o,
    .i2c_sda_i,
    .i2c_sda_en_o,
    .i2c_scl_o,
    .i2c_scl_i,
    .i2c_scl_en_o,
    .spih_sck_o,
    .spih_sck_en_o,
    .spih_csb_o,
    .spih_csb_en_o,
    .spih_sd_o,
    .spih_sd_en_o,
    .spih_sd_i,
    .gpio_i             ( gpio32_i    ),
    .gpio_o             ( gpio32_o    ),
    .gpio_en_o          ( gpio32_en_o ),
    .slink_rcv_clk_i,
    .slink_rcv_clk_o,
    .slink_i,
    .slink_o,
    .vga_hsync_o,
    .vga_vsync_o,
    .vga_red_o,
    .vga_green_o,
    .vga_blue_o
  );

endmodule
