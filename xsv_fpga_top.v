//////////////////////////////////////////////////////////////////////
////                                                              ////
////  OR1K test application for XESS XSV board, Top Level         ////
////                                                              ////
////  This file is part of the OR1K test application              ////
////  http://www.opencores.org/cores/or1k/                        ////
////                                                              ////
////  Description                                                 ////
////  Top level instantiating all the blocks.                     ////
////                                                              ////
////  To Do:                                                      ////
////   - nothing really                                           ////
////                                                              ////
////  Author(s):                                                  ////
////      - Damjan Lampret, lampret@opencores.org                 ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2001 Authors                                   ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS Revision History
//
// $Log: xsv_fpga_top.v,v $
// Revision 1.10  2004/04/05 08:44:35  lampret
// Merged branch_qmem into main tree.
//
// Revision 1.8  2003/04/07 21:05:58  lampret
// WB = 1/2 RISC clock test code enabled.
//
// Revision 1.7  2003/04/07 01:28:17  lampret
// Adding OR1200_CLMODE_1TO2 test code.
//
// Revision 1.6  2002/08/12 05:35:12  lampret
// rty_i are unused - tied to zero.
//
// Revision 1.5  2002/03/29 20:58:51  lampret
// Changed hardcoded address for fake MC to use a define.
//
// Revision 1.4  2002/03/29 16:30:47  lampret
// Fixed port names that changed.
//
// Revision 1.3  2002/03/29 15:50:03  lampret
// Added response from memory controller (addr 0x60000000)
//
// Revision 1.2  2002/03/21 17:39:16  lampret
// Fixed some typos
//
//

`include "xsv_fpga_defines.v"
//`include "bench_defines.v"

