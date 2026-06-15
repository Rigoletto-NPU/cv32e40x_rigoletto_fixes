// Copyright (c) 2026
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// CV32E40X clock gate implementation.
//
// This module must exist as `cv32e40x_clock_gate` and is instantiated by
// `cv32e40x_sleep_unit`.
//
// We select the implementation using the same FuseSoC-provided `PRIM_DEFAULT_IMPL`
// define that OpenTitan primitives use:
// - Generic / simulation: latch enable on clk low, gate with AND (no FPGA primitives)
// - Xilinx (Ultrascale/7-series): latch enable on clk low, gate with BUFHCE (local clock)

module cv32e40x_clock_gate #(
  parameter int unsigned LIB = 0
) (
  input  logic clk_i,
  input  logic en_i,
  input  logic scan_cg_en_i,
  output logic clk_o
);

  // Default to generic if the knob isn't set by the top-level core.
`ifndef PRIM_DEFAULT_IMPL
  `define PRIM_DEFAULT_IMPL prim_pkg::ImplGeneric
`endif

  localparam prim_pkg::impl_e Impl = `PRIM_DEFAULT_IMPL;

  logic clk_en;

  // Glitch-free enable latch: update only while clock is low.
  always_latch begin
    if (clk_i == 1'b0) begin
      clk_en = en_i | scan_cg_en_i;
    end
  end

  generate
    // Treat any non-generic prim implementation as "FPGA techlib available".
    // This keeps CV32E40X aligned with the same knob that selects OpenTitan prims.
    if (Impl == prim_pkg::ImplXilinx || Impl == prim_pkg::ImplXilinx_ultrascale) begin : gen_xilinx
      // Local (per-worker) gated clock: use BUFHCE instead of scarce BUFGCE.
      BUFHCE u_bufhce (
        .I (clk_i),
        .CE(clk_en),
        .O (clk_o)
      );
    end else begin : gen_generic
      // Simulation / generic fallback (no vendor primitives).
      assign clk_o = clk_i & clk_en;
    end
  endgenerate

endmodule

