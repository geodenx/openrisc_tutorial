//
// modified from openrisc-HW-tutorial-Altera.pdf
// supporting lpm_ram_dq (APEX)
//
// $Id$
//
module onchip_ram_top (wb_clk_i,
		       wb_rst_i,
		       wb_dat_i,
		       wb_dat_o,
		       wb_adr_i,
		       wb_sel_i,
		       wb_we_i,
		       wb_cyc_i,
		       wb_stb_i,
		       wb_ack_o,
		       wb_err_o);
   //
   // Parameters
   //
   parameter aw = 12;

   //
   // I/O Ports
   //
   input     wb_clk_i;
   input     wb_rst_i;

   //
   // WB slave i/f
   //
   input [31:0] wb_dat_i;
   output [31:0] wb_dat_o;
   input [31:0]  wb_adr_i;
   input [3:0] 	 wb_sel_i;
   input 	 wb_we_i;
   input 	 wb_cyc_i;
   input 	 wb_stb_i;
   output 	 wb_ack_o;
   output 	 wb_err_o;

   //
   // Internal regs and wires
   //
   wire 	 we;
   wire [3:0] 	 be_i;
   //   wire [aw-1:0] adr;
   wire [31:0] 	 wb_dat_o;
   reg 		 ack_we;
   reg 		 ack_re;

   //
   // Aliases and simple assignments
   //
   assign 	 wb_ack_o = ack_re | ack_we;
   assign 	 wb_err_o = wb_cyc_i & wb_stb_i & (|wb_adr_i[23:aw+2]);

   // If Access to > (8-bit leading prefix ignored)
   assign 	 we = wb_cyc_i & wb_stb_i & wb_we_i & (|wb_sel_i[3:0]);
   assign 	 be_i = (wb_cyc_i & wb_stb_i) * wb_sel_i;

   //
   // Write acknowledge
   //
   always @ (negedge wb_clk_i or posedge wb_rst_i) begin
      if (wb_rst_i)
	ack_we <= 1'b0;
      else if (wb_cyc_i & wb_stb_i & wb_we_i & ~ack_we)
	ack_we <= #1 1'b1;
      else
	ack_we <= #1 1'b0;
   end

   //
   // read acknowledge
   //
   always @ (posedge wb_clk_i or posedge wb_rst_i) begin
      if (wb_rst_i)
	ack_re <= 1'b0;
      else if (wb_cyc_i & wb_stb_i & ~wb_err_o & ~wb_we_i & ~ack_re)
	ack_re <= #1 1'b1;
      else
	ack_re <= #1 1'b0;
   end