module xsv_fpga_top (

		     //
		     // Global signals
		     //
		     clk, rstn,

		     //
		     // Flash chip
		     //
		     // 	flash_rstn, flash_cen, flash_oen, flash_wen,
		     // 	flash_rdy, flash_d, flash_a,

		     //
		     // SRAM right bank
		     //
		     // 	sram_r_cen, sram_r_oen, sram_r0_wen,
		     // 	sram_r1_wen, sram_r_d, sram_r_a,

		     //
		     // SRAM left bank
		     //
		     // 	sram_l_cen, sram_l_oen, sram_l0_wen,
		     // 	sram_l1_wen, sram_l_d, sram_l_a,

`ifdef APP_VGA_RAMDAC

		     //
		     // VGA RAMDAC
		     //
		     // 	ramdac_pixclk, ramdac_hsyncn, ramdac_vsync, ramdac_blank,
		     // 	ramdac_p, ramdac_rdn, ramdac_wrn, ramdac_rs, ramdac_d,
`else
		     //
		     // VGA Direct
		     //
		     // 	vga_blank, vga_pclk, vga_hsyncn, vga_vsyncn,
		     // 	vga_r, vga_g, vga_b,

`endif

		     //
		     // Stereo Codec
		     //
		     // 	codec_mclk, codec_lrclk, codec_sclk,
		     // 	codec_sdin, codec_sdout,

		     //
		     // Ethernet
		     //
		     // 	eth_col, eth_crs, eth_trste, eth_tx_clk,
		     // 	eth_tx_en, eth_tx_er, eth_txd, eth_rx_clk,
		     // 	eth_rx_dv, eth_rx_er, eth_rxd, eth_fds_mdint,
		     // 	eth_mdc, eth_mdio,

		     //
		     // Switches
		     //
		     // 	sw,

		     //
		     // PS/2 keyboard
		     //
		     // 	ps2_clk, ps2_data,

		     //
		     // CPLD
		     //
		     // 	tdmfrm, tdmrx, tdmtx

		     uart_stx, uart_srx,
  		     jtag_tvref, jtag_tgnd, jtag_tck, jtag_tms, jtag_trst, jtag_tdi, jtag_tdo
		     );

   //
   // I/O Ports
   //

   //
   // Global
   //
   input			clk;
   input			rstn;

   //
   // Flash
   //
   // output 			flash_rstn;
   // output 			flash_cen;
   // output 			flash_oen;
   // output 			flash_wen;
   // input 			flash_rdy;
   // inout	[7:0]		flash_d;
   // inout	[20:0]		flash_a;

   //
   // SRAM Right
   //
   // output			sram_r_cen;
   // output			sram_r1_wen;
   // output			sram_r0_wen;
   // output			sram_r_oen;
   // output	[18:0]		sram_r_a;
   // inout	[15:0]		sram_r_d;

   //
   // SRAM Left
   //
   // output			sram_l_cen;
   // output			sram_l0_wen;
   // output			sram_l1_wen;
   // output			sram_l_oen;
   // output	[18:0]		sram_l_a;
   // inout	[15:0]		sram_l_d;

`ifdef APP_VGA_RAMDAC

   //
   // VGA RAMDAC
   //
   // output			ramdac_pixclk;
   // output			ramdac_hsyncn;
   // output			ramdac_vsync;
   // output			ramdac_blank;
   // output	[7:0]		ramdac_p;
   // output			ramdac_rdn;
   // output			ramdac_wrn;
   // output	[2:0]		ramdac_rs;
   // inout	[7:0]		ramdac_d;

`else

   //
   // VGA Direct
   //
   // output			vga_pclk;
   // output			vga_blank;
   // output			vga_hsyncn;
   // output			vga_vsyncn;
   // output	[3:0]		vga_r;
   // output	[3:0]		vga_g;
   // output	[3:0]		vga_b;

`endif

   //
   // Stereo Codec
   //
   // output			codec_mclk;
   // output			codec_lrclk;
   // output			codec_sclk;
   // output			codec_sdin;
   // input			codec_sdout;

   //
   // Ethernet
   //
   // output			eth_tx_er;
   // input			eth_tx_clk;
   // output			eth_tx_en;
   // output	[3:0]		eth_txd;
   // input			eth_rx_er;
   // input			eth_rx_clk;
   // input			eth_rx_dv;
   // input	[3:0]		eth_rxd;
   // input			eth_col;
   // input			eth_crs;
   // output			eth_trste;
   // input			eth_fds_mdint;
   // inout			eth_mdio;
   // output			eth_mdc;

   //
   // Switches
   //
   // input	[2:1]		sw;

   //
   // PS/2 keyboard
   //
   // inout			ps2_clk;
   // inout			ps2_data;

   //
   // CPLD TDM
   //
   // input			tdmfrm;
   // input			tdmrx;
   // output			tdmtx;

   input 			uart_srx;
   output 			uart_stx;
   output 			jtag_tvref; // 1
   output 			jtag_tgnd; // 0
   input 			jtag_tck;
   input 			jtag_tms;
   input 			jtag_trst;
   input 			jtag_tdi;
   output 			jtag_tdo;

   //
   // Internal wires
   //

   //
   // VGA core slave i/f wires
   //
   // wire 	[31:0]		wb_vs_adr_i;
   // wire 	[31:0]		wb_vs_dat_i;
   // wire 	[31:0]		wb_vs_dat_o;
   // wire 	[3:0]		wb_vs_sel_i;
   // wire 			wb_vs_we_i;
   // wire 			wb_vs_stb_i;
   // wire 			wb_vs_cyc_i;
   // wire 			wb_vs_ack_o;
   // wire 			wb_vs_err_o;

   //
   // VGA core master i/f wires
   //
   // wire 	[31:0]		wb_vm_adr_o;
   // wire 	[31:0] 		wb_vm_dat_i;
   // wire 	[3:0]		wb_vm_sel_o;
   // wire			wb_vm_we_o;
   // wire 			wb_vm_stb_o;
   // wire			wb_vm_cyc_o;
   // wire			wb_vm_cab_o;
   // wire			wb_vm_ack_i;
   // wire			wb_vm_err_i;

   //
   // VGA CRT wires
   //
   // wire	[4:0]		vga_r_int;
   // wire	[5:0]		vga_g_int;
   // wire	[4:0]		vga_b_int;
   // wire			crt_hsync;
   // wire			crt_vsync;

   //
   // Debug core master i/f wires
   //
   wire [31:0] 			wb_dm_adr_o;
   wire [31:0] 			wb_dm_dat_i;
   wire [31:0] 			wb_dm_dat_o;
   wire [3:0] 			wb_dm_sel_o;
   wire 			wb_dm_we_o;
   wire 			wb_dm_stb_o;
   wire 			wb_dm_cyc_o;
   wire 			wb_dm_cab_o;
   wire 			wb_dm_ack_i;
   wire 			wb_dm_err_i;

   //
   // Debug <-> RISC wires
   //
   wire [3:0] 			dbg_lss;
   wire [1:0] 			dbg_is;
   wire [10:0] 			dbg_wp;
   wire 			dbg_bp;
   wire [31:0] 			dbg_dat_dbg;
   wire [31:0] 			dbg_dat_risc;
   wire [31:0] 			dbg_adr;
   wire 			dbg_ewt;
   wire 			dbg_stall;
   wire [2:0] 			dbg_op;

   //
   // RISC instruction master i/f wires
   //
   wire [31:0] 			wb_rim_adr_o;
   wire 			wb_rim_cyc_o;
   wire [31:0] 			wb_rim_dat_i;
   wire [31:0] 			wb_rim_dat_o;
   wire [3:0] 			wb_rim_sel_o;
   wire 			wb_rim_ack_i;
   wire 			wb_rim_err_i;
   wire 			wb_rim_rty_i = 1'b0;
   wire 			wb_rim_we_o;
   wire 			wb_rim_stb_o;
   wire 			wb_rim_cab_o;
   wire [31:0] 			wb_rif_adr;
   reg 				prefix_flash;

   //
   // RISC data master i/f wires
   //
   wire [31:0] 			wb_rdm_adr_o;
   wire 			wb_rdm_cyc_o;
   wire [31:0] 			wb_rdm_dat_i;
   wire [31:0] 			wb_rdm_dat_o;
   wire [3:0] 			wb_rdm_sel_o;
   wire 			wb_rdm_ack_i;
   wire 			wb_rdm_err_i;
   wire 			wb_rdm_rty_i = 1'b0;
   wire 			wb_rdm_we_o;
   wire 			wb_rdm_stb_o;
   wire 			wb_rdm_cab_o;
   wire 			wb_rdm_ack;

   //
   // RISC misc
   //
   wire [19:0] 			pic_ints;

   //
   // SRAM controller slave i/f wires
   //
   wire [31:0] 			wb_ss_dat_i;
   wire [31:0] 			wb_ss_dat_o;
   wire [31:0] 			wb_ss_adr_i;
   wire [3:0] 			wb_ss_sel_i;
   wire 			wb_ss_we_i;
   wire 			wb_ss_cyc_i;
   wire 			wb_ss_stb_i;
   wire 			wb_ss_ack_o;
   wire 			wb_ss_err_o;

   //
   // SRAM external wires
   //
   //    wire [15:0] 			sram_r_d_o;
   //    wire [15:0] 			sram_l_d_o;
   //    wire 			sram_d_oe;

   //
   // Flash controller slave i/f wires
   //
//    wire [31:0] 			wb_fs_dat_i;
//    wire [31:0] 			wb_fs_dat_o;
//    wire [31:0] 			wb_fs_adr_i;
//    wire [3:0] 			wb_fs_sel_i;
//    wire 			wb_fs_we_i;
//    wire 			wb_fs_cyc_i;
//    wire 			wb_fs_stb_i;
//    wire 			wb_fs_ack_o;
//    wire 			wb_fs_err_o;

   //
   // Audio core slave i/f wires
   //
//    wire [31:0] 			wb_as_dat_i;
//    wire [31:0] 			wb_as_dat_o;
//    wire [31:0] 			wb_as_adr_i;
//    wire [3:0] 			wb_as_sel_i;
//    wire 			wb_as_we_i;
//    wire 			wb_as_cyc_i;
//    wire 			wb_as_stb_i;
//    wire 			wb_as_ack_o;
//    wire 			wb_as_err_o;

   //
   // Audio core master i/f wires
   //
//    wire [31:0] 			wb_am_dat_o;
//    wire [31:0] 			wb_am_dat_i;
//    wire [31:0] 			wb_am_adr_o;
//    wire [3:0] 			wb_am_sel_o;
//    wire 			wb_am_we_o;
//    wire 			wb_am_cyc_o;
//    wire 			wb_am_stb_o;
//    wire 			wb_am_cab_o;
//    wire 			wb_am_ack_i;
//    wire 			wb_am_err_i;

   //
   // PS/2 core slave i/f wires
   //
//    wire [31:0] 			wb_ps_dat_i;
//    wire [31:0] 			wb_ps_dat_o;
//    wire [31:0] 			wb_ps_adr_i;
//    wire [3:0] 			wb_ps_sel_i;
//    wire 			wb_ps_we_i;
//    wire 			wb_ps_cyc_i;
//    wire 			wb_ps_stb_i;
//    wire 			wb_ps_ack_o;
//    wire 			wb_ps_err_o;

   //
   // PS/2 external i/f wires
   //
//    wire 			ps2_clk_o;
//    wire 			ps2_data_o;
//    wire 			ps2_clk_oe;
//    wire 			ps2_data_oe;

   //
   // Ethernet core master i/f wires
   //
//    wire [31:0] 			wb_em_adr_o;
//    wire [31:0] 			wb_em_dat_i;
//    wire [31:0] 			wb_em_dat_o;
//    wire [3:0] 			wb_em_sel_o;
//    wire 			wb_em_we_o;
//    wire 			wb_em_stb_o;
//    wire 			wb_em_cyc_o;
//    wire 			wb_em_cab_o;
//    wire 			wb_em_ack_i;
//    wire 			wb_em_err_i;

   //
   // Ethernet core slave i/f wires
   //
//    wire [31:0] 			wb_es_dat_i;
//    wire [31:0] 			wb_es_dat_o;
//    wire [31:0] 			wb_es_adr_i;
//    wire [3:0] 			wb_es_sel_i;
//    wire 			wb_es_we_i;
//    wire 			wb_es_cyc_i;
//    wire 			wb_es_stb_i;
//    wire 			wb_es_ack_o;
//    wire 			wb_es_err_o;

   //
   // Ethernet external i/f wires
   //
//    wire 			eth_mdo;
//    wire 			eth_mdoe;

   //
   // UART16550 core slave i/f wires
   //
   wire [31:0] 			wb_us_dat_i;
   wire [31:0] 			wb_us_dat_o;
   wire [31:0] 			wb_us_adr_i;
   wire [3:0] 			wb_us_sel_i;
   wire 			wb_us_we_i;
   wire 			wb_us_cyc_i;
   wire 			wb_us_stb_i;
   wire 			wb_us_ack_o;
   wire 			wb_us_err_o;

   //
   // UART external i/f wires
   //
   wire 			uart_stx;
   wire 			uart_srx;

   //
   // JTAG wires
   //
   wire 			jtag_tvref;
   wire 			jtag_tgnd;
   wire 			jtag_tdi;
   wire 			jtag_tms;
   wire 			jtag_tck;
   wire 			jtag_trst;
   wire 			jtag_tdo;

   //
   // CPLD TDM wires
   //
//    wire [2:0] 			tdm_out_unused;

   //
   // Reset debounce
   //
   reg 				rst_r;
   reg 				wb_rst;

   //
   // Global clock
   //
`ifdef OR1200_CLMODE_1TO2
   reg 				wb_clk;
`else
   wire 			wb_clk;
`endif

   //
   // Reset debounce
   //
   always @(posedge wb_clk or negedge rstn)
     if (~rstn)
       rst_r <= 1'b1;
     else
       rst_r <= #1 1'b0;

   //
   // Reset debounce
   //
   always @(posedge wb_clk)
     wb_rst <= #1 rst_r;

   //
   // This is purely for testing 1/2 WB clock
   // This should never be used when implementing in
   // an FPGA. It is used only for simulation regressions.
   //
`ifdef OR1200_CLMODE_1TO2
   initial wb_clk = 0;
   always @(posedge clk)
     wb_clk = ~wb_clk;
`else
   //
   // Some Xilinx P&R tools need this
   //
`ifdef TARGET_VIRTEX
   IBUFG IBUFG1 (
		 .O	( wb_clk ),
		 .I	( clk )
		 );
`else
   assign 			wb_clk = clk;
//    clkdiv_inst (
// 		.inclk0 (clk)
// 		.c0 (wb_clk) );
`endif
`endif // OR1200_CLMODE_1TO2

   //
   // SRAM tri-state data
   //
//    assign 			sram_r_d = sram_d_oe ? sram_r_d_o : 16'hzzzz;
//    assign 			sram_l_d = sram_d_oe ? sram_l_d_o : 16'hzzzz;

   //
   // Ethernet tri-state
   //
//    assign 			eth_mdio = eth_mdoe ? eth_mdo : 1'bz;
//    assign 			eth_trste = 1'b0;

   //
   // PS/2 Keyboard tri-state
   //
//    assign 			ps2_clk = ps2_clk_oe ? ps2_clk_o : 1'bz;
//    assign 			ps2_data = ps2_data_oe ? ps2_data_o : 1'bz;

   //
   // Unused interrupts
   //
//    assign 			pic_ints[`APP_INT_RES1] = 'b0;
//    assign 			pic_ints[`APP_INT_RES2] = 'b0;
//    assign 			pic_ints[`APP_INT_RES3] = 'b0;

   //
   // Unused WISHBONE signals
   //
   assign 			wb_us_err_o = 1'b0;
//    assign 			wb_ps_err_o = 1'b0;
//    assign 			wb_em_cab_o = 1'b0;
//    assign 			wb_am_cab_o = 1'b0;

   //
   // RISC Instruction address for Flash
   //
   // Until first access to real Flash area,
   // it is always prefixed with Flash area prefix.
   // This way we have flash at base address 0x0
   // during reset vector execution (boot). First
   // access to real Flash area will automatically
   // move SRAM to 0x0.
   //
//    always @(posedge wb_clk or negedge rstn)
//      if (!rstn)
//        prefix_flash <= #1 1'b1;
//      else if (wb_rim_cyc_o &&
// 	      (wb_rim_adr_o[31:32-`APP_ADDR_DEC_W] == `APP_ADDR_FLASH))
//        prefix_flash <= #1 1'b0;
//    assign 			wb_rif_adr = prefix_flash ? {`APP_ADDR_FLASH, wb_rim_adr_o[31-`APP_ADDR_DEC_W:0]}
// 				: wb_rim_adr_o;
//    assign 			wb_rdm_ack_i = (wb_rdm_adr_o[31:28] == `APP_ADDR_FAKEMC) &&
// 				wb_rdm_cyc_o && wb_rdm_stb_o ? 1'b1 : wb_rdm_ack;

   assign 			jtag_tvref = 1'b1;
   assign 			jtag_tgnd = 1'b0;
   
   //
   // Instantiation of the VGA CRT controller
   //
//    ssvga_top ssvga_top (

// 			// Clock and reset
// 			.wb_clk_i	( wb_clk ), 
// 			.wb_rst_i	( wb_rst ),
     