`ifdef RTL
   lpm_ram_dq_bank0 lpm_ram_dq_component_bank0(
					       .reset(wb_rst_i),
					       .address (wb_adr_i[aw+1:2]),
  					       .inclock (wb_clk_i),
					       .data (wb_dat_i[31:24]),
					       .we (we & be_i[3]),
					       .q (wb_dat_o[31:24]));

   lpm_ram_dq_bank1 lpm_ram_dq_component_bank1(
					       .reset(wb_rst_i),
					       .address (wb_adr_i[aw+1:2]),
					       .inclock (wb_clk_i),
					       .data (wb_dat_i[23:16]),
					       .we (we & be_i[2]),
					       .q (wb_dat_o[23:16]));
   
   lpm_ram_dq_bank2 lpm_ram_dq_component_bank2(
					       .reset(wb_rst_i),
					       .address (wb_adr_i[aw+1:2]),
					       .inclock (wb_clk_i),
					       .data (wb_dat_i[15:8]),
					       .we (we & be_i[1]),
					       .q (wb_dat_o[15:8]));

   lpm_ram_dq_bank3 lpm_ram_dq_component_bank3(
					       .reset(wb_rst_i),
					       .address (wb_adr_i[aw+1:2]),
					       .inclock (wb_clk_i),
					       .data (wb_dat_i[7:0]),
					       .we (we & be_i[0]),
					       .q (wb_dat_o[7:0]));

`else				// Altera Quartus
   lpm_ram_dq lpm_ram_dq_component_bank0(
					 .address (wb_adr_i[aw+1:2]),
					 .inclock (wb_clk_i),
					 .data (wb_dat_i[31:24]),
					 .we (we & be_i[3]),
					 .q (wb_dat_o[31:24]));

   lpm_ram_dq lpm_ram_dq_component_bank1(
					 .address (wb_adr_i[aw+1:2]),
					 .inclock (wb_clk_i),
					 .data (wb_dat_i[23:16]),
					 .we (we & be_i[2]),
					 .q (wb_dat_o[23:16]));
   
   lpm_ram_dq lpm_ram_dq_component_bank2(
					 .address (wb_adr_i[aw+1:2]),
					 .inclock (wb_clk_i),
					 .data (wb_dat_i[15:8]),
					 .we (we & be_i[1]),
					 .q (wb_dat_o[15:8]));

   lpm_ram_dq lpm_ram_dq_component_bank3(
					 .address (wb_adr_i[aw+1:2]),
					 .inclock (wb_clk_i),
					 .data (wb_dat_i[7:0]),
					 .we (we & be_i[0]),
					 .q (wb_dat_o[7:0]));

   defparam
	   lpm_ram_dq_component_bank0.intended_device_family = "APEX20KE",
	   lpm_ram_dq_component_bank0.lpm_width = 8,
	   lpm_ram_dq_component_bank0.lpm_widthad = 12,
	   lpm_ram_dq_component_bank0.lpm_indata = "REGISTERED",
	   lpm_ram_dq_component_bank0.lpm_address_control = "REGISTERED",
	   lpm_ram_dq_component_bank0.lpm_outdata = "UNREGISTERED",
	   lpm_ram_dq_component_bank0.lpm_file = "onchip_ram_bank0.mif",
	   lpm_ram_dq_component_bank0.use_eab = "ON",
	   lpm_ram_dq_component_bank0.lpm_type = "LPM_RAM_DQ";
   defparam
	   lpm_ram_dq_component_bank1.intended_device_family = "APEX20KE",
	   lpm_ram_dq_component_bank1.lpm_width = 8,
	   lpm_ram_dq_component_bank1.lpm_widthad = 12,
	   lpm_ram_dq_component_bank1.lpm_indata = "REGISTERED",
	   lpm_ram_dq_component_bank1.lpm_address_control = "REGISTERED",
	   lpm_ram_dq_component_bank1.lpm_outdata = "UNREGISTERED",
	   lpm_ram_dq_component_bank1.lpm_file = "onchip_ram_bank1.mif",
	   lpm_ram_dq_component_bank1.use_eab = "ON",
	   lpm_ram_dq_component_bank1.lpm_type = "LPM_RAM_DQ";
   defparam
	   lpm_ram_dq_component_bank2.intended_device_family = "APEX20KE",
	   lpm_ram_dq_component_bank2.lpm_width = 8,
	   lpm_ram_dq_component_bank2.lpm_widthad = 12,
	   lpm_ram_dq_component_bank2.lpm_indata = "REGISTERED",
	   lpm_ram_dq_component_bank2.lpm_address_control = "REGISTERED",
	   lpm_ram_dq_component_bank2.lpm_outdata = "UNREGISTERED",
	   lpm_ram_dq_component_bank2.lpm_file = "onchip_ram_bank2.mif",
	   lpm_ram_dq_component_bank2.use_eab = "ON",
	   lpm_ram_dq_component_bank2.lpm_type = "LPM_RAM_DQ";
   defparam
	   lpm_ram_dq_component_bank3.intended_device_family = "APEX20KE",
	   lpm_ram_dq_component_bank3.lpm_width = 8,
	   lpm_ram_dq_component_bank3.lpm_widthad = 12,
	   lpm_ram_dq_component_bank3.lpm_indata = "REGISTERED",
	   lpm_ram_dq_component_bank3.lpm_address_control = "REGISTERED",
	   lpm_ram_dq_component_bank3.lpm_outdata = "UNREGISTERED",
	   lpm_ram_dq_component_bank3.lpm_file = "onchip_ram_bank3.mif",
	   lpm_ram_dq_component_bank3.use_eab = "ON",
	   lpm_ram_dq_component_bank3.lpm_type = "LPM_RAM_DQ";
`endif //  `ifdef RTL
endmodule // onchip_ram_top

`ifdef RTL
module lpm_ram_dq_bank0(
			reset,
			address,
			we,
			inclock,
			data,
			q);
   input                reset;
   input [11:0] 	address;
   input 		we;
   input 		inclock;
   input [7:0] 		data;
   output [7:0] 	q;

   reg [7:0] 		mem[0:4095];
   
   //    assign 		q = we ? 8'hZZ : (inclock ? mem[address] : 8'hZZ);
   assign 		q = we ? 8'hZZ : mem[address];
   always @(posedge inclock or posedge reset) begin
      if (reset) begin
 `include "onchip_ram_bank0.v"
      end else if (we == 1'b1) begin
	 mem[address] <= data;
      end
   end
endmodule

module lpm_ram_dq_bank1(
			reset,
			address,
			we,
			inclock,
			data,
			q);
   input                reset;
   input [11:0] 	address;
   input 		we;
   input 		inclock;
   input [7:0] 		data;
   output [7:0] 	q;

   reg [7:0] 		mem[0:4095];
   
   assign 		q = we ? 8'hZZ : mem[address];
   always @(posedge inclock or posedge reset) begin
      if (reset) begin
 `include "onchip_ram_bank1.v"
      end else if (we == 1'b1) begin
	 mem[address] <= data;
      end
   end
endmodule

module lpm_ram_dq_bank2(
			reset,
			address,
			we,
			inclock,
			data,
			q);
   input                reset;
   input [11:0] 	address;
   input 		we;
   input 		inclock;
   input [7:0] 		data;
   output [7:0] 	q;

   reg [7:0] 		mem[0:4095];
   
   assign 		q = we ? 8'hZZ : mem[address];
   always @(posedge inclock or posedge reset) begin
      if (reset) begin
 `include "onchip_ram_bank2.v"
      end else if (we == 1'b1) begin
	 mem[address] <= data;
      end
   end
endmodule

module lpm_ram_dq_bank3(
			reset,
			address,
			we,
			inclock,
			data,
			q);
   input                reset;
   input [11:0] 	address;
   input 		we;
   input 		inclock;
   input [7:0] 		data;
   output [7:0] 	q;

   reg [7:0] 		mem[0:4095];
   
   assign 		q = we ? 8'hZZ : mem[address];
   always @(posedge inclock or posedge reset) begin
      if (reset) begin
 `include "onchip_ram_bank3.v"
      end else if (we == 1'b1) begin
	 mem[address] <= data;
      end
   end
endmodule
`endif