// 			// WISHBONE Master I/F
// 			.wbm_cyc_o  ( wb_vm_cyc_o ), 
// 			.wbm_stb_o  ( wb_vm_stb_o ), 
// 			.wbm_sel_o  ( wb_vm_sel_o ), 
// 			.wbm_we_o   ( wb_vm_we_o ),
// 			.wbm_adr_o  ( wb_vm_adr_o ), 
// 			.wbm_dat_o  ( ), 
// 			.wbm_cab_o  ( wb_vm_cab_o ),
// 			.wbm_dat_i  ( wb_vm_dat_i ), 
// 			.wbm_ack_i  ( wb_vm_ack_i ), 
// 			.wbm_err_i  ( wb_vm_err_i ), 
// 			.wbm_rty_i  ( 1'b0 ),

// 			// WISHBONE Slave I/F
// 			.wbs_cyc_i  ( wb_vs_cyc_i ), 
// 			.wbs_stb_i  ( wb_vs_stb_i ), 
// 			.wbs_sel_i  ( wb_vs_sel_i ), 
// 			.wbs_we_i   ( wb_vs_we_i ),
// 			.wbs_adr_i  ( wb_vs_adr_i ), 
// 			.wbs_dat_i  ( wb_vs_dat_i ), 
// 			.wbs_cab_i  ( 1'b0 ),
// 			.wbs_dat_o  ( wb_vs_dat_o ), 
// 			.wbs_ack_o  ( wb_vs_ack_o ), 
// 			.wbs_err_o  ( wb_vs_err_o ), 
// 			.wbs_rty_o  ( ),

// 			// Signals to VGA display
// 			.pad_hsync_o ( crt_hsync ), 
// 			.pad_vsync_o ( crt_vsync ), 
// 			.pad_rgb_o   ( {vga_r_int, vga_g_int, vga_b_int} ),
// 			.led_o	 ( )
// 			);

//    CRTC_IOB crt_out_reg (
// 			 .reset_in	( wb_rst ),
// 			 .clk_in	( wb_clk ),
// 			 .hsync_in	( crt_hsync ),
// 			 .vsync_in	( crt_vsync ),
// 			 .rgb_in	( {vga_r_int[4:1], vga_g_int[5:2], vga_b_int[4:1]} ),
// 			 .hsync_out	( vga_hsyncn ),
// 			 .vsync_out	( vga_vsyncn ),
// 			 .rgb_out	( {vga_r, vga_g, vga_b} )
// 			 );


   //
   // Instantiation of the Audio controller.
   //
   // This controller connects to AK4520A Codec chip.
   //
//    audio_top audio_top (
     
// 			// WISHBONE common
// 			.wb_clk_i ( wb_clk ),
// 			.wb_rst_i ( wb_rst ),

// 			// WISHBONE slave
// 			.wb_dat_i ( wb_as_dat_i ),
// 			.wb_dat_o ( wb_as_dat_o ),
// 			.wb_adr_i ( wb_as_adr_i ),
// 			.wb_sel_i ( wb_as_sel_i ),
// 			.wb_we_i  ( wb_as_we_i  ),
// 			.wb_cyc_i ( wb_as_cyc_i ),
// 			.wb_stb_i ( wb_as_stb_i ),
// 			.wb_ack_o ( wb_as_ack_o ),
// 			.wb_err_o ( wb_as_err_o ),

// 			// WISHBONE master
// 			.m_wb_dat_o ( wb_am_dat_o ),
// 			.m_wb_dat_i ( wb_am_dat_i ),
// 			.m_wb_adr_o ( wb_am_adr_o ),
// 			.m_wb_sel_o ( wb_am_sel_o ),
// 			.m_wb_we_o  ( wb_am_we_o  ),
// 			.m_wb_cyc_o ( wb_am_cyc_o ),
// 			.m_wb_stb_o ( wb_am_stb_o ),
// 			.m_wb_ack_i ( wb_am_ack_i ),
// 			.m_wb_err_i ( wb_am_err_i ),

// 			// AK4520A CODEC interface
// 			.mclk	  ( codec_mclk ),
// 			.lrclk	  ( codec_lrclk ),
// 			.sclk	  ( codec_sclk ),
// 			.sdin	  ( codec_sdin ),
// 			.sdout	  ( codec_sdout )
// 			);

   //
   // Instantiation of the development i/f model
   //
   // Used only for simulations.
   //
`ifdef DBG_IF_MODEL
   dbg_if_model dbg_if_model  (

			       // JTAG pins
			       .tms_pad_i	( jtag_tms ),
			       .tck_pad_i	( jtag_tck ),
			       .trst_pad_i	( jtag_trst ),
			       .tdi_pad_i	( jtag_tdi ),
			       .tdo_pad_o	( jtag_tdo ), 

			       // Boundary Scan signals
			       .capture_dr_o	( ), 
			       .shift_dr_o	( ), 
			       .update_dr_o	( ), 
			       .extest_selected_o ( ), 
			       .bs_chain_i	( 1'b0 ),
     
			       // RISC signals
			       .risc_clk_i	( wb_clk ),
			       .risc_data_i	( dbg_dat_risc ),
			       .risc_data_o	( dbg_dat_dbg ),
			       .risc_addr_o	( dbg_adr ),
			       .wp_i		( dbg_wp ),
			       .bp_i		( dbg_bp ),
			       .opselect_o	( dbg_op ),
			       .lsstatus_i	( dbg_lss ),
			       .istatus_i	( dbg_is ),
			       .risc_stall_o	( dbg_stall ),
			       .reset_o	( ),

			       // WISHBONE common
			       .wb_clk_i	( wb_clk ),
			       .wb_rst_i	( wb_rst ),

			       // WISHBONE master interface
			       .wb_adr_o	( wb_dm_adr_o ),
			       .wb_dat_i	( wb_dm_dat_i ),
			       .wb_dat_o	( wb_dm_dat_o ),
			       .wb_sel_o	( wb_dm_sel_o ),
			       .wb_we_o	( wb_dm_we_o  ),
			       .wb_stb_o	( wb_dm_stb_o ),
			       .wb_cyc_o	( wb_dm_cyc_o ),
			       .wb_cab_o	( wb_dm_cab_o ),
			       .wb_ack_i	( wb_dm_ack_i ),
			       .wb_err_i	( wb_dm_err_i )
			       );
`else
   //
   // Instantiation of the development i/f
   //
   dbg_top dbg_top  (

		     // JTAG pins
		     .tms_pad_i	( jtag_tms ),
		     .tck_pad_i	( jtag_tck ),
		     .trst_pad_i	( jtag_trst ),
		     .tdi_pad_i	( jtag_tdi ),
		     .tdo_pad_o	( jtag_tdo ),
		     .tdo_padoen_o	( ),

		     // Boundary Scan signals
		     .capture_dr_o	( ), 
		     .shift_dr_o	( ), 
		     .update_dr_o	( ), 
		     .extest_selected_o ( ), 
		     .bs_chain_i	( 1'b0 ),
		     .bs_chain_o	( ),

		     // RISC signals
		     .risc_clk_i	( wb_clk ),
		     .risc_addr_o	( dbg_adr ),
		     .risc_data_i	( dbg_dat_risc ),
		     .risc_data_o	( dbg_dat_dbg ),
		     .wp_i		( dbg_wp ),
		     .bp_i		( dbg_bp ),
		     .opselect_o	( dbg_op ),
		     .lsstatus_i	( dbg_lss ),
		     .istatus_i	( dbg_is ),
		     .risc_stall_o	( dbg_stall ),
		     .reset_o	( ),

		     // WISHBONE common
		     .wb_clk_i	( wb_clk ),
		     .wb_rst_i	( wb_rst ),

		     // WISHBONE master interface
		     .wb_adr_o	( wb_dm_adr_o ),
		     .wb_dat_i	( wb_dm_dat_i ),
		     .wb_dat_o	( wb_dm_dat_o ),
		     .wb_sel_o	( wb_dm_sel_o ),
		     .wb_we_o	( wb_dm_we_o  ),
		     .wb_stb_o	( wb_dm_stb_o ),
		     .wb_cyc_o	( wb_dm_cyc_o ),
		     .wb_cab_o	( wb_dm_cab_o ),
		     .wb_ack_i	( wb_dm_ack_i ),
		     .wb_err_i	( wb_dm_err_i )
		     );
`endif

   //
   // Instantiation of the OR1200 RISC
   //
   or1200_top or1200_top (

			  // Common
			  .rst_i		( wb_rst ),
			  .clk_i		( wb_clk ),
`ifdef OR1200_CLMODE_1TO2
			  .clmode_i	( 2'b01 ),
`else
`ifdef OR1200_CLMODE_1TO4
			  .clmode_i	( 2'b11 ),
`else
			  .clmode_i	( 2'b00 ),
`endif
`endif

			  // WISHBONE Instruction Master
			  .iwb_clk_i	( wb_clk ),
			  .iwb_rst_i	( wb_rst ),
			  .iwb_cyc_o	( wb_rim_cyc_o ),
			  .iwb_adr_o	( wb_rim_adr_o ),
			  .iwb_dat_i	( wb_rim_dat_i ),
			  .iwb_dat_o	( wb_rim_dat_o ),
			  .iwb_sel_o	( wb_rim_sel_o ),
			  .iwb_ack_i	( wb_rim_ack_i ),
			  .iwb_err_i	( wb_rim_err_i ),
			  .iwb_rty_i	( wb_rim_rty_i ),
			  .iwb_we_o	( wb_rim_we_o  ),
			  .iwb_stb_o	( wb_rim_stb_o ),
			  .iwb_cab_o	( wb_rim_cab_o ),

			  // WISHBONE Data Master
			  .dwb_clk_i	( wb_clk ),
			  .dwb_rst_i	( wb_rst ),
			  .dwb_cyc_o	( wb_rdm_cyc_o ),
			  .dwb_adr_o	( wb_rdm_adr_o ),
			  .dwb_dat_i	( wb_rdm_dat_i ),
			  .dwb_dat_o	( wb_rdm_dat_o ),
			  .dwb_sel_o	( wb_rdm_sel_o ),
			  .dwb_ack_i	( wb_rdm_ack_i ),
			  .dwb_err_i	( wb_rdm_err_i ),
			  .dwb_rty_i	( wb_rdm_rty_i ),
			  .dwb_we_o	( wb_rdm_we_o  ),
			  .dwb_stb_o	( wb_rdm_stb_o ),
			  .dwb_cab_o	( wb_rdm_cab_o ),

			  // Debug
			  .dbg_stall_i	( dbg_stall ),
			  .dbg_dat_i	( dbg_dat_dbg ),
			  .dbg_adr_i	( dbg_adr ),
			  .dbg_ewt_i	( 1'b0 ),
			  .dbg_lss_o	( dbg_lss ),
			  .dbg_is_o	( dbg_is ),
			  .dbg_wp_o	( dbg_wp ),
			  .dbg_bp_o	( dbg_bp ),
			  .dbg_dat_o	( dbg_dat_risc ),
			  .dbg_ack_o	( ),
			  .dbg_stb_i	( dbg_op[2] ),
			  .dbg_we_i	( dbg_op[0] ),

			  // Power Management
			  .pm_clksd_o	( ),
			  .pm_cpustall_i	( 1'b0 ),
			  .pm_dc_gate_o	( ),
			  .pm_ic_gate_o	( ),
			  .pm_dmmu_gate_o	( ),
			  .pm_immu_gate_o	( ),
			  .pm_tt_gate_o	( ),
			  .pm_cpu_gate_o	( ),
			  .pm_wakeup_o	( ),
			  .pm_lvolt_o	( ),

			  // Interrupts
			  //.pic_ints_i	( pic_ints )
			  .pic_ints_i	( 20'b0 )
			  );

   //
   // Instantiation of the Flash controller
   //
//    flash_top flash_top (

// 			// WISHBONE common
// 			.wb_clk_i	( wb_clk ),
// 			.wb_rst_i	( wb_rst ),

// 			// WISHBONE slave
// 			.wb_dat_i	( wb_fs_dat_i ),
// 			.wb_dat_o	( wb_fs_dat_o ),
// 			.wb_adr_i	( wb_fs_adr_i ),
// 			.wb_sel_i	( wb_fs_sel_i ),
// 			.wb_we_i	( wb_fs_we_i  ),
// 			.wb_cyc_i	( wb_fs_cyc_i ),
// 			.wb_stb_i	( wb_fs_stb_i ),
// 			.wb_ack_o	( wb_fs_ack_o ),
// 			.wb_err_o	( wb_fs_err_o ),

// 			// Flash external
// 			.flash_rstn	( flash_rstn ),
// 			.cen		( flash_cen ),
// 			.oen		( flash_oen ),
// 			.wen		( flash_wen ),
// 			.rdy		( flash_rdy ),
// 			.d		( flash_d ),
// 			.a		( flash_a ),
// 			.a_oe		( )
// 			);

   //
   // Instantiation of the SRAM controller
   //
//    sram_top sram_top (
   onchip_ram_top onchip_ram_top (
		      // WISHBONE common
		      .wb_clk_i	( wb_clk ),
		      .wb_rst_i	( wb_rst ),

		      // WISHBONE slave
		      .wb_dat_i	( wb_ss_dat_i ),
		      .wb_dat_o	( wb_ss_dat_o ),
		      .wb_adr_i	( wb_ss_adr_i ),
		      .wb_sel_i	( wb_ss_sel_i ),
		      .wb_we_i	( wb_ss_we_i  ),
		      .wb_cyc_i	( wb_ss_cyc_i ),
		      .wb_stb_i	( wb_ss_stb_i ),
		      .wb_ack_o	( wb_ss_ack_o ),
		      .wb_err_o	( wb_ss_err_o )

		      // SRAM external
// 		      .r_cen		( sram_r_cen ),
// 		      .r0_wen		( sram_r0_wen ),
// 		      .r1_wen		( sram_r1_wen ),
// 		      .r_oen		( sram_r_oen ),
// 		      .r_a		( sram_r_a ),
// 		      .r_d_i		( sram_r_d ),
// 		      .r_d_o		( sram_r_d_o ),
// 		      .d_oe		( sram_d_oe ),
// 		      .l_cen		( sram_l_cen ),
// 		      .l0_wen		( sram_l0_wen ),
// 		      .l1_wen		( sram_l1_wen ),
// 		      .l_oen		( sram_l_oen ),
// 		      .l_a		( sram_l_a ),
// 		      .l_d_i		( sram_l_d ),
// 		      .l_d_o		( sram_l_d_o )
		      );

   //
   // Instantiation of the UART16550
   //
   uart_top uart_top (

		      // WISHBONE common
		      .wb_clk_i	( wb_clk ), 
		      .wb_rst_i	( wb_rst ),

		      // WISHBONE slave
		      .wb_adr_i	( wb_us_adr_i[4:0] ),
		      .wb_dat_i	( wb_us_dat_i ),
		      .wb_dat_o	( wb_us_dat_o ),
		      .wb_we_i	( wb_us_we_i  ),
		      .wb_stb_i	( wb_us_stb_i ),
		      .wb_cyc_i	( wb_us_cyc_i ),
		      .wb_ack_o	( wb_us_ack_o ),
		      .wb_sel_i	( wb_us_sel_i ),

		      // Interrupt request
// 		      .int_o		( pic_ints[`APP_INT_UART] ),
 		      .int_o		(),
		      // UART signals
		      // serial input/output
		      .stx_pad_o	( uart_stx ),
		      .srx_pad_i	( uart_srx ),

		      // modem signals
		      .rts_pad_o	( ),
		      .cts_pad_i	( 1'b0 ),
		      .dtr_pad_o	( ),
		      .dsr_pad_i	( 1'b0 ),
		      .ri_pad_i	( 1'b0 ),
		      .dcd_pad_i	( 1'b0 )
		      );

   //
   // Instantiation of the Ethernet 10/100 MAC
   //
//    eth_top eth_top (

// 		    // WISHBONE common
// 		    .wb_clk_i	( wb_clk ),
// 		    .wb_rst_i	( wb_rst ),

// 		    // WISHBONE slave
// 		    .wb_dat_i	( wb_es_dat_i ),
// 		    .wb_dat_o	( wb_es_dat_o ),
// 		    .wb_adr_i	( wb_es_adr_i[11:2] ),
// 		    .wb_sel_i	( wb_es_sel_i ),
// 		    .wb_we_i	( wb_es_we_i  ),
// 		    .wb_cyc_i	( wb_es_cyc_i ),
// 		    .wb_stb_i	( wb_es_stb_i ),
// 		    .wb_ack_o	( wb_es_ack_o ),
// 		    .wb_err_o	( wb_es_err_o ), 

// 		    // WISHBONE master
// 		    .m_wb_adr_o	( wb_em_adr_o ),
// 		    .m_wb_sel_o	( wb_em_sel_o ),
// 		    .m_wb_we_o	( wb_em_we_o  ), 
// 		    .m_wb_dat_o	( wb_em_dat_o ),
// 		    .m_wb_dat_i	( wb_em_dat_i ),
// 		    .m_wb_cyc_o	( wb_em_cyc_o ), 
// 		    .m_wb_stb_o	( wb_em_stb_o ),
// 		    .m_wb_ack_i	( wb_em_ack_i ),
// 		    .m_wb_err_i	( wb_em_err_i ), 

// 		    // TX
// 		    .mtx_clk_pad_i	( eth_tx_clk ),
// 		    .mtxd_pad_o	( eth_txd ),
// 		    .mtxen_pad_o	( eth_tx_en ),
// 		    .mtxerr_pad_o	( eth_tx_er ),

// 		    // RX
// 		    .mrx_clk_pad_i	( eth_rx_clk ),
// 		    .mrxd_pad_i	( eth_rxd ),
// 		    .mrxdv_pad_i	( eth_rx_dv ),
// 		    .mrxerr_pad_i	( eth_rx_er ),
// 		    .mcoll_pad_i	( eth_col ),
// 		    .mcrs_pad_i	( eth_crs ),
     
// 		    // MIIM
// 		    .mdc_pad_o	( eth_mdc ),
// 		    .md_pad_i	( eth_mdio ),
// 		    .md_pad_o	( eth_mdo ),
// 		    .md_padoe_o	( eth_mdoe ),

// 		    // Interrupt
// 		    .int_o		( pic_ints[`APP_INT_ETH] )
// 		    );

   //
   // Instantiation of the PS/2 Keyboard Controller
   //
//    ps2_top ps2_top (

// 		    // WISHBONE common
// 		    .wb_clk_i	( wb_clk ),
// 		    .wb_rst_i	( wb_rst ),

// 		    // WISHBONE slave
// 		    .wb_cyc_i	( wb_ps_cyc_i ),
// 		    .wb_stb_i	( wb_ps_stb_i ),
// 		    .wb_we_i	( wb_ps_we_i  ),
// 		    .wb_sel_i	( wb_ps_sel_i ),
// 		    .wb_adr_i	( wb_ps_adr_i ),
// 		    .wb_dat_i	( wb_ps_dat_i ),
// 		    .wb_dat_o	( wb_ps_dat_o ),
// 		    .wb_ack_o	( wb_ps_ack_o ),

// 		    // Interrupt
// 		    .wb_int_o	( pic_ints[`APP_INT_PS2] ),

// 		    // PS/2 external wires
// 		    .ps2_kbd_clk_pad_i	( ps2_clk ),
// 		    .ps2_kbd_data_pad_i	( ps2_data ),
// 		    .ps2_kbd_clk_pad_o	( ps2_clk_o ),
// 		    .ps2_kbd_data_pad_o	( ps2_data_o ),
// 		    .ps2_kbd_clk_pad_oe_o	( ps2_clk_oe ),
// 		    .ps2_kbd_data_pad_oe_o	( ps2_data_oe )
// 		    );

   //
   // Instantiation of the CPLD TDM
   //
   // This small block connects XSV FPGA (xsv_fpga_top)
   // to the CPLD. CPLD has connections to the
   // RS232 PHY chip and to host PC (if you run OR1K
   // GDB debugger). In order for TDM to work, CPLD
   // must also be programmed with TDM master i/f.
   //
//    tdm_slave_if tdm_slave_if (
// 			      .clk	( wb_clk ),
// 			      .rst	( wb_rst ),
// 			      .tdmfrm	( tdmfrm ),
// 			      .tdmrx	( tdmrx ),
// 			      .tdmtx	( tdmtx ),
// 			      .din	( { jtag_tdo, uart_stx, 6'b000_000 } ),
// 			      .dout	( { jtag_tms, jtag_tck, jtag_trst, jtag_tdi, uart_srx, tdm_out_unused } )
// 			      );

   //
   // Instantiation of the Traffic COP
   //
   tc_top #(`APP_ADDR_DEC_W,
	    `APP_ADDR_SRAM,
	    `APP_ADDR_DEC_W,
	    `APP_ADDR_FLASH,
	    `APP_ADDR_DECP_W,
	    `APP_ADDR_PERIP,
	    `APP_ADDR_DEC_W,
	    `APP_ADDR_VGA,
	    `APP_ADDR_ETH,
	    `APP_ADDR_AUDIO,
	    `APP_ADDR_UART,
	    `APP_ADDR_PS2,
	    `APP_ADDR_RES1,
	    `APP_ADDR_RES2
	    ) tc_top (

		      // WISHBONE common
		      .wb_clk_i	( wb_clk ),
		      .wb_rst_i	( wb_rst ),

		      // WISHBONE Initiator 0
		      .i0_wb_cyc_i	( 1'b0 ),
		      .i0_wb_stb_i	( 1'b0 ),
		      .i0_wb_cab_i	( 1'b0 ),
		      .i0_wb_adr_i	( 32'h0000_0000 ),
		      .i0_wb_sel_i	( 4'b0000 ),
		      .i0_wb_we_i	( 1'b0 ),
		      .i0_wb_dat_i	( 32'h0000_0000 ),
		      .i0_wb_dat_o	( ),
		      .i0_wb_ack_o	( ),
		      .i0_wb_err_o	( ),

		      // WISHBONE Initiator 1
		      .i1_wb_cyc_i	( 1'b0 ),
		      .i1_wb_stb_i	( 1'b0 ),
		      .i1_wb_cab_i	( 1'b0 ),
		      .i1_wb_adr_i	( 32'h0000_0000 ),
		      .i1_wb_sel_i	( 4'b0000 ),
		      .i1_wb_we_i	( 1'b0 ),
		      .i1_wb_dat_i	( 32'h0000_0000 ),
		      .i1_wb_dat_o	( ),
		      .i1_wb_ack_o	( ),
		      .i1_wb_err_o	( ),

		      // WISHBONE Initiator 2
		      .i2_wb_cyc_i	( 1'b0 ),
		      .i2_wb_stb_i	( 1'b0 ),
		      .i2_wb_cab_i	( 1'b0 ),
		      .i2_wb_adr_i	( 32'h0000_0000 ),
		      .i2_wb_sel_i	( 4'b0000 ),
		      .i2_wb_we_i	( 1'b0 ),
		      .i2_wb_dat_i	( 32'h0000_0000 ),
		      .i2_wb_dat_o	( ),
		      .i2_wb_ack_o	( ),
		      .i2_wb_err_o	( ),

		      // WISHBONE Initiator 3
		      .i3_wb_cyc_i	( wb_dm_cyc_o ),
		      .i3_wb_stb_i	( wb_dm_stb_o ),
		      .i3_wb_cab_i	( wb_dm_cab_o ),
		      .i3_wb_adr_i	( wb_dm_adr_o ),
		      .i3_wb_sel_i	( wb_dm_sel_o ),
		      .i3_wb_we_i	( wb_dm_we_o  ),
		      .i3_wb_dat_i	( wb_dm_dat_o ),
		      .i3_wb_dat_o	( wb_dm_dat_i ),
		      .i3_wb_ack_o	( wb_dm_ack_i ),
		      .i3_wb_err_o	( wb_dm_err_i ),

		      // WISHBONE Initiator 4
		      .i4_wb_cyc_i	( wb_rdm_cyc_o ),
		      .i4_wb_stb_i	( wb_rdm_stb_o ),
		      .i4_wb_cab_i	( wb_rdm_cab_o ),
		      .i4_wb_adr_i	( wb_rdm_adr_o ),
		      .i4_wb_sel_i	( wb_rdm_sel_o ),
		      .i4_wb_we_i	( wb_rdm_we_o  ),
		      .i4_wb_dat_i	( wb_rdm_dat_o ),
		      .i4_wb_dat_o	( wb_rdm_dat_i ),
// 		      .i4_wb_ack_o	( wb_rdm_ack ),
		      .i4_wb_ack_o	( wb_rdm_ack_i ),
		      .i4_wb_err_o	( wb_rdm_err_i ),

		      // WISHBONE Initiator 5
		      .i5_wb_cyc_i	( wb_rim_cyc_o ),
		      .i5_wb_stb_i	( wb_rim_stb_o ),
		      .i5_wb_cab_i	( wb_rim_cab_o ),
// 		      .i5_wb_adr_i	( wb_rif_adr ),
		      .i5_wb_adr_i	( wb_rim_adr_o ),
		      .i5_wb_sel_i	( wb_rim_sel_o ),
		      .i5_wb_we_i	( wb_rim_we_o  ),
		      .i5_wb_dat_i	( wb_rim_dat_o ),
		      .i5_wb_dat_o	( wb_rim_dat_i ),
		      .i5_wb_ack_o	( wb_rim_ack_i ),
		      .i5_wb_err_o	( wb_rim_err_i ),

		      // WISHBONE Initiator 6
		      .i6_wb_cyc_i	( 1'b0 ),
		      .i6_wb_stb_i	( 1'b0 ),
		      .i6_wb_cab_i	( 1'b0 ),
		      .i6_wb_adr_i	( 32'h0000_0000 ),
		      .i6_wb_sel_i	( 4'b0000 ),
		      .i6_wb_we_i	( 1'b0 ),
		      .i6_wb_dat_i	( 32'h0000_0000 ),
		      .i6_wb_dat_o	( ),
		      .i6_wb_ack_o	( ),
		      .i6_wb_err_o	( ),

		      // WISHBONE Initiator 7
		      .i7_wb_cyc_i	( 1'b0 ),
		      .i7_wb_stb_i	( 1'b0 ),
		      .i7_wb_cab_i	( 1'b0 ),
		      .i7_wb_adr_i	( 32'h0000_0000 ),
		      .i7_wb_sel_i	( 4'b0000 ),
		      .i7_wb_we_i	( 1'b0 ),
		      .i7_wb_dat_i	( 32'h0000_0000 ),
		      .i7_wb_dat_o	( ),
		      .i7_wb_ack_o	( ),
		      .i7_wb_err_o	( ),

		      // WISHBONE Target 0
		      .t0_wb_cyc_o	( wb_ss_cyc_i ),
		      .t0_wb_stb_o	( wb_ss_stb_i ),
		      .t0_wb_cab_o	( wb_ss_cab_i ),
		      .t0_wb_adr_o	( wb_ss_adr_i ),
		      .t0_wb_sel_o	( wb_ss_sel_i ),
		      .t0_wb_we_o	( wb_ss_we_i  ),
		      .t0_wb_dat_o	( wb_ss_dat_i ),
		      .t0_wb_dat_i	( wb_ss_dat_o ),
		      .t0_wb_ack_i	( wb_ss_ack_o ),
		      .t0_wb_err_i	( wb_ss_err_o ),

		      // WISHBONE Target 1
		      .t1_wb_cyc_o	( ),
		      .t1_wb_stb_o	( ),
		      .t1_wb_cab_o	( ),
		      .t1_wb_adr_o	( ),
		      .t1_wb_sel_o	( ),
		      .t1_wb_we_o	( ),
		      .t1_wb_dat_o	( ),
		      .t1_wb_dat_i	( 32'h0000_0000 ),
		      .t1_wb_ack_i	( 1'b0 ),
		      .t1_wb_err_i	( 1'b1 ),

		      // WISHBONE Target 2
		      .t2_wb_cyc_o	( ),
		      .t2_wb_stb_o	( ),
		      .t2_wb_cab_o	( ),
		      .t2_wb_adr_o	( ),
		      .t2_wb_sel_o	( ),
		      .t2_wb_we_o	( ),
		      .t2_wb_dat_o	( ),
		      .t2_wb_dat_i	( 32'h0000_0000 ),
		      .t2_wb_ack_i	( 1'b0 ),
		      .t2_wb_err_i	( 1'b1 ),

		      // WISHBONE Target 3
		      .t3_wb_cyc_o	( ),
		      .t3_wb_stb_o	( ),
		      .t3_wb_cab_o	( ),
		      .t3_wb_adr_o	( ),
		      .t3_wb_sel_o	( ),
		      .t3_wb_we_o	( ),
		      .t3_wb_dat_o	( ),
		      .t3_wb_dat_i	( 32'h0000_0000 ),
		      .t3_wb_ack_i	( 1'b0 ),
		      .t3_wb_err_i	( 1'b1 ),

		      // WISHBONE Target 4
		      .t4_wb_cyc_o	( ),
		      .t4_wb_stb_o	( ),
		      .t4_wb_cab_o	( ),
		      .t4_wb_adr_o	( ),
		      .t4_wb_sel_o	( ),
		      .t4_wb_we_o	( ),
		      .t4_wb_dat_o	( ),
		      .t4_wb_dat_i	( 32'h0000_0000 ),
		      .t4_wb_ack_i	( 1'b0 ),
		      .t4_wb_err_i	( 1'b1 ),

		      // WISHBONE Target 5
		      .t5_wb_cyc_o	( wb_us_cyc_i ),
		      .t5_wb_stb_o	( wb_us_stb_i ),
		      .t5_wb_cab_o	( wb_us_cab_i ),
		      .t5_wb_adr_o	( wb_us_adr_i ),
		      .t5_wb_sel_o	( wb_us_sel_i ),
		      .t5_wb_we_o	( wb_us_we_i  ),
		      .t5_wb_dat_o	( wb_us_dat_i ),
		      .t5_wb_dat_i	( wb_us_dat_o ),
		      .t5_wb_ack_i	( wb_us_ack_o ),
		      .t5_wb_err_i	( wb_us_err_o ),

		      // WISHBONE Target 6
		      .t6_wb_cyc_o	( ),
		      .t6_wb_stb_o	( ),
		      .t6_wb_cab_o	( ),
		      .t6_wb_adr_o	( ),
		      .t6_wb_sel_o	( ),
		      .t6_wb_we_o	( ),
		      .t6_wb_dat_o	( ),
		      .t6_wb_dat_i	( 32'h0000_0000 ),
		      .t6_wb_ack_i	( 1'b0 ),
		      .t6_wb_err_i	( 1'b1 ),

		      // WISHBONE Target 7
		      .t7_wb_cyc_o	( ),
		      .t7_wb_stb_o	( ),
		      .t7_wb_cab_o	( ),
		      .t7_wb_adr_o	( ),
		      .t7_wb_sel_o	( ),
		      .t7_wb_we_o	( ),
		      .t7_wb_dat_o	( ),
		      .t7_wb_dat_i	( 32'h0000_0000 ),
		      .t7_wb_ack_i	( 1'b0 ),
		      .t7_wb_err_i	( 1'b1 ),

		      // WISHBONE Target 8
		      .t8_wb_cyc_o	( ),
		      .t8_wb_stb_o	( ),
		      .t8_wb_cab_o	( ),
		      .t8_wb_adr_o	( ),
		      .t8_wb_sel_o	( ),
		      .t8_wb_we_o	( ),
		      .t8_wb_dat_o	( ),
		      .t8_wb_dat_i	( 32'h0000_0000 ),
		      .t8_wb_ack_i	( 1'b0 ),
		      .t8_wb_err_i	( 1'b1 )
		      );

   //initial begin
   //  $dumpvars(0);
   //  $dumpfile("dump.vcd");
   //end

endmodule
